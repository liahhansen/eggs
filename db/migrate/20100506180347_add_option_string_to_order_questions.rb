class AddOptionStringToOrderQuestions < ActiveRecord::Migration
  def self.up
    add_column :order_questions, :option_string, :string
  end

  def self.down
    remove_column :order_questions, :option_string
  end
end
