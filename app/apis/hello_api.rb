
class HelloApi < Grape::API
  content_type :json, 'application/json;charset=utf-8'
  # use Rack::Cors do
  #   allow do
  #     origins '*'
  #     resource '*', headers: :any, methods: :get
  #   end
  # end

  format :json

  get 'stat_work' do
    if params[:cond]
      t1=Time.now
      data = Crawler::Work.stat params[:cond]
      {ok:true,msg:"成功,共用时#{Time.now-t1}秒",data:data}
    else
      {ok:false,msg:'缺少cond条件'}
    end
  end

  get 'get_users' do
    {ok:true,msg:JSON.parse(User.all.to_json) }
  end
  
  get 'hello' do
    {ok:true,msg:'success'}
  end

  post 'hello' do
    {ok:true,msg:'success'}
  end

  get 'add_user' do
    u = User.new
    u.name = params[:name]
    u.email = params[:email]
    u.mobile = params[:mobile]
    if u.save
      {ok:true,msg:JSON.parse(u.to_json)}
    else
      {ok:false,msg:u.errors.messages}
    end
  end

  get 'save_img_by_base64' do
    puts params
    if params[:base64]
      Ld::File.write_image_by_base64_and_path params[:base64], '/Users/liudong/Desktop/44.jpg'
      {ok:true,msg:params[:base64]}
    else
      {ok:false,msg:'base64 is null!'}
    end
  end

  get 'apk1' do
    File.open('/Users/liudong/ruby/api/config/routes.rb')
  end

  get 'get_html' do
    url = params[:html_url]
    if url
      {ok:true,msg:open(url).read}
    else
      {ok:false,msg:'url为空'}
    end
  end

  post 'create_table' do
    table_name = params[:table_name]
    table_desc = params[:table_desc]
    web_id = params[:web_id]
    if table_name.nil? or table_desc.nil?
      return {ok:false,msg:'缺少参数,表名或描述都是必须填写的!'}
    end
    table = Table.new
    table.name = table_name
    table.desc = table_desc
    table.web_id = web_id
    if table.save
      {ok:true,msg:table}
    else
      {ok:false,msg:table.errors.messages.to_s}
    end
  end


  get 'provinces' do
    @provinces = Province.all.select(:name,:id)
    @parent_citys = @provinces.first.parent_citys
    @child_citys = @parent_citys.first.childs
    if @child_citys.size == 0
      @streets = @parent_citys.first.streets.select(:id,:name)
    else
      @streets = @child_citys.first.streets.select(:id,:name)
    end
    {
        ok:true,
        provinces:@provinces,
        parent_citys:@parent_citys,
        child_citys:@child_citys,
        streets:@streets
    }
  end

  get 'parent_citys/:id' do
    id = params[:id]
    if id
      @parent_citys = Province.find(id).parent_citys
      @child_citys = @parent_citys.first.childs
      if @child_citys.size == 0
        @streets = @parent_citys.first.streets.select(:id,:name)
      else
        @streets = @child_citys.first.streets.select(:id,:name)
      end
      {
          ok:true,
          parent_citys:@parent_citys,
          child_citys:@child_citys,
          streets:@streets
      }
    else
      {ok:true,msg:'缺少 省份id参数'}
    end
  end

  get 'child_citys/:id' do
    id = params[:id]
    if id
      @parent_city = City.find(id)
      @child_citys = @parent_city.childs
      if @child_citys.size == 0
        @streets = @parent_city.streets
      else
        @streets = @child_citys.first.streets.select(:id,:name)
      end
      {
          ok:true,
          child_citys:@child_citys,
          streets:@streets
      }
    else
      {ok:true,msg:'缺少 省份id参数'}
    end
  end

  get 'streets/:id' do
    id = params[:id]
    if id
      @streets = City.find(id).streets.select(:id,:name)
      {
          ok:true,
          streets:@streets
      }
    else
      {ok:true,msg:'缺少 省份id参数'}
    end
  end

end