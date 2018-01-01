
class VueApi < Grape::API
  content_type :json, 'application/json;charset=utf-8'
  use Rack::Cors do
    allow do
      origins '*'
      resource '*', {
        headers: :any, methods: [:get, :post, :delete, :put, :patch, :options, :head]
      }
    end
  end

  # add_swagger_documentation(
  #   :api_version => "/vueapi",
  #   hide_documentation_path: true,
  #   hide_format: true
  # )

  format :json

  post 'upload' do
    puts params
    file = params['file']
    puts file

    File.open("/Users/liudong/Desktop/uploads/#{file['filename']}",'wb') do |f|
      f.write(file['tempfile'].read)
    end
  end

  def get_clue id
    if id == 1
      return {
        name: '小明',gender: 1
      }
    end
  end

  # 一个简易登录api
  get 'login' do
    if params[:account] and params[:password]
      return {
          ok:true,
          msg:'登录成功',
          token:BCrypt::Password.create(params[:account]),
          user: {
              account: params[:account],
              password: params[:password]
          }
      }
    else
      return {ok:false, msg:"缺少参数"}
    end
  end

  # 一个简易登录api
  get 'clues/:id' do
    if params[:id]
      clue = {}
      case params[:id]
        when '1'
          clue = {name: '小明',gender: 1}
        when '2'
          clue = {name: '小红',gender: 0}
        when '3'
          clue = {name: '小黑',gender: 1}
        else
          clue = {}
      end
      return {
          ok:true,
          msg:'登录成功',
          # token:BCrypt::Password.create(params[:account]),
          clue: clue
      }
    else
      return {ok:false, msg:"缺少参数"}
    end
  end

  # 待签收件
  # id 姓名
  get "dqsx" do
    return [
      {id:1,name:'小明',gender:1},
      {id:2,name:'小红',gender:0},
      {id:3,name:'小黑',gender:1},
    ]
  end

  # 待办线索
  # id 姓名
  get "dbsx" do
    return [
      {id:1,name:'小明hsfefj'},
      {id:2,name:'小红sefjjesf'},
      {id:3,name:'小黑sefsefs'},
    ]
  end

  # 已办线索
  # id 姓名
  get "ybsx" do
    return [
      {id:1,name:'小明'},
      {id:2,name:'小红'},
      {id:3,name:'小黑'},
    ]
  end

  # 超期提醒
  # id 姓名
  get "cqsx" do
    return [
      {id:1,name:'小明'},
      {id:2,name:'小红'},
      {id:3,name:'小黑'},
    ]
  end

  # 情况汇总
  # 办理部门  合计  未处置 提出拟办意见  小计  拟立案 初步核实  谈话函询  暂存  了结
  get 'qkhz' do
    list = [
        {bm:'信访室',hj:0,wcz:0,yj:0,xj:0,la:0,hs:0,th:0,zc:0,lj:0,},
        {bm:'案件监督管理室',hj:0,wcz:0,yj:0,xj:0,la:0,hs:0,th:0,zc:0,lj:0,},
        {bm:'第一纪检监察室',hj:0,wcz:0,yj:0,xj:0,la:0,hs:0,th:0,zc:0,lj:0,},
        {bm:'第二纪检监察室',hj:0,wcz:0,yj:0,xj:0,la:0,hs:0,th:0,zc:0,lj:0,},
        {bm:'第三纪检监察室',hj:0,wcz:0,yj:0,xj:0,la:0,hs:0,th:0,zc:0,lj:0,},
        {bm:'第四纪检监察室',hj:0,wcz:0,yj:0,xj:0,la:0,hs:0,th:0,zc:0,lj:0,},
        {bm:'第五纪检监察室',hj:0,wcz:0,yj:0,xj:0,la:0,hs:0,th:0,zc:0,lj:0,},
        {bm:'第六纪检监察室',hj:0,wcz:0,yj:0,xj:0,la:0,hs:0,th:0,zc:0,lj:0,},
        {bm:'案件审理室',hj:0,wcz:0,yj:0,xj:0,la:0,hs:0,th:0,zc:0,lj:0,},
      ]
      return {
        total:list.size,
        list:list,
      }
  end

  # 线索来源
  # 线索来源  合计  未处置 提出拟办意见  小计  拟立案 初步核实  谈话函询  暂存  了结
  get 'xsly' do
    list = [
        {ly:'信访室',hj:0,wcz:0,yj:0,xj:0,la:0,hs:0,th:0,zc:0,lj:0,},
        {ly:'案件监督管理室',hj:0,wcz:0,yj:0,xj:0,la:0,hs:0,th:0,zc:0,lj:0,},
        {ly:'第一纪检监察室',hj:0,wcz:0,yj:0,xj:0,la:0,hs:0,th:0,zc:0,lj:0,},
        {ly:'第二纪检监察室',hj:0,wcz:0,yj:0,xj:0,la:0,hs:0,th:0,zc:0,lj:0,},
        {ly:'第三纪检监察室',hj:0,wcz:0,yj:0,xj:0,la:0,hs:0,th:0,zc:0,lj:0,},
        {ly:'第四纪检监察室',hj:0,wcz:0,yj:0,xj:0,la:0,hs:0,th:0,zc:0,lj:0,},
        {ly:'第五纪检监察室',hj:0,wcz:0,yj:0,xj:0,la:0,hs:0,th:0,zc:0,lj:0,},
        {ly:'第六纪检监察室',hj:0,wcz:0,yj:0,xj:0,la:0,hs:0,th:0,zc:0,lj:0,},
        {ly:'案件审理室',hj:0,wcz:0,yj:0,xj:0,la:0,hs:0,th:0,zc:0,lj:0,},
      ]
    return {
        total:list.size,
        list:list,
      }
  end 

  # 获取线索
  get 'clues' do
    user = request.headers['User']
    token = request.headers['Token']
    arr = [
      {date:'2016-05-13',gender:'214',name:'刘芸',duty:'广西省食品安全局局长',rank:'63',source:['89','90','91'],behavior:'113'},
      {date:'2011-03-03',gender:'214',name:'王昌盛',duty:'山西省.太原市市长',rank:'63',source:['88'],behavior:'113'},
      {date:'2014-02-13',gender:'215',name:'郑长军',duty:'上海市副书记',rank:'63',source:['91'],behavior:'112'},
      {date:'2013-05-23',gender:'214',name:'王宇盛',duty:'山西省副省长',rank:'64',source:['88'],behavior:'113'},
      {date:'2013-01-13',gender:'214',name:'陈川平',duty:'辽宁省.大连市副市长',rank:'63',source:['88'],behavior:'112'},
      {date:'2016-05-13',gender:'214',name:'刘芸',duty:'广西省食品安全局局长',rank:'63',source:['89'],behavior:'113'},
      {date:'2016-05-13',gender:'214',name:'刘芸',duty:'广西省食品安全局局长',rank:'63',source:['89'],behavior:'113'},
      {date:'2011-03-03',gender:'214',name:'王昌盛',duty:'山西省.太原市市长',rank:'63',source:['88'],behavior:'113'},
      {date:'2014-02-13',gender:'215',name:'郑长军',duty:'上海市副书记',rank:'63',source:['91'],behavior:'112'},
      {date:'2013-05-23',gender:'214',name:'王宇盛',duty:'山西省副省长',rank:'64',source:['88'],behavior:'113'},
      {date:'2013-01-13',gender:'214',name:'陈川平',duty:'辽宁省.大连市副市长',rank:'63',source:['88'],behavior:'112'},
      {date:'2016-05-13',gender:'214',name:'刘芸',duty:'广西省食品安全局局长',rank:'63',source:['89'],behavior:'113'},
      {date:'2016-05-13',gender:'214',name:'刘芸',duty:'广西省食品安全局局长',rank:'63',source:['89'],behavior:'113'},
      {date:'2011-03-03',gender:'214',name:'王昌盛',duty:'山西省.太原市市长',rank:'63',source:['88'],behavior:'113'},
      {date:'2014-02-13',gender:'215',name:'郑长军',duty:'上海市副书记',rank:'63',source:['91'],behavior:'112'},
      {date:'2013-05-23',gender:'214',name:'王宇盛',duty:'山西省副省长',rank:'64',source:['88'],behavior:'113'},
      {date:'2013-01-13',gender:'214',name:'陈川平',duty:'辽宁省.大连市副市长',rank:'63',source:['88'],behavior:'112'},
      {date:'2016-05-13',gender:'214',name:'刘芸',duty:'广西省食品安全局局长',rank:'63',source:['89'],behavior:'113'},
      {date:'2016-05-13',gender:'214',name:'刘芸',duty:'广西省食品安全局局长',rank:'63',source:['89'],behavior:'113'},
      {date:'2011-03-03',gender:'214',name:'王昌盛',duty:'山西省.太原市市长',rank:'63',source:['88'],behavior:'113'},
      {date:'2014-02-13',gender:'215',name:'郑长军',duty:'上海市副书记',rank:'63',source:['91'],behavior:'112'},
      {date:'2013-05-23',gender:'214',name:'王宇盛',duty:'山西省副省长',rank:'64',source:['88'],behavior:'113'},
      {date:'2013-01-13',gender:'214',name:'陈川平',duty:'辽宁省.大连市副市长',rank:'63',source:['88'],behavior:'112'},
      {date:'2016-05-13',gender:'214',name:'刘芸',duty:'广西省食品安全局局长',rank:'63',source:['89'],behavior:'113'},
      {date:'2016-05-13',gender:'214',name:'刘芸',duty:'广西省食品安全局局长',rank:'63',source:['89'],behavior:'113'},
      {date:'2011-03-03',gender:'214',name:'王昌盛',duty:'山西省.太原市市长',rank:'63',source:['88'],behavior:'113'},
      {date:'2014-02-13',gender:'215',name:'郑长军',duty:'上海市副书记',rank:'63',source:['91'],behavior:'112'},
      {date:'2013-05-23',gender:'214',name:'王宇盛',duty:'山西省副省长',rank:'64',source:['88'],behavior:'113'},
      {date:'2013-01-13',gender:'214',name:'陈川平',duty:'辽宁省.大连市副市长',rank:'63',source:['88'],behavior:'112'},
      {date:'2016-05-13',gender:'214',name:'刘芸',duty:'广西省食品安全局局长',rank:'63',source:['89'],behavior:'113'},
      {date:'2016-05-13',gender:'214',name:'刘芸',duty:'广西省食品安全局局长',rank:'63',source:['89'],behavior:'113'},
      {date:'2011-03-03',gender:'214',name:'王昌盛',duty:'山西省.太原市市长',rank:'63',source:['88'],behavior:'113'},
      {date:'2014-02-13',gender:'215',name:'郑长军',duty:'上海市副书记',rank:'63',source:['91'],behavior:'112'},
      {date:'2013-05-23',gender:'214',name:'王宇盛',duty:'山西省副省长',rank:'64',source:['88'],behavior:'113'},
      {date:'2013-01-13',gender:'214',name:'陈川平',duty:'辽宁省.大连市副市长',rank:'63',source:['88'],behavior:'112'},
      {date:'2016-05-13',gender:'214',name:'刘芸',duty:'广西省食品安全局局长',rank:'63',source:['89'],behavior:'113'},
      {date:'2016-05-13',gender:'214',name:'刘芸',duty:'广西省食品安全局局长',rank:'63',source:['89'],behavior:'113'},
      {date:'2011-03-03',gender:'214',name:'王昌盛',duty:'山西省.太原市市长',rank:'63',source:['88'],behavior:'113'},
      {date:'2014-02-13',gender:'215',name:'郑长军',duty:'上海市副书记',rank:'63',source:['91'],behavior:'112'},
      {date:'2013-05-23',gender:'214',name:'王宇盛',duty:'山西省副省长',rank:'64',source:['88'],behavior:'113'},
      {date:'2013-01-13',gender:'214',name:'陈川平',duty:'辽宁省.大连市副市长',rank:'63',source:['88'],behavior:'112'},
      {date:'2016-05-13',gender:'214',name:'刘芸',duty:'广西省食品安全局局长',rank:'63',source:['89'],behavior:'113'},
      {date:'2016-05-13',gender:'214',name:'刘芸',duty:'广西省食品安全局局长',rank:'63',source:['89'],behavior:'113'},
      {date:'2011-03-03',gender:'214',name:'王昌盛',duty:'山西省.太原市市长',rank:'63',source:['88'],behavior:'113'},
      {date:'2014-02-13',gender:'215',name:'郑长军',duty:'上海市副书记',rank:'63',source:['91'],behavior:'112'},
      {date:'2013-05-23',gender:'214',name:'王宇盛',duty:'山西省副省长',rank:'64',source:['88'],behavior:'113'},
      {date:'2013-01-13',gender:'214',name:'陈川平',duty:'辽宁省.大连市副市长',rank:'63',source:['88'],behavior:'112'},
      {date:'2016-05-13',gender:'214',name:'刘芸',duty:'广西省食品安全局局长',rank:'63',source:['89'],behavior:'113'},
      {date:'2016-05-13',gender:'214',name:'刘芸',duty:'广西省食品安全局局长',rank:'63',source:['89'],behavior:'113'},
      {date:'2011-03-03',gender:'214',name:'王昌盛',duty:'山西省.太原市市长',rank:'63',source:['88'],behavior:'113'},
      {date:'2014-02-13',gender:'215',name:'郑长军',duty:'上海市副书记',rank:'63',source:['91'],behavior:'112'},
      {date:'2013-05-23',gender:'214',name:'王宇盛',duty:'山西省副省长',rank:'64',source:['88'],behavior:'113'},
      {date:'2013-01-13',gender:'214',name:'陈川平',duty:'辽宁省.大连市副市长',rank:'63',source:['88'],behavior:'112'},
      {date:'2016-05-13',gender:'214',name:'刘芸',duty:'广西省食品安全局局长',rank:'63',source:['89'],behavior:'113'},
    ]
    arr.each_with_index{|a,i| a[:name]+=i.to_s}
    page = params[:current_page].to_i
    size = params[:page_size].to_i
    return {
      total:arr.size,
      list:arr[Range.new(size*(page-1),size*page-1)]
    }
  end

  get 'provs' do
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