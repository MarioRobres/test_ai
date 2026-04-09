---
name: process-release-notes
description: Analyzes PR/Issue context, generates a note, updates the correct local repositories, and returns a JSON summary.
---

# Process Release Notes

You are a documentation engineer and release manager. You are provided with a PR Title, PR Body, Issue Body, and an Issue Number. You also have access to a local workspace containing cloned documentation repositories in the `./target_repos/` directory.

Follow these steps exactly:

## Step 1: Extract Metadata
Analyze the PR Title and PR Body to determine two things:
1. **Issue Type (`issue_type`):** - If the PR Title starts with "F", "f", or "F/", or the context clearly describes a new feature/enhancement, it is a feature. Value = `"f"`.
   - Otherwise, if it is a bug fix or error correction, it is a bug. Value = `"b"`.
2. **Target Branches:** Look for the list of branches under `"Branches to which this PR applies"` in the PR Body. Extract all specific branch versions listed, **even if the checkboxes are empty (`- [ ]`)**.
   - **CRITICAL:** ALWAYS ignore the placeholder template `one-X.X`.
   - *Example:* If the PR body contains:
     `- [ ] master`
     `- [ ] one-7.2`
     `- [ ] one-X.X`
     *You must extract only `master` and `7.2`.*

## Step 2: Generate Release Note
Read the ISSUE BODY and summarize the core change into exactly ONE sentence.
- **Length:** Exactly ONE sentence.
- **Bugs (`issue_type: "b"`):** Start with "Fix " and describe what was corrected.
    - *Example:* "Fix race condition in oneflow server in cancel actions."
- **Features (`issue_type: "f"`):** Describe actively without starting with "Fix".
    - *Example:* "Added option CONTEXT_ALLOW_ETH_UPDATES to oned.conf to enable updates of VM context ETH* values."
- **Tone:** Professional, direct, technical. No conversational filler.

## Step 3: Append & Deduplicate Locally
You have up to three folders in `./target_repos/` corresponding to the available branches (e.g., `master`, `6.10`, `7.2`).

**CRITICAL VALIDATION:** For each target branch identified in Step 1, verify that a corresponding folder actually exists in `./target_repos/`. If a branch version (e.g., `5.4`) does not have a matching folder, you MUST skip it entirely.

**ONLY process the folders that match the target branches selected in Step 1.** For each selected branch folder:

1. **Locate the File:**
    - `6.x` folders: Find the latest `.rst` file matching `docs/source/intro_release_notes/release_notes_enterprise/resolved_issues_*.rst`.
    - `7.x` folders: Find the latest `.md` file matching `content/software/release_information/release_notes*/resolved_issues_*.md`.
    - `master` folder: Find `content/software/release_information/release_notes/whats_new.md`.

2. **Deduplication:**
    - For a **Bug** (`issue_type: "b"`), check if the Issue Number already exists in the file. If yes, **skip this folder** (do not modify it, do not include it in the JSON output).
    - For a **Feature** (`issue_type: "f"`), check if your generated note meaning is already present in the file. If yes, **skip this folder** (do not modify it, do not include it in the JSON output).
3. **Format & Append:**
    - `6.x` format: Insert `"- \[Your generated Release Note] <https://github.com/OpenNebula/one/issues/[Issue Number]>`__."
    - `7.x` format: Append `"* [Your generated Release Note] [[Issue Number]](https://github.com/OpenNebula/one/issues/[Issue Number])."` at the end of the file.
    - `master` format: Insert your raw 1-sentence `Your generated Release Note` into the appropriate section based on the affected component.
    - **Save the files.**

## Step 4: Output JSON
Output ONLY a JSON array containing an object for every repository folder you **actually modified**. Ensure you include the `issue_type` you determined in Step 1. Do NOT wrap the JSON in markdown code blocks.

**Expected Format:**
[
  {
    "branch": "6.10",
    "path": "./target_repos/6.10",
    "repo_name": "MarioRobres/docs",
    "base_branch": "one-6.10-maintenance",
    "issue_type": "b"
  },
  {
    "branch": "master",
    "path": "./target_repos/master",
    "repo_name": "MarioRobres/website",
    "base_branch": "master",
    "issue_type": "b"
  }
]
