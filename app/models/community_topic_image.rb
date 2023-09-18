class CommunityTopicImage < ApplicationRecord
  belongs_to :community_topic

  acts_as_paranoid

  attr_accessor :image_topic

  before_validation :set_image

  has_attached_file :image, styles: { medium: "300x300", thumb: "100x100" }
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/
  do_not_validate_attachment_file_type :image

  def set_image
    if self.image_topic.present?
      Paperclip::DataUriAdapter.register
      Paperclip.io_adapters.for(self.image_topic) do |data|
        data.class.class_eval { attr_accessor :original_filename, :content_type }
        data.original_filename = "comunity_topic_#{self.title}.jpg"
        data.content_type = "image/jpeg"
        self.image_topic = data
      end
      self.image = self.image_topic
    end
  end

  def self.set_image
    if self.image_topic.present?
      Paperclip::DataUriAdapter.register
      Paperclip.io_adapters.for(self.image_topic) do |data|
        data.class.class_eval { attr_accessor :original_filename, :content_type }
        data.original_filename = "comunity_topic_#{self.title}.jpg"
        data.content_type = "image/jpeg"
        self.image_topic = data
      end
      self.image = self.image_topic
    end
  end
end
