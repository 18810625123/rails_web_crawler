class CreateCrawlerMenus < ActiveRecord::Migration[5.1]
  def change
    create_table :crawler_menus do |t|
      t.string :name, comment: '菜单名称'
      t.integer :location, comment: '顺序'
      t.string :namespace, comment: '命名空间'
      t.string :controller, comment: '控制器'
      t.string :action, comment: 'Action'
      t.string :note, comment: '备注'
      t.integer :parent_id, comment: '父菜单ID'

      t.timestamps
    end
  end
end
