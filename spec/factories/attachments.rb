FactoryGirl.define do
  factory :attachment do
    project   { create :project }
    user      { project.owner }
    content   { 'https://trello.com' }
    mime_type { 'other' }

    factory :link_attachment, class: LinkAttachment do
      factory :plain_link_attachment do
        content   { 'http://archive.oreilly.com/security/2004/10/07/examples/signatures.txt' }
        mime_type { 'plain' }
      end

      factory :html_link_attachment do
        content   { 'https://trello.com' }
        mime_type { 'html' }
      end

      factory :pdf_link_attachment do
        content   { 'http://www.pdf995.com/samples/pdf.pdf' }
        mime_type { 'pdf' }
      end

      factory :image_link_attachment do
        content   { 'https://upload.wikimedia.org/wikipedia/commons/c/c4/PM5544_with_non-PAL_signals.png' }
        mime_type { 'image' }
      end
    end
  end
end
