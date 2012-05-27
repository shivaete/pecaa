class CreateOrderProducts < ActiveRecord::Migration
  def change
    create_table :order_products do |t|
      t.integer :order_id
      t.integer :product_id
      t.integer :number_of_product

      t.timestamps
    end
  end
end
