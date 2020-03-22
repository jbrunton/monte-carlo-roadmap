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

    def initialize(&init_block)
      @output_path = DEFAULT_OUTPUT_PATH
      init_block.call(self) unless init_block.nil?

      raise "Task must be configured to specify input files" if input_files.nil?

      namespace :simulator do
        desc 'Run the simulator'
        task :play do
          simulator = MonteCarloRoadmap::SimulatorBuilder.new.input_files(input_files).build
          results = simulator.play

          if ENV['save']
            save_results(results)
          else
            print_results(results)
          end
        end
      end
    end

    private

    def print_results(results)
      results.each do |summary|
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

    def save_results(results)
      FileUtils.mkdir_p output_path
      File.open("#{output_path}/forecast-#{Time.now.utc.strftime("%Y%m%d%H%M%S")}.yml", 'w') do |file|
        file.write results.map{ |result| result.deep_stringify_keys }.to_yaml
        puts "Forecast saved to #{Pathname.new(file.path).relative_path_from(Dir.pwd).to_s}"
      end
    end
  end
end
