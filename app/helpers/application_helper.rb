module ApplicationHelper
  def meta_title
    ENV['META_TITLE'] || 'Arbor'
  end

  def meta_description
    ENV['META_DESCRIPTION'] || 'Add meta description'
  end
end
