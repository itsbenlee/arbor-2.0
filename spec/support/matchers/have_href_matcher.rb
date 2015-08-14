RSpec::Matchers.define :have_href do |href|
  match do |actual|
    has_css? "a[href='#{href}']"
  end

  failure_message do
    "Not able to find link with href #{href}"
  end
end
