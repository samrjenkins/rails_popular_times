class SpotsController < ApplicationController
  def show
    @days = Scraper.run(params[:query])
    if @days[:current]
      @current = @days.delete(:current)
    end
  end
end
