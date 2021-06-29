# frozen_string_literal: true

require 'yaml'
require 'date'

CONFIG = YAML.load_file('config.yml')

PARSED_FILE_PATH = ENV["PARSED_FILE_PATH"] || CONFIG['parsed_file_path']
DATE = ENV["DATE"] || DateTime.now
TITLE = ENV["TITLE"] || CONFIG['title']
EDITOR = ENV["EDITOR"] || CONFIG['editor']
ACTIVITIES_DIR = ENV["ACTIVITIES_DIR"] || CONFIG['activities_dir'] || File.dirname(__FILE__)
