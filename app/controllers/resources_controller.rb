class ResourcesController < ApplicationController
  before_action :set_resource, only: [:show, :edit, :update, :destroy]
  skip_before_filter :verify_authenticity_token, :only=> :create
  skip_before_filter :authenticate_user!, :only=> :create

  respond_to :html, :json

  def index
    @resources = Resource.all
    if params[:types] && params[:types][:shuffle] == 'true'
      @resources = @resources.paginate(page: params[:page], per_page: 10).shuffle
    else
      @resources = @resources.paginate(page: params[:page], per_page: 10)
    end
    @resources = @resources.where
    #@cenfiles = @cenfiles.partition {|c| !c.groups.empty?}.flatten if params[:types] && params[:types][:group_filter] == "true"
    @groups = Group.all
    @main_groups = Group.where(main: true)
  end

  def show
    respond_with(@resource)
  end

  def new
    @resource = Resource.new
    cdir = Dir.pwd
    cdir = params[:dir] if params[:dir]
    dirs = []
    files = []
    FileUtils.cd(cdir) do
      @new_dir = FileUtils.pwd+'/'
    end

    Dir.entries(@new_dir).delete_if {|d| d == '.'}.each do |dir|
      File.directory?(@new_dir+dir) ? dirs << dir : files << dir
    end

    dirs.sort!.collect! {|d| {name: d+'/', type: 'directory'}}
    files.sort!.collect! {|f| {name: f, type: 'file'}}
    @list = dirs + files
    if request.xhr?
      render partial: 'directory', layout: false
    else
      render 'new'
    end
  end

  def edit
  end

  def create
    cdir = Dir.pwd
    cdir = params[:dir] if params[:dir]
    dirs = []
    files = []
    FileUtils.cd(cdir) do
      @new_dir = FileUtils.pwd+'/'
    end

    Dir.entries(@new_dir).delete_if {|d| d == '.'}.each do |dir|
      File.directory?(@new_dir+dir) ? dirs << dir : files << dir
    end

    dirs.sort!.collect! {|d| {name: d+'/', type: 'directory'}}
    files.sort!.collect! {|f| {name: f, type: 'file'}}
    @list = dirs + files
    if resource_params[:url].present?
      prev = Dir.entries('./')
      `wget #{resource_params[:url]}`
      path = (Dir.entries('./') - prev)[0]
      @resource = Resource.new
      File.open(path) do |f|
	      @resource.file = f
      end
    elsif resource_params[:location2].present?
      @resource = Resource.new
      File.open(resource_params[:location2]) do |f|
        @resource.file = f
      end
    else
      @resource = Resource.new(resource_params)
    end

    if @resource.save
      redirect_to action: :index
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

  private
    def set_resource
      @resource = Resource.find(params[:id])
    end

    def resource_params
      params.require(:resource).permit(:file, :name, :url, :location2)
    end
end
