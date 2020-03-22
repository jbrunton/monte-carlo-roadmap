require 'monte-carlo-roadmap/simulator/simulator_builder'
require 'rake'
require 'rake/tasklib'
require 'fileutils'
require 'active_support/core_ext/hash/keys'

module MonteCarloRoadmap
  class Task < ::Rake::TaskLib
    include ::Rake::DSL

    DEFAULT_OUTPUT_PATH = File.join(Dir.pwd, 'forecasts')

    attr_accessor :input_files
    attr_accessor :output_path
    attr_accessor :output_format

    def initialize(name=:run, &init_block)
      @output_path = DEFAULT_OUTPUT_PATH
      @output_format = :console

      init_block.call(self) unless init_block.nil?

      raise "Task must be configured to specify input files" if input_files.nil?

      namespace :simulator do
        desc 'Run the simulator'
        task name do
          seed = Integer(ENV['seed']) unless ENV['seed'].nil?
          simulator = MonteCarloRoadmap::SimulatorBuilder.new
                          .input_files(input_files)
                          .seed(seed)
                          .build
          forecast = simulator.play

          case output_format
          when :console
            print_results(forecast)
          when :yaml
            save_results(forecast)
          else
            raise "Unexpected output format: #{output_format}. Should be :console or :yaml"
          end
        end
      end
    end

    private

    def print_results(forecast)
      puts "Seed: #{forecast.seed}"
      puts "Timestamp: #{forecast.timestamp}"
      forecast.results.each do |summary|
        puts "Team: #{summary[:team]}"
        {
            10 => summary[:percentile_10],
            50 => summary[:percentile_50],
            90 => summary[:percentile_90]
        }.each do |percentile, percentile_summary|
          pretty_date = Date.parse(percentile_summary[:completion_date]).strftime('%d %b %Y')
          puts "  #{percentile}th percentile: #{pretty_date}" +
                   " (stories: #{percentile_summary[:total_stories]}, weeks: #{percentile_summary[:weeks]})"
        end
      end
    end

    def save_results(forecast)
      FileUtils.mkdir_p output_path
      File.open("#{output_path}/forecast-#{Time.now.utc.strftime("%Y%m%d%H%M%S")}.yml", 'w') do |file|
        file.write forecast.to_h.deep_stringify_keys.to_yaml
        puts "Forecast saved to #{Pathname.new(file.path).relative_path_from(Dir.pwd).to_s}"
      end
    end
  end
end
