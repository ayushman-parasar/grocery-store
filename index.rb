require_relative "store"
require 'terminal-table/import'

class Order < Store
  attr_reader :total_cost_of_purchase, :total_savings_in_purchase,:not_available_items

  def get_order_list(items)
    array_item_qty = items.map do |item|
      qty = items.count(item)
      {item => qty}
    end 
    array_item_qty.uniq
  end

  def calculate(order_list)
    order_list.each do |hsh|
      hsh.each do |key, val|
        if MENU[key.to_sym] && SALE_MENU[key.to_sym]
          unit_price_of_item = MENU[key.to_sym]
          sale_qty_for_item = SALE_MENU[key.to_sym][:qty]
          sale_price_for_item = SALE_MENU[key.to_sym][:price]
          
          if val.to_f >= SALE_MENU[key.to_sym][:qty]
            if val.to_f == SALE_MENU[key.to_sym][:qty]
              total_price_array << {key => sale_price_for_item}
              without_discount_price = val * unit_price_of_item
              saving_price << {key => (without_discount_price - sale_price_for_item).round(2)} 
            else
                n = (val / sale_qty_for_item).to_i
                qty_used = n * sale_qty_for_item
                price = ((val- qty_used)*unit_price_of_item) + (n *sale_price_for_item)
                @total_price_array << {key => price}
                without_discount_price = val * unit_price_of_item
                @saving_price << {key => (without_discount_price - price).round(2)}
    
            end
          end
         
        elsif MENU[key.to_sym]
          unit_price_of_item = MENU[key.to_sym]
          
          price = val * unit_price_of_item
          @total_price_array << {key => price}
        else
          
          @not_available_items << key
        end
        # p @total_price_array, 'final total price array'
        # p @saving_price, "final saving price"
        # p @total_price_array,"total_price_array in calculate"
        price_values_array = @total_price_array.map{|item| item.inject(0){|sum, (key,val)| sum+=val}}
        saving_array = @saving_price.map{|item| item.inject(0){|sum, (key,val)| sum+=val}}
        @total_cost_of_purchase = price_values_array.inject(0){|sum,item| sum+=item}
        @total_savings_in_purchase = saving_array.inject(0){|sum,item| sum+=item}
        # p "finalization #{@total_cost_of_purchase} and #{@total_savings_in_purchase}"
      end
      
      
      
    end
    show_items(@total_price_array, order_list)
    
  end

  def show_items(array_with_prices, array_with_quantity)
    result = []
    # p array_with_prices, "array in show_items and quantites are",array_with_quantity
    array_with_prices.each do |item_price|
      item_price.each do |item_name, item_cost|
        array_with_quantity.each do |item_quantity|
          item_quantity.each do |itm_name, itm_qty|
            if item_name == itm_name
              result << [(item_name[0].upcase+item_name[1..-1]), itm_qty, "#{item_cost}"]
            end
          end
        end
      end
    end
    p result, "result"
    puts Terminal::Table.new(
      rows: result,
      headings: ["Item", "Quantity", "Price"]
      
    )
  end
end



puts "Enter the items seperated by coma"
item_list = gets.chomp.gsub(" ", '')
items = item_list.split(",")
order = Order.new
order_list = order.get_order_list(items)
# p "order list", order_list
order.calculate(order_list)
if !order.not_available_items.empty?
  puts "Total price: $#{order.total_cost_of_purchase} excluding #{order.not_available_items.join(",")} as these are not available"
else 
  puts "Total price: $#{order.total_cost_of_purchase}"
end
puts "You saved $#{order.total_savings_in_purchase} today"