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

  describe "#build_placements_with_product_ids_and_quantities" do
    before(:each) do
      product_1 = create :product, price: 100, quantity: 5
      product_2 = create :product, price: 85, quantity: 10

      @product_ids_and_quantities = [[product_1.id, 2], [product_2.id, 3]]
    end

    it "builds 2 placements for the order" do
      expect{order.build_placements_with_product_ids_and_quantities(@product_ids_and_quantities)}.to change{order.placements.size}.from(0).to(2)
    end
  end

  describe "#valid?" do
    before do
      product_1 = create :product, price: 100, quantity: 5
      product_2 = create :product, price: 85, quantity: 10


      placement_1 = build :placement, product: product_1, quantity: 3
      placement_2 = build :placement, product: product_2, quantity: 15

      @order = build :order

      @order.placements << placement_1
      @order.placements << placement_2
    end

    it "becomes invalid due to insufficient products" do
      expect(@order).to_not be_valid
    end
  end
end
