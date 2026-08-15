class AddBankReferenceToFinancialTransactions < ActiveRecord::Migration[8.0]
  def change
    add_column :financial_transactions, :bank_reference, :string
  end
end
