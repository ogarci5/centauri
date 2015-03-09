class ResourcesController < ApplicationController
  before_action :set_resource, only: [:show, :edit, :update, :destroy, :update_group]
  before_action :set_list, only: [:new, :create]
  skip_before_filter :verify_authenticity_token, only: :create
  skip_before_filter :authenticate_user!, only: :create

  respond_to :html, :json

  def index
    @resources = Resource.includes(:groups)

    if params[:groups].present?
      @resources = params[:controls].try(:include?, 'union') ? @resources.where(groups: {id: params[:groups]}) : @resources.with_groups(params[:groups])
    end

    @resources = @resources.for_type(params[:type])

    if params[:controls].try(:include?, 'shuffle')
      cookies[:seed] ||= SecureRandom.random_number.to_s[2..20].to_i
      @resources = @resources.order("RAND(#{cookies[:seed]})")
    else
      cookies.delete(:seed)
      @resources = @resources.order(updated_at: :desc)
    end

    @resources = @resources.where(groups: {id: nil}) if params[:controls].try(:include?, 'group_filter')
    size = params[:page_size] == 'all' ? @resources.count : params[:page_size].presence
    @resources = @resources.paginate(page: params[:page], per_page: size || 10)

    @groups = Group.filters
    @main_groups = Group.main
  end

  def show
    @main_groups = Group.where(main: true)
    respond_with(@resource)
  end

  def new
    @resource = Resource.new
    if request.xhr?
      render partial: 'directory', layout: false
    else
      render :new
    end
  end

  def edit
  end

  def create
    if resource_params[:url].present?
      @resource = Resource.new(resource_params)
      @resource.file = URI.parse(resource_params[:url])

    elsif resource_params[:local].present?

      if params[:directory] == 'true' || params[:directory] == true
        @group = Group.where(group_params.slice(:name)).first || Group.new(group_params)

        if @group.save
          run_through_directory(@group, resource_params[:local])

          redirect_to resources_path
        else
          render :new, flash: {error: 'The group could not be saved.'}
        end

        return
      else
        @resource = Resource.new

        File.open(resource_params[:local]) do |f|
          @resource.file = f
        end
      end
    else
      @resource = Resource.new(resource_params)
    end

    if @resource.save
      redirect_to @resource
    else
      render :new
    end
  end

  def update
    @resource.update(resource_params)
    respond_with(@resource)
  end

  def destroy
    @resource.destroy
    respond_with(@resource)
  end

  def update_group
    if params[:checked] == 'true'
      @resource.groups = Group.where(id: @resource.group_ids + [params[:group_id].to_i])
    else
      @resource.groups = Group.where(id: @resource.group_ids - [params[:group_id].to_i])
    end
    @resource.save

    render json: nil, status: :ok
  end

  private
    def set_resource
      @resource = Resource.find(params[:id])
    end

    def resource_params
      params.require(:resource).permit(:file, :name, :url, :local)
    end

    def group_params
      params.require(:group).permit(:name, :main)
    end

    def set_list
      cdir = params[:dir].presence || Dir.pwd
      dirs = []
      files = []

      begin
        FileUtils.cd(cdir) do
          @new_dir = FileUtils.pwd == '/' ? FileUtils.pwd : FileUtils.pwd+'/'
        end
      rescue Errno::ENOENT
        FileUtils.cd(Dir.pwd) do
          @new_dir = FileUtils.pwd == '/' ? FileUtils.pwd : FileUtils.pwd+'/'
        end
      end

      Dir.entries(@new_dir).delete_if{|d| d == '.'}.each do |dir|
        File.directory?(@new_dir+dir) ? dirs << dir : files << dir
      end

      dirs.sort!.collect! {|d| {name: d+'/', type: 'directory'}}
      files.sort!.collect! {|f| {name: f, type: 'file'}}
      @list = dirs + files
    end

    def run_through_directory(group, location)
      puts 'Current location: %s' % location
      p group
      p group.name

      Dir.entries(location).reject{|d| d == '.' || d == '..'}.each do |entry|
        next if entry.start_with?('.') # We do not want hidden files
        dir = location + entry

        if File.directory?(dir)
          child_group = Group.where(name: entry).first || Group.create(name: entry, group_id: group.id)

          run_through_directory(child_group, dir+'/')
        else
          @resource = group.resources.build(resource_params)

          File.open(dir) do |file|
            @resource.file = file
          end

          group.resources << @resource if @resource.save
        end

      end
    end
end
