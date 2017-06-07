class FarmsController < ApplicationController
  before_action :set_farm, only: [:show, :edit, :update, :destroy]

  # GET /farms
  # GET /farms.json
  def index
    @farms = Farm.all
    @mst_prefs = MstPref.all
    @crops = Crop.all
    #栽培品目で検索
    if params[:id].present?
      @farms = Farm.with_crop.search_by_crop(params[:id])
    end
    #県名で検索
    if params[:mst_pref_id] && params[:id].present?
      @farms = Farm.with_crop.search_by_crop(params[:id]).search_by_pref(params[:mst_pref_id])
    elsif params[:mst_pref_id].present?
      @farms = Farm.search_by_pref(params[:mst_pref_id])
    elsif params[:id].present?
      @farms = Farm.with_crop.search_by_crop(params[:id])
    else
      @farms = Farm.all
      flash[:notice] = "条件に合う農家データは見つかりませんでした。"
    end
  end

  # GET /farms/1
  # GET /farms/1.json
  def show
  end

  # GET /farms/new
  def new
    @farm = Farm.new
    @mst_prefs = MstPref.all
  end

  # GET /farms/1/edit
  def edit
    @mst_prefs = MstPref.all
  end

  # POST /farms
  # POST /farms.json
  def create
    @farm = Farm.new(farm_params)

    respond_to do |format|
      if @farm.save
        format.html { redirect_to @farm, notice: 'Farm was successfully created.' }
        format.json { render :show, status: :created, location: @farm }
      else
        format.html { render :new }
        format.json { render json: @farm.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /farms/1
  # PATCH/PUT /farms/1.json
  def update
    respond_to do |format|
      if @farm.update(farm_params)
        format.html { redirect_to @farm, notice: 'Farm was successfully updated.' }
        format.json { render :show, status: :ok, location: @farm }
      else
        format.html { render :edit }
        format.json { render json: @farm.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /farms/1
  # DELETE /farms/1.json
  def destroy
    @farm.destroy
    respond_to do |format|
      format.html { redirect_to farms_url, notice: 'Farm was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_farm
      @farm = Farm.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def farm_params
      params.require(:farm).permit(:farmname, :area, :mst_pref_id, :prefecture, :city, :message, { :crop_ids => [] })
    end
end
