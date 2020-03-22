module MonteCarloRoadmap
  class Metadata
    def initialize(inputs)
      @inputs = inputs
    end

    def teams
      @inputs.teams
    end

    def hourly_cost
      @inputs.hourly_cost
    end

    def start_date
      @inputs.start_date
    end

    def unplanned_work
      Float(@inputs.unplanned_work.tr('%', '')) / 100.0
    end
  end
end
