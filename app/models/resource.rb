class Resource < ActiveRecord::Base
  has_and_belongs_to_many :groups

  attr_accessor :local

  has_attached_file :file
  do_not_validate_attachment_file_type :file
  validates :file_file_name, presence: true, uniqueness: true

  def self.all_with_params(params)
    resources = self.all
    return resources if params.empty?
    groups = params[:groups].map{|k,v| k if v == 'true'}
    resources.includes(:groups).where(groups: {name: groups}) if params[:groups]
    return resources.partition {|c| c.type == "image" }[0] if params[:types] && params[:types][:image] == "true"
    return resources.partition {|c| c.type == "gif" }[0] if params[:types] && params[:types][:gif] == "true"
    resources
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
