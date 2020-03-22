FactoryBot.define do
  factory :metadata, class: 'MonteCarloRoadmap::Metadata' do
    teams { %w(Android iOS API) }
    hourly_cost { 80 }
    start_date { date('2020-01-01') }
    unplanned_work { '0%' }

    initialize_with { new(ostruct(attributes)) }
  end
end
