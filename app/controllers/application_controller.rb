class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_mate, :signed_in?, :is_admin?,
      :signed_out?, :current_mate_is_mate?
  
  def signed_in?
    current_mate
  end
  
  def current_mate_is_mate?
    current_mate == @mate
  end
  
  def require_sign_in
    unless signed_in?
      redirect_to sign_in_path
      return false
    end
    
    true
  end
  
  def api_call(url)
    body = access_token.get(url).body
    logger.debug "response:\n#{body}"
    Nokogiri::XML(body)
  end
  
  def current_mate
    @current_mate ||= session[:mate_id] && Mate.find_by_id(session[:mate_id])
  end
  
  GOODREADS_CONSUMER = 
    OAuth::Consumer.new(key = "BGlVP1E1V4fhpPb6N2ezLA",
      secret = "rEe509o0fs4xrsSoS8nYnIZU8gN0ldfgwnH95jds",
      {:site => "http://www.goodreads.com"})
  
  
  def access_token
    @access_token ||= OAuth::AccessToken.new(GOODREADS_CONSUMER,
        session[:oauth_token],
        session[:oauth_token_secret])
  end
  
  
  
  %w(Mate).each do |klass_name|
    klass = klass_name.constantize
    define_method "load_#{klass_name.underscore}" do
      item = klass.find_by_id(params[:id])
      unless item
        respond_to do |format|
          format.html do
            flash[:error] = "#{klass_name.humanize} not found."
            redirect_to "/"
          end
          format.js do
            render :status => 404, :text => "not found"
          end
        end
        return false
      end
      instance_variable_set "@" + klass_name.underscore, item
    end
  end
  
end
