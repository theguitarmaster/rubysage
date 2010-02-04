#!/usr/bin/env ruby

require 'rubygems'
require 'yaml'
require 'twitter'
require 'plugin.rb'

class Sage
  VERSION = '0.0.1'
  
  def initialize
    load_plugins  
  end
  
  def run
    account = load_account
    client  = create_client(account)
    process_incoming_messages(account, client)
  end
  
protected
  
  def load_plugins
    Dir["plugins/*.rb"].each{ |x| load x }
  end
  
  def load_account
    account  = YAML::load(File.open('account.yml')) 
  end
  
  def create_client(account)
    httpauth = Twitter::HTTPAuth.new(account['username'], account['password'])
    Twitter::Base.new(httpauth)
  end

  def process_incoming_messages(account, client)
    Twitter::Search.new.to(account['username']).each do |tweet|
      Plugin.registered_plugins.each do |pattern, plugin|
        regexp = Regexp.new("^@#{account['username']} #{pattern}$", Regexp::IGNORECASE)
        if !(match = tweet.text.scan(regexp)).empty?
          plugin.run(client, tweet, match)
        end
      end
    end
  end

end

sage = Sage.new()
sage.run
