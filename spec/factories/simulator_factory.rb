FactoryBot.define do
  factory :simulator, class: 'MonteCarloRoadmap::Simulator' do
    metadata
    backlog
    history

    initialize_with { new(metadata, backlog, history) }
  end
end
