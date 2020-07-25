require_relative "store"


class Order < Store
  def get_order_list(items)
    array_item_qty = items.map do |item|
      qty = items.count(item)
      {item => qty}
    end 
    array_item_qty.uniq
  end
end



puts "Enter the items seperated by coma"
item_list = gets.chomp.gsub(" ", '')
items = item_list.split(",")
order = Order.new
order_list = order.get_order_list(items)
order.check
