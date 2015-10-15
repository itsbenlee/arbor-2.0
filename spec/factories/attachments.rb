FactoryGirl.define do
  factory :attachment do
    project   { create :project }
    user      { project.owner }
    mime_type { 'other' }

    factory :link_attachment, class: LinkAttachment do
      content   { 'https://trello.com' }
      mime_type { 'other' }

      factory :image_link_attachment do
        content   { 'https://upload.wikimedia.org/wikipedia/commons/c/c4/PM5544_with_non-PAL_signals.png' }
        mime_type { 'image' }
      end
    end

    factory :file_attachment, class: FileAttachment do
      content   { File.open File.join(Rails.root, 'spec', 'support', 'files', 'txt.txt') }
      mime_type { 'other' }

      factory :image_file_attachment do
        content   { File.open File.join(Rails.root, 'spec', 'support', 'files', 'image.png') }
        mime_type { 'image' }
      end
    end
  end
end
