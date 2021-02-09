class SourcesController < SecureController
  
  def index
    @sources = Source.where(user_id: current_user.id)
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
    source = Source.find(params[:id])
    source.destroy
    redirect_to sources_path
  end
end
