class AssetsController < ApplicationController
  before_action :set_asset, only: [:edit, :update, :destroy]
  before_action :authenticate_user!, except: [:get]
  respond_to :html, :json

  def index
    @assets = current_user.assets
    respond_with(@assets)
  end

  def sharing

  end

  def new
    @asset = current_user.assets.new
    respond_with(@asset)
  end

  def edit
  end

  def get
    if(user_signed_in?)
      asset = current_user.assets.find_by_id(params[:id])
      if asset
        send_file asset.uploaded_file.path, :type => asset.uploaded_file_content_type, :disposition => 'inline'
      end
    elsif (Asset.find_by_id(params[:id]) && Asset.find_by_id(params[:id]).is_public)
      asset = Asset.find_by_id(params[:id])
      send_file asset.uploaded_file.path, :type => asset.uploaded_file_content_type, :disposition => 'inline'
    else
      flash[:error] = "If you stop trespassing now, that would be the end of it. But if you don't, I will find you and make all your uploads public. Good Luck!"
      redirect_to assets_path
    end
  end

  def create
    @asset = current_user.assets.new(asset_params)
    @asset.save
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

  def online_upload
    name = params[:name]
    text = params[:edit_text]
    @asset = current_user.assets.new()
    @asset.uploaded_file_file_name = name
    @asset.uploaded_file_content_type = 'text/html'
    @asset.save
    require 'fileutils'
    file_path = @asset.uploaded_file.path
    folder = file_path[0...file_path.rindex('/')]
    FileUtils.mkdir_p folder
    File.open(@asset.uploaded_file.path, 'w+') { |file| file.write(text) }
    size = File.size(@asset.uploaded_file.path)
    @asset.update(uploaded_file_file_size: size)
    redirect_to assets_path
  end

  private
    def set_asset
      @asset = current_user.assets.find(params[:id])
    end

    def asset_params
      params.require(:asset).permit(:uploaded_file, :is_public)
    end
end
