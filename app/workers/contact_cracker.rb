class ContactCracker
  include Sidekiq::Worker

  def perform(imports_ids, current_user_id, params1, params2, params3, params4, params5, params6)
    imports = Import.where(id: imports_ids)

    user = User.find(current_user_id)

    imports.each do |import|
      keys = [ params1, params2, params3, params4, params5, "franchise", params6 ]
      values = [ import.name, import.birth_date, import.tel, import.address, import.credit_card, "", import.email]
      # errors = ""
      # contact = current_user.contacts.build(keys.zip(values).to_h)
      contact = user.contacts.build(keys.zip(values).to_h)

      if contact.save
        # Source.where(filename: import.filename).first.update(status: "in_progress")
        import.destroy
        # if Import.where(filename: import.filename) == []
        #   Source.where(filename: import.filename).first.update(status: "finished")
        # end
      else
        import.update(import_errors: contact.errors.to_a.join(', '))
      end
    end
  end
end