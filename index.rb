puts "Enter the items seperated by coma"
item_list = gets.chomp.gsub(" ", '')
items = item_list.split(",")