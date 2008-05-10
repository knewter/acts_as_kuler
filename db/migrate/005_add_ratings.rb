class AddRatings < ActiveRecord::Migration
  def self.up
    create_table :ratings do |t|
      t.integer :rating, :default => 0 # You can add a default value here if you wish
      t.integer :rateable_id, :null => false
      t.string  :rateable_type, :null => false
      t.integer :user_id, :integer
    end
    add_index :ratings, [:rateable_id, :rating]    # Not required, but should help more than it hurts
  end

  def self.down
    remove_index :ratings, :column => [:rateable_id, :rating] # Not required, but should help more than it hurts
    drop_table :ratings
  end
end
