require 'csv'

class IdentifiersController < ApplicationController
  include Sidekiq::Worker
  sidekiq_options retry: false

  def index
    @identifiers = Identifier.where(user: current_user)
  end

  def new
  end

  def create
    begin
      file_path = params[:file]&.tempfile&.path
      raise 'Please select the file to proceed further.' unless file_path.present?
      row_count = CSV.foreach(file_path, headers: true).count
      raise 'Atleast one row should be exist in the CSV.' if row_count < 1
      identifier = Identifier.find_or_create_by!(name: params[:name].presence, user: current_user)
      if identifier.valid?
        IdentifierJob.perform_later(file_path, identifier)
        redirect_to root_path, notice: "File imported successfully."
      else
        redirect_to root_path, notice: "Failed to process your request."
      end
    rescue => e
      puts '*' * 40, e.message, e.backtrace, '*' * 40
      redirect_to new_identifiers_path, alert: e.message
    end
  end

  def show
    @identifier = Identifier.find(params[:id])
    @success_datas = @identifier.csv_datas.validation_success_datas
    @error_datas = @identifier.csv_datas.validation_failed_datas
  end
end
