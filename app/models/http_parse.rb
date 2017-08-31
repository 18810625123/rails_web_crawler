class HttpParse

  attr_accessor :doc, :url

  def initialize url
    @url = url
  end

  def save path
    file = File.open(path, 'w+')
    file.write @doc.html
    file.close
    self
  end

  def parse
    @respone = open @url
    @result = @respone.read
    @result = @result.force_encoding('gbk').encode('utf-8') if @result.encoding.to_s == "ASCII-8BIT"
    @doc = Hpricot(@result)
    self
  end

  def parse_51job
    pagecount = @doc.search('span[@class="td"]').first.html.split('共').last.split('页').first.to_i
    page = @doc.search('span[@class="dw_c_orange"]').last.html.to_i
    divs = @doc.search('div[@class="el"]')
    html = {page:page,pagecount:pagecount,works:[]}
    name = divs[3].search('a').last.html

    3.upto(divs.size-1).each do |i|
      arr = divs[i].search('a')
      next if arr.size != 2
      arr2 = divs[i].search('span')
      html[:works] << {
          company_name:arr.last.html,
          company_url:arr.last['href'],
          work_name:arr.first.html.split(' ').join('-'),
          work_url:arr.first['href'],
          work_price:arr2[3].html,
          work_time:arr2[4].html,
          work_address:arr2[2].html,
      }
    end
    html
  end

  def parse_boss
    lis = @doc.search('div[@class="job-box"]').search('li')
    html = {page:nil,pagecount:nil,works:[]}
    lis.each do |li|
      html[:works] << {
          company_name:li.search('a').last.html,
          company_url:li.search('a').last[:href],
          work_name:li.search('a').first.html.split('<span').first,
          work_url:li.search('a').first[:href],
          work_price:li.search('span').first.html,
          work_time:li.search('span').last.html.split('发布于').last.split('日').first.split('月').join('-'),
          work_address:li.search('p').first.html.split('<em').first,
      }
    end
    html
  end

end

