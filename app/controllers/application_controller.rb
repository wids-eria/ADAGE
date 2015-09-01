
class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :oauth_access_token,:store_location

  def store_location
    return unless request.get? 
    if (request.path != "/users/sign_in" &&
        request.path != "/users/sign_up" &&
        request.path != "/users/password/new" &&
        request.path != "/users/password/edit" &&
        request.path != "/users/confirmation" &&
        request.path != "/users/sign_out" &&
        !request.xhr?)
      session[:previous_url] = request.fullpath 
    end
  end

  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = exception.message
    redirect_to homepage_url
  end

  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path
  end

  def after_sign_in_path_for(resource_or_scope)
    if session[:previous_url].blank?
      if current_user.roles.where('name NOT IN (?)',["teacher","student","player"]).count == 0

        subdomain = request.subdomain(0)
        if subdomain == ""
          #No subdomain
          @org = current_user.organizations.first

          url =  homepage_url
          http = url.split("//")
          url = http[0]+"//"+@org.subdomain+"."+http[1]
        else
          homepage_path
        end
      else
        welcome_index_path
      end
    else
      session[:previous_url]
    end
  end

  def parse_filters(filters)

    @filters = Hash.new
    unless filters.nil?
      filters =  JSON.parse(filters)

      filters.keys.each do |key|
        type =  filters[key]['type']
        if type == "range"
          from = filters[key]['values'][0].to_i*1000
          to =  filters[key]['values'][1].to_i*1000

          @filters["timestamp"] = {
            "$gte"=> from.to_s,
            "$lte"=> to.to_s,
          }         

        elsif type == "equals"

          temp = Hash.new

          @filters[filters[key]["key"]] = temp
        elsif type == "select"
          @filters[filters[key]["key"]] = filters[key]["values"]
        end
      end
    end
    return @filters
  end

  def qrcode(text="",width=200,height=200)
    #helper to generate a qr code with adaptive resizing to compensate for data size
    size = 1
    qr = nil
    while qr.nil?
      begin
        #Try to generate the QR code for the given size
        qr = RQRCode::QRCode.new(text, :size => size, :level => :l )
      rescue RQRCode::QRCodeRunTimeError => e
        #increase the size of the qr code to fit the data size
        size += 1
      end

      #If the size is greater than 20 then raise and error, otherwise rqrcode will fail
      if size >=20
        raise "Text data for QR is too long!"
      end
    end

    #returns a friendly data url for the image
    return qr.to_img.resize(width,height).to_data_url
  end

  def time_range_to_epoch(time_range)
    since = time_range

    if since == nil
      since = 'all'
    end

    if time_range.include?("hour")
      since = (Time.now - 1.hour).to_i * 1000
    end

    if time_range.include?("day")
      since = (Time.now - 1.day).to_i * 1000
    end

    if time_range.include?("week")
      since = (Time.now - 1.week).to_i * 1000
    end

    if time_range.include?("month")
      since = (Time.now - 1.month).to_i * 1000
    end

    if time_range.include?("all")
      since = 0
    end

    return since.to_s

  end

  def time_range_to_bin(time_range)

    if time_range.include?("day")
      since = 1.day
    end

    if time_range.include?("week")
      since = 1.week
    end

    if time_range.include?("month")
      since = 1.month
    end

    if time_range.include?("hour")
      since = 1.hour
    end

    if time_range.include?("all")
      since = 1.year
    end

    #convert to milliseconds and return
    return since * 1000


  end

  def get_client_by_token token

    if token != nil
      client = Client.where(app_token: token).first
    end

    if client.nil?
      render :json => {:errors => ["Could not find application."] }, :status => 401
    end

    return client

  end


  #called recursively to collect all the graphable numeric field names
  def add_field_names depth, attributes, field_hash, filter_hash

    if field_hash[depth] == nil
      field_hash[depth] = Array.new
    end

    attributes.each do |key, value|

      if value.is_a? Hash
        if filter_hash[depth] != nil and filter_hash[depth].include?(key)
          field_hash = add_field_names(depth+1, value, field_hash, filter_hash)
        end
      end

      unless value.is_a? String
        field_hash[depth] << key
      end

    end

    return field_hash
  end

  def authenticate_app_token
    if params[:app_token]
      client = Client.where(app_token: params[:app_token]).first
      if client.nil?
        render :json => {:errors => ["Invalid Application Token"] }, status: :unauthorized
      end
    else
      render :json => {:errors => ["Invalid Application Token"] }, status: :unauthorized
    end
  end

  def breadcrumb(key,flush = false)
    url = request.original_url

    if flush
      session[:breadcrumb] = nil
    end

    if session[:breadcrumb].nil? or session[:breadcrumb].length == 0
      session[:breadcrumb] = [{key: key,url: url}]
    else
      found = false
      l = session[:breadcrumb].length
      for i in 0..l -1 do
        if session[:breadcrumb][i][:key] == key
          if i <= l - 1
            session[:breadcrumb].slice!(i+1,l) 
            found = true
            break
          end
        end
      end

      unless found
        session[:breadcrumb] << {key: key,url: url}
      end
    end
  end

  protected

  def oauth_access_token
    #check the header for use of an access token
    authorization = request.env["HTTP_AUTHORIZATION"]
    access_token = nil
    if authorization != nil
      token = authorization.split().last
      access_token = AccessToken.where(consumer_secret: token).first
    else
      #check for a param with the token
      authorization = params[:authorization_token]
      if authorization != nil
        access_token = AccessToken.where(consumer_secret: authorization).first
      end
    end

    if access_token != nil
      sign_in access_token.user
    end
  end
end
