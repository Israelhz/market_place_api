require 'rails_helper'

RSpec.describe Order, type: :model do
  let(:order) { create :order }
  subject { order }

  it { is_expected.to respond_to(:total) }
  it { is_expected.to respond_to(:user_id) }

  it { is_expected.to validate_presence_of :user_id }

  it { is_expected.to belong_to :user }

  it { is_expected.to have_many(:placements) }
  it { is_expected.to have_many(:products).through(:placements) }

  describe '#set_total!' do
    before(:each) do
      product_1 = create :product, price: 100
      product_2 = create :product, price: 85

      @order = build :order, product_ids: [product_1.id, product_2.id]
    end

    it "returns the total amount to pay for the products" do
      expect{@order.set_total!}.to change{@order.total}.from(0).to(185)
    end
  end
end
