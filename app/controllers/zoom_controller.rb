class ZoomController < ApplicationController
  BASE_URI = "https://api.zoom.us/v2"
  def redirect
    client = Signet::OAuth2::Client.new(client_options)
    redirect_to client.authorization_uri(approval_prompt: :force).to_s
  end

  def callback
    client = Signet::OAuth2::Client.new(client_options)
    client.code = params[:code]
    response = client.fetch_access_token!
    zoom_connection = current_user.build_zoom_connection response.select{|key, value| ZoomConnection::PERMITTED_PARAMS.include? key.to_sym}
    zoom_response = RestClient::Request.execute method: :get,
      url: "#{BASE_URI}/users/me",
      headers: {Authorization: "#{zoom_connection.token_type} #{zoom_connection.access_token}"}
    zoom_info = JSON.parse(zoom_response).deep_symbolize_keys
    zoom_connection.email = zoom_info[:email]
    zoom_connection.zoom_id = zoom_info[:id]
    zoom_connection.save
    redirect_to root_path
  end

  private
  def client_options
    {
      client_id: Settings.omniauth.zoom.api_key,
      client_secret: Settings.omniauth.zoom.api_secret,
      authorization_uri: "https://zoom.us/oauth/authorize",
      token_credential_uri: "https://zoom.us/oauth/token ",
      response_type: :code,
      redirect_uri: connect_zoom_callback_url,
      grant_type: :refresh_token
    }
  end
end
