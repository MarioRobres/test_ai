---
name: process-release-notes
description: Analyzes commit messages, issue context, and code diff to generate a release note, updates the website repository locally, and returns a JSON summary.
---

# Process Release Notes

You are a documentation engineer and release manager. You are provided with a `TARGET_BRANCH`, `COMMIT_MSG`, `ISSUE_BODY`, `ISSUE_NUMBER`, and a `CODE_DIFF`.
You have access to a local workspace containing the cloned website repository in `./documentation/website/`.

Follow these steps exactly:

## Step 1: Analyze Context & Extract Metadata
1. **Determine Issue Type (`issue_type`):**
   - If the `COMMIT_MSG` starts with "F", "f", or "F/", or the context clearly describes a new feature/enhancement, it is a feature (`"f"`).
   - Otherwise, if it is a bug fix or error correction, it is a bug (`"b"`).
2. **Analyze the Code Diff:** Read the `CODE_DIFF` alongside the `ISSUE_BODY` to ensure you completely understand the context of what was changed before writing your release note.
3. **Locate Documentation Links (Features Only):** If `issue_type` is `"f"`, look through the context (and your internal knowledge / `Agent.md` guidance) to deduce the base path in the documentation where this feature should be documented (e.g., `product/cluster_configuration/storage_system/nas_ds.md#automatic-nfs-setup` or `integrations/storage_extensions/netapp`). Keep this base path handy.

## Step 2: Generate Release Note
Summarize the core change into exactly ONE sentence.
- **Length:** Exactly ONE sentence.
- **Bugs (`issue_type: "b"`):** Start with "Fix " and describe what was corrected.
    - *Example:* "Fix race condition in oneflow server in cancel actions."
- **Features (`issue_type: "f"`):** Describe actively without starting with "Fix".
    - *Example:* "Added option CONTEXT_ALLOW_ETH_UPDATES to oned.conf to enable updates of VM context ETH* values."
- **Tone:** Professional, direct, technical. No conversational filler.

## Step 3: Modify Website Locally
The repository is located at `./documentation/website/`.

1. **Locate the Target File:**
   - **If `TARGET_BRANCH` ends with `-maintenance`:** Find the latest `.md` file matching `content/software/release_information/release_notes*/resolved_issues_*.md`.
   - **If `TARGET_BRANCH` is `master`:** Locate `content/software/release_information/release_notes/whats_new.md`.

2. **Deduplication:**
  - Check if the `ISSUE_NUMBER` or a semantically identical description of your release note already exists in the file. If yes, skip modifying the file and return an empty JSON array `[]`.

3. **Format & Append:**
   - **Maintenance Branches (`-maintenance`):**
     - Append your note to the bottom of the file in this exact format:
       `* [Your generated Release Note] [[ISSUE_NUMBER]](https://github.com/OpenNebula/one/issues/[ISSUE_NUMBER]).`

   - **Master Branch (`master`):**
     - **If Bug (`"b"`):** Locate the `## Other Issues Solved` section at the bottom of the file. Append your note under it in this exact format:
       `* [Your generated Release Note](https://github.com/OpenNebula/one/issues/[ISSUE_NUMBER]).`
     - **If Feature (`"f"`):** Insert under the relevant component section (e.g., `## OpenNebula Core`, `## Sunstone`). **If you are unsure which component applies, place it under `## OpenNebula Core`.** If you deduced a base path in Step 1, format the hyperlink as a relative path by prepending `../../../` to the base path:
       `* [Your generated Release Note](../../../<base-path>).`

4. **Save the file.**

## Step 4: Output JSON
Output ONLY a JSON array containing a single object detailing your execution.

- **For Features (`"f"`):** In the `doc_links` field, provide the absolute URL pointing to the `devel` documentation by prepending `https://docs.opennebula.io/devel/` to the base path you deduced in Step 1 (e.g., `https://docs.opennebula.io/devel/product/cluster_configuration/storage_system/local_ds`).
- **For Bugs (`"b"`):** Leave `doc_links` empty.

**CRITICAL:** Do NOT wrap the JSON in markdown code blocks (e.g., no ```json). Return raw JSON only. Do not include any comments in the JSON.

**Expected Format:**
[
  {
    "target_branch": "master",
    "issue_type": "f",
    "doc_links": "https://docs.opennebula.io/devel/product/cluster_configuration/storage_system/local_ds"
  }
]
