class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :token
      t.integer :purchase_count

      t.timestamps
    end
  end
end
