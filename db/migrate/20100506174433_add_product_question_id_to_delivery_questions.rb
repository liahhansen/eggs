class AddProductQuestionIdToDeliveryQuestions < ActiveRecord::Migration
  def self.up
    add_column :delivery_questions, :product_question_id, :integer
  end

  def self.down
    remove_column :delivery_questions, :product_question_id
  end
end
