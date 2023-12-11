# frozen_string_literal: true

class User < ApplicationRecord
  validates :name, presence: true
  validates :email, presence: true, uniqueness: {case_sensitive: false}
  validates_presence_of :password

  has_secure_password

  has_many :party_users
  has_many :viewing_parties, through: :party_users

  # @return all OTHER users in the database
  def friends
    User.where.not(id: id)
  end

  # @return formatted string of name and email
  def formatted
    "#{name} (#{email})"
  end
end
