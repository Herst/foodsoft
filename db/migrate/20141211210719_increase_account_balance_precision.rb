class IncreaseAccountBalancePrecision < ActiveRecord::Migration
  def up
    change_column :groups, :account_balance, :decimal, precision: 12, scale: 2
  end

  def down
    change_column :groups, :account_balance, :decimal, precision: 8, scale: 2
  end
end
