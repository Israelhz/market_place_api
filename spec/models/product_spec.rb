require 'rails_helper'

RSpec.describe Product, type: :model do
  let(:product) { create :product }
  subject { product }

  it { is_expected.to respond_to(:title) }
  it { is_expected.to respond_to(:price) }
  it { is_expected.to respond_to(:published) }
  it { is_expected.to respond_to(:user) }

  it { expect(product.published).to be false }

  it { is_expected.to validate_presence_of :title }
  it { is_expected.to validate_presence_of :price }
  it { is_expected.to validate_numericality_of(:price).is_greater_than_or_equal_to(0) }
  it { is_expected.to belong_to :user }
end