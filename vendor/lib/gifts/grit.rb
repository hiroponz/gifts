# core
require 'fileutils'
require 'time'

# stdlib
require 'timeout'
require 'logger'
require 'digest/sha1'

# third party

begin
  require 'mime/types'
  require 'rubygems'
rescue LoadError
  require 'rubygems'
  begin
    gem "mime-types", ">=0"
    require 'mime/types'
  rescue Gem::LoadError => e
    puts "WARNING: Gem LoadError: #{e.message}"
  end
end

# ruby 1.9 compatibility
require 'gifts/grit/ruby1.9'

# internal requires
require 'gifts/grit/lazy'
require 'gifts/grit/errors'
require 'gifts/grit/git-ruby'
require 'gifts/grit/git' unless defined? Gifts::Grit::Git
require 'gifts/grit/ref'
require 'gifts/grit/tag'
require 'gifts/grit/commit'
require 'gifts/grit/commit_stats'
require 'gifts/grit/tree'
require 'gifts/grit/blob'
require 'gifts/grit/actor'
require 'gifts/grit/diff'
require 'gifts/grit/config'
require 'gifts/grit/repo'
require 'gifts/grit/index'
require 'gifts/grit/status'
require 'gifts/grit/submodule'
require 'gifts/grit/blame'
require 'gifts/grit/merge'

module Gifts::Grit
  VERSION = '2.5.0'

  class << self
    # Set +debug+ to true to log all git calls and responses
    attr_accessor :debug
    attr_accessor :use_git_ruby
    attr_accessor :no_quote

    # The standard +logger+ for debugging git calls - this defaults to a plain STDOUT logger
    attr_accessor :logger
    def log(str)
      logger.debug { str }
    end
  end
  self.debug = false
  self.use_git_ruby = true
  self.no_quote = false

  @logger ||= ::Logger.new(STDOUT)

  def self.version
    VERSION
  end
end
