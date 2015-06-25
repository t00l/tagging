class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  has_many :posts

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, 
         omniauth_providers: [:facebook, :linkedink]     
  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)      
  user = User.where(provider: auth.provider, uid: auth.uid).first       
  # The User was found in our database    
  return user if user    
  # Check if the User is already registered without Facebook      
  user = User.where(email: auth.info.email).first 
  return user if user
  User.create(
    name: auth.extra.raw_info.name,
    provider: auth.provider, uid: auth.uid,
    email: auth.info.email,
    password: Devise.friendly_token[0,20])  
  end

  class << self
  def from_omniauth(auth_hash)
    user = find_or_create_by(uid: auth_hash['uid'], provider: auth_hash['provider'])
    user.name = auth_hash['info']['name']
    user.location = get_social_location_for user.provider, auth_hash['info']['location']
    user.image_url = auth_hash['info']['image']
    user.url = get_social_url_for user.provider, auth_hash['info']['urls']
    user.save!
    user
  end
 
  private
 
  def get_social_location_for(provider, location_hash)
    case provider
      when 'linkedin'
        location_hash['name']
      else
        location_hash
    end
  end
 
  def get_social_url_for(provider, urls_hash)
    case provider
      when 'linkedin'
        urls_hash['public_profile']
      else
        urls_hash[provider.capitalize]
    end
  end
end

end
