FactoryBot.define do
  factory :simulator do
    metadata
    backlog
    history

    initialize_with { new(metadata, backlog, history) }
  end
end
