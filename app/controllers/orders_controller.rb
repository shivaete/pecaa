class OrdersController < ApplicationController
  # GET /orders
  # GET /orders.json
  layout 'features'
  def index
    @orders = Order.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @orders }
    end
  end

  # GET /orders/1
  # GET /orders/1.json
  def show
    @order = Order.find(params[:id])
    render :layout => false
  end

  # GET /orders/new
  # GET /orders/new.json
  def new
    @order = Order.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @order }
    end
  end

  # GET /orders/1/edit
  def edit
    @order = Order.find(params[:id])
  end

  # POST /orders
  # POST /orders.json
  def create
    @order = Order.new(params[:order])

    respond_to do |format|
      if @order.save
        format.html { redirect_to @order, notice: 'Order was successfully created.' }
        format.json { render json: @order, status: :created, location: @order }
      else
        format.html { render action: "new" }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /orders/1
  # PUT /orders/1.json
  def update
    @order = Order.find(params[:id])

    @order.billing.billing_address.update_attributes(params[:billing_address])
    @order.shipping_detial.update_attributes(params[:shipping_detail])
    @order.shipping_detial.shipping_address.update_attributes(params[:shipping_address])
    respond_to do |format|
      if @order.update_attributes(params[:order])
        format.html { redirect_to "/sites/#{params[:site_id]}/orders/#{@order.id}/product_list", notice: 'Order was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1
  # DELETE /orders/1.json
  def destroy
    @order = Order.find(params[:id])
    @order.destroy

    respond_to do |format|
      format.html { redirect_to orders_url }
      format.json { head :ok }
    end
  end
  
  def product_list
    @order = Order.find(params[:id])
  end
  
  def notes_and_history
    @order = Order.find(params[:id])
  end
  
  def create_notes
    @order = Order.find(params[:id])
    @order_note = @order.order_notess.create(:description => params[:desc],:created_by => current_user.id)
    render :layout => false
  end
  
  
  def search
    search_on = ''
    q = {}
    and_flag = false
    
    if !params[:query].blank?
      if params[:search_on] == 'all'
        search_on += '(order_id LIKE :q or customer_email LIKE :q or grand_total LIKE :q)'
        q.merge!({:q=>"%#{params[:query]}%"});
      else
        search_on += params[:search_on]+' LIKE :q'
        q.merge!({:q=>"%#{params[:query]}%"});
      end
      and_flag = true
    end
    
    if params[:total] == 'on'
      search_on += (and_flag ? ' AND ': '') + 'grand_total >= :total_amount_from AND grand_total <= :total_amount_to'
      q.merge!({:total_amount_from=> params[:from_total] })
      q.merge!({:total_amount_to=> params[:to_total] })
      and_flag = true
    end
    
    if params[:date_created] == 'on'
      search_on += (and_flag ? ' AND ': '') + 'created_at >= :date_created_from AND created_at <= :date_created_to'
      q.merge!({:date_created_from=>Date.strptime(params[:date_created_from],'%Y-%m-%d')})
      q.merge!({:date_created_to=>Date.strptime(params[:date_created_to],'%Y-%m-%d')})
      and_flag = true
    end
    
     if params[:status] and !params[:status].blank?
      search_on += (and_flag ? ' AND ': '') + 'status = :status'
      q.merge!({:status=>params[:status]})
      and_flag = true
    end
    
    if !current_user.role?('SuperAdmin')
      search_on += (and_flag ? ' AND ': '') + 'site_id = :site_id'
      q.merge!({:site_id=>params[:site_id]})
    end
    
    
    @orders = Order.where("#{search_on} ", q)
    
    respond_to do |format|
      format.html {render :action => 'index'}
      format.json { render json: @order }
      format.js {}
    end
    
  end
  
end
