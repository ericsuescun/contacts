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
    imports = Import.where(id: params[:imports_ids])
    @contacts = current_user.contacts

    # CreateContactsFromImportJob.perform_later(import, current_user)

    imports.each do |import|
      keys = [ "user_id", params[:field1], params[:field2], params[:field3], params[:field4], params[:field5], "franchise", params[:field6] ]
      values = [ current_user.id, import.name, import.birth_date, import.tel, import.address, import.credit_card, "", import.email]
      errors = ""
      # contact = Import.new(keys.zip(values).to_h) #Take as model Import, not contact yet
      contact = Contact.new(keys.zip(values).to_h)

      if contact.save
        helpers.refresh_file(import)
        import.destroy
        if Import.where(filename: import.filename) == []
          Source.where(filename: import.filename).first.update(status: "finished")
        end
        # contact = nil
      else
        import.update(import_errors: contact.errors.to_a.join(', '))
      end

      # if helpers.get_franchise(contact)
      #   import.update(import_errors: import.import_errors + " Wrong Credit Card number. ")
      # end

    end
    redirect_to contacts_path
  end

  def update
    @contact.update(contact_params)
    redirect_to contact_path
  end

  def destroy
    @contact.destroy
    redirect_to contacts_path
  end

  # def fix_header

  # end

  private

    def get_contact
      @contact = current_user.contacts.where(id: params[:id].to_i).first
    end

    def contact_params
      params.require(:contact).permit(:user_id, :name, :birth_date, :tel, :address, :credit_card, :franchise, :email)
    end
end
