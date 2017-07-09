class CreatePurchasedContent < ActiveRecord::Migration[5.0]
  def change
    create_table :purchased_contents do |t|
      t.belongs_to :score, index: true
      t.string :content
    end
  end
end
