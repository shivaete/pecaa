pdf.text "Order ##{@order.id}", :size => 30, :style => :bold

 total_cost = 0
        @order.products.each do |product|
        total_cost = total_cost + product.cost.to_i
        end
        billing = @order.billing
items = [["placed :", @order.created_at.strftime("%D")],
         ["Status",@order.status],
         ["paid status :", @order.pay_status],
         ["ship status :", @order.ship_status],
         ["customer :", @order.customer_email],
         ["shipping :", "#{number_to_currency(@order.shipping_detial.cost)}"],
         ["total :", "#{number_to_currency(total_cost)}"],
         ["payment",billing.created_at.strftime('%D')],
         ["Master Card :",billing.card_number],
         ["shipping :","UPS 3day select"]]
pdf.move_down(30)

# items = @order.cart.line_items.map do |item|
#   [
#     item.product.name,
#     item.quantity,
#     number_to_currency(item.unit_price),
#     number_to_currency(item.full_price)
#   ]
# end
# 
 pdf.table items

pdf.move_down(10)

pdf.text "Total Price: #{number_to_currency(total_cost)}", :size => 16, :style => :bold