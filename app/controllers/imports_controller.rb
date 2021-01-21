class ImportsController < ApplicationController
  before_action :authenticate_user!

  def import
    Import.import(params[:file])
    redirect_to imports_path, notice: "Datos importados!"
  end

  def index
    @imports = Import.all
  end

  def new
  end

  def show
  end

  def edit
  end

  def create
  end

  def update
  end

  def destroy
  end
end
