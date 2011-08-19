class MatesController < ApplicationController
  before_filter :require_sign_in
  before_filter :load_mate, :only => [:show, :edit, :update]
  before_filter :require_self, :only => [:edit, :update]
  
  def index
    if current_mate.looking_for_gender?
      @mates = Mate.where(:gender => current_mate.looking_for_gender).paginate(:page => params[:page])
    else
      flash[:notice] = "Please tell us what gender you are looking for first!"
      redirect_to edit_mate_path(current_mate)
    end
  end
  
  def show
    data = api_call("/user/show/#{@mate.goodreads_id}.xml")
    iter = Mate.where(:gender => current_mate.looking_for_gender)
    @next = iter.where("id > ?", @mate.id).first
    @previous = iter.where("id < ?", @mate.id).first
  end
  
  
  def refresh
    data = api_call("/user/show/#{current_mate.goodreads_id}.xml")
    user_node = data.css("user").first
    
    current_mate.location = user_node.css("location").first.content
    current_mate.hobbies = user_node.css("interests").first.content
    current_mate.name = user_node.css("name").first.content
    current_mate.profile_photo_url = user_node.css("image_url").first.content
    current_mate.thumbnail_url = user_node.css("small_image_url").first.content
    current_mate.books_count = user_node.css("reviews_count").first.content
    current_mate.gender = user_node.css("gender").first.content[0, 1].upcase
    current_mate.save!
    redirect_to edit_mate_path(current_mate)
  end
  
  
  def edit
    
  end
  
  def update
    if @mate.update_attributes params[:mate]
      redirect_to @mate
      return
    end
    render :action => 'edit'
  end
  
  
  private
  
  def require_self
    unless current_mate_is_mate?
      flash[:notice] = "not self"
      redirect_to "/"
      return true
    end
    
    false
  end
  
end
