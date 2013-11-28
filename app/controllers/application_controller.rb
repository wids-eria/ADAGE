
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
