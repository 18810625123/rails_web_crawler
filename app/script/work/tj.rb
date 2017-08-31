def total
  ws_count = Crawler::Work.count
  company_count = Crawler::Work.select(:company_hash).group(:company_hash).size.size
  puts "总共有#{company_count}家公司在招人,共有岗位#{ws_count}个"
  puts "平均每个公司提供#{ (ws_count / company_count.to_f).round(1) }个岗位"
end


def city_company1 works, cond
  t1 = Time.now

  companys = {}
  citys = Crawler::Work.select(:name).all
  t3=Time.now
  works.map(&:company_name).uniq.each{|cname| companys[cname]=works.select{|w| w.company_name==cname}}
  t4=Time.now

  citys = {}
  t5=Time.now
  works.map(&:city).uniq.each{|city| citys[city]=works.select{|w| w.city==city}}
  t6=Time.now

  city_sum = citys.size
  work_sum = works.size
  company_sum = companys.size

# 排序
  t7=Time.now
  companys_px = companys.sort{|b,a| a[1].size<=>b[1].size}
  citys_px = citys.sort{|b,a| a[1].size<=>b[1].size}
  t8=Time.now
  first5_count = citys_px.first(5).map{|a| a[1].size}.sum

  puts "招#{cond}的公司#{company_sum}个,共提供岗位#{work_sum}个,平均每家公司招#{(work_sum/company_sum.to_f).round(2)}个\n"+
           "这些位置共分布在#{city_sum}个城市,其中前五城市招人占比#{(first5_count / work_sum.to_f*100).round(2)}%(#{first5_count}个),详情数据:\n"
  citys_px.first(5).each{|arr| puts "#{arr[0]}:\t#{(arr[1].size/work_sum.to_f*100).round(2)}%(#{arr[1].size}个)" }

  t2 = Time.now
  puts "time:#{t2-t1} #{t4-t3} #{t6-t5} #{t8-t7}"+"-----------" * 10
end

def city_company works, cond
  t1 = Time.now

  work_sum = works.size

  t3=Time.now
  companys = works.group(:company_name).size
  t4=Time.now

  t5=Time.now
  citys = works.group(:city).size
  t6=Time.now

  city_sum = citys.size
  company_sum = companys.size

# 排序
  t7=Time.now
  companys_px = companys.to_a.sort{|b,a| a[1]<=>b[1]}
  citys_px = citys.to_a.sort{|b,a| a[1]<=>b[1]}
  t8=Time.now
  first5_count = citys_px.first(5).map{|a| a[1]}.sum

  puts "招#{cond}的公司#{company_sum}个,共提供岗位#{work_sum}个,平均每家公司招#{(work_sum/company_sum.to_f).round(2)}个\n"+
           "这些位置共分布在#{city_sum}个城市,其中前五城市招人占比#{(first5_count / work_sum.to_f*100).round(2)}%(#{first5_count}个),详情数据:\n"
  citys_px.first(5).each{|arr| puts "#{arr[0]}:\t#{(arr[1]/work_sum.to_f*100).round(2)}%(#{arr[1]}个)" }

  t2 = Time.now
  puts "time:#{t2-t1} #{t4-t3} #{t6-t5} #{t8-t7}"+"-----------" * 10
end

total
# city_company Crawler::Work.where('name like "%ruby%" or name like "%rails%"'), 'Ruby or Rails'
# city_company Crawler::Work.where('name like "%java%"'), 'Java'
# city_company Crawler::Work.where('name like "%php%"'), 'PHP'
# city_company Crawler::Work.where('name like "%c++%"'), 'C++'
# city_company Crawler::Work.where('name like "%销售%"'), '销售'
# city_company Crawler::Work.where('name like "%测试%"'), '测试'