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

rvm_ruby_string = ENV["rvm_ruby_string"] || "#{RUBY_ENGINE rescue 'ruby'}-#{RUBY_VERSION}-#{(RUBY_PATCHLEVEL) ? "p#{RUBY_PATCHLEVEL}" : "r#{RUBY_REVISION}"}"

# colorize prompt
IRB.conf[:PROMPT][:DOTFILES] = {
  # Do not use coloring for prompts because of weird bug in cursor positioning in IRB.
  # \001 and \002 are special characters prcessed by readline, so the substring between them
  # will not be counted in prompt length calculation.
  # http://www.tek-tips.com/viewthread.cfm?qid=1560209&page=20
  :PROMPT_I => "\001\e[90m\002#{rvm_ruby_string}\001\e[0m\002\001\e[0;36m\002 >> \001\e[0m\002",
  :PROMPT_S => "\001\e[90m\002#{rvm_ruby_string}\001\e[0m\002\001\e[0;32m\002%l>> \001\e[0m\002",
  :PROMPT_C => "\001\e[90m\002#{rvm_ruby_string}\001\e[0m\002\001\e[0;36m\002 .. \001\e[0m\002",
  :PROMPT_N => "\001\e[90m\002#{rvm_ruby_string}\001\e[0m\002\001\e[0;36m\002?.. \001\e[0m\002",
  :RETURN   => "\e[1;31m\342\206\222\e[0m %s\n"
}
# Mac OS X uses editline instead of readline by default. It does not support invisible
# chars guards, so there will be positioning problems in IRB console. Strip invisible chars
# now.
#
# If you want to get a full-featured IRB console, recompile your ruby with normal readline:
#     rvm install ree -C --with-readline-dir=/opt/homebrew/Cellar/readline/6.0
#
# BTW, editline does not support UTF8...
if Readline::VERSION == 'EditLine wrapper'
  puts "\e[31mWARNING\e[0m: You ruby built with \e[35meditline\e[0m, instead of \e[35mreadline\e[0m, so it does not support" +
    "Unicode and ANSI chars in prompt.\n" +
    "Please re-build your Ruby with readline support (see http://bit.ly/dxQmvQ for details):
    \e[90mrvm install ree -C --with-readline-dir=/opt/homebrew/Cellar/readline/6.0\e[0m"
  IRB.conf[:PROMPT][:DOTFILES].each do |k, v|
    IRB.conf[:PROMPT][:DOTFILES][k] = v.gsub(%r{\001[^\002]*\002}, '')
  end
end
IRB.conf[:PROMPT_MODE] = :DOTFILES

# pretty print
require 'pp'

# awesome print
begin
  require 'ap'

  IRB::Irb.class_eval do
    def output_value
      puts IRB.conf[:PROMPT][:DOTFILES][:RETURN] % @context.last_value.ai
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
