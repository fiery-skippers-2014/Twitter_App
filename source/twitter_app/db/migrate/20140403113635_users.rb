class Users < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :user_name
      t.string :name
      t.string :password
      t.string :email

      t.timestamps
    end
  end
end
