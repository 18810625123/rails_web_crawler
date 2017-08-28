class Crawler::WebsitesController < Crawler::BaseController
  before_action :set_crawler_website, only: [:show, :edit, :update, :destroy]

  # GET /crawler/websites
  # GET /crawler/websites.json
  def index
    @crawler_websites = Crawler::Website.includes(:website_type)
  end

  # GET /crawler/websites/1
  # GET /crawler/websites/1.json
  def show
  end

  # GET /crawler/websites/new
  def new
    @crawler_website = Crawler::Website.new
  end

  # GET /crawler/websites/1/edit
  def edit
  end

  # POST /crawler/websites
  # POST /crawler/websites.json
  def create
    @crawler_website = Crawler::Website.new(crawler_website_params)

    respond_to do |format|
      if @crawler_website.save
        format.html { redirect_to @crawler_website, notice: 'Website was successfully created.' }
        format.json { render :show, status: :created, location: @crawler_website }
      else
        format.html { render :new }
        format.json { render json: @crawler_website.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /crawler/websites/1
  # PATCH/PUT /crawler/websites/1.json
  def update
    respond_to do |format|
      if @crawler_website.update(crawler_website_params)
        format.html { redirect_to @crawler_website, notice: 'Website was successfully updated.' }
        format.json { render :show, status: :ok, location: @crawler_website }
      else
        format.html { render :edit }
        format.json { render json: @crawler_website.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /crawler/websites/1
  # DELETE /crawler/websites/1.json
  def destroy
    @crawler_website.destroy
    respond_to do |format|
      format.html { redirect_to crawler_websites_url, notice: 'Website was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_crawler_website
      @crawler_website = Crawler::Website.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def crawler_website_params
      params.require(:crawler_website).permit(:name, :index_url, :website_type_id, :note)
    end
end
