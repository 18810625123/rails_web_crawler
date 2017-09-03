class Crawler::PlansController < Crawler::BaseController
  before_action :set_crawler_plan, only: [:today_finish, :flush_page, :exce, :auto_exce, :show, :edit, :update, :destroy]

  # GET /crawler/plans
  # GET /crawler/plans.json
  def index
    @crawler_plans = Crawler::Plan.all
    @q = Crawler::Plan.includes(:website).ransack(params[:q])
    @count = @q.result.size
    @per = params[:per].blank? ? 50 : params[:per].to_i
    @pagecount = @count % @per > 0 ? @count / @per + 1 : @count
    @crawler_plans = @q.result.order(:website_id).page(params[:page]).per(@per)
  end


  # 执行采集
  def exce
    @plans = Crawler::Plan.all
    a = params[:page_a]
    b = params[:page_b]
    if a.blank? or b.blank?
      @msg = "手动采集必须填写页码a-b"
      return
    else
      a = a.to_i
      b = b.to_i
      if b < a
        @msg = "b页不能小于a"
        return
      end
      results = @crawler_plan.exce_works(a, b, params[:include_work_name], params[:filter_work_name], params[:save_flag])
      @works = results[:works]
      time = results[:time]
      data_count = @works.map{|k,v| v.size}.sum
      if results[:ok]
        @msg = "执行完成,共用时 #{time} 秒, 共对#{b-a+1}页进行了采集, #{data_count}条"

      else
        @msg = "执行中断,止于第#{results[:error_page]}页,错误原因:#{results[:error]},共用时 #{time} 秒, 共对#{results[:error_page].to_i-a+1}页进行了采集, 处理数据#{data_count}条"

      end
    end
  end

  def flush_page
    @crawler_plan.flush_page
    redirect_to action: :index
  end

  def today_finish
    @crawler_plan.today_finish
    redirect_to action: :index
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
