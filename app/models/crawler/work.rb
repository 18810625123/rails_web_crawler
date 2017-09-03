class Crawler::Work < ApplicationRecord
  belongs_to :website
  belongs_to :plan


  cattr_accessor :address_list, :citys, :categroys, :sources



  def self.stat cond
    case cond
      when '全部'
        ws = Crawler::Work.all
      else
        ws = Crawler::Work.where("name like '%#{cond}%' and last_flag is true")
    end
    self.simple_stat ws, cond
  end

  def self.simple_stat works, cond
    t1 = Time.now

    t3=Time.now
    companys = works.group(:company_name).size
    t4=Time.now

    t5=Time.now
    citys = works.group(:city).size
    t6=Time.now


    city_sum = citys.size
    work_sum = citys.map{|a| a[1]}.sum
    company_sum = companys.size

    # 排序
    t7=Time.now
    companys = companys.to_a.sort{|b,a| a[1]<=>b[1]}.first(10)
                   .map{|a| {name:a[0],
                             size:a[1]}}
    first10_company_work_sum = companys.map{|a| a[:size]}.sum
    first10_company_names = companys.map{|a| a[:name]}
    all_city_names = citys.to_a.sort{|b,a| a[1]<=>b[1]}
                         .map{|a| {name:a[0],
                                   value:(a[1]/work_sum.to_f*100).round(2)}}
    citys = citys.to_a.sort{|b,a| a[1]<=>b[1]}.first(5)
                .map{|a| {name:a[0],
                          size:a[1],
                          rate:(a[1]/work_sum.to_f*100).round(2)}}
    first5_city_work_sum = citys.map{|a| a[:size]}.sum
    first5_city_names = citys.map{|a| {name:a[:name],value:a[:size]}}
    first5_city_names << {name:'其它城市',value:work_sum-first5_city_work_sum}
    t8=Time.now


    company_aver_work_count = (work_sum/company_sum.to_f*100).round(2)
    first5_rate = (first5_city_work_sum / work_sum.to_f*100).round(2)



    t2 = Time.now
    puts "time:#{t2-t1} #{t4-t3} #{t6-t5} #{t8-t7}"+"-----------" * 10
    return {
        cond:cond,
        work_total:work_sum,
        city_total:city_sum,
        company_total:company_sum,
        company_aver_work:company_aver_work_count,
        first5_citys:first5_city_names,
        first5_city_work_sum:first5_city_work_sum,
        first5_rate:first5_rate,
        all_city_names:all_city_names,
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
