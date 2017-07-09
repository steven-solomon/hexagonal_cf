class CreateUserPurchase < ActiveRecord::Migration[5.0]
  def change
    create_table :user_purchases do |t|
      t.belongs_to :score, index: true
      t.integer :user_id
    end
  end
end
