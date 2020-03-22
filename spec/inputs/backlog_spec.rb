require './lib/monte-carlo-roadmap/inputs/backlog'

RSpec.describe MonteCarloRoadmap::Backlog do
  let(:items) {
    [
        { name: 'Epic 1', estimates: { Android: 'S', iOS: 'S', API: 'M' } },
        { name: 'Epic 2', estimates: { API: 'S' } }
    ]
  }

  subject { build(:backlog, items: items) }

  it "returns backlog sizes for the given team" do
    expect(subject.epic_sizes('Android')).to eq(['S'])
    expect(subject.epic_sizes('API')).to eq(%w(M S))
  end
end
