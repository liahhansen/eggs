class AddNotesToEmailTemplates < ActiveRecord::Migration
  def self.up
    add_column :email_templates, :notes, :text
  end

  def self.down
    remove_column :email_templates, :notes
  end
end
