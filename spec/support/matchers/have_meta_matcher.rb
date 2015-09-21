RSpec::Matchers.define :have_meta do |name, expected|
  match do |actual|
    has_css?("meta[name='#{name}'][content='#{expected}']", visible: false)
  end

  failure_message do |actual|
    actual = page.find "meta[name='#{name}']", visible: false
    if actual
      "expected that meta #{name} would have content='#{expected}' but was '#{actual[:content]}'"
    else
      "expected that meta #{name} would exist with content='#{expected}'"
    end
  end
end
