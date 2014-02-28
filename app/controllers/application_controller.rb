
class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :oauth_access_token

  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = exception.message
    redirect_to profile_url
  end

  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path
  end

  def qrcode(text="",width=128,height=128)
    #helper to generate a qr code with adaptive resizing to compensate for data size
    size = 2
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
