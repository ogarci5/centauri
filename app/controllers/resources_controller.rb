class ResourcesController < ApplicationController
  before_action :set_resource, only: [:show, :edit, :update, :destroy]

  respond_to :html

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
    @resource = Resource.new(resource_params)
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
      params.require(:resource).permit(:file, :name)
    end
end
