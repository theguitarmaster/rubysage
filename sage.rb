#!/usr/bin/env ruby

# == Synopsis 
#   Simple little Bot for Twitter.
#   Uses plugins to extend the bot's capabilities.
# 
# == Details 
#   When run in the normal manner it will connect to twitter and collect
#   recent tweets sent to the account detailed within account.yml. It will
#   then process these tweets using the currently available responders.
#
#   Responders sit within the 'responders' directory and provide specific bits
#   of functionality for the bot. Theses are effectively the commands that
#   the bot can respond to. They are implemented as plugins.
#
#   To use the bot for real you must create an 'account.yml' file containing
#   your twitter username and password. OAuth support will come in time.
#
#   If you want to test the bot out without actually tweeting anything out
#   to the great unwashed public then you can run it in test mode. In this
#   mode it will utilise a local yml file to provide incoming tweets and will
#   simply return text indicating how it would have tweeted had it been
#   running for real. This makes it easy to test out new plugins by crafting
#   sample tweets and checking that the bot responds in the correct manner.
#
# == Usage
#   To run the bot and process incoming messages etc. simply set up your
#   account.yml file and then...
#     sage.rb
#
#   To run it locally for testing purposes then do this...
#     sage.rb --test
#
#   If you run locally then be sure to create some yml files to use in place
#   of the real twitter API. See example files for more details.
#
# == Options
#   -h, --help          Displays help message
#   -v, --version       Display the version, then exit
#   -V, --verbose       Verbose output
#   -t, --test          Run in test mode making no remote connections

require 'rubygems'
require 'yaml'
require 'hashie'
require 'twitter'
require 'optparse' 
require 'rdoc/usage'
require 'ostruct'
require 'lib/responder.rb'

class Sage
  VERSION = '0.0.2'
  
  attr_reader :options
  
  def initialize(arguments)
    @arguments = arguments
    
    # Set defaults
    @options = OpenStruct.new
    @options.verbose = false
    @options.testing = false
    
    load_responders  
  end
  
  def run
    if parsed_options?
      client = create_client
      process_mentions(client)
    end
  end
  
protected
  
  def load_responders
    puts "Lodaing responders from ./responders directory" if @options.verbose
    Dir["responders/*.rb"].each{ |x| load x }
  end
  
  def parsed_options?
    # Specify options
    opts = OptionParser.new 
    opts.on('-v', '--version')    { output_version ; exit 0 }
    opts.on('-h', '--help')       { output_help }
    opts.on('-V', '--verbose')    { @options.verbose = true }  
    opts.on('-t', '--test')       { @options.testing = true }

    opts.parse!(@arguments) rescue return false
    true      
  end
  
  def output_version
    puts "#{File.basename(__FILE__)} version #{VERSION}"
  end
  
  def output_help
    output_version
    RDoc::usage() #exits app
  end
  
  def create_client
    if @options.testing
      puts "Creating a fake client for local testing" if @options.verbose
      LocalClient.new
    else
      puts "Attempting to login to twitter and create a client" if @options.verbose
      account  = YAML::load(File.open('config/account.yml')) 
      httpauth = Twitter::HTTPAuth.new(account['username'], account['password'])
      Twitter::Base.new(httpauth)
    end
  end

  def process_mentions(client)
    max_id = get_users_max_tweet_id(client)
    puts "Processing mentions (incoming messages since #{max_id})" if @options.verbose
    # For each mention see if any plugins can respond to it.
    # This nested loop is as ugly as hell and could be done better!
    client.mentions(:since_id => max_id).each do |tweet|
      Responder.registered_responders.each do |pattern, responder|
        regexp = Regexp.new(pattern, Regexp::IGNORECASE)
        matches = tweet.text.scan(regexp)
        puts " #{responder.name} ==> #{tweet.text} ==> #{matches.inspect}" if @options.verbose
        unless matches.empty?
          client.update responder.run(tweet, matches)
        end
      end
    end
  end
  
  def get_users_max_tweet_id(client)
    client.user_timeline(:count => 1).first.id
  end

end

class LocalClient
  def initialize
  end
  
  def update(text)
    puts " ...#{text}"
  end
  
  def mentions(parameters = {})
    mash_yaml('config/mentions.yml')
  end
  
  def user_timeline(parameters = {})
    [ Hashie::Mash.new({:id => 1}) ]
  end
  
protected

  # Takes a filename for a yaml file and converts its contents into a Mash.
  # This is the object type that the twitter API uses internally so this lets
  # us fake out API responses. Mashes are just Hashes with bells on!
  def mash_yaml(filename)
    things = []
    YAML::load(File.open(filename)).each_value do |thing|
      things << Hashie::Mash.new(thing)
    end
    things
  end

end

sage = Sage.new(ARGV)
sage.run
