class Crawler::MenusController < Crawler::BaseController
  before_action :set_crawler_menu, only: [:move, :copy, :show, :edit, :update, :destroy]

  # GET /crawler/menus
  # GET /crawler/menus.json
  def index
    @crawler_menus = Crawler::Menu.all.order :location
  end

  # GET /crawler/menus/1
  # GET /crawler/menus/1.json
  def show
  end

  # GET /crawler/menus/new
  def new
    @crawler_menu = Crawler::Menu.new
  end

  def move
    Crawler::Menu.move @crawler_menu, params[:move] if params[:move]
    redirect_to action: :index
  end

  # GET /crawler/menus/1/edit
  def edit
  end

  # POST /crawler/menus
  # POST /crawler/menus.json
  def create
    @crawler_menu = Crawler::Menu.new(crawler_menu_params)

    respond_to do |format|
      if @crawler_menu.save
        format.html { redirect_to @crawler_menu, notice: 'Menu was successfully created.' }
        format.json { render :show, status: :created, location: @crawler_menu }
      else
        format.html { render :new }
        format.json { render json: @crawler_menu.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /crawler/menus/1
  # PATCH/PUT /crawler/menus/1.json
  def update
    respond_to do |format|
      if @crawler_menu.update(crawler_menu_params)
        format.html { redirect_to @crawler_menu, notice: 'Menu was successfully updated.' }
        format.json { render :show, status: :ok, location: @crawler_menu }
      else
        format.html { render :edit }
        format.json { render json: @crawler_menu.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /crawler/menus/1
  # DELETE /crawler/menus/1.json
  def destroy
    @crawler_menu.destroy
    respond_to do |format|
      format.html { redirect_to crawler_menus_url, notice: 'Menu was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_crawler_menu
      @crawler_menu = Crawler::Menu.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def crawler_menu_params
      params.require(:crawler_menu).permit(:name, :namespace, :controller, :action, :note, :parent_id)
    end
end
