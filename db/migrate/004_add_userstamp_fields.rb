class AddUserstampFields < ActiveRecord::Migration
  def self.up
    add_column :themes, :creator_id, :integer
    add_column :themes, :updater_id, :integer
    add_column :themes, :deleter_id, :integer
  end

  def self.down
    remove_column :themes, :updated_by
    remove_column :themes, :created_by
  end
end
