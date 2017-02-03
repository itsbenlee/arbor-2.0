require 'spec_helper'

describe Google::SheetsV4::Formatter do
  let(:service) { Google::SheetsV4::Formatter.new }

  let(:color_advanced) { { red: 0.956, green: 0.8, blue: 0.8 } }
  let(:color_deliver) { { red: 0.576, green: 0.768, blue: 0.490 } }
  let(:color_header) { { red: 0.85, green: 0.85, blue: 0.85 } }
  let(:color_plan) { { red: 1, green: 0.949, blue: 0.8 } }
  let(:color_progress) { { red: 0.788, green: 0.854, blue: 0.972 } }
  let(:color_default) { { red: 0.0, green: 0.0, blue: 0.0 } }
  let(:format_t) { 'userEnteredFormat.textFormat' }
  let(:format_at) { 'userEnteredFormat(horizontalAlignment,textFormat)' }
  let(:format_bt) { 'userEnteredFormat(borders,textFormat)' }
  let(:format_ct) { 'userEnteredFormat(backgroundColor,textFormat)' }
  let(:format_cat) { 'userEnteredFormat(backgroundColor,horizontalAlignment,textFormat)' }

  let(:repeat_range) { [0, 1, 2] }
  let(:result) { {} }
  let(:format) { result[:repeat_cell][:cell][:user_entered_format] }
  let(:text_format) { format[:text_format] }
  let(:background_color) { format[:background_color] }
  let(:fields) { result[:repeat_cell][:fields] }
  let(:result_repeat_range) { result[:repeat_cell][:range] }

  feature '#title' do
    let(:result) { service.title(repeat_range) }

    scenario { expect(result_repeat_range).to eq(repeat_range) }
    scenario { expect(fields).to eq(format_t) }
    scenario { expect(text_format[:bold]).to be true }
  end

  feature '#header' do
    let(:result) { service.header(repeat_range) }

    scenario { expect(result_repeat_range).to eq(repeat_range) }
    scenario { expect(fields).to eq(format_ct) }
    scenario { expect(text_format[:bold]).to be true }
    scenario { expect(format[:background_color]).to eq(color_header) }
  end

  feature '#description' do
    let(:result) { service.description(repeat_range) }

    scenario { expect(result_repeat_range).to eq(repeat_range) }
    scenario { expect(fields).to eq(format_t) }
    scenario { expect(text_format).to eq(italic: true, font_size: 8) }
  end

  feature '#group_name' do
    let(:result) { service.group_name(repeat_range) }

    scenario { expect(result_repeat_range).to eq(repeat_range) }
    scenario { expect(fields).to eq(format_ct) }
    scenario { expect(text_format[:bold]).to be true }
    scenario { expect(format[:background_color]).to eq(color_header) }
  end

  feature '#estimation_column' do
    let(:result) { service.estimation_column(repeat_range) }

    scenario { expect(result_repeat_range).to eq(repeat_range) }
    scenario { expect(fields).to eq(format_bt) }
    scenario { expect(text_format[:bold]).to be true }

    scenario 'has borders' do
      expect(format[:borders][:right]).to eq(style: 'SOLID',
                                              color: color_default)
    end
  end

  feature '#delivered_cell' do
    let(:result) { service.delivered_cell(repeat_range) }

    scenario { expect(result_repeat_range).to eq(repeat_range) }
    scenario { expect(fields).to eq(format_at) }
    scenario 'applies correct format' do
      expect(text_format).to eq(foreground_color: color_deliver,
                                font_family: 'Verdana',
                                font_size: 11,
                                bold: true)
    end
  end

  feature '#in_progess_cell' do
    let(:result) { service.in_progress_cell(repeat_range) }

    scenario { expect(result_repeat_range).to eq(repeat_range) }
    scenario { expect(fields).to eq(format_cat) }
    scenario { expect(text_format[:bold]).to be true }
    scenario { expect(format[:horizontal_alignment]).to eq('CENTER') }
    scenario { expect(format[:background_color]).to eq(color_progress) }
  end

  feature '#planned_cell' do
    let(:result) { service.planned_cell(repeat_range) }

    scenario { expect(result_repeat_range).to eq(repeat_range) }
    scenario { expect(fields).to eq(format_cat) }
    scenario { expect(text_format[:bold]).to be true }
    scenario { expect(format[:horizontal_alignment]).to eq('CENTER') }
    scenario { expect(format[:background_color]).to eq(color_plan) }
  end

  feature '#advanced_cell' do
    let(:result) { service.advanced_cell(repeat_range) }

    scenario { expect(result_repeat_range).to eq(repeat_range) }
    scenario { expect(fields).to eq(format_cat) }
    scenario { expect(text_format[:bold]).to be true }
    scenario { expect(format[:horizontal_alignment]).to eq('CENTER') }
    scenario { expect(format[:background_color]).to eq(color_advanced) }
  end
end
