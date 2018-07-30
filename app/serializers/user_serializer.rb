class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :created_at, :updated_at, :auth_token, :product_ids
  
  def products_ids
    object.products.pluck(:id)
  end
end
