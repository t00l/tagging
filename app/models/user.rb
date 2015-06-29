class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  has_many :posts

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, 
         omniauth_providers: [:facebook, :linkedin]     
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

  def self.find_for_linkedin_oauth(auth, signed_in_resource=nil)      
    user = User.where(provider: auth.provider, uid: auth.uid).first       
    # The User was found in our database    
    return user if user    
    # Check if the User is already registered without Facebook      
    user = User.where(email: auth.info.nickname).first 
    return user if user
    create! do |user|
      user.name = auth.info.name
      user.uid = auth.uid
      user.provider = auth.provider
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]

      #name: auth.info.name,
      #provider: auth.provider, uid: auth.uid,
      #email: auth.info.nickname,
      #password: Devise.friendly_token[0,20],  
      #photo: auth.info.image)
    end
  end

end
