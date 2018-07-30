require 'rails_helper'

RSpec.describe User, type: :model do
   let(:user) { create :user }

  subject { user }

  it { is_expected.to respond_to :email }
  it { is_expected.to respond_to :password }
  it { is_expected.to respond_to :password_confirmation }
  it { is_expected.to respond_to :auth_token }

  it { is_expected.to validate_presence_of :email }
  it { is_expected.to validate_confirmation_of :password }
  it { is_expected.to allow_value('example@domain.com').for :email }
  it { is_expected.to validate_uniqueness_of :auth_token }
  it { is_expected.to have_many :products }

  it { is_expected.to be_valid }

  describe "#generate_authentication_token!" do
    it "generates a unique token" do
      user = create :user, auth_token: ''
      allow(Devise).to receive(:friendly_token).and_return("auniquetoken123")
      user.generate_authentication_token!
      expect(user.auth_token).to eql "auniquetoken123"
    end

    it "generates another token when one already has been taken" do
      existing_user = create :user, auth_token: "auniquetoken123"
      user.generate_authentication_token!
      expect(user.auth_token).not_to eql existing_user.auth_token
    end
  end

  describe "#products association" do

    before do
      3.times { create :product, user: user }
    end

    it "destroys the associated products on self destruct" do
      products = user.products
      user.destroy
      products.each do |product|
        expect(Product.find(product)).to raise_error ActiveRecord::RecordNotFound
      end
    end
  end
end
