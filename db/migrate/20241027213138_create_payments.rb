class CreatePayments < ActiveRecord::Migration[7.2]
  def change
    create_table :payments do |t|
      t.string :state
      t.decimal :paid_amount
      t.references :subscription, null: false, foreign_key: true, index: true

      t.datetime :deleted_at, index: true
      t.timestamps
    end
  end
end
