class ContactsController < ApplicationController
  before_action :authenticate_user!

  def index
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

  private

    def fix_header
      imports = Import.where(id: params[:imports_ids])
      @contacts = []
      errors = ""
      imports.each do |import|
        keys = [ params[:field1], params[:field2], params[:field3], params[:field4], params[:field5], params[:field6], params[:field7] ]
        values = [ import.name, import.birth_date, import.tel, import.address, import.credit_card, import.franchise, import.email]
        contact = Contact.new(keys.zip(values).to_h)
        if contact.name.match(/^[a-zA-Z-]/) != nil
          errors += "Character missmatch. "
        end

        if (contact.birth_date.match(/^\d{4}-\d{2}-\d{2}/) == nil || contact.birth_date.match(/^\d{4}\d{2}\d{2}/) == nil)
          errors += "Date format error. "
        end

        if contact.tel.match(/\(\+\d{1,2}\)\s\d{3,3}\s\d{3,3}\s\d{2,2}\s\d{2,2}/) == false || contact.tel.match(/\(\+\d{1,2}\)\s\d{3,3}-\d{3,3}-\d{2,2}-\d{2,2}/) == false
          errors += "Phone number format error. "
        end

        if contact.address == ""
          errors += "Address empty error. "
        end



        @contacts << contact

      end
    end
end
