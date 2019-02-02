class IdentifiersController < ApplicationController

  def index
    @identifiers = Identifier.where(user: current_user)
  end

  def new
  end

  def create
    begin
      identifier = Identifier.find_or_create_by!(name: params[:name].presence, user: current_user)
      binding.pry
      Identifier.import(params[:file].tempfile, identifier)
      redirect_to root_url, notice: "File imported successfully."
    rescue => e
      puts '*' * 40
      puts e.message
      puts '*' * 40
      redirect_to root_url, notice: e.message
    end
  end
end
