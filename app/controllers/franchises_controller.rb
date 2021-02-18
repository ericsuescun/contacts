class FranchisesController < SecureController

  def index
    # @franchises = Franchise.all
    @franchises = Franchise.order("LENGTH(prefix) DESC")
  end

  def show
  end

  def new
  end

  def edit
  end

  def create
    Franchise.import(params[:file])
    redirect_to franchises_path, notice: "Datos importados!"
  end

  def update
  end

  def destroy
  end
end
