class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, 
    :rememberable, :validatable, :confirmable, :omniauthable, 
    omniauth_providers: %i[twitter]
  
  has_one_attached :profile_image
  
  has_many :projects
  has_many :comments 
  has_many :donations

  def self.from_omniauth(auth)
    # first_or_create will try and find the instance where the provider and uid match, 
    # else it will create a new instance.
    image = open(auth.info.image)
    where(:provider => auth.provider, :uid => auth.uid).first_or_create do |user|
      user.first_name = auth.info.name.split(" ")[0]
      user.last_name = auth.info.name.split(" ")[1]
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.profile_image.attach(
        io: image, 
        filename: "#{user.first_name}_#{user.last_name}_image.jpg", 
        content_type: image.content_type
      )
      # If you are using confirmable and the provider(s) you use validate emails, 
      # uncomment the line below to skip the confirmation emails.
      user.skip_confirmation!
    end
  end

  def display_name
    "#{self.first_name} #{self.last_name}"
  end
end
