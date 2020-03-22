require './lib/monte-carlo-roadmap/inputs/metadata'

RSpec.describe Metadata do

  let(:teams) { %w(iOS Android API) }
  let(:hourly_cost) { 80 }
  let(:start_date) { date('2020-01-01') }

  subject {
    build(:metadata,
          teams: teams,
          hourly_cost: hourly_cost,
          start_date: start_date)
  }

  it "lists teams" do
    expect(subject.teams).to eq(teams)
  end

  it "returns the hourly cost" do
    expect(subject.hourly_cost).to eq(hourly_cost)
  end

  it "returns the start date" do
    expect(subject.start_date).to eq(start_date)
  end
end
