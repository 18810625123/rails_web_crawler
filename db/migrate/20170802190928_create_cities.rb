class CreateCities < ActiveRecord::Migration[5.1]
  def change
    create_table :cities do |t|
      t.string :name, comment: '市'
      t.string :code, comment: '市代码'
      t.integer :parent_id, comment: '所属市(区)ID'
      t.integer :province_id, comment: '所属省ID'

      t.timestamps
    end
  end
end
