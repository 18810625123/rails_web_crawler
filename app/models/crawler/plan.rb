class Crawler::Plan < ApplicationRecord
  belongs_to :website
  has_many :works

  WORKHASHS ||= {}

  def self.gen_work_hashs
    if WORKHASHS.empty?
      Crawler::Work.order(:send_time).all.each do |w|
        WORKHASHS[w.work_hash] = w
      end
    end
  end

  def today_finish
    self.note = "#{Date.today.to_s}/已完成"
    save
  end

  def today_finish?
    return true if note == "#{Date.today.to_s}/已完成"
    false
  end

  def http_url page
    url.split('PAGE').join(page.to_s)
  end

  def get_html_by_page page
    respone = open http_url(page)
    result = respone.read
    result = result.force_encoding('gbk').encode('utf-8') if result.encoding.to_s == "ASCII-8BIT"
    html_doc = Hpricot(result)
    html_doc
  end

  def save_doc html_doc, path
      file = File.open(path, 'w+')
      file.write html_doc.html
      file.close
  end

  def exce_works page_a, page_b, include, filter, save_flag
    Crawler::Plan.gen_work_hashs
    t1 = Time.now
    website_name = website.name
    @work_datas = {success:[],fail:[],filter:[],no_save:[],exist:[],update:[]}
    page_a.to_i.upto(page_b.to_i).each do |i|
      @current_page = i
      html_doc = get_html_by_page @current_page

      save_doc(html_doc, "/Users/liudong/Desktop/xml/#{website_name}-#{name}(#{page}).txt")
      case website_name
        when '前程无忧'
          doc = parse_51job_html(html_doc)
        when 'BOSS直聘'
          doc = parse_boss_html(html_doc)
        when '拉勾网'
          doc = parse_lagou_html(html_doc)
        else

      end
      doc[:works].each do |wk|

        w = Crawler::Work.new
        w.company_name = wk[:company_name]
        w.company_url = wk[:company_url]
        w.name = wk[:work_name].split('有限').first
        w.url = wk[:work_url]
        if w.url.include?('.html')
          w.work_hash = w.url.split('.html').first.split('/').last
        else
          w.work_hash = w.url.split('=').last
        end
        w.price_scope = wk[:work_price]
        w.send_time = wk[:work_time]
        w.address = wk[:work_address]

        w.plan_id = id
        w.website_id = website_id

        if !include.blank? and !w.name.include?(include)
          @work_datas[:filter] << w
          next
        end
        if !filter.blank? and w.name.include?(filter)
          @work_datas[:filter] << w
          next
        end

        update = false
        if save_flag == 'yes'
          old_wk = WORKHASHS[w.work_hash]
          if old_wk
            if w.send_time <= old_wk.send_time
              @work_datas[:exist] << w
              next
            else
              update = true
            end
          end
          w.last_flag = true
          if w.save
            WORKHASHS[w.work_hash] = w
            if update
              @work_datas[:update] << w
            else
              @work_datas[:success] << w
            end
            old_wk.update(last_flag:false) if old_wk
          else
            @work_datas[:fail] << w
          end
        else
          @work_datas[:no_save] << w
        end

      end
    end
    t2 = Time.now
    time = t2 - t1
    return {
        ok:true,
        works:@work_datas,
        time:time,
        a:page_a,
        b:page_b,
    }
  rescue
    return {
        ok:false,
        error:$!.to_s,
        works:@work_datas,
        time:(Time.now-t1),
        error_page:@current_page,
    }
  end

  def parse_51job_html html_doc
    pagecount = html_doc.search('span[@class="td"]').first.html.split('共').last.split('页').first.to_i
    page = html_doc.search('span[@class="dw_c_orange"]').last.html.to_i
    divs = html_doc.search('div[@class="el"]')
    doc = {page:page,pagecount:pagecount,works:[]}
    name = divs[3].search('a').last.html

    3.upto(divs.size-1).each do |i|
      arr = divs[i].search('a')
      next if arr.size != 2
      arr2 = divs[i].search('span')
      doc[:works] << {
          company_name:arr.last.html,
          company_url:arr.last['href'],
          work_name:arr.first.html.split(' ').join('-'),
          work_url:arr.first['href'],
          work_price:arr2[3].html,
          work_time:arr2[4].html,
          work_address:arr2[2].html,
      }
    end
    sleep(0.2)

    doc
  end

  def parse_boss_html html_doc
    lis = html_doc.search('div[@class="job-box"]').search('li')
    doc = {page:nil,pagecount:nil,works:[]}
    lis.each do |li|
      doc[:works] << {
          company_name:li.search('a').last.html,
          company_url:li.search('a').last[:href],
          work_name:li.search('a').first.html.split('<span').first,
          work_url:li.search('a').first[:href],
          work_price:li.search('span').first.html,
          work_time:li.search('span').last.html.split('发布于').last.split('日').first.split('月').join('-'),
          work_address:li.search('p').first.html.split('<em').first,
      }
    end
    sleep(2)

    doc
  end

  def flush_page
    if website.name == '前程无忧'
      html_doc = get_html_by_page 1
      pagecount = html_doc.search('span[@class="td"]').first.html.split('共').last.split('页').first.to_i
      if pagecount.to_i > 0
        self.page = pagecount
        puts "这个计划有#{pagecount}页"
        save
      else
        false
      end
    end
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
