class AddNameToEmailTemplates < ActiveRecord::Migration
  def self.up
    add_column :email_templates, :name, :string
  end

  def self.down
    remove_column :email_templates, :name
  end
end
