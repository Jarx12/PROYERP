require "test_helper"

class ProjectTest < ActiveSupport::TestCase
  # Keep this model test independent of the repository's global fixture issue.
  self.fixture_table_names = []

  test "requires a name" do
    project = Project.new

    assert_not project.valid?
    assert project.errors[:name].any?
  end

  test "accepts optional summary fields" do
    project = Project.new(
      name: "Proyecto sin detalles",
      start_date: Date.new(2026, 2, 1),
      end_date: Date.new(2026, 2, 28),
      location: "Barcelona",
      customer: "Cliente",
      description: "Alcance"
    )

    assert_predicate project, :valid?
  end
end
