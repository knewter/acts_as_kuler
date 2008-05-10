class Theme < ActiveRecord::Base
  has_many :colors
  acts_as_rateable :average => true

  validates_presence_of :creator_id
  validates_associated :creator

  stampable

  before_create :set_default_colors

  def set_default_colors
    unless self.colors.any?
      5.times do
        self.colors << Color.new(:hex => '000000')
      end
    end
  end

  def clone_colors_from copy_theme
    copy_theme.colors.each do |color|
      self.colors << color.clone
    end
  end
end
