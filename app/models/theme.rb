class Theme < ActiveRecord::Base
  has_many :colors
  before_create :set_default_colors

  def set_default_colors
    5.times do
      self.colors << Color.new(:hex => '000000')
    end
  end
end
