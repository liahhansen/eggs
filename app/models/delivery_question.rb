class DeliveryQuestion < ActiveRecord::Base
  belongs_to :delivery
  belongs_to :product_question

    def copy_product_question_attributes
    if(product_question)
      self.description        = product_question.description          if !self.description
      self.short_code         = product_question.short_code           if !self.short_code
      self.options            = product_question.options              if !self.options
    end
  end

end