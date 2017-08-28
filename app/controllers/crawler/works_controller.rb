class Crawler::WorksController < Crawler::BaseController
  before_action :set_crawler_work, only: [:show, :edit, :update, :destroy]

  # GET /crawler/works
  # GET /crawler/works.json
  def index
    @q = Crawler::Work.includes(:website).ransack(params[:q])
    @count = @q.result.size
    @order = params[:order].blank? ? 'address' : params[:order]
    @per = params[:per].blank? ? 50 : params[:per].to_i
    @pagecount = @count % @per > 0 ? @count / @per + 1 : @count
    @works = @q.result.order(@order).page(params[:page]).per(@per)
  end

  # GET /crawler/works/1
  # GET /crawler/works/1.json
  def show
  end

  # 处理数据
  def handle
    # @handles = {destroy_all:'全部删除',tracking_all:'标记更新',}
    if params[:handle] and params[:w_ids]
      @works = Crawler::Work.where('id in (?)',params[:w_ids])
      case params[:handle]
        when 'destroy_all'
          @works.destroy_all
          @msg = "成功删除#{@works.size}条"
        when 'tracking_all'
          @works.update_all tracking:params[:tracking]
          @msg = "成功标记#{params[:tracking]} #{@works.size}条"

        else
          @msg = "无法处理#{params[:handle]}"
      end
    end
    respond_to do |format|
      format.html {  }
      format.json { render json:{ok:true,msg:@msg,data:{id:@works.map(&:id)}} }
    end
  end

  # 统计
  def tj
    @ruby_rails_results = {}
    @r = Crawler::Work.where("name like '%ruby%' or name like '%rails%'").group(:address).count
    @ruby_rails_results[:count_sum] = @r.values.sum
    @ruby_rails_results[:citys] = @r.keys
    @ruby_rails_results[:first5] = @r.to_a.sort{|a,b| b[1]<=>a[1]}.first(5)

    # @job51 = Crawler::Website.find_by_name('前程无忧')
    # @job51_rubys = @job51.works.where('name like "%ruby%"').order(:address)
    # @job51_rails = @job51.works.where('name like "%rails%"').order(:address)
    #
    # @boss = Crawler::Website.find_by_name('BOSS直聘')
    # @boss_rubys = @boss.works.where('name like "%ruby%"').order(:address)
    # @boss_rails = @boss.works.where('name like "%rails%"').order(:address)
    #
    # @lagou = Crawler::Website.find_by_name('拉勾网')
    # @lagou_rubys = @lagou.works.where('name like "%ruby%"').order(:address)
    # @lagou_rails = @lagou.works.where('name like "%rails%"').order(:address)
  end

  # 深度挖掘
  def wj

  end



  # GET /crawler/works/new
  def new
    @crawler_work = Crawler::Work.new
  end

  # GET /crawler/works/1/edit
  def edit
  end

  # POST /crawler/works
  # POST /crawler/works.json
  def create
    @crawler_work = Crawler::Work.new(crawler_work_params)

    respond_to do |format|
      if @crawler_work.save
        format.html { redirect_to @crawler_work, notice: 'Work was successfully created.' }
        format.json { render :show, status: :created, location: @crawler_work }
      else
        format.html { render :new }
        format.json { render json: @crawler_work.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /crawler/works/1
  # PATCH/PUT /crawler/works/1.json
  def update
    respond_to do |format|
      if @crawler_work.update(crawler_work_params)
        format.html { redirect_to @crawler_work, notice: 'Work was successfully updated.' }
        format.json { render :show, status: :ok, location: @crawler_work }
      else
        format.html { render :edit }
        format.json { render json: @crawler_work.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /crawler/works/1
  # DELETE /crawler/works/1.json
  def destroy
    @crawler_work.destroy
    respond_to do |format|
      format.html { redirect_to crawler_works_url, notice: 'Work was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_crawler_work
      @crawler_work = Crawler::Work.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def crawler_work_params
      params.require(:crawler_work).permit(:name, :url, :text, :company_name, :company_url, :price_scope, :address, :price_min, :price_max, :city, :company_id, :category, :website_id, :note, :send_time)
    end
end
