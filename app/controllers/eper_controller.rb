class EperController < ApplicationController
  def create
    encoded = EperSuRcretsEOcoderen.new().encode(params[:item][:message].gsub('/e ', ''))
    response = {
        message: encoded,
        notify: true,
        message_format: 'text'
    }
    render response
  end
end