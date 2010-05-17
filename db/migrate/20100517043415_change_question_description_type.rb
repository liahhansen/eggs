class ChangeQuestionDescriptionType < ActiveRecord::Migration
  def self.up
    change_column :product_questions, :description, :text
    change_column :delivery_questions, :description, :text
  end

  def self.down
    change_column :product_questions, :description, :string
    change_column :delivery_questions, :description, :string
  end
end
