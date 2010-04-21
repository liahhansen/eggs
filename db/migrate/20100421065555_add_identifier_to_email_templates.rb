class AddIdentifierToEmailTemplates < ActiveRecord::Migration
  def self.up
    add_column :email_templates, :identifier, :string
  end

  def self.down
    remove_column :email_templates, :identifier
  end
end
