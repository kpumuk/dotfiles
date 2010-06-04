# encoding: utf-8
begin
  # Load rubygems and some helpful gems
  require 'rubygems'
rescue LoadError
  abort 'Rubygems not available!'
end

# IRB settings
require 'irb/completion'
require 'irb/ext/save-history'
IRB.conf[:AUTO_INDENT]  = true
IRB.conf[:USE_READLINE] = true
IRB.conf[:SAVE_HISTORY] = 1000
IRB.conf[:HISTORY_FILE] = "#{ENV['HOME']}/.irb_history"

# colorize prompt
IRB.conf[:PROMPT][:CUSTOM] = {
  # Do not use coloring for prompts because of weird bug in cursor positioning in IRB.
  # \001 and \002 are special characters prcessed by readline, so the substring between them
  # will not be counted in prompt length calculation.
  # http://www.tek-tips.com/viewthread.cfm?qid=1560209&page=20
  :PROMPT_I => "\001\e[0;36m\002>> \001\e[0m\002",
  :PROMPT_S => "\001\e[0;32m\002>> \001\e[0m\002",
  :PROMPT_C => "\001\e[0;36m\002.. \001\e[0m\002",
  :PROMPT_N => "\001\e[0;36m\002.. \001\e[0m\002",
  :RETURN   => "\e[1;31m\342\206\222\e[0m %s\n"
}
IRB.conf[:PROMPT_MODE] = :CUSTOM

# pretty print
require 'pp'

# awesome print
begin
  require 'ap'

  IRB::Irb.class_eval do
    def output_value
      puts IRB.conf[:PROMPT][:CUSTOM][:RETURN] % @context.last_value.ai
    end
  end
rescue LoadError
  puts 'AwesomePrint gem not available: `gem install awesome_print`'
end

# Looksee gem
begin
  require 'looksee/shortcuts'
rescue LoadError
  puts 'Looksee gem not available: `gem install looksee`'
end

# Easily print methods local to an object's class
module ObjectLocalMethods
  def local_methods(include_superclasses = true)
    (self.methods - (include_superclasses ? Object.methods : obj.class.superclass.instance_methods)).sort
  end
end
Object.send(:extend,  ObjectLocalMethods)
Object.send(:include, ObjectLocalMethods)

module Kernel
  def copy(str)
    IO.popen('pbcopy', 'w') { |f| f << str.to_s }
    str
  end

  def paste
    `pbpaste`
  end

  def copy_history
    history = Readline::HISTORY.entries
    index = history.rindex("exit") || -1
    content = history[(index + 1)..-2].join("\n")
    puts content
    copy content
  end
end

# Log to STDOUT if in Rails
if ENV.include?('RAILS_ENV') && !Object.const_defined?('RAILS_DEFAULT_LOGGER')
  require 'logger'
  RAILS_DEFAULT_LOGGER = Logger.new(STDOUT)
end

