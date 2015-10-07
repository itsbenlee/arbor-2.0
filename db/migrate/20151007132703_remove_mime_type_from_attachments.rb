class RemoveMimeTypeFromAttachments < ActiveRecord::Migration
  def change
    remove_column :attachments, :mime_type
  end
end
