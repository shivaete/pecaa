class CouponsController < ApplicationController
  # GET /coupons
  # GET /coupons.json
  layout 'features'
  def index

    @coupons= Coupon.where('')
    if !params[:query].blank?
      @searchName	=	params[:query]
      @searchOn	=	params[:search_on]
      if params[:search_on] =="created_by"
        user_ids = User.where("username like ?", "%#{params[:query]}%").collect(&:id)
        @coupons= @coupons.where(" created_by in (?)", user_ids)
      else

        @coupons = @coupons.where("#{params[:search_on]} like ?", "%#{params[:query]}%")
      end
    end
    if !params[:date_added].blank?
      @coupons = @coupons.where(:created_at => (Date.strptime(params[:start_date],"%m-%d-%Y")..Date.strptime(params[:end_date],"%m-%d-%Y")))
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @coupons }
    end
  end

  # GET /coupons/1
  # GET /coupons/1.json
  def show
    @coupon = Coupon.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @coupon }
    end
  end

  # GET /coupons/new
  # GET /coupons/new.json
  def new
    @coupon = Coupon.new
    render :layout => false
  end

  # GET /coupons/1/edit
  def edit
    @coupon = Coupon.find(params[:id])
  end

  # POST /coupons
  # POST /coupons.json
  def create
    @coupon = Coupon.new(params[:coupon])
    @coupon.created_by = current_user.id
    respond_to do |format|
      if @coupon.save
        format.html { redirect_to "/sites/#{params[:site_id]}/coupons", notice: 'Coupon was successfully created.' }
        format.json { render json: @coupon, status: :created, location: @coupon }
      else
        format.html { render action: "new" }
        format.json { render json: @coupon.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /coupons/1
  # PUT /coupons/1.json
  def update
    @coupon = Coupon.find(params[:id])

    respond_to do |format|
      if @coupon.update_attributes(params[:coupon])
        format.html { redirect_to @coupon, notice: 'Coupon was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @coupon.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /coupons/1
  # DELETE /coupons/1.json
  def destroy
    @coupon = Coupon.find(params[:id])
    @coupon.destroy

    respond_to do |format|
      format.html { redirect_to coupons_url }
      format.json { head :ok }
    end
  end
  
  def approve
    @review = Coupon.find(params[:id])
    @review.status =!@review.status
    @review.save
    redirect_to "/sites/#{params[:site_id]}/coupons"
  end
end
