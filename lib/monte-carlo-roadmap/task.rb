require 'monte-carlo-roadmap/simulator/simulator_builder'
require 'rake'
require 'rake/tasklib'

module MonteCarloRoadmap
  class Task < ::Rake::TaskLib
    include ::Rake::DSL

    attr_accessor :input_files

    def initialize(&init_block)
      init_block.call(self) unless init_block.nil?

      raise "Task must be configured to specify input files" if input_files.nil?

      namespace :simulator do
        desc 'Run the simulator'
        task :play do
          simulator = MonteCarloRoadmap::SimulatorBuilder.new.input_files(input_files).build
          results = simulator.play
          print_results(results)
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
  end
end
