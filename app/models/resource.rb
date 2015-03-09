class Resource < ActiveRecord::Base
  has_many :groups_resources
  has_many :groups, through: :groups_resources
  has_many :filters, -> { where(filter: true) }, through: :groups_resources, source: :group

  attr_accessor :local

  has_attached_file :file
  do_not_validate_attachment_file_type :file
  validates :file_file_name, presence: true, uniqueness: true

  def self.for_type(type)
    return self.current_scope if type.blank?
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
    ids = ids.map(&:to_i)
    Resource.where(id: self.select{|r| (r.group_ids || []) & ids == ids}.map(&:id)).includes(:groups)
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

  def filter
    filters.first
  end
end
