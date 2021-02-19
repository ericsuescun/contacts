class ContactsController < SecureController

  before_action :get_contact, only: [:show, :edit, :update, :destroy]

  def index
    @contacts = current_user.contacts.paginate(page: params[:page], per_page: 2)
  end

  def new
  end

  def show
  end

  def edit
  end

  def create
    # @contacts = current_user.contacts
    # CreateContactsFromImportJob.perform_later(params[:imports_ids], current_user, params[:field1], params[:field2], params[:field3], params[:field4], params[:field5], params[:field6])
    # ContactCracker.perform_async(params[:imports_ids], current_user.id, params[:field1], params[:field2], params[:field3], params[:field4], params[:field5], params[:field6])
    ContactCracker.new.perform(params[:imports_ids], current_user.id, params[:field1], params[:field2], params[:field3], params[:field4], params[:field5], params[:field6])
    redirect_to imports_path
  end

  def update
    @contact.update(contact_params)
    redirect_to contact_path
  end

  def destroy
    @contact.destroy
    redirect_to contacts_path
  end

  private

    def get_contact
      @contact = current_user.contacts.where(id: params[:id].to_i).first
    end

    def contact_params
      params.require(:contact).permit(:user_id, :name, :birth_date, :tel, :address, :credit_card, :franchise, :email)
    end
end
