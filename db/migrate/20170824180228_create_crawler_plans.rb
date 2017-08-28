class CreateCrawlerPlans < ActiveRecord::Migration[5.1]
  def change
    create_table :crawler_plans do |t|
      t.integer :website_id, comment: '网站id'
      t.string :name, comment: '采集计划名称'
      t.text :url, comment: '采集计划URL'
      t.integer :page, comment: '采集计划总页数'
      t.string :note, comment: '备注'

      t.timestamps
    end
  end
end
