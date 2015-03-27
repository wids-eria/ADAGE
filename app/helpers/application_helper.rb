module ApplicationHelper

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
end
