class Crawler::Work < ApplicationRecord
  belongs_to :website

  cattr_accessor :address_list, :citys, :categroys, :sources
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

  def parse_price_scope
    case website_id
      when '1' # 51job
        if price_scope.include?('-')
          arr = price_scope.split('-')
          a = arr.first.to_f
          if price_scope.include?('千')
            a = a
            @b = arr.last.split('千').first.to_f
          elsif price_scope.include?('万')
            a = a * 10
            @b = arr.last.split('万').first.to_f * 10
          end
          if price_scope.include?('年')
            a = a / 12
            @b = @b / 12
          elsif price_scope.include?('月')

          end
        end
        self.price_min = a.to_i
        self.price_max = @b.to_i
        save!
        [a.to_i,@b.to_i]

      when '2' #BOSS
        arr = price_scope.split('-')
        a = arr.first.scan(/[0-9]+/).join().to_i
        b = arr.last.scan(/[0-9]+/).join().to_i
        self.price_min = a.to_i
        self.price_max = b.to_i
        save!
        [a,b]
      when '3' #lagou
        arr = price_scope.split('-')
        a = arr.first.scan(/[0-9]+/).join().to_i
        b = arr.last.scan(/[0-9]+/).join().to_i
        self.price_min = a.to_i
        self.price_max = b.to_i
        save!
        [a,b]
    end

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
