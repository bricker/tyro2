class TagsController < ApplicationController
  before_filter :get_management, :get_channel_descriptions
  
  def index
    @tags = Tag.limit(200)
  end

  def show
    @tag = Tag.find(params[:tag_name])
    rescue ActiveRecord::RecordNotFound
      redirect_to root_path
  end
end
