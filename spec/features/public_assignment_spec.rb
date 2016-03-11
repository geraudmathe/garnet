require 'rails_helper'

RSpec.feature 'Submission Visibility' do
  before(:all) do
    load "#{Rails.root}/db/seeds/test_seed.rb"
  end

  let(:cohort1) { FactoryGirl.create(:cohort) }

  let(:test_instructor)  { User.create!(:username => 'TEST_INSTRUCTOR',  :password => 'password') }

  let(:john) { User.find_by(username: 'john') }

  let(:test_instructor_membership) { Membership.find_by(user: test_instructor, cohort: cohort1) }
  let(:john_membership) { Membership.find_by(user: john, cohort: cohort1) }

  let(:public_assignment) { cohort1.assignments.create(title: "Test Assignment", public: true, base_score: 10) }
  let(:private_assignment) { cohort1.assignments.create(title: "Test Assignment", public: false, base_score: 10) }

  let(:public_submission) { public_assignment.submissions.find_by(membership: john_membership) }
  let(:private_submission) { private_assignment.submissions.find_by(membership: john_membership) }

  before(:each) {
    cohort1.add_admin(test_instructor)
    cohort1.add_member(john)

    public_submission.score = 7
    private_submission.score = 8
  }

  scenario 'instructor can see scores for both public and private submissions' do
    login_user(test_instructor)
    visit(membership_path(john_membership))
    # expect(page).to have_content "Homework Submissions"

    puts '8' + '=' * 50 + 'D'
    # puts find_field("form[action='/submissions/#{public_submission.id}'] input.sm").value
    puts page.find_field("form[action='/submissions/#{public_submission.id}'] input.sm").value
    puts '8' + '=' * 50 + 'D'
  end

  # scenario 'when signed in' do
  #   login_user(test_instructor)
  #   expect(page).to have_content "You're signed in, #{test_instructor.username}"
  # end
  #
  # scenario 'viewing todos for events' do
  #   login_user(test_instructor)
  #   visit(root_path)
  #   expect(page).to have_content "Jane"
  #   expect(page).to have_content "Test Event"
  # end
  #
  # scenario 'viewing todos for assignments' do
  #   login_user(test_instructor)
  #   visit(root_path)
  #   expect(page).to have_content "Jane"
  #   expect(page).to have_content "Test Assignment"
  # end
  #
  # scenario 'inactive students are not shown on todos' do
  #   login_user(test_instructor)
  #   visit(root_path)
  #   expect(page).to_not have_content "John"
  # end
end
