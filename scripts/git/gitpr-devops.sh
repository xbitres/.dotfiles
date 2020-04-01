#!/bin/bash
# vim: syntax=sh
# * dependencies
# ** moreutils
# ** git
# ** azcli

set -e

create_template() {
    cat << EOF > "$1"
$(git rev-parse --abbrev-ref HEAD): $(git log -1 --pretty=format:"%s")

$(git log -1 --pretty=format:"%b")

# Line   1: Title
# Line   2: --//--
# Line >=3: Description
# Commented lines will be ignored. An empty message aborts the PR.

$(git status | sed 's/^/# /')

$(git diff --name-status origin/master..HEAD | sed 's/^/# /')

$(git diff --stat origin/master..HEAD | sed 's/^/# /')

$(git log --pretty=format:"%C(yellow)%h %ad%Cred%d %Creset%s%Cblue [%cn]" --decorate --date=short origin/master..HEAD | sed 's/^/# /')

# vim: syntax=gitcommit
EOF
}

main() {
    AZURE_ALIAS="FILL_ME"
    AZURE_REVIEWERS=("FILL_ME")
    local tfile=$(mktemp); create_template "$tfile"

    $EDITOR "$tfile"
    local title=$(awk 'NR == 1' "$tfile")
    local description=$(awk 'NR >= 3 && ! /^ *#/' "$tfile")
    rm "$tfile"

    if ! [ "$title" ]; then
        >&2 echo 'Aborting due to empty title.'
        exit 1
    fi

    >&2 echo '> git push'
    branch=$(git rev-parse --abbrev-ref HEAD)
    chronic git push -u origin "$branch"

    if [ "$(awk -F -v '{ print NF }' <<< "$branch" )" -gt 1 ]; then
        target_branch=$(awk -F -v '{ print $(NF-1)($NF==1?"":"-v"($NF-1)) }' <<< "$branch" )
        target_branch="--target-branch $target_branch"
    fi

    >&2 echo '> az repos pr create'
    az repos pr create \
        --reviewers "${AZURE_REVIEWERS[@]}" \
        --delete-source-branch \
        --title "$title" \
        --description "$description" \
        --output json \
        ${target_branch} \
        "${@}" \
            | jq -r '[ .repository.webUrl, "pullrequest", .codeReviewId ] | join("/")' \
            | tee /dev/tty | pbcopy
}

main "${@}"
