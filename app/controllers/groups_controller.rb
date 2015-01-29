class GroupsController < ApplicationController
  before_action :set_group, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @groups = Group.all
    respond_with(@groups)
  end

  def show
    respond_with(@group)
  end

  def new
    @group = Group.new
    respond_with(@group)
  end

  def edit
  end

  def create
    @group = Group.new(group_params)
    @group.save
    redirect_to groups_path
  end

  def update
    @group.update(group_params)
    redirect_to groups_path
  end

  def destroy
    @group.destroy
    respond_with(@group)
  end

  def toggle
    if cookies[:toggle_groups].nil?
      cookies[:toggle_groups] = true
    else
      cookies[:toggle_groups] = cookies[:toggle_groups] == 'true' ? false : true
    end

    render json: nil, status: :ok
  end

  private
    def set_group
      @group = Group.find(params[:id])
    end

    def group_params
      params.require(:group).permit(:name, :main)
    end
end
