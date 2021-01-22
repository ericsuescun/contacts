class ContactsController < ApplicationController
  require 'bcrypt'
  
  before_action :authenticate_user!

  def index
    @contacts = Contact.where(user_id: current_user.id).paginate(page: params[:page], per_page: 2)
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
    contact = Contact.find(params[:id])
    contact.destroy
    redirect_to contacts_path
  end

  

    def get_franchise(contact)
      franchises = Franchise.order("LENGTH(prefix) DESC")
      franchises.each do |franchise|
      # Franchise.all.each do |franchise|
        puts "Franchise: " + franchise.name
        franchise.prefix.split(',').each do |prefix|
          if prefix.match(/-/) != nil
            (prefix.split('-')[0].to_i..prefix.split('-')[1].to_i).each do |range|
              puts "range: " + range.to_s
              if contact.credit_card[0..(range.to_s.length - 1)] == range
                franchise.number_length.split(',').each do |f_length|
                  if f_length.match(/-/) != nil
                    (f_length.split('-')[0].to_i..f_length.split('-')[1].to_i).each do |l|
                      if contact.credit_card.length == l
                        contact.franchise = franchise.name
                        return false
                      end
                    end
                  else
                    if contact.credit_card.length == f_length.to_i
                      contact.franchise = franchise.name
                      return false
                    end
                  end
                end
              end
            end
          else
            if contact.credit_card[0..(prefix.length - 1)] == prefix
              if prefix == "5018"
              end
              puts "Prefix: " + prefix.to_s
              franchise.number_length.split(',').each do |f_length|
                if f_length.match(/-/) != nil
                  (f_length.split('-')[0].to_i..f_length.split('-')[1].to_i).each do |l|
                    if contact.credit_card.length == l
                      contact.franchise = franchise.name
                      return false
                    end
                  end
                else
                  if contact.credit_card.length == f_length.to_i
                    contact.franchise = franchise.name
                    return false
                  end
                end
              end
            end
          end
        end
      end
      return true
    end

    def fix_header
      imports = Import.where(id: params[:imports_ids])
      @contacts = []
      
      imports.each do |import|
        keys = [ params[:field1], params[:field2], params[:field3], params[:field4], params[:field5], "franchise", params[:field6] ]
        values = [ import.name, import.birth_date, import.tel, import.address, import.credit_card, "", import.email]
        errors = ""
        contact = Import.new(keys.zip(values).to_h) #Take as model Import, not contact yet

        if contact.name.match(/^[\p{L}\s\p{N}._@?¿!¡€-]+$/) == nil
          errors += "Character missmatch. "
        end

        unless contact.birth_date.match(/^\d{4}-\d{2}-\d{2}/) != nil || contact.birth_date.match(/^\d{4}\d{2}\d{2}/) != nil
          errors += "Date format error. "
        end

        if contact.tel.match(/\(\+\d{1,2}\)\s\d{3,3}\s\d{3,3}\s\d{2,2}\s\d{2,2}/) == false || contact.tel.match(/\(\+\d{1,2}\)\s\d{3,3}-\d{3,3}-\d{2,2}-\d{2,2}/) == false
          errors += "Phone number format error. "
        end

        if contact.address == ""
          errors += "Address empty error. "
        end

        if get_franchise(contact)
          errors += "Credit Card number wrong. "
        end

        if contact.email == nil
          byebug
        end

        if !contact.email.match(/^\S+@\S+\.\S+$/)
          errors += "Email has errors. "
        end

        if errors == ""
          new_contact = Contact.new(
            user_id: current_user.id,
            name: contact.name,
            birth_date: Date.parse(contact.birth_date),
            tel: contact.tel,
            address: contact.address,
            credit_card: contact.credit_card[-4..-1],
            franchise: contact.franchise,
            email: contact.email,
            cc_digest: BCrypt::Password.create(contact.credit_card)
            )
          new_contact.save
          import.destroy
          contact = nil
        else
          import.update(import_errors: errors)
        end
        # @contacts << contact
      end
      redirect_to contacts_path
    end
end
