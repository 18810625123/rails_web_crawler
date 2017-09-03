class AddLastFlagToWork < ActiveRecord::Migration[5.1]
  def change
    add_column :crawler_works, :last_flag, :boolean
  end
end
