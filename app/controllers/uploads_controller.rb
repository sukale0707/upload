class UploadsController < ApplicationController
  require 'csv'
  require 'iconv'

  def index
  end

  def create
    uploaded_file = params[:file]

    if uploaded_file.present? && File.extname(uploaded_file.path) == ".csv"
      results = process_csv_file(uploaded_file)
      @success_count = results.count { |result| result[:status].start_with?("Success") }
      @error_count = results.count { |result| result[:status].start_with?("Error") }
      @results = results
    else
      flash[:alert] = "Please upload a valid CSV file."
      redirect_to root_path
    end
  end

  private

  def process_csv_file(file)
    results = []
    begin
      CSV.foreach(file.path, headers: true, encoding: "UTF-8") do |row|
        name = row["name"]
        password = row["password"]

        if name.present? && password.present?
          user = User.new(name: name, password: password)

          if user.valid?
            user.save
            results << { name: name, status: "Success: User created successfully." }
          else
            results << { name: name, status: "Error: #{user.errors.full_messages.join(', ')}" }
          end
        else
          results << { name: name, status: "Error: Name or password missing." }
        end
      end
    rescue CSV::MalformedCSVError => e
      results << { name: "N/A", status: "Error: Malformed CSV - #{e.message}" }
    rescue ArgumentError => e
      results << { name: "N/A", status: "Error: Encoding issue - #{e.message}" }
    end

    results
  end
end
