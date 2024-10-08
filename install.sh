#!/bin/bash

# Enable error handling
set -euo pipefail

# Define variables
DOTFILES_REPO="https://github.com/Randallsm83/dotfiles.git"
DOTFILES_DIR="$HOME/dotfiles"
LOCAL_BIN="$HOME/local/bin"
LOCAL_DIR="$HOME/local"
STOW_URL_BASE="https://ftp.gnu.org/gnu/stow"
DEPENDENCIES=("wget" "tar" "git" "make" "gcc")

# Function to check dependencies
check_dependencies() {
    echo "Checking dependencies..."
    for dep in "${DEPENDENCIES[@]}"; do
        if ! command -v "$dep" &>/dev/null; then
            echo "Error: $dep is not installed. Please install it first."
            exit 1
        fi
    done
    echo "All dependencies are installed."
}

# Function to get the latest GNU Stow version number
get_latest_stow_version() {
    wget -qO- "$STOW_URL_BASE/" | grep -oP 'stow-\K[0-9.]+(?=.tar.gz)' | sort -V | tail -1
}

# Function to install GNU Stow locally
install_stow() {
    STOW_VERSION=$(get_latest_stow_version)
    STOW_TAR="stow-$STOW_VERSION.tar.gz"
    STOW_URL="$STOW_URL_BASE/$STOW_TAR"

    echo "Installing GNU Stow locally..."
    echo "Latest GNU Stow version: $STOW_VERSION"

    # Create local directories
    mkdir -p "$LOCAL_BIN"

    # Download and extract GNU Stow
    wget "$STOW_URL" -O "$STOW_TAR"
    tar -xf "$STOW_TAR"
    cd "stow-$STOW_VERSION" || exit

    # Install Stow locally in ~/local
    ./configure --prefix="$LOCAL_DIR"
    make -j$(nproc)
    make install

    # Clean up
    cd ..
    rm -rf "stow-$STOW_VERSION" "$STOW_TAR"

    echo "GNU Stow installed locally at $LOCAL_BIN"
}

# Function to clone dotfiles repository
clone_dotfiles() {
    echo "Cloning dotfiles repository..."
    if [ -d "$DOTFILES_DIR" ]; then
        echo "Dotfiles directory already exists."
        cd "$DOTFILES_DIR" || exit

        # Check for local changes
        if [ -n "$(git status --porcelain)" ]; then
            echo "Local changes detected in dotfiles repository."

            # Prompt user to stash or reset
            read -p "Would you like to (s)tash, (r)eset, or (a)bort? [s/r/a]: " choice
            case $choice in
                s|S)
                    echo "Stashing local changes..."
                    git stash --include-untracked
                    ;;
                r|R)
                    echo "Resetting local changes..."
                    git reset --hard
                    git clean -fd
                    ;;
                a|A)
                    echo "Aborting..."
                    exit 1
                    ;;
                *)
                    echo "Invalid choice. Aborting..."
                    exit 1
                    ;;
            esac
        fi

        # Pull latest changes
        echo "Pulling latest changes from repository..."
        git pull --rebase origin main
    else
        git clone "$DOTFILES_REPO" "$DOTFILES_DIR"
    fi
    echo "Dotfiles cloned to $DOTFILES_DIR"
}

# Function to restore stashed changes
restore_stashed_changes() {
    cd "$DOTFILES_DIR" || exit
    if git stash list | grep -q 'stash@{0}'; then
        echo "Restoring stashed changes..."
        git stash pop
    else
        echo "No stashed changes to restore."
    fi
}

# Function to back up conflicting files during stow operation
backup_conflicting_files() {
    local conflicting_dir="$1"
    local backup_dir="$HOME/dotfiles_backup"
    mkdir -p "$backup_dir"
    echo "Backing up existing dotfiles from $HOME to $backup_dir"

    # Check for conflicts in the home directory and back them up
    for file in "$DOTFILES_DIR/$conflicting_dir"/*; do
        filename="$(basename "$file")"
        home_file="$HOME/$filename"

        # If the file exists in home and is not a symlink, back it up
        if [ -e "$home_file" ] && [ ! -L "$home_file" ]; then
            echo "Backing up $home_file to $backup_dir"
            mv "$home_file" "$backup_dir"
        fi
    done
    echo "Backup completed for $conflicting_dir."
}

# Function to create symlinks using stow with options for handling conflicts
stow_dotfiles() {
    echo "Creating symlinks with GNU Stow..."

    # Add ~/local/bin to PATH if it's not already there
    if [[ ":$PATH:" != *":$LOCAL_BIN:"* ]]; then
        export PATH="$LOCAL_BIN:$PATH"
    fi

    cd "$DOTFILES_DIR" || exit

    # Use stow to create symlinks for each directory
    for dir in */; do
        echo "Stowing $dir"

        # Check if there are conflicting files before stowing
        if stow --override=~ -n -v -t ~ "$dir" 2>&1 | grep -q "would cause conflicts"; then
            echo "Conflicts detected for $dir:"
            stow --override=~ -n -v -t ~ "$dir"

            # Print what each option will do
            echo "Options:"
            echo "  (s)kip: Do not stow $dir."
            echo "  (b)ackup: Move conflicting files in $HOME to $HOME/dotfiles_backup and then stow $dir."
            echo "  (a)dopt: Make stow take control of existing conflicting files."
            echo "  (o)verwrite: Forcefully replace conflicting files with symlinks from $dir."
            read -r -p "Choose an option: [s/b/a/o]: " choice

            case $choice in
                s|S)
                    echo "Skipping $dir..."
                    ;;
                b|B)
                    echo "Backing up conflicting files for $dir..."
                    backup_conflicting_files "$dir"
                    stow --override=~ -v -t ~ "$dir"
                    ;;
                a|A)
                    echo "Adopting existing files for $dir..."
                    stow --override=~ --adopt -v -t ~ "$dir"
                    ;;
                o|O)
                    echo "Overwriting existing files for $dir..."
                    stow --override=~ --force -v -t ~ "$dir"
                    ;;
                *)
                    echo "Invalid choice. Skipping $dir..."
                    ;;
            esac
        else
            stow --override=~ -v -t ~ "$dir"
        fi
    done

    echo "Symlinks created successfully."
}

# Function to check if GNU Stow is installed
check_stow_installation() {
    if ! command -v stow &> /dev/null; then
        echo "GNU Stow is not installed. Installing now..."
        install_stow
    else
        echo "GNU Stow is already installed."
    fi
}

# Check and install dependencies
check_dependencies

# Check if GNU Stow is installed and install it if not
check_stow_installation

# Clone dotfiles repository and handle any local changes
clone_dotfiles

# Create symlinks using GNU Stow and handle conflicts dynamically
stow_dotfiles

# Restore stashed changes, if any
restore_stashed_changes

echo "Dotfiles setup completed!"
