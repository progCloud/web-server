class AssetsController < ApplicationController
  before_action :set_asset, only: [:edit, :update, :destroy]
  before_action :authenticate_user!
  respond_to :html, :json

  def index
    @assets = current_user.assets
    respond_with(@assets)
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
      send_file asset.uploaded_file.path, :type => asset.uploaded_file_content_type, :disposition => 'inline'
    else
      flash[:error] = "If you stop trespassing now, that would be the end of it. But if you don't, I will find you and make all your uploads public. Good Luck!"
      redirect_to assets_path
    end
  end

  def create
    @asset = current_user.assets.new(asset_params)
    @asset.save
    distribute_to_locations(@asset)
    redirect_to assets_path
  end

  def update
    @asset.update(asset_params)
    redirect_to assets_path
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

    def distribute_to_locations(asset)
      rand_num = 1 + rand(3)            # Randomly choose a server to exclude

      if rand_num == 1
        asset.s1 = '0'
      else
        asset.s1 = '1'
        source = "assets/" + asset.id.to_s
        destination = 's1/' + asset.id.to_s
        FileUtils.copy_entry source, destination
      end
      if rand_num == 2
        asset.s2 = '0'
      else
        asset.s2 = '1'
        source = "assets/" + asset.id.to_s
        destination = 's2/' + asset.id.to_s
        FileUtils.copy_entry source, destination
      end
      if rand_num == 3
        asset.s3 = '0'
      else
        asset.s3 = '1'
        source = "assets/" + asset.id.to_s
        destination = 's3/' + asset.id.to_s
        FileUtils.copy_entry source, destination
      end
    end

end
