class Subscription < ActiveRecord::Base
  belongs_to :farm
  belongs_to :user
end
