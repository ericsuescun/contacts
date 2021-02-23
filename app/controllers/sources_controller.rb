class SourcesController < SecureController
  before_action :get_source, only: [:destroy]

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
    @source.destroy
    redirect_to sources_path
  end

  private
    def get_source
      unless current_user.sources.empty?
        @source = current_user.sources.where(id: params[:id].to_i).first
      else
        render partial: "./shared/forbiden_user"
      end
    end
end
