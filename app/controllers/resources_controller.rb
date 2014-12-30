class ResourcesController < ApplicationController
  before_action :set_resource, only: [:show, :edit, :update, :destroy]
  skip_before_filter :verify_authenticity_token, :only=> :create
  skip_before_filter :authenticate_user!, :only=> :create

  respond_to :html, :json

  def index
    @resources = Resource.all
    @resources.randomize if params[:types] && params[:types][:shuffle] == "true"
    #@cenfiles = @cenfiles.partition {|c| !c.groups.empty?}.flatten if params[:types] && params[:types][:group_filter] == "true"
    @groups = Group.all
    @main_groups = Group.where(main: true)
  end

  def show
    respond_with(@resource)
  end

  def new
    @resource = Resource.new
    respond_with(@resource)
  end

  def edit
  end

  def create
    if resource_params[:url].present?
      prev = Dir.entries('./')
      `wget #{resource_params[:url]}`
      path = (Dir.entries('./') - prev)[0]
      @resource = Resource.new
      File.open(path) do |f|
	@resource.file = f
        @resource.save
      end
    else
      @resource = Resource.new(resource_params)
    end
    @resource.save
    respond_with(@resource)
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
      params.require(:resource).permit(:file, :name, :url)
    end
end
