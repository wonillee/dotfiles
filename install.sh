#!/bin/sh

echo "Setting up your Mac ..."

# Install requirements
xcode-select --install

# Check for Homebrew and install if we don't have it.
if test ! $(which brew); then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
if [ ! -f ~/.zprofile ]; then
  echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Update Homebrew recipes
brew update

# Install all our dependencies with Brewfile
brew tap homebrew/bundle
brew bundle

# Install Oh-My-Zsh & custom aliases

ZSH=~/.oh-my-zsh

if [ -d "$ZSH" ]; then
  echo "Oh My Zsh is already installed. Skipping.."
else
  echo "Installing Oh My Zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/master/tools/install.sh)"
fi

# Add plugins for zsh
sed -i'' -e 's/plugins=(git)/plugins=(git fzf fasd)/g' ~/.zshrc

# Set macOS preferences
# This reloads the shell, that's why we run it last.
source .macos

# Set jenv
if [[ -z `grep -e "jenv init" ~/.zshrc` ]]
  then echo 'eval "$(jenv init -)"' >> ~/.zshrc
fi
exec zsh

jenv add $(/usr/libexec/java_home -v1.8)
jenv add $(/usr/libexec/java_home -v1.11)
jenv global 1.8

