# Retrieve the name and version of Git
PROBEDOCK_SCM_NAME='git'
PROBEDOCK_SCM_VERSION=$(`git --version` | cut -d " " -f 3)

# Gathering data related to the current state of Git repo
PROBEDOCK_SCM_BRANCH=`git rev-parse --abbrev-ref HEAD`
PROBEDOCK_SCM_COMMIT=`git rev-parse --verify HEAD`
PROBEDOCK_SCM_DIRTY=`if [[ $(git diff --shortstat 2> /dev/null | tail -n1) != "" ]]; then echo true; else echo false; fi`

PROBEDOCK_SCM_REMOTE_AHEAD=0
PROBEDOCK_SCM_REMOTE_BEHIND=0

merge=$(git config branch.$PROBEDOCK_SCM_BRANCH.merge 2>/dev/null)

# Gathering data related to the remote of the Git repo
PROBEDOCK_SCM_REMOTE_NAME=$(git config branch.$PROBEDOCK_SCM_BRANCH.remote 2>/dev/null)
PROBEDOCK_SCM_REMOTE_URL_FETCH=$(git remote get-url "$PROBEDOCK_SCM_REMOTE_NAME")
PROBEDOCK_SCM_REMOTE_URL_PUSH=$(git remote get-url "$PROBEDOCK_SCM_REMOTE_NAME")

# Check if the repo is locally ahead/behind the remote
if [[ -n "$merge" ]] && [[ -n "$PROBEDOCK_SCM_REMOTE_NAME" ]]; then
	ref=${merge/heads/remotes/$PROBEDOCK_SCM_REMOTE_NAME}
	
	changes=$( git rev-list --left-right $ref...HEAD 2>/dev/null | tr '\n' '-' )
	changes=${changes//[^<>]/}
	
	ahead_changes=${changes//</}
	behind_changes=${changes//>/}
	
	PROBEDOCK_SCM_REMOTE_AHEAD=${#ahead_changes}
	PROBEDOCK_SCM_REMOTE_BEHIND=${#behind_changes}
fi

# Retrieve the original configuration file given in argument
cat $1

# Produce the additional configuration to stdout
echo "scm:"
echo "  name: $PROBEDOCK_SCM_NAME"
echo "  version: $PROBEDOCK_SCM_VERSION"
echo "  branch: $PROBEDOCK_SCM_BRANCH"
echo "  commit: $PROBEDOCK_SCM_COMMIT"
echo "  dirty: $PROBEDOCK_SCM_DIRTY"
echo "  remote:"
echo "    name: $PROBEDOCK_SCM_REMOTE_NAME"
echo "    url:"
echo "      fetch: $PROBEDOCK_SCM_REMOTE_URL_FETCH"
echo "      push: $PROBEDOCK_SCM_REMOTE_URL_PUSH"
echo "    ahead: $PROBEDOCK_SCM_REMOTE_AHEAD"
echo "    behind: $PROBEDOCK_SCM_REMOTE_BEHIND"