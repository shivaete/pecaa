class SiteStylesController < ApplicationController
  before_filter :setup
   layout 'site'
  
  def index
    @style_type = params[:type] || 'background'
    @site_style = @site.site_style || SiteStyle.new
  end
  
  def create
    raise params.inspect
  end
  
  protected

  def setup
    @site = Site.find(params[:site_id] || params[:id])
  end
  
end
