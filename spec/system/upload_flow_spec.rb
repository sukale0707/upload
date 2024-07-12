require 'rails_helper'

RSpec.describe "Upload CSV Flow", type: :system do
  it "uploads a valid CSV file and displays results" do
    visit root_path

    attach_file "file", Rails.root.join('spec', 'fixtures', 'files', 'valid_users.csv')
    click_button "Upload"

    expect(page).to have_content("Successful uploads: 1")
    expect(page).to have_content("Failed uploads: 3")
    expect(page).to have_content("Name")
    expect(page).to have_content("Status")
    expect(page).to have_content("Muhammad")
    expect(page).to have_content("Success")
  end

  it "shows error message for invalid CSV file" do
    visit root_path

    attach_file "file", Rails.root.join('spec', 'fixtures', 'files', 'invalid_users.txt')
    click_button "Upload"

    expect(page).to have_content("Please upload a valid CSV file.")
    expect(current_path).to eq(root_path)
  end
end
