class StreetsController < ApplicationController
  before_action :set_street, only: [:show, :edit, :update, :destroy]

  # GET /streets
  # GET /streets.json
  def index
    @streets = Street.all
  end

  # GET /streets/1
  # GET /streets/1.json
  def show
  end

  # GET /streets/new
  def new
    @street = Street.new
  end

  # GET /streets/1/edit
  def edit
  end

  # POST /streets
  # POST /streets.json
  def create
    @street = Street.new(street_params)

    respond_to do |format|
      if @street.save
        format.html { redirect_to @street, notice: 'Street was successfully created.' }
        format.json { render :show, status: :created, location: @street }
      else
        format.html { render :new }
        format.json { render json: @street.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /streets/1
  # PATCH/PUT /streets/1.json
  def update
    respond_to do |format|
      if @street.update(street_params)
        format.html { redirect_to @street, notice: 'Street was successfully updated.' }
        format.json { render :show, status: :ok, location: @street }
      else
        format.html { render :edit }
        format.json { render json: @street.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /streets/1
  # DELETE /streets/1.json
  def destroy
    @street.destroy
    respond_to do |format|
      format.html { redirect_to streets_url, notice: 'Street was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_street
      @street = Street.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def street_params
      params.require(:street).permit(:city_id, :name, :code)
    end
end
