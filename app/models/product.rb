# == Schema Information
#
# Table name: products
#
#  id          :integer(4)      not null, primary key
#  name        :string(255)
#  description :text
#  price       :float
#  estimated   :boolean(1)
#  farm_id     :integer(4)
#  created_at  :datetime
#  updated_at  :datetime
#  price_code  :string(255)
#

class Product < ActiveRecord::Base
  belongs_to :farm
  has_many :stock_items

  validates_associated :farm
  validates_presence_of :name
end
