class CreateStreets < ActiveRecord::Migration[5.1]
  def change
    create_table :streets do |t|
      t.string :name, comment: '街道名称'
      t.string :code, comment: '街道代码'
      t.integer :city_id, comment: '所属城市ID'

      t.timestamps
    end
  end
end
