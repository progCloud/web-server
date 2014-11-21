class FoldersController < ApplicationController
  before_action :set_folder, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  respond_to :html

  def index
    @folders = current_user.folders.order("uploaded_file_file_name desc")
    respond_with(@folders)
  end

  def show
    @assets = Asset.where(folder_id: @folder.id)
    respond_with(@folder)
  end

  def new
    @folder = current_user.folders.new
    respond_with(@folder)
  end

  def edit
  end

  def create
    @folder = current_user.folders.new(folder_params)
    @folder.save
    redirect_to assets_path
  end

  def update
    @folder.update(folder_params)
    redirect_to assets_path
  end

  def destroy
    @folder.destroy
    redirect_to assets_path
  end

  private
    def set_folder
      if(current_user.folders.where(id: params[:id]).count() > 0 )
        @folder = current_user.folders.find(params[:id])
      else
        @folder = current_user.shared_folders_by_others.find(params[:id])
      end
    end

    def folder_params
      params.require(:folder).permit(:name)
    end
end
