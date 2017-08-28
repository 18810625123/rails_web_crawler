class Sdf < ActiveRecord::Migration[5.1]
  def change
    change_column :crawler_works,:tracking,:string

  end
end
