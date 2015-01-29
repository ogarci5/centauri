class Resource < ActiveRecord::Base
  has_and_belongs_to_many :groups

  attr_accessor :local

  has_attached_file :file
  do_not_validate_attachment_file_type :file
  validates :file_file_name, presence: true, uniqueness: true

  def self.for_type(type)
    return where('file_content_type LIKE ?', "%#{type}%") unless type.to_s == 'video'
    where('file_content_type LIKE ? OR file_content_type LIKE ?', "%#{type}%", '%octet-stream%')
  end

  def type
    types = self.file_content_type.split('/')
    self.file_content_type == 'application/octet-stream' ? types.last : types.first
  end

  def location
    self.file.url
  end

  def file_from_url(url)
    self.file = URI.parse(url)
  end
end
