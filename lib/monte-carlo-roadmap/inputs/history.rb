module MonteCarloRoadmap
  class History
    attr_reader :random

    def initialize(inputs, seed = nil)
      @inputs = inputs
      @seed = seed

      @random = Random.new(seed) unless seed.nil?
      @random ||= Random.new
    end

    def sample_epic_size(epic_size)
      sample(@inputs.epic_sizes.send(epic_size))
    end

    def sample_throughput(team, date)
      throughput = sample(@inputs.teams.send(team).throughput)
      adjust_throughput(throughput, date, @inputs.teams.send(team).adjustments)
    end

    private

    def adjust_throughput(throughput, date, adjustments)
      adjusted_throughput = throughput
      (adjustments || []).each do |adjustment|
        if adjustment[:from] <= date && date < adjustment[:until]
          adjusted_throughput *= Float(adjustment[:adjust_throughput_by].tr('%', '')) / 100.0
        end
      end
      adjusted_throughput
    end

    def sample(values)
      values[@random.rand(values.length)]
    end
  end
end
