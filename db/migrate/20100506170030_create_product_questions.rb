class CreateProductQuestions < ActiveRecord::Migration
  def self.up
    create_table :product_questions do |t|
      t.integer   :farm_id
      t.string    :description
      t.text      :options

      t.timestamps
    end

    create_table :delivery_questions do |t|
      t.integer   :delivery_id
      t.string    :description
      t.text      :options
      t.boolean   :visible
    end

    create_table :order_questions do |t|
      t.integer   :order_id
      t.integer   :delivery_question_id
      t.string    :option_code
    end
  end

  def self.down
    drop_table :product_questions
    drop_table :delivery_questions
    drop_table :order_questions
  end
end
