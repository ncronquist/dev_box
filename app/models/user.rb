class User < ActiveRecord::Base
  has_many :tvotes
  has_many :reviews
  has_and_belongs_to_many :tools
end
