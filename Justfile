# just is a handy way to save and run project-specific commands.
#
# https://github.com/casey/just

# Just settings
set dotenv-load := true

# Variables
FISH_PEPPER_IMAGE := "fabric8/fish-pepper:latest"

# Lists all available commands
default:
  just --list

# fish-pepper generic command
# See fish-pepper repository for a full list of available commands: https://github.com/fabric8io-images/fish-pepper
alias fp := fish-pepper
fish-pepper *ARGS:
  @echo "Executing fish-pepper..."
  docker run -it --rm -v `pwd`:/fp -v /var/run/docker.sock:/var/run/docker.sock {{FISH_PEPPER_IMAGE}} {{ARGS}}

# fish-pepper make
# Create Docker build files from templates
alias m := make
make: (fish-pepper "make")

# fish-pepper build
# Docker images from generated build files. Implies 'make'
alias b := build
build: (fish-pepper "build")

# Format the code
alias f := fmt
fmt:
  treefmt
