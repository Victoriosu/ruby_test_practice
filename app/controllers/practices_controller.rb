class PracticesController < ApplicationController
    before_action :set_layout

    def start
        @left_section_partial = 'test_selection'
        @right_section_partial = 'test_description_summary'
    end

    def fetch_tests
        ruby_webpage_html = HTTParty.get("https://github.com/ruby-association/prep-test/blob/version3/#{request_params[:test_type]}.md").response.body
        initial_question_index = ruby_webpage_html.html_safe.index('Q1')
        final_question_index = ruby_webpage_html.html_safe.index('Q50')
        sanitized_string = JSON.parse(%Q["#{ruby_webpage_html[initial_question_index..final_question_index]}"])
        questions_starting_indexes = sanitized_string.split("").map.with_index{|a,i| a == "Q" ? i : next}.compact
        @questions = []

        questions_starting_indexes.each_with_index do |current_index, i|
            next_questions_starting_index = questions_starting_indexes[i+1]
            @questions << Question.find_or_create_by(
                text: sanitized_string[current_index..(next_questions_starting_index ? (next_questions_starting_index-9) : -1)],
                test_type: request_params[:test_type],
                parse_date: Date.today
            )
        end
        
        @status = :ok
        
        question_text = @questions[0].text
        question_title = question_text[0..(question_text.index('Which option')-1)]
        question_body = question_text[(question_text.index('Which option'))..-1]
        @left_section_partial = question_title
        @right_section_partial = question_body

        render 'layouts/change_sections'
    end

private

    def set_layout
    end

    def request_params
        params.permit(:test_type)
    end
end
