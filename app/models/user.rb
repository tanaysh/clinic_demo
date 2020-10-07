class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  #Validations
  validates :name,:user_type, presence: true

  %w(Patient Doctor).each do |u_type|
    define_method "#{u_type.downcase}?" do
      self.type == u_type
    end
  end
end
