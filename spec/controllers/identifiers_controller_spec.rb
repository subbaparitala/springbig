require 'rails_helper'
require_relative '../factories'

describe IdentifiersController do
  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    @user = FactoryBot.create(:user)
    sign_in :user, @user
  end

  it 'should render index' do
    get :index
    expect(response).to render_template("index")
  end

  it 'should render new' do
    get :new
    expect(response).to render_template("new")
  end

  it '#create' do
    file = ActionDispatch::Http::UploadedFile.new(
        {
            :filename => 'test.csv',
            :type => ' text/csv',
            :tempfile => Tempfile.new("../test.csv")
        }
    )
    post :create, params: {name: 'testrest34324', file: file}
    expect( response.status).to eq 302
  end

end
