export RED='\033[0;31m'
export GREEN='\033[1;32m'
export YELLOW='\033[0;33m'
export BLUE='\033[0;34m'
export NC='\033[0m' # No Color

echo "common.sh loaded"

# All allowed types, including wip for feature branches
export COMMIT_TYPES="feat|fix|test|docs|style|chore|refactor|wip"
# Types for main branch, excluding wip
export ANTI_MAIN_COMMIT_TYPES="feat|fix|test|docs|style|chore|refactor"

# Task ID format, e.g., PROJ-1234
export TASK_ID_PATTERN="[A-Z]+-[0-9]+"

# --- Rules for Main Branch ---
# On main branch, only below formats are allowed:
# 1. <TYPE>(PROJ-1234): <message>
# 2. <TYPE>(PROJ-1234,PROJ-5678): <message>
# 3. hotfix: <message>
export MAIN_SCOPE_PATTERN="\(${TASK_ID_PATTERN}(,${TASK_ID_PATTERN})*\)"
export MAIN_PATTERN="^(${ANTI_MAIN_COMMIT_TYPES})${MAIN_SCOPE_PATTERN}: .+|hotfix: .+|init"

# --- Rules for Other Branches ---
# Task ID is optional
# 1. <TYPE>: <message>
# 2. <TYPE>(PROJ-1234): <message>
export OTHER_PATTERN="^(${COMMIT_TYPES})(\\(${TASK_ID_PATTERN}\\))?: .+"

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
  echo "${YELLOW}On the main branch, required formats are:${NC}"
  echo "  1. ${GREEN}<TYPE>(PROJ-1234): <message>${NC}"
  echo "  2. ${GREEN}<TYPE>(PROJ-1234,PROJ-5678): <message>${NC}"
  echo "  3. ${GREEN}hotfix: <message>${NC}"
  echo "\n"
  print_readme_reminder
}

print_other_error() {
  local message=$1

  print_general_info "$message"
  echo "${YELLOW}On this branch, required formats are:${NC}"
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

  if [ "$CURRENT_BRANCH" = "main" ]; then
    if [[ ! $message =~ $MAIN_PATTERN ]]; then
        print_main_error "$message"
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
