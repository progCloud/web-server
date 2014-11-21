class Folder < ActiveRecord::Base
  belongs_to :user
  has_many :assets, dependent: :destroy
end
