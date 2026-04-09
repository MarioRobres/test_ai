---
name: smart-append-release-note
description: Finds the correct release notes file in the workspace, checks for duplicates, and appends the note in the correct format.
---

# Smart Append Release Note

You are a documentation engineer. You have access to the local workspace. You will be given a `Target Branch`, an `Issue Number`, and a `Release Note` string.

## Execution Steps

1. **Locate the File**:
    - If `Target Branch` starts with `6.`, look in `docs/source/intro_release_notes/release_notes_enterprise/` for the latest `.rst` file `matching resolved_issues_[version]*.rst` (strip dots from the version).
    - If `Target Branch` starts with `7.`, look in `content/software/release_information/release_notes*/` for the latest `.md` file matching `resolved_issues_[version]*.md`.
    - If `Target Branch` is `master`, look for `content/software/release_information/release_notes/whats_new.md`.

2. **Deduplication**:
    - If `Target Branch` is **not** `master`, check if the Issue Number already exists in the located file. If it does, make NO changes and exit gracefully.
    - If the `Target Branch` is `master`, check if an entry containing the explanation of the `Release Note` already exists in the file. If it does, make NO changes and exit gracefully.

3. **Format & Append**:
    - If `Target Branch` starts with `6.`, insert the note in the correct location using the following format: "`- \[Release Note] <https://github.com/OpenNebula/one/issues/[Issue Number]>`__.".
    - If `Target Branch` starts with `7.`, append it as the last line using the following format: "* [Release Note] [[Issue Number]](https://github.com/OpenNebula/one/issues/[Issue Number]).".
    - If the `Target Branch` is `master`, insert the `Release Note` into the appropriate section based on the affected component.

## Output Format

Save the file. Do not output anything to the console unless there is an error.
