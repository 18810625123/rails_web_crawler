class CreateCrawlerWebsiteTypes < ActiveRecord::Migration[5.1]
  def change
    create_table :crawler_website_types do |t|
      t.string :name, comment: '网站类型'
      t.string :note, comment: '备注'

      t.timestamps
    end
  end
end
