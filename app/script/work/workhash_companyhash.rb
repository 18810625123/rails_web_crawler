# work_hash
ActiveRecord::Base.logger=false

# puts Crawler::Website.all[0].works.first(20).map(&:url)
# puts Crawler::Website.all[0].works.first(20).map(&:company_url)
# puts Crawler::Website.all[1].works.first(20).map(&:url)
# puts Crawler::Website.all[1].works.first(20).map(&:company_url)
# puts Crawler::Website.all[2].works.first(20).map(&:url)
# puts Crawler::Website.all[2].works.first(20).map(&:company_url)
#
# puts Crawler::Website.all[0].works.last(20).map(&:url)
# puts Crawler::Website.all[0].works.last(20).map(&:company_url)
# puts Crawler::Website.all[1].works.last(20).map(&:url)
# puts Crawler::Website.all[1].works.last(20).map(&:company_url)
# puts Crawler::Website.all[2].works.last(20).map(&:url)
# puts Crawler::Website.all[2].works.last(20).map(&:company_url)
#
# puts Crawler::Work.count
# puts Crawler::Work.where('url like "%html%" and company_url like "%html%"').size
# puts Crawler::Work.where('url not like "%.html%" and company_url not like "%.html%"').size



def parse_price_scope w
  case w.website_id
    when '1' # 51job
      if w.price_scope.include?('-')
        arr = w.price_scope.split('-')
        a = arr.first.to_f
        if w.price_scope.include?('千')
          a = a
          @b = arr.last.split('千').first.to_f
        elsif w.price_scope.include?('万')
          a = a * 10
          @b = arr.last.split('万').first.to_f * 10
        end
        if w.price_scope.include?('年')
          a = a / 12
          @b = @b / 12
        elsif w.price_scope.include?('月')

        end
      end
      w.price_min = a.to_i
      w.price_max = @b.to_i
      return true

    when '2' #BOSS
      arr = w.price_scope.split('-')
      a = arr.first.scan(/[0-9]+/).join().to_i
      b = arr.last.scan(/[0-9]+/).join().to_i
      w.price_min = a.to_i
      w.price_max = b.to_i
      return true
    when '3' #lagou
      arr = w.price_scope.split('-')
      a = arr.first.scan(/[0-9]+/).join().to_i
      b = arr.last.scan(/[0-9]+/).join().to_i
      w.price_min = a.to_i
      w.price_max = b.to_i
      return true
  end

end

t1 = Time.now
ws = Crawler::Work.where('city is null')
if ws.size > 0
  puts "有#{ws.size}条新数据将要被处理"

  ws.each do |w|
    flag = false
    workhash
    if w.work_hash.blank?
      w.work_hash = w.url.split('.html').first.split('/').last if url.include?('.html')
      w.work_hash = w.url.split('=').last if w.work_hash.blank?
      flag = true
    end
    # company_hash
    if w.company_url.include?('.html')
      w.company_hash = w.company_url.split('.html').first.split('/').last
      w.company_hash = w.company_url.split('.51job').first.split('.').last if w.company_hash.blank?
      flag = true
    end
    # 城市
    if w.address
      w.city = w.address.split('-')[0]
      flag = true
    end
    # 最高最低工资
    if w.price_scope
      parse_price_scope w
      flag = true
    end
    # 公司名称
    if w.company_name
      w.company_name.include?('有限')
      w.company_name = w.company_name.split('有限')[0]
      flag = true
    end
    # 时间

    w.save if flag
  end

  puts "#{ws.size}条数据被处理,共耗时#{Time.now-t1}秒"
else
  puts "没有 city is null的数据"
end

# workhash
puts "字段为空的:"
ws = Crawler::Work.where('work_hash is null')
puts "\twork_hash:#{ws.size}"
ws = Crawler::Work.where('company_hash is null')
puts "\tcompany_hash:#{ws.size}条"
ws = Crawler::Work.where('city is null')
puts "\tcity#{ws.size}条"
ws = Crawler::Work.where('price_max is null or price_min is null')
puts "\tprice#{ws.size}条"
ws = Crawler::Work.where('last_flag is null')
puts "\tlast_flag#{ws.size}条"


puts "字段包含:"
ws = Crawler::Work.where('company_name like "%有限%" ')
puts "\t公司名称包含'有限':#{ws.size}条"


puts "招人最多的50家公司:"
Crawler::Work.group(:company_hash).size.to_a.sort{|a,b| b[1]<=>a[1]}.first(50).each{|a| puts "\t#{a[1]}:\t#{a[0]}"}
puts "更新次数最多的30个岗位:"
Crawler::Work.group(:work_hash).size.to_a.sort{|a,b| b[1]<=>a[1]}.first(30).each{|a| puts "\t#{a[1]}:\t#{a[0]}"}
# puts ws1.size
# puts ws1.map &:url
# ws1.each{|w| w.update(work_hash:w.url.split('=').last)}

# companyhash 都是前程无忧的专页

# puts ws2.size
# puts ws2.map &:company_hash
# ws2.each{|w| w.update(company_hash:w.company_url.split('.51job').first.split('.').last)}
