class IdentifiersController < ApplicationController

  def index
    @identifiers = Identifier.where(user: current_user)
  end

  def new
  end

  def create
    begin
      identifier = Identifier.find_or_create_by!(name: params[:name].presence, user: current_user)
      Identifier.import(params[:file].tempfile, identifier)
      redirect_to root_url, notice: "File imported successfully."
    rescue => e
      puts '*' * 40
      puts e.message
      puts e.backtrace
      puts '*' * 40
      redirect_to root_url, notice: e.message
    end
  end

  def show
    @identifier = Identifier.find(params[:id])
    @success_datas = @identifier.csv_datas.validation_success_datas
    @error_datas = @identifier.csv_datas.validation_failed_datas
  end
end
