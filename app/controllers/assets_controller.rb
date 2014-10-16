class AssetsController < ApplicationController
  before_action :set_asset, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  respond_to :html, :json

  def index
    @assets = current_user.assets
    respond_with(@assets)
  end

  def show
    respond_with(@asset)
  end

  def new
    @asset = current_user.assets.new
    respond_with(@asset)
  end

  def edit
  end

  def get
    asset = current_user.assets.find_by_id(params[:id])
    if asset
      send_file asset.uploaded_file.path, :type => asset.uploaded_file_content_type 
    else
      flash[:error] = "If you stop trespassing now, that would be the end of it. But if you don't, I will find you and make all your uploads public. Good Luck!"
      redirect_to assets_path
    end
  end

  def create
    @asset = current_user.assets.new(asset_params)
    @asset.save
    respond_with(@asset)
  end

  def update
    @asset.update(asset_params)
    respond_with(@asset)
  end

  def destroy
    @asset.destroy
    respond_with(@asset)
  end

  private
    def set_asset
      @asset = current_user.assets.find(params[:id])
    end

    def asset_params
      params.require(:asset).permit(:uploaded_file)
    end
end
