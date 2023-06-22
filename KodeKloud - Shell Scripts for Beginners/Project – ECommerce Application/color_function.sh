function print_green() {
  GREEN='\033[0;32m'
  NC='\033[0m'

  echo -e "${GREEN} $1 ${NC}"
}

print_green "Installing Apache Web Server..."