class GiftCertificatesController < ApplicationController
  # GET /gift_certificates
  # GET /gift_certificates.json
  layout 'features'
  def index

    @gift_certificates= GiftCertificate.where('')

    if !params[:query].blank?
      @searchName	=	params[:query]
      @searchOn	=	params[:search_on]

      if params[:search_on] == "assigned_to"
        user_ids = User.where("username like ?", "%#{params[:query]}%").collect(&:id)
        @gift_certificates= @gift_certificates.where("assigned_to in (?)", user_ids)
      else
        @gift_certificates= @gift_certificates.where("#{params[:search_on]} like ?", "%#{params[:query]}%")
      end
    end
    if params[:search]
      min,max = params[:search][:amount].split(' ')

      @gift_certificates = @gift_certificates.where(:value => (min..max)) if min or max

      mindt,maxdt = params[:search][:created_at].split(' ')
      @gift_certificates = @gift_certificates.where(:created_at => (Date.strptime(mindt,"%m/%d/%Y")..Date.strptime(maxdt,"%m/%d/%Y"))) if mindt or maxdt
      minexdt,maxexdt = params[:search][:expired_date].split(' ')
      @gift_certificates = @gift_certificates.where(:expired_date => (Date.strptime(minexdt,"%m/%d/%Y")..Date.strptime(maxexdt,"%m/%d/%Y")))    if minexdt or maxexdt
    end
    if !params[:date_added].blank?
      @gift_certificates = @gift_certificates.where(:created_at => (Date.strptime(params[:start_date],"%m-%d-%Y")..Date.strptime(params[:end_date],"%m-%d-%Y")))
    end
    #@gift_certificates = GiftCertificate.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @gift_certificates }
    end
  end

  # GET /gift_certificates/1
  # GET /gift_certificates/1.json
  def show
    @gift_certificate = GiftCertificate.find(params[:id])
    @gift_certificate.destroy
    redirect_to "/sites/#{params[:site_id]}/gift_certificates"
  end

  # GET /gift_certificates/new
  # GET /gift_certificates/new.json
  def new
    @gift_certificate = GiftCertificate.new
    render :layout => false
  end

  # GET /gift_certificates/1/edit
  def edit
    @gift_certificate = GiftCertificate.find(params[:id])
  end

  # POST /gift_certificates
  # POST /gift_certificates.json
  def create
    @gift_certificate = GiftCertificate.new(params[:gift_certificate])
    @gift_certificate.assigned_to = User.find_by_username(params[:gift_certificate][:assigned_to]).id rescue nil

    respond_to do |format|
      if @gift_certificate.save
         format.html { redirect_to "/sites/#{params[:site_id]}/gift_certificates" }
      else
        format.html { render action: "new" }
        format.json { render json: @gift_certificate.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /gift_certificates/1
  # PUT /gift_certificates/1.json
  def update
    @gift_certificate = GiftCertificate.find(params[:id])

    respond_to do |format|
      if @gift_certificate.update_attributes(params[:gift_certificate])
        format.html { redirect_to @gift_certificate, notice: 'Gift certificate was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @gift_certificate.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /gift_certificates/1
  # DELETE /gift_certificates/1.json
  def destroy
    @gift_certificate = GiftCertificate.find(params[:id])
    @gift_certificate.destroy

    respond_to do |format|
      format.html { redirect_to gift_certificates_url }
      format.json { head :ok }
    end
  end
  
    def approve
    @review = GiftCertificate.find(params[:id])
    @review.status =!@review.status
    @review.save
    redirect_to "/sites/#{params[:site_id]}/gift_certificates"
  end
end
