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

# 处理数据
ws = Crawler::Work.where('city is null and plan_id is not null')
ws.each do |w|
  flag = false
  # workhash
  if w.url.include?('.html')
    w.work_hash = w.url.split('.html').first.split('/').last
    flag = true
  end
  # company_hash
  if w.company_url.include?('.html')
    w.company_hash = w.company_url.split('.html').first.split('/').last
    flag = true
  end
  # 城市
  if w.address
    w.city = w.address.split('-').first
    flag = true
  end
  # 最高最低工资
  if w.price_scope
    parse_price_scope w
    flag = true
  end
  # 时间

  w.save if flag
end


# workhash
ws1 = Crawler::Work.where('work_hash is null').size
puts ws1.size
puts ws1.map &:url
ws1.each{|w| w.update(work_hash:w.url.split('=').last)}

# companyhash 都是前程无忧的专页
ws2 = Crawler::Work.where('company_hash is null')
puts ws2.size
puts ws2.map &:company_hash
ws2.each{|w| w.update(company_hash:w.company_url.split('.51job').first.split('.').last)}


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


