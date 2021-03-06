class ApplicationController < ActionController::Base

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.

  # Rails CSRF Protection + Angular.js
  # http://stackoverflow.com/questions/14734243/rails-csrf-protection-angular-js-protect-from-forgery-makes-me-to-log-out-on

  protect_from_forgery with: :exception

  before_action :current_user

  after_filter :set_csrf_cookie_for_ng

  def is_authenticated?
    unless current_user
      flash[:danger] = "Please sign up or log in"
      redirect_to root_path
    end
  end

  def current_user
    @current_user ||= User.find_by_id(session[:user_id])
  end

  def set_csrf_cookie_for_ng
    cookies['XSRF-TOKEN'] = form_authenticity_token if protect_against_forgery?
  end

  protected

  # In Rails 4.2 and above
  def verified_request?
    super || valid_authenticity_token?(session, request.headers['X-XSRF-TOKEN'])
  end

  def get_popular_tags
    Tag.find_by_sql("SELECT    tt.tag_id, t.tag, count(tt.tag_id)
                      FROM    tags_tools tt,
                          tags t
                      WHERE    tt.tag_id = t.id
                      GROUP BY tt.tag_id, t.tag
                      ORDER BY count(tag_id) desc
                      LIMIT 10")
  end

end
