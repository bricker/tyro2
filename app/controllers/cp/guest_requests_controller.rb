class Cp::GuestRequestsController < Cp::BaseController
  def new
    @shows = @current_user.shows.active
  end
  
  def create
  end
end