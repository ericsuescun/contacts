class CreateContactsFromImportJob < ApplicationJob
  queue_as :default

  def perform(import, user)
    imports = Import.where(id: params[:imports_ids])

    imports.each do |import|
      keys = [ "user_id", params[:field1], params[:field2], params[:field3], params[:field4], params[:field5], "franchise", params[:field6] ]
      values = [ current_user.id, import.name, import.birth_date, import.tel, import.address, import.credit_card, "", import.email]
      errors = ""
      # contact = Import.new(keys.zip(values).to_h) #Take as model Import, not contact yet
      contact = user.contacts.build(keys.zip(values).to_h)

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
  end

end