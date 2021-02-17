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
    import = Import.import(params[:file])
    redirect_to imports_path, notice: "Datos importados!"
  end

  def update
    @import.update(import_params)
    redirect_to import_path(import)
  end

  def destroy
    @import.destroy
    redirect_to imports_path
  end

  private
    def get_import
      @import = current_user.imports.where(id: params[:id].to_i).first
    end
    def import_params
      params.require(:import).permit(:user_id, :import_errors, :name, :birth_date, :tel, :address, :credit_card, :franchise, :email)
    end
end
