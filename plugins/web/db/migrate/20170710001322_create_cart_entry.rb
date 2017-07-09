class CreateCartEntry < ActiveRecord::Migration[5.0]
  def change
    create_table :cart_entries do |t|
      t.belongs_to :score, index: true
      t.integer :user_id
    end
  end
end
