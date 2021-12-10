# just is a handy way to save and run project-specific commands.
#
# https://github.com/casey/just

# Just settings
set dotenv-load := true

# Variables
FISH_PEPPER_VERSION := "latest"

# Lists all available commands
default:
  just --list

# fish-pepper command
alias fp := fish-pepper
fish-pepper *ARGS:
  docker run -it --rm -v `pwd`:/fp -v /var/run/docker.sock:/var/run/docker.sock fabric8/fish-pepper:{{FISH_PEPPER_VERSION}} {{ARGS}}

# Format the code
alias f := fmt
fmt:
  treefmt
