class Backlog
  def initialize(items)
    @items = items
  end

  def epic_sizes(team)
    @items.map { |item| item.estimates.send(team) }.compact
  end
end
