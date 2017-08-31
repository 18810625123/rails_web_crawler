class Crawler::Plan < ApplicationRecord
  belongs_to :website
  has_many :works


  def exce_works data
    t1 = Time.now
    website_name = website.name
    works = {success:[],fail:[],filter:[],no_save:[]}
    data[:page][:a].upto(data[:page][:b]).each do |i|
      http_url = url.split('PAGE').join(i.to_s)
      http_doc = HttpParse.new(http_url)
      http_doc.parse
      http_doc.save("/Users/liudong/Desktop/xml/#{website_name}-#{name}(#{i}).txt")
      case website_name
        when '前程无忧'
          @doc = http_doc.parse_51job
        when 'BOSS直聘'
          @doc = http_doc.parse_boss
        when '拉勾网'
          @doc = http_doc.parse_lagou
        else

      end
      @doc[:works].each do |wk|

        w = Crawler::Work.new
        w.company_name = wk[:company_name]
        w.company_url = wk[:company_url]
        w.name = wk[:work_name]
        w.url = wk[:work_url]
        w.price_scope = wk[:work_price]
        w.send_time = wk[:work_time]
        w.address = wk[:work_address]

        w.plan_id = id
        w.website_id = website.id

        if !data[:include].blank? and !w.name.include?(data[:include])
          works[:filter] << w
          next
        end
        if !data[:filter].blank? and w.name.include?(data[:filter])
          works[:filter] << w
          next
        end

        if data[:save_flag] == 'yes'
          if w.save
            works[:success] << w
          else
            works[:fail] << w
          end
        else
          works[:no_save] << w
        end

      end
      sleep(2)
    end
    t2 = Time.now
    time = t2 - t1
    [works, time]
    
  end

  def self.save_lagou_hash str
    json = JSON.parse str
    c1 = Crawler::Work.count
    json['content']['positionResult']['result'].each do |h|
      w = Crawler::Work.new
      w.company_name = h['companyShortName']
      w.company_url = "https://www.lagou.com/gongsi/#{h['companyId']}.html"
      w.name = h['positionName']
      w.url = "https://www.lagou.com/jobs/#{h['positionId']}.html"
      w.price_scope = h['salary']
      w.send_time = h['createTime']
      w.address = h['city']
      w.website_id = 3
      w.save
      #puts w.errors.messages
    end
    c2 = Crawler::Work.count
    puts "保存了#{c2-c1}个"
  end

end
