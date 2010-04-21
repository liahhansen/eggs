class AddFarmIdToEmailTemplates < ActiveRecord::Migration
  def self.up
    add_column :email_templates, :farm_id, :integer
  end

  def self.down
    remove_column :email_templates, :farm_id
  end
end
