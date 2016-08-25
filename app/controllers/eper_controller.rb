class EperController < ApplicationController
  require 'eper-su-rcrets-e-ocoderen'
  def create
    encoded = EperSuRcretsEOcoderen.new().encode(params[:item][:message][:message].gsub('/e ', ''))
    response = {
        message: encoded,
        notify: true,
        message_format: 'text',
        from: params[:item][:message][:from][:name]
    }
    render json: response
  end
end