#!/usr/bin/env ruby

require 'rubygems'  
require 'munin'
require 'time'

class GoBroadcastStatistics

  attr_accessor :suffix
  attr_accessor :minimum_samplecount, :maximum_samplecount
  attr_accessor :total_samplecount, :measure_count
  attr_accessor :low_adjustment, :high_adjustment

  def initialize(suffix = nil)
    @suffix = "-#{suffix}" if suffix
    @total_samplecount = @measure_count = 0
  end

  attr_accessor :log_file
  def log_file
    @log_file ||= ENV.fetch 'LOG_FILE', '/var/log/syslog'
  end 

  def offset_file
    @offset_file ||= ENV.fetch 'OFFSET_FILE', "/var/run/munin/go-broadcast#{suffix}.offset"
  end

  def tail
    IO.popen("/usr/sbin/logtail2 -f #{log_file} -o #{offset_file}") do |log|
      while line = log.gets 
        analyse(parse_line(line)) 
      end
    end
    self
  end

  def now
    if forced_now = ENV['NOW']
      Time.parse forced_now
    else
      Time.now
    end
  end

  def time_limit
    @time_limit ||= now - 300
  end

  def analyse(data)
    return unless data
    return unless (data[:time] and data[:time] > time_limit)

    samplecount = (data and data[:samplecount])
    if samplecount
      if minimum_samplecount.nil? or minimum_samplecount > samplecount
        self.minimum_samplecount = samplecount 
      end

      if maximum_samplecount.nil? or maximum_samplecount < samplecount
        self.maximum_samplecount = samplecount 
      end

      self.total_samplecount += samplecount
      self.measure_count += 1
    end

    self.low_adjustment = data[:low_adjustment]
    self.high_adjustment = data[:high_adjustment]
  end

  def average_samplecount
    if measure_count > 0
      total_samplecount / measure_count
    else
      nil
    end
  end

  LINE_FORMAT = /^(\w{3} [ :[:digit:]]{11}) .*SampleCount: ([0-9]+), Low Adjustment: ([0-9]+), High Adjustment: (-?[0-9]+).*$/

  def parse_line(line)
    if line =~ LINE_FORMAT
      { 
        :time => Time.parse($1),
        :samplecount => $2.to_i,
        :low_adjustment => $3.to_i,
        :high_adjustment => $4.to_i
      }  
    end
  end     

end

mode = nil
if $0 =~ /(buffer_size|adjustment)$/
  mode = $1
end
mode ||= ENV.fetch 'MODE', "buffer_size"


class BufferSizePlugin < Munin::Plugin

  MAXIMUM = 44100 * 10

  def initialize
    super

    declare_field :minimum, :label => "Minimum", :type => :gauge, :min => 0, :max => MAXIMUM
    declare_field :maximum, :label => "Maximum", :type => :gauge, :min => 0, :max => MAXIMUM
    declare_field :average, :label => "Average", :type => :gauge, :min => 0, :max => MAXIMUM
    
    @@graph_options[:info] = "This graph shows Go-Broadcast buffer size evolution"
    @@graph_options[:vlabel] = "Sample count"
    @@graph_options[:args] = "--lower-limit 0 --upper-limit #{MAXIMUM}"
    # @@graph_options[:scale] = "no"
  end
  
  graph_attributes "Buffer Size", :category => 'go-broadcast'

  def stats
    @stats ||= GoBroadcastStatistics.new("buffer-size").tail
  end
  
  def retrieve_values
    { 
      :minimum => stats.minimum_samplecount, 
      :maximum => stats.maximum_samplecount,
      :average => stats.average_samplecount 
    }.delete_if { |k,v| v.nil? }
  rescue => e
    $stderr.puts "Can't read go-broadcast statistics: #{e}"
    {}
  end

end if mode == "buffer_size"

class AdjustmentPlugin < Munin::Plugin

  def initialize
    super

    declare_field :low, :label => "Adjustment", :type => :derive, :negative => "high", :min => 0
    declare_field :high, :label => "High", :type => :derive, :graph => "no", :min => 0
    
    @@graph_options[:info] = "This graph shows Go-Broadcast buffer adjustment"
    @@graph_options[:vlabel] = "Samples removed (-) / added (+) per ${graph_period}"
    @@graph_options[:order] = "high low"

    # @@graph_options[:args] = "--lower-limit 0 --upper-limit #{MAXIMUM}"
    # @@graph_options[:scale] = "no"
  end
  
  graph_attributes "Buffer Adjustment", :category => 'go-broadcast'

  def stats
    @stats ||= GoBroadcastStatistics.new("adjustment").tail
  end
  
  def retrieve_values
    { 
      :low => stats.low_adjustment, 
      :high => -stats.high_adjustment,
    }.delete_if { |k,v| v.nil? }
  rescue => e
    $stderr.puts "Can't read go-broadcast statistics: #{e}"
    {}
  end

end if mode == "adjustment"

mode_class_prefix = mode.gsub(/(^|_)([a-z])/) { $2.capitalize }
plugin = Object.const_get("#{mode_class_prefix}Plugin").new
plugin.run
