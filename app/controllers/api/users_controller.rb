class Api::UsersController < ApplicationController
  protect_from_forgery except: %i[create signin signout]
  before_action :downcase_public_address
  skip_before_action :authenticate, only: %i[create signin signout]

  def index
    return head(:bad_request) unless params[:public_address]

    @user = User.find_by(public_address: params[:public_address])
    render json: @user
  end

  def create
    @user = User.create!(
      public_address: params[:public_address],
      nonce: rand(1_000_000_000_000_000..9_999_999_999_999_999)
    )

    render json: @user
  end

  def signin
    return head(:bad_request) unless params[:public_address] || params[:signature]

    @user = User.find_by!(public_address: params[:public_address])
    msg = "[MetaMask Demo]\none-time nonce: #{@user.nonce}"
    bin_msg = msg.unpack1('B*')
    msg_buf_hex = '0x%02x' % bin_msg.to_i(2)
    address = babel.recoverPersonalSignature({
      data: msg_buf_hex,
      sig: params[:signature]
    })
    return head(:unauthorized) unless params[:public_address] == address

    @user.update!(nonce: rand(1_000_000_000_000_000..9_999_999_999_999_999))
    payload = { id: @user.id, public_address: @user.public_address }
    token = JWT.encode(payload, HMAC_SECRET, 'HS256')
    session[:token] = token

    head(:ok)
  end

  def signout
    session.clear
    redirect_to root_path
  end

  private

  def downcase_public_address
    return unless params[:public_address]

    params[:public_address] = params[:public_address].downcase
  end
end
