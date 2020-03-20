class Calendar < ApplicationRecord
  belongs_to :user

  PERMITTED_PARAMS = [:user_id, :access_token, :refresh_token,
    :expires_in, :scope, :token_type, :email]
end
