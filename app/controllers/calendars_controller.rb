class CalendarsController < ApplicationController
  require "google/apis/calendar_v3"
  require "google/apis/oauth2_v2"
  def redirect
    client = Signet::OAuth2::Client.new(client_options)
    redirect_to client.authorization_uri(approval_prompt: :force).to_s
  end

  def callback
    client = Signet::OAuth2::Client.new(client_options)
    client.code = params[:code]
    response = client.fetch_access_token!
    google_account = Google::Apis::Oauth2V2::Oauth2Service.new
    google_account.authorization = client
    calendar = current_user.calendars.build response.select{|key, value| Calendar::PERMITTED_PARAMS.include? key.to_sym}
    calendar.email = google_account.get_userinfo_v2.email
    calendar.save
    client.update! calendar.as_json(except: [:id, :user_id, :email])
    service = Google::Apis::CalendarV3::CalendarService.new
    service.authorization = client
    p service.list_events(:primary)
    redirect_to root_path
  end

  private
  def client_options
    {
      client_id: Settings.omniauth.google.api_key,
      client_secret: Settings.omniauth.google.api_secret,
      authorization_uri: "https://accounts.google.com/o/oauth2/auth",
      token_credential_uri: "https://accounts.google.com/o/oauth2/token",
      scope: "#{Google::Apis::CalendarV3::AUTH_CALENDAR} email",
      redirect_uri: connect_calendar_callback_url,
      grant_type: :refresh_token
    }
  end
end
