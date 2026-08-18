# Linux System Update Script

A simple Bash script that automatically detects available Linux package managers and runs the appropriate system update and cleanup commands.

The script is designed to work across several Linux distributions, including Debian/Ubuntu, Fedora, Arch Linux, openSUSE, systems using Snap or Flatpak, and OSTree-based systems such as Bazzite.

## Features
Displays the current:
Username
Hostname
Date and time
Operating system
Uses colored terminal output for better readability.
Automatically checks whether a package-management command exists before running it.
Updates and cleans up supported package managers.
Supports multiple package-management systems:
APT
DNF
Snap
Flatpak
Pacman
Zypper
OSTree
Skips package managers that are not installed.
Supported Package Managers
Package Manager	Operations
APT	Update, upgrade, autoremove, autoclean
DNF	Make cache, upgrade, autoremove, clean
Snap	Refresh
Flatpak	Update
Pacman	Full system upgrade
Zypper	Refresh, update
OSTree	Pull updates
Requirements

## The script requires:

### Bash
A supported Linux distribution
sudo privileges for commands that require administrative access

Some commands used by the script, such as lsb_release, may not be installed on every Linux distribution.

On Debian/Ubuntu, you can install it with:

sudo apt install lsb-release

## Installation

Clone or download the script and make it executable:

chmod +x update.sh


Replace update.sh with the actual filename if you use a different name.

Usage

Run the script:

./update.sh


Because several operations require administrator privileges, you may be prompted for your sudo password.

How run_if_exists Works

The main reusable function in the script is:

run_if_exists()


It first checks whether the command specified by the first argument is available:

command -v "$1" >/dev/null 2>&1 || return


For example:

run_if_exists flatpak sudo flatpak update


The function first checks whether flatpak exists.

If it does not exist, the function exits without doing anything.

If it exists, shift removes the first argument:

Before shift:
$1 = flatpak
$2 = sudo
$3 = flatpak
$4 = update

After shift:
$1 = sudo
$2 = flatpak
$3 = update


The remaining arguments are then executed with:

"$@"


This allows the same function to be used for different package managers without repeatedly writing command-existence checks.

Example Output

The script starts by displaying basic system information:

Hello username on hostname
Today is: 2026-08-18_18:00:00
OS: Ubuntu 24.04 LTS


It then runs the available package-management commands.

If a package manager is not installed, it is automatically skipped.

Package Manager Commands
APT

Used by Debian, Ubuntu, Linux Mint, and related distributions.

sudo apt update -y
sudo apt upgrade -y
sudo apt autoremove -y
sudo apt autoclean -y

DNF

Used by Fedora and several RPM-based distributions.

sudo dnf makecache
sudo dnf upgrade -y
sudo dnf autoremove -y
sudo dnf clean all

Snap

Refreshes installed Snap packages:

sudo snap refresh

Flatpak

Updates installed Flatpak applications:

sudo flatpak update

Pacman

Performs a full system upgrade on Arch Linux:

sudo pacman -Syu --noconfirm

Zypper

Refreshes repositories and updates packages:

sudo zypper refresh
sudo zypper update -y

OSTree

Pulls updates from an OSTree repository:

sudo ostree pull

Important Notes
Multiple Package Managers

The script does not try to determine the Linux distribution before running package-manager commands. Instead, it checks whether each command exists.

For example, on a system with both Snap and Flatpak installed, both will be updated.

This is useful for systems where multiple package-management technologies are intentionally installed.

apt update -y

apt update generally does not require -y, because it does not normally ask for confirmation. The script uses:

sudo apt update -y


This is harmless on many systems, but -y is not necessary for this operation.

lsb_release

The following line:

OS=$(lsb_release -d | awk -F"\t" '{print $2}')


depends on lsb_release being available.

If you want the script to be more portable, you could use /etc/os-release instead.

For example:

OS=$(. /etc/os-release && echo "$PRETTY_NAME")


This is generally available on modern Linux distributions.

OSTree

The OSTree command:

sudo ostree pull


is not equivalent to the normal update workflow used by every OSTree-based distribution.

For systems such as Bazzite, Fedora Atomic, and similar immutable distributions, the operating-system update mechanism is normally provided by the distribution's image/update tooling.

Therefore, the OSTree section should be reviewed before relying on it for complete system updates.

Safety

The script performs system-level package operations using sudo.

Before using it on an important system:

Review the commands.
Make sure you understand what each package manager operation does.
Keep backups of important data.
Avoid running it blindly on production systems.
Test it in a virtual machine or non-critical system first.

The --noconfirm option used by Pacman means the package manager will not ask for confirmation before proceeding:

sudo pacman -Syu --noconfirm


Use this option only if you are comfortable with fully automatic package upgrades.

Customization

You can add additional package managers by following the same pattern:

run_if_exists <command> <command> <arguments>


For example:

run_if_exists nala sudo nala upgrade -y


The first argument is used to check whether the command exists. The remaining arguments are executed when it is available.

License

You can use, modify, and distribute this script according to the license you choose for your project. If this is an open-source project, adding an explicit license file is recommended.
