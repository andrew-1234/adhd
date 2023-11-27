# Readme

Simple script for fast project directory setup. For personal use and learning, so paths
are hardcoded for now.

O que isso faz?:

- Prompt based
- Enter a name and the project type to create a new directory with some stuff in
  it, depending on project choice
- By default, the new project dir will include a readme and vscode workspace
- For now only other option is Go:
  - init a Go module with name of project
  - creates main.go file

## Use

- clone repo
- symlink script to somewhere on path
- `ln -s path/to/adhd.rb /usr/local/bin/adhd`
- template files should stay in the same directory as the ruby script
- `adhd` to run in terminal
  - when prompted enter project name
  - when prompted enter project type
