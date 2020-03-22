require './lib/monte-carlo-roadmap/simulator/simulator'
require './lib/monte-carlo-roadmap/simulator/simulator_builder'

RSpec.describe Simulator do

  let(:metadata) {
    build(:metadata, teams: %w(iOS Android API))
  }

  let(:history) {
    double('history')
  }

  subject { build(:simulator, metadata: metadata, backlog: backlog, history: history) }

  describe "#play_once" do
    context "when forecasting for a single team" do
      let(:backlog) {
        build(:backlog, items: [
            {
                name: 'Epic 1',
                estimates: {
                    'Android': 'S'
                }
            }
        ])
      }

      it "returns the result of a single run for the given team" do
        allow(history).to receive(:sample_epic_size).with('S').and_return(2)
        allow(history).to receive(:sample_throughput).with('Android', date('2020-01-01')).and_return(4)

        result = subject.play_once('Android')

        expect(result.to_h).to eq({
            team: 'Android',
            story_counts: [2],
            total_stories: 2,
            velocities: [4],
            weeks: 1,
            completion_date: date('2020-01-08')
        })
      end
    end

    context "when forecasting for multiple teams" do
      let(:backlog) {
        build(:backlog, items: [
            {
                name: 'Epic 1',
                estimates: {
                    'Android': 'S',
                    'iOS': 'S',
                    'API': 'M'
                }
            },
            {
                name: 'Epic 2',
                estimates: {
                    'API': 'S'
                }
            }
        ])
      }

      it "returns the result of a single run for the given teams" do
        allow(history).to receive(:sample_epic_size).with('S').and_return(2)
        allow(history).to receive(:sample_throughput).with('Android', date('2020-01-01')).and_return(4)

        result = subject.play_once('Android')

        expect(result.to_h).to eq({
                                      team: 'Android',
                                      story_counts: [2],
                                      total_stories: 2,
                                      velocities: [4],
                                      weeks: 1,
                                      completion_date: date('2020-01-08')
                                  })
      end
    end
  end
end
