class ReaddMimeTypeToAttachments < ActiveRecord::Migration
  def change
    add_column(
      :attachments,
      :mime_type,
      :string,
      null: false,
      index: true,
      default: 'other'
    )
  end
end
