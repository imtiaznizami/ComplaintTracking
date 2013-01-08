class SiteImportsController < ApplicationController
  def new
    @site_import = SiteImport.new
  end

  def create
    @site_import = SiteImport.new(params[:site_import])
    if @site_import.save
      redirect_to root_url, notice: "Imported sites successfully."
    else
      render :new
    end
  end
end
