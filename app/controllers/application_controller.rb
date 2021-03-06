class ApplicationController < ActionController::Base

	after_filter :set_access_control_headers
  before_filter :authenticate

  #
  # permit javascript to execute out of origin
  # 
  def set_access_control_headers
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Request-Method'] = '*'
  end

  #
  # renders an error object with the following format
  # {
  #   error:'<name of the error>',
  #   message:'a descriptive message showing the nature of the error'
  # }
  #
  def render_error(e)

    json = {:error=>e.class.to_s, :message=>e.message}.to_json
    respond_to do |format|
      format.json { render json: json }
    end

  end

  def render_message(message)
    json = {:message=>message}.to_json
    respond_to do |format|
      format.json {render json: json}
    end
  end

  def render_as_json(object)
    respond_to do |format|
      format.json { render json: object }
    end
  end

  protected

  def authenticate
    authenticate_or_request_with_http_basic do |username, password|
      username == ENV["ADMIN_USERNAME"] && password == ENV["ADMIN_PASSWORD"]
    end
  end

end
