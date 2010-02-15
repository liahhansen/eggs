# == Schema Information
#
# Table name: members
#
#  id            :integer         not null, primary key
#  first_name    :string(255)
#  last_name     :string(255)
#  email_address :string(255)
#  phone_number  :string(255)
#  neighborhood  :string(255)
#  joined_on     :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#

require 'test_helper'

class MemberTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end
