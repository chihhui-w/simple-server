export RED='\033[0;31m'
export GREEN='\033[1;32m'
export YELLOW='\033[0;33m'
export BLUE='\033[0;34m'
export NC='\033[0m' # No Color

export COMMIT_TYPES="feat|fix|test|docs|style|chore|refactor|wip"
export NON_WIP_COMMIT_TYPES="feat|fix|test|docs|style|chore|refactor"

export TASK_ID_PATTERN="[A-Za-z0-9-]+"
export TASK_SCOPE_PATTERN="\(${TASK_ID_PATTERN}(,${TASK_ID_PATTERN})*\)"

export MAIN_PATTERN="^(hotfix(${TASK_SCOPE_PATTERN})?|(${NON_WIP_COMMIT_TYPES})(${TASK_SCOPE_PATTERN})): .+$"
export DEV_PATTERN="^(hotfix|${NON_WIP_COMMIT_TYPES})(${TASK_SCOPE_PATTERN}): .+$"
export OTHER_PATTERN="^(${COMMIT_TYPES})(\\(${TASK_ID_PATTERN}\\))?: .+"
export MERGE_PATTERN="^Merge .+$"


# Get current branch, fallback to commit hash if not on a branch
export CURRENT_BRANCH=$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD)

print_general_info() {
  local message=$1

  echo  "┌──────────────────────────────┐"
  echo  "│     Commit Message Format    │"
  echo  "└──────────────────────────────┘"

  echo  "${RED}❌ Your commit message is invalid${NC}"
  echo  "\n"
  echo  "${YELLOW}Current branch:${NC} ${GREEN}$CURRENT_BRANCH${NC}"
  echo  "\n"
  echo  "${YELLOW}Commit message:${NC} ${GREEN}$message${NC}"
  echo  "\n"
}

print_readme_reminder() {
  echo "${YELLOW}For more info, see the README.md file.${NC}"
  echo "\n"
}

print_main_error() {
  local message=$1

  print_general_info "$message"
  echo "${YELLOW}Required format for main branch:${NC}"
  echo "  1. ${GREEN}<TYPE>(PROJ-1234): <message>${NC}"
  echo "  2. ${GREEN}<TYPE>(PROJ-1234,PROJ-5678): <message>${NC}"
  echo "  3. ${GREEN}hotfix: <message>${NC}"
  echo "\n"
  print_readme_reminder
}

print_dev_error() {
  local message=$1

  print_general_info "$message"
  echo "${YELLOW}Required format for dev/staging branch:${NC} ${GREEN}<TYPE>: <message>${NC} or ${GREEN}<TYPE>(TASK-123): <message>${NC} or ${GREEN}<TYPE>(br-pixel): <message>${NC}"
  echo "\n"
  echo "${YELLOW}Where type is one of:${NC} ${GREEN}$NON_WIP_COMMIT_TYPES${NC}"
  echo "\n"
  print_readme_reminder
}

print_other_error() {
  local message=$1

  print_general_info "$message"
  echo "${YELLOW}Required format for other branches:${NC}"
  echo "  1. ${BLUE}<TYPE>: <message>${NC}"
  echo "  2. ${BLUE}<TYPE>(PROJ-1234): <message>${NC}"
  echo "\n"
  echo "${YELLOW}Where type is one of:${NC} ${BLUE}$COMMIT_TYPES${NC}"
  echo "\n"
  print_readme_reminder
}

validate_commit_message() {
  local message=$1
  local check_other_branches=${2:-true}

  if [ $CURRENT_BRANCH == "main" ]; then
    if [[ ! $message =~ $MAIN_PATTERN ]] && [[ ! $message =~ $MERGE_PATTERN ]]; then
        print_main_error "$message"
        return 1
    fi
  elif [ $CURRENT_BRANCH == "dev" ] || [ $CURRENT_BRANCH == "staging" ]; then
        if [[ ! $message =~ $DEV_PATTERN ]] && [[ ! $message =~ $MERGE_PATTERN ]]; then
        print_dev_error "$message"
        return 1
    fi
  elif [ "$check_other_branches" = true ]; then
    if [[ ! $message =~ $OTHER_PATTERN ]]; then
        print_other_error "$message"
        return 1
    fi
  fi
  return 0
}
export -f validate_commit_message
