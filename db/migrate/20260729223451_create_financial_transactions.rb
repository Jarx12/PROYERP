class CreateFinancialTransactions < ActiveRecord::Migration[8.0]
  def change
    create_table :financial_transactions do |t|
      t.references :bank_account, null: false, foreign_key: true
      t.references :transaction_category, null: false, foreign_key: true
      t.references :employee, null: false, foreign_key: true
      t.decimal :amount, precision: 12, scale: 2, default: 0.0
      t.string :transaction_type
      t.text :description
      t.string :responsible_name
      t.string :beneficiary
      t.date :transaction_date

      t.timestamps
    end
  end
end
