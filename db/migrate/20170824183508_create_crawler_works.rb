class CreateCrawlerWorks < ActiveRecord::Migration[5.1]
  def change
    create_table :crawler_works do |t|
      t.string :name, comment: '工作标题'
      t.string :url, comment: '工作页面地址'
      t.text :text, comment: '工作内容描述'
      t.string :company_name, comment: '所属公司名称'
      t.string :company_url, comment: '所属公司页面地址'
      t.string :price_scope, comment: '工资范围'
      t.string :address, comment: '工作地点'
      t.integer :price_min, comment: '最少工资'
      t.integer :price_max, comment: '最高工资'
      t.string :city, comment: '工作城市'
      t.integer :company_id, comment: '所属公司ID'
      t.string :category, comment: '所属采集计划名称'
      t.string :website_id, comment: '来源网站'
      t.string :tracking, comment: '是否要更新'
      t.integer :parent_id, comment: '父ID(第一个版本)'
      t.string :note, comment: '备注'
      t.string :send_time, comment: '工作发布的时间'

      t.timestamps
    end
  end
end
