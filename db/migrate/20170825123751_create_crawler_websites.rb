class CreateCrawlerWebsites < ActiveRecord::Migration[5.1]
  def change
    create_table :crawler_websites do |t|
      t.string :name, comment: '网站名'
      t.integer :website_type_id, comment: '网站类型ID'
      t.string :index_url, comment: '网站首页'
      t.string :note, comment: '备注'

      t.timestamps
    end
  end
end
