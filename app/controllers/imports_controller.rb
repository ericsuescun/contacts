class ImportsController < SecureController

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
    @import = Import.find(params[:id])
  end

  def edit
    @import = Import.find(params[:id])
  end

  def create
  end

  def update
    import = Import.find(params[:id])
    import.update(import_params)
    redirect_to import_path(import)
  end

  def destroy
    import = Import.find(params[:id])
    import.destroy
    redirect_to imports_path
  end

  private
    def import_params
      params.require(:import).permit(:user_id, :import_errors, :name, :birth_date, :tel, :address, :credit_card, :franchise, :email)
    end
end
