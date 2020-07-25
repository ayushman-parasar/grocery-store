require_relative "store"


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
        p @total_price_array, 'final total price array'
        p @saving_price, "final saving price"
        p @total_price_array,"total_price_array in calculate"
        price_values_array = @total_price_array.map{|item| item.inject(0){|sum, (key,val)| sum+=val}}
        saving_array = @saving_price.map{|item| item.inject(0){|sum, (key,val)| sum+=val}}
        @total_cost_of_purchase = price_values_array.inject(0){|sum,item| sum+=item}
        @total_savings_in_purchase = saving_array.inject(0){|sum,item| sum+=item}
        p "finalization #{@total_cost_of_purchase} and #{@total_savings_in_purchase}"
      end
      total_sum = 0
      
      
    end
    
    p "total price is $#{@total_cost_of_purchase} and savings is $#{@total_savings_in_purchase}"
  end
end



puts "Enter the items seperated by coma"
item_list = gets.chomp.gsub(" ", '')
items = item_list.split(",")
order = Order.new
order_list = order.get_order_list(items)
# p "order list", order_list
order.calculate(order_list)