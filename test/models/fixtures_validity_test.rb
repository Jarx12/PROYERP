require "test_helper"

class FixturesValidityTest < ActiveSupport::TestCase
  test "todos los fixtures satisfacen las validaciones de sus modelos" do
    invalid = []

    [ Warehouse, Category, Position, Product, Vehicle, VehicleCategory,
      TransactionCategory, BankAccount, Employee, Document ].each do |model|
      model.find_each do |record|
        next if record.valid?

        invalid << "#{model.name}##{record.id}: #{record.errors.full_messages.to_sentence}"
      end
    end

    assert_empty invalid, "Fixtures inválidos:\n#{invalid.join("\n")}"
  end
end
