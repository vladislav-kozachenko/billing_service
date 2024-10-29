class CreateSubscriptions < ActiveRecord::Migration[7.2]
  def change
    create_table :subscriptions do |t|
      t.date :expiration_date
      t.decimal :cost

      t.datetime :deleted_at, index: true
      t.timestamps
    end
  end
end
