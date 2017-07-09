class Score < ActiveRecord::Base
  has_many :cart_entries
end