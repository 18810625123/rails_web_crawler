class CreateProvinces < ActiveRecord::Migration[5.1]
  def change
    create_table :provinces do |t|
      t.string :name, comment: '省'
      t.string :code, comment: '省代码'

      t.timestamps
    end
  end
end
