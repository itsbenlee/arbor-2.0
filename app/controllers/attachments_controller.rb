class AttachmentsController < ApplicationController
  ATTACHMENT_TYPES = [LinkAttachment, FileAttachment]
  before_action :set_project

  def index
    @project = Project.find(params[:project_id])
    @attachment = Attachment.new(project: @project)
  end

  def create
    assign_values
    if @attachment.valid? && @attachment.save
      redirect_to project_attachments_path @project
    else
      render :index
    end
  end

  private

  def assign_values
    @attachment = attachment_type.new attachment_params
    @attachment.project = @project
    @attachment.user = current_user
    service = attachment_type_service.new @attachment
    service.set_metadata if @attachment.type == 'link'
  end

  def attachment_type
    type = attachment_params[:table_type].constantize
    type if type.in? ATTACHMENT_TYPES
  end

  def attachment_type_service
    "#{attachment_type}Services".constantize if attachment_type
  end

  private

  def attachment_params
    params.require(:attachment).permit(:content, :table_type)
  end

  def set_project
    @project =
      @attachment.try(:project) ||
      Project.includes(:attachments).find(params[:project_id])
  end
end
