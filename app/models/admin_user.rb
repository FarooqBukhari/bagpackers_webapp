class AdminUser < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, 
         :recoverable, :rememberable, :validatable
  validates :email, presence: true
  validates :encrypted_password, presence: true
  validates :reset_password_token, uniqueness: true
end
