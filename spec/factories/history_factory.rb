FactoryBot.define do
  factory :history do
    epic_sizes {
      {
          S: [1, 4],
          M: [4, 7],
          L: [7, 15]
      }
    }

    teams {
      {
          Android: {
              throughput: [2, 3, 4]
          },
          iOS: {
              throughput: [3, 4, 5]
          },
          API: {
              throughput: [4, 5, 6]
          }
      }
    }

    initialize_with { new(ostruct(epic_sizes: epic_sizes, teams: teams)) }
  end
end
