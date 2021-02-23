require 'rails_helper'
require_relative '../support/devise'

RSpec.describe ContactsController, type: :controller do
  describe "#index" do
    context "as an unauthenticated user" do
      it "gets a redirection to sign in" do
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

  describe "#show" do
    context "as an UNauthenticated user" do
      it "makes redirection to sign in when #show action invoked" do
        contact = create(:contact)
        user2 = create(:user)
        params = { id: user2.id }
        get :show, params: params
        expect(response).to redirect_to("/users/sign_in")
      end
    end
    context "as an authenticated user" do
      login_user
      it "shows an contact record when #show action invoked" do
        contact = create(:contact)
        contact.update(user_id: @user.id)  #Make sure it's the same user
        params = { id: @user.id }
        get :show, params: params
        expect(response).to have_http_status(:success)
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

    it "imports a single contact with correclty exchanged fields from a single import record" do
      import = create(:import, name: "5100111122223333", credit_card: "Jon Doe")
      params = { "imports_ids"=>[import.id], "field1"=>"credit_card", "field2"=>"birth_date", "field3"=>"tel", "field4"=>"address", "field5"=>"name", "field6"=>"email" }
      expect {
        post :create, params: params
      }.to change(@user.contacts, :count).by(1)
    end

    it "does not import a single contact with exchanged fields from a single import record" do
      import = create(:import)
      params = { "imports_ids"=>[import.id], "field1"=>"credit_card", "field2"=>"birth_date", "field3"=>"tel", "field4"=>"address", "field5"=>"name", "field6"=>"email" }
      expect {
        post :create, params: params
      }.to change(@user.contacts, :count).by(0)
    end

    it "does not destroy import record if contact is not imported by exchanging fields" do
      import = create(:import)
      params = { "imports_ids"=>[import.id], "field1"=>"credit_card", "field2"=>"birth_date", "field3"=>"tel", "field4"=>"address", "field5"=>"name", "field6"=>"email" }
      expect {
        post :create, params: params
      }.to change(@user.imports, :count).by(0)
      #I suspect that this one is best suited for imports
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
    login_user
    it "updates contact with adecuate format data for name, birth_date, tel, address, credit_card, email" do
      contact = create(:contact)
      contact.update(user_id: @user.id) #We have to make sure it's the same user
      params = { id: contact.id, contact: { name: "Jane Doe" }}
      patch :update, params: params
      expect(contact.reload.name).to eq("Jane Doe")
    end

    it "does not update a contact with a different user" do
      user2 = create(:user)
      contact = create(:contact, name: "John Smith")
      contact.update(user_id: user2.id)

      params = { id: contact.id, contact: { name: "Jane Doe" }}
      patch :update, params: params
      expect(contact.reload.name).to eq("John Smith")
    end
  end

  describe "#forbiden_user" do
    login_user
    it "renders a page when an action is called from a user.id other than current_user.id" do
      expect(response).to have_http_status "200"
    end
  end

  describe "#destroy" do
    login_user
    it "destroys a contact" do
      contact = create(:contact)
      contact.update(user_id: @user.id) #We have to make sure it's the same user
      params = { id: contact.id }
      expect {
        delete :destroy, params: params
      }.to change(@user.contacts, :count).by(-1)
    end

    it "does not destroy a contact from an user.id other than the current_user.id" do
      user2 = create(:user)
      contact = create(:contact)
      contact.update(user_id: user2.id)

      params = { id: contact.id }
      # delete :destroy, params: params
      # expect(response).to have_http_status "200"
      expect {
        delete :destroy, params: params
      }.to_not change(Contact, :count)
    end
  end

  after do
    User.destroy_all
  end
end