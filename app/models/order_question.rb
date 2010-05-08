class OrderQuestion < ActiveRecord::Base
  belongs_to :delivery_question
  belongs_to :order
end