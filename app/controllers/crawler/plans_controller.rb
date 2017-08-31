class Crawler::PlansController < Crawler::BaseController
  before_action :set_crawler_plan, only: [:exce, :auto_exce, :show, :edit, :update, :destroy]

  # GET /crawler/plans
  # GET /crawler/plans.json
  def index
    @crawler_plans = Crawler::Plan.all
  end


  # 执行采集
  def exce
    @flag = false
    @plans = Crawler::Plan.all
    if params[:page_a].blank? or params[:page_b].blank?
      @msg = "手动采集必须填写页码a-b"
      return
    else
      a = params[:page_a].to_i
      b = params[:page_b].to_i
      if @page_b.to_i < @page_a.to_i
        @msg = "b页不能小于a"
        return
      end
      include = params[:include_work_name]
      filter = params[:filter_work_name]

      save_flag = params[:save_flag]
      @works, @time = @crawler_plan.exce_works({save_flag:save_flag,page:{a:a,b:b},filter:filter,include:include})
      @msg = "执行完成,共用时 #{@time.to_i} 秒"
      @flag = true
    end
  end

  def auto_exce
    if params[:start].blank? or params[:stop].blank? or params[:page].blank?
      @msg = "缺少参数!"
    else
      start = params[:start].to_i
      page = params[:page].to_i
      stop = params[:stop].to_i

      current_page = start
      i = 0
      @msg = ''
      loop do
        @works, @time = @crawler_plan.exce_works({save_flag:'yes',page:{a:current_page,b:current_page},filter:nil,include:nil})
        i += 1
        current_page += 1
        if i == page
          @msg = "本次共采集#{i+1}页,从第#{start}页到第#{current_page}页"
          return
        end
        puts "sum=#{@works.map{|k,v| v.size}.sum.size} < #{stop} ??"

        if @works.map{|k,v| v.size}.sum.size < stop
          @msg = "在采集到第#{current_page}页时,只有#{@works.size}条数据,本次共采集#{i+1}页,从第#{start}页到第#{current_page}页"
          return
        end

      end
      @msg += ",执行完毕"

    end
  end

  # GET /crawler/plans/1
  # GET /crawler/plans/1.json
  def show
  end

  # GET /crawler/plans/new
  def new
    @crawler_plan = Crawler::Plan.new
  end

  # GET /crawler/plans/1/edit
  def edit
  end

  # POST /crawler/plans
  # POST /crawler/plans.json
  def create
    @crawler_plan = Crawler::Plan.new(crawler_plan_params)

    respond_to do |format|
      if @crawler_plan.save
        format.html { redirect_to @crawler_plan, notice: 'Plan was successfully created.' }
        format.json { render :show, status: :created, location: @crawler_plan }
      else
        format.html { render :new }
        format.json { render json: @crawler_plan.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /crawler/plans/1
  # PATCH/PUT /crawler/plans/1.json
  def update
    respond_to do |format|
      if @crawler_plan.update(crawler_plan_params)
        format.html { redirect_to @crawler_plan, notice: 'Plan was successfully updated.' }
        format.json { render :show, status: :ok, location: @crawler_plan }
      else
        format.html { render :edit }
        format.json { render json: @crawler_plan.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /crawler/plans/1
  # DELETE /crawler/plans/1.json
  def destroy
    @crawler_plan.destroy
    respond_to do |format|
      format.html { redirect_to crawler_plans_url, notice: 'Plan was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_crawler_plan
      @crawler_plan = Crawler::Plan.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def crawler_plan_params
      params.require(:crawler_plan).permit(:website_id, :source, :name, :url, :page, :note)
    end
end
