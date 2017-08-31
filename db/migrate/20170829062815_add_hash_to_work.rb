class AddHashToWork < ActiveRecord::Migration[5.1]
  def change
    add_column :crawler_works, :work_hash, :string
    add_column :crawler_works, :company_hash, :string
  end
end
