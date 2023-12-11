require "rails_helper"

RSpec.describe User, type: :model do
  describe "relationships" do
    it { should have_many(:party_users) }
    it { should have_many(:viewing_parties).through(:party_users) }
  end

  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:password) }
    it { should validate_presence_of(:password_confirmation) }
  end

  before :each do
    @user1 = create :user
    @user2 = create :user
  end

  describe "instance methods" do
    describe "#friends" do
      it "returns all other users in database" do
        expect(@user1.friends).to eq [@user2]
        expect(@user2.friends).to eq [@user1]
      end
    end

    describe "#formatted" do
      it "formats the name and email" do
        expect(@user1.formatted).to eq "#{@user1.name} (#{@user1.email})"
      end
    end
  end
end
