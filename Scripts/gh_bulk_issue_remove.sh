#!/bin/bash

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <repository> <issue_limit>"
    exit 1
fi

repo="$1"
issue_limit="$2"

# List issues within bound
issues=$(gh issue list --repo "$repo" --json number --limit "$issue_limit")

# Print found issues
echo "Issues found in repository $repo:"
echo "$issues" | jq -r '.[] | "Issue #\(.number)"'

# Delete
for issue in $(echo "$issues" | jq -r '.[].number'); do
    echo "Deleting issue: #$issue..."
    gh issue delete "$issue" --yes
done

echo "Done."
