class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_one :ideal, dependent: :destroy
  after_create :create_ideal

  private

  def after_create
    Ideal.create(user: self)
  end
end
