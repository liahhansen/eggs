# == Schema Information
#
# Table name: products
#
#  id          :integer         not null, primary key
#  name        :string(255)
#  description :text
#  price       :float
#  estimated   :boolean
#  farm_id     :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class Product < ActiveRecord::Base
  belongs_to :farm
  has_many :stock_items

  validates_associated :farm
  validates_presence_of :name
end
