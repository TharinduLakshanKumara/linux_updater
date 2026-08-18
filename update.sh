#!/bin/bash 

# -----------------------
# Variables
# -----------------------

# Current date and time
DATE=$(date +%F_%T) # Current date in YYYY-MM-DD_HH:MM:SS format

# The current user is the user who is running the script.
USER=$(whoami) # Current user

# OS version
OS=$(lsb_release -d | awk -F"\t" '{print $2}') # OS version of the system

# Hostname
HOSTNAME=$(hostname) # Hostname of the system

# -----------------------
# Colors
# -----------------------

# Regular Colors
RedC="\e[31m"
GreenC="\e[32m"
YellowC="\e[33m"
BlueC="\e[34m"
ResetC="\e[0m"

# Bold
BBlackC='\033[1;30m'
BRedC='\033[1;31m'
BGreenC='\033[1;32m'
BYellowC='\033[1;33m'


# -----------------------
# Functions
# -----------------------

print_header() {
  echo
  printf "${YellowC}%*s${ResetC}\n" 60 '' | tr ' ' '='
  echo -e "$BGreenC $@ $ResetC"
  printf "${YellowC}%*s${ResetC}\n" 60 '' | tr ' ' '='
  echo
}

run_if_exists() {
  command -v "$1" >/dev/null 2>&1 || return # If the command does not exist, return from the function without executing the rest of the code
  # When executed "run_if_exists flatpak flatpak update -y", $1 will be "flatpak", $2 will be flatpak, $3 will be update, $4 will be -y, but first "flatpak" is used to check if the package is installed.
  # If the package exists, the first "flatpack" is no longer needed and we want just "flatpak update -y".
  # To remove the first "flatpak", we use "shift" which shifts the positional parameters to the left, so $2 becomes $1, $3 becomes $2, and so on. After the shift, $1 will be "flatpak", $2 will be "update", and $3 will be "-y".
  shift # removes the first argument (the command name) from the list of arguments. By default "shift" moves arguments to the left by exactly 1 position. It is same as "shift 1". You can do "shift 2 or any number".
  print_header "$@"
  "$@" # Executes the remaining arguments as a command. "$@" is a special variable that represents all the positional parameters passed to the function. After the shift, it will execute the command with the remaining arguments (e.g., "flatpak update -y").
  
  # Basically what happened in this function is
  # 1. Check if the command exists using the first argument ($1). If it does not exist, return from the function.
  # 2. If the command exists, remove the first argument (the command name) from the list of arguments using "shift".
  # 3. Execute the remaining arguments as a command using "$@". (e.g., if the original arguments were "flatpak update -y", after the shift, it will execute "flatpak update -y").
  echo -e "$GreenC Done $ResetC"
}


# -----------------------
# Main script
# -----------------------
clear

echo -e "$GreenC Hello$BGreenC $USER $ResetC$GreenC on$BGreenC $HOSTNAME $ResetC"
echo -e "$GreenC Today is: $BGreenC $DATE $ResetC"
echo -e "$GreenC OS: $BGreenC $OS $ResetC"

# APT (Debian, Ubuntu)
run_if_exists apt sudo apt update -y
run_if_exists apt sudo apt upgrade -y
run_if_exists apt sudo apt autoremove -y
run_if_exists apt sudo apt autoclean -y

# DNF (Fedora)
run_if_exists dnf sudo dnf makecache
run_if_exists dnf sudo dnf upgrade -y
run_if_exists dnf sudo dnf autoremove -y
run_if_exists dnf sudo dnf clean all

# Snap
run_if_exists snap sudo snap refresh

# Flatpak
run_if_exists flatpak sudo flatpak update

# Pacman (Arch Linux)
run_if_exists pacman sudo pacman -Syu --noconfirm

# Zypper (openSUSE)
run_if_exists zypper sudo zypper refresh
run_if_exists zypper sudo zypper update -y

# OStree (Bazzite)
run_if_exists ostree sudo ostree pull
