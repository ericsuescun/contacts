class ImportsController < SecureController
  before_action :get_import, only: [:show, :edit, :update, :destroy]

  def index
    @imports = current_user.imports
  end

  def new
  end

  def show
  end

  def edit
  end

  def create
    Import.import(params[:file], current_user.id)
    helpers.set_source_filename(current_user.id, params[:file].original_filename)
    redirect_to imports_path, notice: "Datos importados!"
  end

  def update
    @import.update(import_params)
    redirect_to imports_path(@import)
  end

  def destroy
    @import.destroy
    redirect_to imports_path
  end

  private
    def get_import
      unless current_user.imports.empty?
        @import = current_user.imports.where(id: params[:id].to_i).first
      else
        render partial: "./shared/forbiden_user"
      end
    end

    def import_params
      params.require(:import).permit(:user_id, :import_errors, :name, :birth_date, :tel, :address, :credit_card, :franchise, :email)
    end
end
