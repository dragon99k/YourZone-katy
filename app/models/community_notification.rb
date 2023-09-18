class CommunityNotification < ApplicationRecord
  belongs_to :community
  belongs_to :user
  belongs_to :favorite

  enum status: { not_seen: 0, seen: 1 }
  enum notification_type: { join_to_event: 0, another_one_join_event: 1 }
  delegate :name, to: :community, prefix: true

  scope :not_seen, -> { where(status: self.statuses[:not_seen]) }
  scope :seen, -> { where(status: self.statuses[:seen]) }
  scope :join_to_event, -> { where(notification_type: self.notification_types[:join_to_event]) }
  scope :another_one_join_event, -> { where(notification_type: self.notification_types[:another_one_join_event]) }
end
