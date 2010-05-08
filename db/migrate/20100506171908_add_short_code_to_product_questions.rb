class AddShortCodeToProductQuestions < ActiveRecord::Migration
  def self.up
    add_column :product_questions, :short_code, :string
    add_column :delivery_questions, :short_code, :string
  end

  def self.down
    remove_column :product_questions, :short_code
    remove_column :delivery_questions, :short_code
  end
end
