#!/usr/bin/env ruby

# frozen_string_literal: true

# Pseudo-Projectile Plugin for zsh
# Written by Git Girl (git-girl)
# github.com/git-girl/pseudo-projectile-plugin

# open project symlink folder with FZF and start nvim

require 'optparse'

def set_vars
  @pwd = `echo $PWD`
  @size = 10

  @path_to_projects = `echo $PATHTOPROJECTS`
end

def set_opts
  @options = {}

  OptionParser.new do |opts|
    opts.banner = 'Usage: ppp.rb [options]'\
                  "\n\n"\
                  "Options: \n"\
                  "e, --editor:  Set the editor \n"\
                  "s, --size: \n"\
                  "h, --help: \n"

    opts.on('e', '--editor', 'Set the editor with which to open the project') do |e|
      options[:editor] = e
    end

    opts.on('-s', '--size', 'Set the size of the') do |v|
      options[:verbose] = v
    end

    opts.on('-h', '--help', 'Display this help') do
      puts opts.banner

      # WARNING: Exit on help
      abort
    end
  end.parse!

  # p options
  # p ARGV
end

def project_open
  @cd_path = if $1
               `find -L ~/projects -maxdepth 1 -print | fzf --no-multi --height #{@size} -1 -q $1`
             else
               `find -L ~/projects -maxdepth 1 -print | fzf --no-multi --height #{@size}`
             end

  `cd #{@cd_path}` if @cd_path
end

def main
  set_vars
  set_opts
  project_open
end

main
