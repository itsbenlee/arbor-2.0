FactoryGirl.define do
  factory :attachment do
    project   { create :project }
    user      { project.owner }

    factory :link_attachment, class: LinkAttachment do
      content   { 'http://archive.oreilly.com/security/2004/10/07/examples/signatures.txt' }
    end

    factory :file_attachment, class: FileAttachment do
      content   { File.open File.join(Rails.root, 'spec', 'support', 'files', 'txt.txt') }
    end
  end
end
