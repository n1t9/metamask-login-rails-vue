class Users < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :public_address, null: false
      t.bigint :nonce, null: false
    end

    add_index :users, :nonce, unique: true
  end
end
