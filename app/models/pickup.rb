class Pickup < ActiveRecord::Base
  belongs_to :farm
  has_many :stock_items
  has_many :orders

  validates_presence_of :farm_id

  define_easy_dates do
    format_for :date, :format => "%A, %b%e, %Y", :as => "pretty_date"
    format_for :opening_at, :format => "%I:%M%p, %m/%d/%y" 
    format_for :closing_at, :format => "%I:%M%p, %m/%d/%y"
  end

  def estimated_total
    total = 0
    orders.each do |order|
      total += order.estimated_total
    end
    total
  end

  def map_link
    "http://mapof.it/#{location}"
  end

end
