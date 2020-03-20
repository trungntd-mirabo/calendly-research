class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :validatable, :omniauthable,
    :omniauth_providers => [:google_oauth2]

  has_many :calendars
  has_one :zoom_connection

  class << self
    def from_omniauth access_token
      data = access_token.info
      user = User.where(:email => data["email"]).first
      unless user
        password = Devise.friendly_token[0,20]
        user = User.create(email: data["email"],
          password: password, password_confirmation: password
        )
      end
      user
    end
  end
end
