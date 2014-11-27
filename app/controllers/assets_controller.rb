class AssetsController < ApplicationController
  before_action :set_asset, only: [:edit, :update, :destroy]
  before_action :authenticate_user!, except: [:get]
  respond_to :html

  def index
    @being_shared_folders = current_user.shared_folders_by_others
    @assets = current_user.assets.where(folder_id: -1).order("uploaded_file_file_name desc")
    @folders = current_user.folders
    respond_with(@assets)
  end

  def sharing
    share_with_email = params[:sharing][:email]
    message = params[:sharing][:message]
    folder_id = params[:sharing][:folder]
    shared_folder = current_user.shared_folders.new
    shared_folder.shared_email = share_with_email
    shared_folder.message = message
    shared_folder.folder_id = folder_id
    shared_folder.shared_user_id = User.where(email: share_with_email).first.id
    shared_folder.folder_name = Folder.find_by_id(folder_id).name
    shared_folder.save
    redirect_to assets_path
  end

  def new
    @asset = current_user.assets.new
    if params[:folder_id]
      @current_folder = current_user.folders.find(params[:folder_id]) 
      @asset.folder_id = @current_folder.id 
    end
    respond_with(@asset)
  end

  def edit
  end

  def remove_dot_if_present(string)
    if string[-1] == '.'
      string[0..-2]
    else
      string
    end
  end

  def get
    if(user_signed_in?)
      if current_user.all_assets.find_by_id(params[:id])
        asset = current_user.all_assets.find_by_id(params[:id])
        send_file remove_dot_if_present(asset.uploaded_file.path), :type => asset.uploaded_file_content_type, :disposition => 'inline'
      else
        flash[:error] = "If you stop trespassing now, that would be the end of it. But if you don't, I will find you and make all your uploads public. Good Luck!"
        redirect_to assets_path
      end
    elsif (Asset.find_by_id(params[:id]) && Asset.find_by_id(params[:id]).is_public)
      asset = Asset.find_by_id(params[:id])
      send_file remove_dot_if_present(asset.uploaded_file.path), :type => asset.uploaded_file_content_type, :disposition => 'inline'
    else
      flash[:error] = "If you stop trespassing now, that would be the end of it. But if you don't, I will find you and make all your uploads public. Good Luck!"
      redirect_to assets_path
    end
  end

  def create
    @asset = current_user.assets.new(asset_params)

    if params[:folder_id]
      @current_folder = current_user.folders.find(params[:folder_id]) 
      @asset.folder_id = @current_folder.id 
    end
    @asset.save
    if !@asset.folder_id
      @asset.update(folder_id: -1)
    end
    redirect_to assets_path
  end

  def update
    @asset.update(asset_params)
    redirect_to assets_path
  end

  def destroy
    @asset.destroy
    redirect_to :back
    rescue ActionController::RedirectBackError
    redirect_to root_path
  end

  def online_upload
    name = params[:name]
    text = params[:edit_text]
    @asset = current_user.assets.new()
    @asset.uploaded_file_file_name = name
    @asset.uploaded_file_content_type = 'text/html'
    @asset.save
    require 'fileutils'
    file_path = remove_dot_if_present(@asset.uploaded_file.path)
    folder = file_path[0...file_path.rindex('/')]
    FileUtils.mkdir_p folder
    File.open(@asset.uploaded_file.path, 'w+') { |file| file.write(text) }
    size = File.size(@asset.uploaded_file.path)
    @asset.update(uploaded_file_file_size: size)
    redirect_to assets_path
  end

  private
    def set_asset
      @asset = current_user.all_assets.find(params[:id])
    end

    def asset_params
      params.require(:asset).permit(:uploaded_file, :is_public, :folder_id)
    end

    def distribute_to_locations(asset)
      rand_num = 1 + rand(3)            # Randomly choose a server to exclude

      if rand_num != 1
        @asset.update(s1: '1')
        source = "assets/" + asset.id.to_s
        destination = 's1/' + asset.id.to_s
        FileUtils.copy_entry source, destination
      end
      if rand_num != 2
        @asset.update(s2: '1')
        source = "assets/" + asset.id.to_s
        destination = 's2/' + asset.id.to_s
        FileUtils.copy_entry source, destination
      end
      if rand_num != 3
        @asset.update(s3: '1')
        source = "assets/" + asset.id.to_s
        destination = 's3/' + asset.id.to_s
        FileUtils.copy_entry source, destination
      end
    end

end
