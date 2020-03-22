require './lib/monte-carlo-roadmap/inputs/history'

RSpec.describe MonteCarloRoadmap::History do

  let(:epic_sizes) {
    {
        S: [1, 4],
        M: [4, 7],
        L: [7, 15]
    }
  }

  let(:teams) {
    {
        Android: {
            throughput: [5, 5, 5, 7],
            adjustments: [
                { from: date('2020-04-01'), until: date('2020-07-01'), adjust_throughput_by: '50%' }
            ]
        },
        iOS: {
            throughput: [3, 2]
        },
        API: {
            throughput: [2, 0, 0, 2],
            adjustments: [
                { from: date('2020-04-01'), until: date('2021-07-01'), adjust_throughput_by: '130%' },
                { from: date('2020-07-01'), until: date('2021-01-01'), adjust_throughput_by: '150%' }
            ]
        }
    }
  }

  subject { build(:history, epic_sizes: epic_sizes, teams: teams) }

  it "samples epic size" do
    stub_rand_and_return(subject.random, [0, 1, 0])
    sizes = (0..2).collect { subject.sample_epic_size('S') }
    expect(sizes).to eq([1, 4, 1])
  end

  it "samples throughput" do
    stub_rand_and_return(subject.random, [0, 3, 1])
    values = (0..2).collect { subject.sample_throughput('Android', Date.new(2020, 01, 01)) }
    expect(values).to eq([5, 7, 5])
  end

  it "adjusts throughputs" do
    stub_rand_and_return(subject.random, [0, 3, 1])
    values = (0..2).collect { subject.sample_throughput('Android', Date.new(2020, 05, 01)) }
    expect(values).to eq([2.5, 3.5, 2.5])
  end
end
