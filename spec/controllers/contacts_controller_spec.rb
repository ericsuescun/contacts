require 'rails_helper'
require_relative '../support/devise'

RSpec.describe ContactsController, type: :controller do
  # before do
  #   @user = create(:user)
  # end
  describe "#index" do
    context "as a guest user" do
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
        # sign_in @user
        get :index
        expect(response).to have_http_status(:success)
      end

      it "returns a 200 http response code" do
        # sign_in @user
        get :index
        expect(response).to have_http_status "200"
      end
    end

    after do
      User.destroy_all
    end

  end
end