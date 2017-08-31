class Crawler::WebsiteTypesController < Crawler::BaseController
  before_action :set_crawler_website_type, only: [:show, :edit, :update, :destroy]

  # GET /crawler/website_types
  # GET /crawler/website_types.json
  def index
    @crawler_website_types = Crawler::WebsiteType.all
  end

  # GET /crawler/website_types/1
  # GET /crawler/website_types/1.json
  def show
  end

  # GET /crawler/website_types/new
  def new
    @crawler_website_type = Crawler::WebsiteType.new
  end

  # GET /crawler/website_types/1/edit
  def edit
  end

  # POST /crawler/website_types
  # POST /crawler/website_types.json
  def create
    @crawler_website_type = Crawler::WebsiteType.new(crawler_website_type_params)

    respond_to do |format|
      if @crawler_website_type.save
        format.html { redirect_to @crawler_website_type, notice: 'Website type was successfully created.' }
        format.json { render :show, status: :created, location: @crawler_website_type }
      else
        format.html { render :new }
        format.json { render json: @crawler_website_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /crawler/website_types/1
  # PATCH/PUT /crawler/website_types/1.json
  def update
    respond_to do |format|
      if @crawler_website_type.update(crawler_website_type_params)
        format.html { redirect_to @crawler_website_type, notice: 'Website type was successfully updated.' }
        format.json { render :show, status: :ok, location: @crawler_website_type }
      else
        format.html { render :edit }
        format.json { render json: @crawler_website_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /crawler/website_types/1
  # DELETE /crawler/website_types/1.json
  def destroy
    @crawler_website_type.destroy
    respond_to do |format|
      format.html { redirect_to crawler_website_types_url, notice: 'Website type was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_crawler_website_type
      @crawler_website_type = Crawler::WebsiteType.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def crawler_website_type_params
      params.require(:crawler_website_type).permit(:name, :note)
    end
end
