require 'spec_helper'

feature 'Canvas question change for each canvas step' do
  let!(:member)   { create :user }
  let!(:project)  { create :project, members: [member] }
  let!(:canvas)   { create :canvas, project: project }

  let(:questions) do
    {
      advantage: 'What about your solution can\'t be easily copied or bought.',
      alternative: 'How are users solving or overcoming these problems today, if at all?',
      channel: 'What are your main path(s) to customers?',
      cost_structure: 'What are your customer acquisition costs, distribution costs, people, hosting, integration partners, etc?',
      problems: 'What are the top three problems that you are trying to solve?',
      revenue_streams: 'What is your revenue model, gross margin, and proposed path to revenue?',
      segment: 'Who are your target customers?',
      solutions: 'What are the top three features that solve your identified pain points or problems?',
      value_proposition: 'Write a single, clear compelling message that states why you are different and worth taking notice of.'
    }
  end

  background do
    sign_in member
    visit arbor_reloaded_project_canvases_path(project)
  end

  Canvas::QUESTIONS.each do |question|
    context 'when a member enters project\'s canvas page' do
      scenario "it should see #{question} question's title on page" do
        within '#canvas' do
          expect(page).to have_text(I18n.t("#{question}"))
        end
      end

      scenario "it should see #{question} text on page" do
        within '#canvas' do
          question_text = canvas.public_send(question) || questions[question]
          expect(page).to have_text(question_text)
        end
      end
    end

    context "when a member edits #{question}" do
      before(:each) do
        within ".canvas-question-container[data-name=#{question}]" do
          find('.question').click
        end
      end

      scenario 'it should display edit textarea with save and cancel buttons' do
        within ".canvas-question-container[data-name=#{question}]" do
          expect(page).to have_selector('textarea', visible: true)
          expect(page).to have_selector('.cancel', visible: true)
          expect(page).to have_selector('.success', visible: true)
        end
      end

      scenario 'it should hide edit mode when cancel is clicked' do
        within ".canvas-question-container[data-name=#{question}]" do
          find('.cancel').click()

          expect(page).to have_selector('textarea', visible: false)
          expect(page).to have_selector('.cancel', visible: false)
          expect(page).to have_selector('.success', visible: false)
        end
      end

      context 'and saves' do
        before(:each) do
          @text = "#{I18n.t(question)} text"
          within ".canvas-question-container[data-name=#{question}]" do
            find('textarea').set(@text)
            find('.success').click()
          end
        end

        scenario 'it should be displayed on page' do
          within ".canvas-question-container[data-name=#{question}]" do
            expect(page).to have_text(@text)
          end
        end

        scenario 'it should be the default text of the textarea when editing' do
          within ".canvas-question-container[data-name=#{question}]" do
            expect(find('textarea')).to have_text(@text)
          end
        end

        scenario 'it should be persisted' do
          expect(canvas.reload.public_send(question)).to eq(@text)
        end
      end
    end
  end
end
