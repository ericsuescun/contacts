require 'rails_helper'
require_relative '../support/devise'

RSpec.describe FranchisesController, type: :controller do
  describe "#index" do
    context "as an unauthenticated user" do
      it "gets a redirection" do
        get :index
        expect(response).to redirect_to("/users/sign_in")
      end

      it "returns a 302 http code for redirection" do
        get :index
        expect(response).to have_http_status "302"
      end
    end

    context "as an authenticated user" do
      login_user
      it "responds successfully" do
        get :index
        expect(response).to have_http_status(:success)
      end

      it "returns a 200 http response code" do
        get :index
        expect(response).to have_http_status "200"
      end
    end
  end

  describe "#create" do
    context "as an UNauthenticated user" do
      it "makes redirection to sign in when #create action invoked" do
        @file = fixture_file_upload('files/cc.csv', 'text/csv')
        file = Hash.new
        file['file'] = @file
        post :create, params: file
        expect(response).to redirect_to("/users/sign_in")
      end
    end
    context "as an authenticated user" do
      login_user
      it "makes redirection to franchises index when #create action invoked" do
        @file = fixture_file_upload('files/cc.csv', 'text/csv')
        file = Hash.new
        file['file'] = @file
        post :create, params: file
        expect(response).to redirect_to("/franchises")
      end

      it "imports 23 records successfully from a file with 23 well formed registers" do
        @file = fixture_file_upload('files/cc.csv', 'text/csv')
        file = Hash.new
        file['file'] = @file
        expect {
          post :create, params: file
        }.to change(Franchise, :count).by 23
      end
    end
  end

  after do
    User.destroy_all
  end

end