class ChangeTransactionCategoryIdNullInFinancialTransactions < ActiveRecord::Migration[8.0]
  def change
    change_column_null :financial_transactions, :transaction_category_id, true
  end
end
