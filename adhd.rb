#!/usr/bin/env ruby
require 'fileutils'
require 'json'

def display_help
  puts 'Available commands:'
  puts '  help             - Show this help message'
  puts '  new              - Start a new project (interactive)'
  puts '  -q [name] [type] - Quick start project (non-interactive)'
  puts '  -p PATH          - Set the base path for projects'
  puts '  -pg PATH         - Set the base path for Go projects'
end

def start_new_project(_name = nil, _type = nil)
  if _name.nil?
    print 'Enter the project name: '
    project_name = STDIN.gets.chomp
  else
    project_name = _name
  end
  # Set the base directory
  base_directory = File.expand_path('~/Documents/GitHub')
  project_directory = File.join(base_directory, project_name)
  if File.directory?(project_directory)
    puts 'Project directory already exists, exiting.'
    exit
  else
    FileUtils.mkdir_p(project_directory)
    create_workspace_file(project_directory, project_name)
    create_readme_file(project_directory)
    define_project_type(project_directory, project_name, _type)
    print "Project '#{project_name}'"
    puts "created successfully in #{project_directory}"
    exit
  end
end

def create_workspace_file(project_directory, project_name)
  workspace_content = {
    'folders' => [{ 'path' => '.' }],
    'settings' => {}
  }.to_json

  workspace_file = File.join(project_directory,
                             "#{project_name}.code-workspace")
  File.open(workspace_file, 'w') do |file|
    file.write(workspace_content)
  end
end

def create_readme_file(project_directory)
  adhd_location = File.dirname(File.realdirpath($PROGRAM_NAME))
  readme_template_path = File.join(adhd_location, 'template_readme.md')
  readme_template_contents = File.read(readme_template_path)
  project_readme = File.join(project_directory, 'README.md')
  File.write(project_readme, readme_template_contents)
end

def define_project_type(project_directory, project_name, _type = nil)
  if _type.nil?
    print "Enter the project type (e.g., 'go'): "
    project_type = STDIN.gets.chomp
  else
    project_type = _type
  end
  case project_type.downcase
  when 'go'
    init_go_project(project_directory, project_name)
  else
    puts "Unsupported project type: #{project_type}"
    puts 'Using default project structure'
  end
end

# Initialise a Go project in the given directory.
#
# Method to init Go template. A Go module is created using the project name as
# the module name, and a basic `main.go` file is created.
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
    File.open('main.go', 'w') do |file|
      file.puts "package main\n\nimport \"fmt\"\n\nfunc main() {\n\tfmt.Println(\"Hello, World\")\n}"
    end
  end
end

# Entry point for the script
case ARGV[0]
when 'help'
  display_help
when 'new'
  start_new_project
when '-q'
  start_new_project(ARGV[1], ARGV[2])
when '-p'
  set_base_path(ARGV[1])
when '-pg'
  set_go_path(ARGV[1])
else
  puts "Invalid command. Use 'adhd help' for usage information."
end
