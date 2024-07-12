require 'rails_helper'

RSpec.describe UploadsController, type: :controller do
  describe "POST #create" do
    context "with valid CSV file" do
      let(:valid_csv) { fixture_file_upload(Rails.root.join('spec', 'fixtures', 'files', 'valid_users.csv'), 'text/csv') }

      it "processes the CSV file and counts success and error results" do
        post :create, params: { file: valid_csv }

        expect(response).to have_http_status(:success)
        expect(assigns(:success_count)).to eq(1)
        expect(assigns(:error_count)).to eq(3)

        expect(assigns(:results).length).to eq(4)

        success_results = assigns(:results).select { |result| result[:status].start_with?("Success") }
        expect(success_results.length).to eq(1)

        error_results = assigns(:results).select { |result| result[:status].start_with?("Error") }
        expect(error_results.length).to eq(3)
      end
    end

    context "with invalid CSV file" do
      let(:invalid_csv) { fixture_file_upload(Rails.root.join('spec', 'fixtures', 'files', 'invalid_users.txt'), 'text/csv') }

      it "shows error message and redirects to root path" do
        post :create, params: { file: invalid_csv }
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq("Please upload a valid CSV file.")
      end
    end

    context "with malformed CSV file" do
      let(:malformed_csv) { fixture_file_upload(Rails.root.join('spec', 'fixtures', 'files', 'malformed_users.csv'), 'text/csv') }

      it "shows error message for malformed CSV and renders index page" do
        # Stub CSV.foreach to raise CSV::MalformedCSVError
        allow(CSV).to receive(:foreach).and_raise(CSV::MalformedCSVError)

        post :create, params: { file: malformed_csv }

        error_results = assigns(:results).select { |result| result[:status].start_with?("Error") }
        expect(error_results.length).to eq(1)
        expect(assigns(:results)[0][:status]).to eq("Error: Encoding issue - wrong number of arguments (given 0, expected 2)")
      end
    end
  end
end
