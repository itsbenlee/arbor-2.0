module ArborReloaded
  class AttachmentsController < ApplicationController
    layout 'application_reload'
    ATTACHMENT_TYPES = [LinkAttachment, FileAttachment]
    before_action :set_project, only: [:index, :create, :destroy]
    before_action :load_attachment, only: [:destroy]

    def index
      @attachment = Attachment.new(project: @project)
    end

    def create
      assign_values
      if @attachment.save?
        send("set_#{@attachment.type}_flash_message")
        redirect_to project_attachments_path @project
      else
        render :index
      end
    end

    def destroy
      @project.attachments.destroy(@attachment)
      redirect_to project_attachments_path @project
    end

    private

    def assign_values
      @attachment = attachment_type.new(attachment_params)
      @attachment.project = @project
      @attachment.user = current_user
      service = attachment_type_service.new @attachment
      service.set_metadata
    end

    def attachment_type
      type = attachment_params[:table_type].constantize
      type if type.in? ATTACHMENT_TYPES
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

    def set_link_flash_message
      flash[:success] = I18n.t('attachment.link.success')
    end

    def set_file_flash_message
      filename = @attachment.content.file.filename
      flash[:success] = I18n.t('attachment.file.success', filename: filename)
    end

    def attachment_type_service
      "#{attachment_type}Services".constantize if attachment_type
    end

    def load_attachment
      @attachment = Attachment.find(params['id'])
    end
  end
end
