class AuthController < ApplicationController
  def sign_in
    if signed_in?
      redirect_to "/"
      return
    end
    
    request_token = GOODREADS_CONSUMER.get_request_token
    session[:request_token] = request_token
    auth_url = request_token.authorize_url +
      "&oauth_callback=#{CGI.escape sign_in_callback_url}"
    #TODO Add the callback url!
    redirect_to auth_url
  end
  
  def sign_in_callback
    if signed_in?
      redirect_to "/"
      return
    end
    request_token = session[:request_token]
    if !request_token
      render :text => "request token not found"
      return
    end
    
    begin
      @access_token = request_token.get_access_token 
    rescue OAuth::Unauthorized => e
      redirect_to sign_in_url
      return
    end
    
    session[:oauth_token] = access_token.params[:oauth_token]
    session[:oauth_token_secret] = access_token.params[:oauth_token_secret]
    #TODO create the user account, or log them in!
    data = api_call("/api/auth_user")
    user_node = data.css("user").first
    goodreads_id = user_node[:id]
    mate = Mate.find_or_initialize_by_goodreads_id(goodreads_id)
    if mate.new_record?
      mate.name = user_node.css("name").first.content
      mate.save!
      created = true
    end
    session[:mate_id] = mate.id
    session[:request_token] = nil
    
    if created
      redirect_to refresh_mate_path
    else
      flash[:notice] = "signed in"
      redirect_to "/"
    end
  end
  
  def sign_out
    session[:mate_id] = nil
    session[:oauth_token] = nil
    session[:oauth_token_secret] = nil
    redirect_to "/"
  end
end
