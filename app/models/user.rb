class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:facebook, :google_oauth2]

  has_one :sns_credential, dependent: :destroy
  has_many :address,dependent: :destroy
  has_one :house,dependent: :destroy
  accepts_nested_attributes_for :house
  



  validates :nickname, :first_name, :last_name, :first_name_kana, :last_name_kana, :phone_number, :birth_year, :birth_month, :birth_day, presence: true


  def self.find_for_oauth(auth)
    sns = SnsCredential.where(uid: auth.uid, provider: auth.provider).first
    unless sns
      @user = User.create(
      email:    auth.info.email,
      password: Devise.friendly_token[0,20]
      )
      sns = SnsCredential.create(
      user_id: @user.id,
      uid: auth.uid,
      provider: auth.provider
      )
　  end
    sns
    @user
  end

end