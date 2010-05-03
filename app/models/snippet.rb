class Snippet < ActiveRecord::Base
  belongs_to :farm

  def self.get_template(name, farm)
    snippet = self.find_by_identifier_and_farm_id(name, farm.id)
    Liquid::Template.parse(snippet.body)
  end

end
