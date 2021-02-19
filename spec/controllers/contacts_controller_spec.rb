require 'rails_helper'
require_relative '../support/devise'

RSpec.describe ContactsController, type: :controller do
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
    before(:each) do
      Import.destroy_all
    end
    login_user
    it "imports a single contact with adecuate information from a single import record" do
      import = create(:import)
      params = { "imports_ids"=>[import.id], "field1"=>"name", "field2"=>"birth_date", "field3"=>"tel", "field4"=>"address", "field5"=>"credit_card", "field6"=>"email" }
      expect {
        post :create, params: params
      }.to change(@user.contacts, :count).by(1)
    end

    it "imports a number of contacts with adecuate information from an equal number of import record" do
      n = rand(2..10)
      n.times{create(:import)}
      params = { "imports_ids"=>Import.ids, "field1"=>"name", "field2"=>"birth_date", "field3"=>"tel", "field4"=>"address", "field5"=>"credit_card", "field6"=>"email" }
      expect {
        post :create, params: params
      }.to change(@user.contacts, :count).by(n)
    end

    it "destroys a number of import records once it imports them to contacts" do
      n = rand(2..10)
      n.times{create(:import)}
      params = { "imports_ids"=>Import.ids, "field1"=>"name", "field2"=>"birth_date", "field3"=>"tel", "field4"=>"address", "field5"=>"credit_card", "field6"=>"email" }
      expect {
        post :create, params: params
      }.to change(@user.imports, :count).by(0)
    end
  end

  describe "#update" do

  end

  after do
    User.destroy_all
  end
end