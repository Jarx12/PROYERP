class CreateBankAccounts < ActiveRecord::Migration[8.0]
  def change
    create_table :bank_accounts do |t|
      t.string :institution
      t.string :currency
      t.string :account_number
      t.string :email
      t.decimal :balance, precision: 12, scale: 2, default: 0.0

      t.timestamps
    end
  end
end
