class AddBalanceToUser < ActiveRecord::Migration[5.1]
  def change
  	change_table :users do |t|
  		t.decimal :balance
  	end
  end
end
