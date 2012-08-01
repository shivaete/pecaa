class ProductsController < ApplicationController
  
  before_filter :ensure_site_id
  before_filter :ensure_product_id, :except => [:index, :new, :search, :create, :featured_products]
  # edit, :update,:add_image,:images_list, :videos_list, :related_products
  
  def index
    @products = Product.all
  end
  
  def new
    @product = @site.products.create(:name =>"new product")
  end
  
  def edit
    render :action => :new
  end
  
  def create
    @product = Product.new(params[:product])
    if @product.save
      redirect_to site_products_url(@site)
    else
      render :action => "new"
    end
  end
  
  def update
    if @product.update_attributes(params[:product])
      if (params[:featured])
        redirect_to featured_products_site_products_path(@site)
      else
        if request.xhr?
          render :nothing=> true
        else
          redirect_to request.referrer
        end
      end
    end
  end
  
  def delete
    @product.destroy
    redirect_to site_products_path(@site)
  end
  
  def featured_products
    @featured_products = Product.find(:all, :conditions=>["is_featured = ?", true])
  end
  
  def search
    @products = Product.find(:all, :conditions=>["name like ?", "%#{params[:query]}%"])
    render :partial => "search"
  end
  
  def images_list
    @product_images = @product.product_images
  end
  
  def search_category
    @product_categories = ProductCategory.find(:all, :conditions=>["name like ?", "%#{params[:query]}%"])
    render :partial => "search_categories"
  end
  
  def add_category
    unless category = @product.categories.find_by_product_id_and_product_category_id(@product.id, params[:product_category_id])
      Category.create(:product_category_id => params[:product_category_id], :product_id => @product.id)
    end
    render :partial => "associated_categories"
  end
  
  def remove_category
    if category = @product.categories.find_by_product_id_and_product_category_id(@product.id, params[:product_category_id])
      category.destroy
    end
    render :partial => "associated_categories"
  end
  
  def search_vendors
    @product_vendors = ProductVendor.find(:all, :conditions=>["name like ?", "%#{params[:query]}%"])
    render :partial => "search_vendors"
  end
  
  def add_vendor
    unless vendor = @product.vendors.find_by_product_id_and_product_vendor_id(@product.id, params[:product_vendor_id])
      Vendor.create(:product_vendor_id => params[:product_vendor_id], :product_id => @product.id)
    end
    render :partial => "associated_vendors"
  end
  
  def remove_vendor
    if vendor = @product.vendors.find_by_product_id_and_product_vendor_id(@product.id, params[:product_vendor_id])
      vendor.destroy
    end
    render :partial => "associated_vendors"
  end
  
  def videos_list
    @product_videos = @product.product_videos
  end
  
  
  def related_products
    if !params[:related_product_id].blank?
      related_product = @product.related_products.find(params[:related_product_id])
      related_product.destroy
    elsif !params[:link_product_id].blank?
      related_product = @product.related_products.find_or_initialize_by_product_id_and_related_product_id(@product.id, params[:link_product_id])
      related_product.save!
    end
    @related_products = @product.related_products
  end
    
  def product_options
    if !params[:link_option].blank? && product_option = ProductOption.find_by_id(params[:link_option])
      new_product_option = product_option.dup
      new_product_option.product_id = @product.id
      new_product_option.save
    end
    @product_options = @product.product_options 
    # @all_product_options = ProductOption.find(:all, :conditions =>['product_id != ? OR product_id = ?', @product.id, nil], :limit=>10, :select=>"name, id")
    @all_product_options = ProductOption.all
  end
  
  def update_intentory
    if !params[:inventory_id].blank?
      @product_inventory = @product.inventories.find(params[:inventory_id])
      @product_inventory.update_attributes(params[:product_inventory])
    else !params[:all].blank?
      @product_inventory = @product.inventories.update_all(params[:product_inventory])
    end
    product_inventory_options
  end
  
  def product_inventory
    product_inventory_options
  end
  
  def create_inventory
    ["XS", "S", "M", "XL", "L", "XXL", "XXS"].each do |i|
      Inventory.create({:product_id => @product.id, :size => i, :sub_sku => "1234QWER",
      :inventory => rand(70), :trigger => rand(6), :track_inventory => false, :allow_negative_inventory => false,
      :material => ["cotton", "polyster", "terra cotta"][rand(2)]
      })
    end if @product.inventories == []
    product_inventory_options
  end
  
  def add_image
    @product_image = ProductImage.new(:product_id => @product.id)
  end
  
  def try_it_on
    @tryitimage = TryItImage.find_by_id(params[:try_image_id]) || TryItImage.first
    @tryitimages = TryItImage.all
  end
    
  private
  
  def product_inventory_options
    @product_inventories = @product.inventories 
    @tracked_inventories = @product.inventories.where(:track_inventory => true).count == @product.inventories.count
    @negative_inventories = @product.inventories.where(:allow_negative_inventory => true).count ==  @product.inventories.count
    
    render :template => '/products/product_inventory'
  end
  
  def ensure_product_id
    unless @product = Product.find_by_id(params[:id])
      render :nothing => true, :status=> 404
    end  
  end

end
