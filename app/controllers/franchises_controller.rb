class FranchisesController < SecureController

  def import
    Franchise.import(params[:file])
    redirect_to franchises_path, notice: "Data imported!"
  end

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

  def update
  end

  def destroy
  end
end
