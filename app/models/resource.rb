class Resource < ActiveRecord::Base
  has_and_belongs_to_many :groups

  attr_accessor :local

  has_attached_file :file
  do_not_validate_attachment_file_type :file
  validates :file_file_name, presence: true, uniqueness: true

  def self.for_type(type)
    case type
      when 'image'
        where('file_content_type LIKE ? AND file_content_type NOT LIKE ?', "#{type}%", '%gif%')
      when 'video'
        where('file_content_type LIKE ? OR file_content_type LIKE ?', "%#{type}%", '%octet-stream%')
      else
        where('file_content_type LIKE ?', "%#{type}%")
    end
  end

  def self.with_groups(ids)
    Resource.where(id: self.select{|r| r.group_ids.map(&:to_i) & ids.map(&:to_i) == ids.map(&:to_i)}.map(&:id)).includes(:groups)
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
