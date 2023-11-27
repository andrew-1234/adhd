#!/usr/bin/env ruby
require 'fileutils'
require 'json'

# Set the base directory
base_directory = File.expand_path('~/Documents/GitHub')

# Prompt for the project name
print "Enter the project name: "
project_name = gets.chomp

# Prompt for the project type
print "Enter the project type (e.g., 'go'): "
project_type = gets.chomp.downcase


# Create the project directory
project_directory = File.join(base_directory, project_name)

if File.directory?(project_directory)
  puts "Project directory already exists, exiting."
  exit
end

FileUtils.mkdir_p(project_directory)

script_location = File.realdirpath($PROGRAM_NAME)

# Get the directory of the script
script_directory = File.dirname(script_location)

# Now set the template path relative to the script's actual directory
template_path = File.join(script_directory, 'template_readme.md')

template_content = File.read(template_path)
readme_file = File.join(project_directory, 'README.md')
File.write(readme_file, template_content)

# Create the VS Code workspace file content
workspace_content = {
  "folders" => [{ "path" => "." }],
  "settings" => {}
}.to_json

# Write the workspace file
workspace_file = File.join(project_directory, "#{project_name}.code-workspace")
File.open(workspace_file, 'w') do |file|
  file.write(workspace_content)
end

# Initialise a Go project in the given directory.
#
# This method initialises a Go project template. A Go module is created using
# the project name (my my github username) as the module name. The method then
# and adds a basic `main.go` file to the project directory.
#
# @param project_directory [String] The directory where the project will be
# initialised
# @param project_name [String] The name of the project, used to name the Go
# module
#
# @return [void] Does not return anything
def init_go_project(project_directory, project_name)
  Dir.chdir(project_directory) do
    system("go mod init github.com/andrew-1234/#{project_name}")
    File.open("main.go", "w") do |file|
      file.puts "package main\n\nimport \"fmt\"\n\nfunc main() {\n\tfmt.Println(\"Hello, World\")\n}"
    end
  end
end

case project_type.downcase
when 'go'
  init_go_project(project_directory, project_name)
else
  puts "Unsupported project type: #{project_type}"
  puts "Using default project structure"
  exit
end

puts "Project '#{project_name}' created successfully in #{project_directory}"
