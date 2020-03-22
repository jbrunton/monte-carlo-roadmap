FactoryBot.define do
  factory :backlog, class: 'MonteCarloRoadmap::Backlog' do
    items {
      [
          { name: 'Epic 1', estimates: { 'Android': 'S', 'iOS': 'S', 'API': 'M' } },
          { name: 'Epic 2', estimates: { 'API': 'M' } }
      ]
    }

    initialize_with { new(items.map { |item| ostruct(item) }) }
  end
end
