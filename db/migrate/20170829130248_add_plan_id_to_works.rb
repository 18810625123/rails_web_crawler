class AddPlanIdToWorks < ActiveRecord::Migration[5.1]
  def change
    add_column :crawler_works, :plan_id, :integer
  end
end
