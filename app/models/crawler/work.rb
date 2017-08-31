class Crawler::Work < ApplicationRecord
  belongs_to :website
  belongs_to :plan


  cattr_accessor :address_list, :citys, :categroys, :sources

  def self.stat cond
    case cond
      when 'ruby'
        ws = Crawler::Work.where('name like "%ruby%" or name like "%rails%"')
      when 'php'
        ws = Crawler::Work.where('name like "%php%"')
      when 'java'
        ws = Crawler::Work.where('name like "%java%"')
      when '销售'
        ws = Crawler::Work.where('name like "%销售%"')
      when '测试'
        ws = Crawler::Work.where('name like "%测试%"')
      when 'c++'
        ws = Crawler::Work.where('name like "%c++%"')
      else
        raise ''
    end
    self.simple_stat ws, cond
  end

  def self.simple_stat works, cond
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
    companys = companys.to_a.sort{|b,a| a[1]<=>b[1]}.first(10)
                   .map{|a| {name:a[0],
                             size:a[1]}}
    first10_company_work_sum = companys.map{|a| a[:size]}.sum
    first10_company_names = companys.map{|a| a[:name]}

    citys = citys.to_a.sort{|b,a| a[1]<=>b[1]}.first(5)
                .map{|a| {name:a[0],
                          size:a[1],
                          rate:(a[1]/work_sum.to_f*100).round(2)}}
    first5_city_work_sum = citys.map{|a| a[:size]}.sum
    first5_city_names = citys.map{|a| "#{a[:name]}-#{a[:size]}个(#{a[:rate]}%)"}

    t8=Time.now


    company_aver_work_count = (work_sum/company_sum.to_f*100).round(2)
    first5_rate = (first5_city_work_sum / work_sum.to_f*100).round(2)


    puts "招#{cond}的公司#{company_sum}个,共提供岗位#{work_sum}个,平均每家公司招#{company_aver_work_count}个\n"+
             "这些位置共分布在#{city_sum}个城市,其中前五城市招人占比#{first5_rate}%(#{first5_city_work_sum}个),详情数据:\n"
    citys.each{|a| puts "#{a[:name]}:\t#{a[:rate]}%(#{a[:size]}个)" }

    t2 = Time.now
    puts "time:#{t2-t1} #{t4-t3} #{t6-t5} #{t8-t7}"+"-----------" * 10
    return {
        cond:cond,
        work_total:work_sum,
        city_total:city_sum,
        company_total:company_sum,
        company_aver_work:company_aver_work_count,
        first5_citys:{
            total:first5_city_work_sum,
            names:first5_city_names,
            rate:first5_rate,
            results:citys
        },
        first10_company:{
            names:first10_company_names,
            total:first10_company_work_sum,
            results:companys,
        },
    }
  end

  # url去重
  def self.del_uniq_by_web_id web_id
    uniqs = []
    works = Crawler::Work.where("website_id = #{web_id}")
    0.upto(works.size-1).each do |i|
      if uniqs.include?(i)
        next
      end
      (i+1).upto(works.size-1).each do |j|
        if works[i].url == works[j].url
          uniqs << j
        end
      end
    end
    puts uniqs.size
    #uniqs.each{|i| works[i].destroy}
    uniqs
  end

  # 解析地址\时间
  def parse_address
    flag = false
    if address and address.include?('-')
      self.city = address.split('-').first
      flag = true
    end
    if send_time
      if website_id == 3
        time = Time.new send_time
        self.send_time = time.strftime("%m-%d")
        flag = true
      else
        # time = Time.new "2017-#{send_time}"
        # self.send_time = time.strftime("%m-%d")
      end

    end
    save! if flag
  end

  def self.sources
    if @@sources.nil?
      # @@sources = Crawler::Work.select().all.map(&:)
    end
  end

  def self.citys
    if @@address_list.nil? or @@citys.nil?
      @@address_list = Crawler::Work.all.map{|w| w.address}
      @@citys = address_list.map{|a| a.split('-')[0]}.uniq
      @@citys = @@citys.map{|c| [c,c]}
    end
    @@citys
  end

  def self.categroys
    if @@categroys.nil?
      @@categroys = Crawler::Work.all.map{|w| w.category}.uniq.map{|c| [c,c]}
    end
    @@categroys
  end

  def del_price_is_null
    Crawler::Work.where('price_scope is ""').destroy_all
  end

end
