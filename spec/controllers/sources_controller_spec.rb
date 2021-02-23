require 'rails_helper'
require_relative '../support/devise'

RSpec.describe SourcesController, type: :controller do
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

  describe "#destroy" do
    context "as an UNauthenticated user" do
      login_user
      it "makes redirection to sign in when #destroy action invoked" do
        source = create(:source )
        params = { id: source.id }
        sign_out @user
        delete :destroy, params: params
        expect(response).to redirect_to("/users/sign_in")
      end
    end
    context "as an authenticated user" do
      login_user
      it "destroys a source" do
        source = create(:source)
        source.update(user_id: @user.id) #We have to make sure it's the same user
        params = { id: source.id }
        expect {
          delete :destroy, params: params
        }.to change(@user.sources, :count).by(-1)
      end

      it "does not destroy a source from a user.id other than the current_user.id" do
        user2 = create(:user)
        source = create(:source)
        source.update(user_id: user2.id)

        params = { id: source.id }
        expect {
          delete :destroy, params: params
        }.to_not change(Source, :count)
      end
    end
  end

  after do
    User.destroy_all
  end

end