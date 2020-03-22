require 'ostruct'

class Simulator
  PLAY_COUNT = 1000

  def initialize(metadata, backlog, history)
    @metadata = metadata
    @backlog = backlog
    @history = history
  end

  def play
    @metadata.teams.map do |team|
      plays = (0..PLAY_COUNT)
                  .collect { play_once(team) }
                  .sort_by { |play| play.weeks }
      summarize(plays, team)
    end
  end

  def play_once(team)
    # TODO: account for epic WIP levels.
    epic_sizes = @backlog.epic_sizes(team)
    story_counts = epic_sizes.map { |epic_size| @history.sample_epic_size(epic_size) }
    velocities = []
    total_stories = story_counts.sum * (1.0 + @metadata.unplanned_work)
    done = 0
    weeks = 0
    while done < total_stories
      velocity = @history.sample_throughput(team, @metadata.start_date + weeks * 7)
      velocity =
      done += velocity
      velocities << velocity
      weeks += 1
    end
    result = {
        team: team,
        story_counts: story_counts,
        total_stories: total_stories,
        velocities: velocities,
        weeks: weeks
    }
    unless @metadata.start_date.nil?
      result.merge!(completion_date: @metadata.start_date + weeks * 7)
    end
    OpenStruct.new(result)
  end

  private

  def summarize(plays, team)
    percentile_10 = plays[PLAY_COUNT * 0.1]
    percentile_50 = plays[PLAY_COUNT * 0.5]
    percentile_90 = plays[PLAY_COUNT * 0.9]
    summary = {
        team: team,
        percentile_10: { weeks: percentile_10.weeks, total_stories: percentile_10.total_stories },
        percentile_50: { weeks: percentile_50.weeks, total_stories: percentile_50.total_stories },
        percentile_90: { weeks: percentile_90.weeks, total_stories: percentile_90.total_stories }
    }
    unless @metadata.start_date.nil?
      summary[:percentile_10].merge!(completion_date: percentile_10.completion_date.to_s)
      summary[:percentile_50].merge!(completion_date: percentile_50.completion_date.to_s)
      summary[:percentile_90].merge!(completion_date: percentile_90.completion_date.to_s)
    end
    summary
  end
end
