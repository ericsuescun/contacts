
franchises_with_prefix = franchises.map do |key, value|
  result = []
  value[:prefix].each do |prefix|
    result << [prefix, key]
  end
end.compact.sort

# franchises.map{|key, value| value[:prefix]}.compact.sort

def get_franchise(card_number)
  franchises_with_prefix.select{|data| card_number.to_s.start_with?(data[0].to_s)}.
end

