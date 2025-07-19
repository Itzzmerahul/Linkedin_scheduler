class Post < ApplicationRecord
  belongs_to :user

  VALID_STATUSES = ['draft', 'scheduled', 'published', 'failed'].freeze
  validates :status, inclusion: { in: VALID_STATUSES }
end