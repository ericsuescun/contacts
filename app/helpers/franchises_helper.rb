module FranchisesHelper
  def get_franchise(contact)
    franchises = Franchise.order("LENGTH(prefix) DESC")
    franchises.each do |franchise|
    # Franchise.all.each do |franchise|
      #puts "Franchise: " + franchise.name
      franchise.prefix.split(',').each do |prefix|
        if prefix.match(/-/) != nil
          (prefix.split('-')[0].to_i..prefix.split('-')[1].to_i).each do |range|
            #puts "range: " + range.to_s
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
end
