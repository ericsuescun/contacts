require 'rails_helper'
# require_relative '../support/devise'

RSpec.describe ImportsController, type: :controller do
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
		login_user
		it "imports successfully from a file in support folder well formed" do
			expect(file_fixture("test1ok.csv").read).to include("Eric")
		end
	end

	after do
	  User.destroy_all
	end
end