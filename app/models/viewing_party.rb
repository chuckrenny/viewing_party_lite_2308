# frozen_string_literal: true

class ViewingParty < ApplicationRecord
  validates :host_id, :duration, :day, :time, :movie_id, presence: true

  belongs_to :movie
  has_many :party_users
  has_many :users, through: :party_users

  def guests
    party_users.select do |user|
      user.hosting? == false
    end
  end
end
