class AddIndexToFinancialTransactionsTransactionDate < ActiveRecord::Migration[8.0]
  def change
    add_index :financial_transactions, :transaction_date
  end
end
