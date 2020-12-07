# Copy the contents of this file into your `~/.zshrc` and `source ~/.zshrc`

# internal heler function to get the current branch
function gitbranch() {
    git branch | grep "*" | tr -d "*" | tr -d "[:space:]"
}

# push the current branch upstream
function gpsu() {
    BRANCH=$(gitbranch)
    git push --set-upstream origin $BRANCH
}

# open a pull request for the current branch
function gpr() {
    BRANCH=$(gitbranch)
    DIR=$(pwd)
    REPO=$(basename $DIR)
    open https://github.com/corvusinsurance/$REPO/compare/$BRANCH\?expand=1
}

# delete local branches that were once on the remote and have been deleted
# this will not delete local branches that have not been pushed up
function gprune() {
    git fetch -p
    REMOVED_BRANCHES=$(git for-each-ref --format '%(refname) %(upstream:track)' refs/heads | awk '$2 == "[gone]" {sub("refs/heads/", "", $1); print $1}')
    for branch in $REMOVED_BRANCHES; do
        git branch -D $branch
    done
}
