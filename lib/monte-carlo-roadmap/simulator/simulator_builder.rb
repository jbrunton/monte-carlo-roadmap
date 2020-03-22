require 'config'
require 'monte-carlo-roadmap/inputs/metadata'
require 'monte-carlo-roadmap/inputs/backlog'
require 'monte-carlo-roadmap/inputs/history'
require 'monte-carlo-roadmap/simulator/simulator'

class SimulatorBuilder
  def input_files(input_files)
    raise "Cannot set both input_files and inputs" unless @inputs.nil?
    @input_files = input_files
    self
  end

  def inputs(inputs)
    raise "Cannot set both input_files and inputs" unless @input_files.nil?
    @inputs = inputs
    self
  end

  def seed(seed)
    @seed = nil
  end

  def build
    raise "Set either inputs or input_files" if @input_files.nil? && @inputs.nil?
    if @inputs.nil?
      Config.setup do |config|
        config.overwrite_arrays = false
      end
      Config.load_and_set_settings(*@input_files)
      inputs = Settings
    else
      inputs = @inputs
    end
    Simulator.new(Metadata.new(inputs.metadata), Backlog.new(inputs.backlog), History.new(inputs.history, @seed))
  end
end
