require 'rails_helper'
# require_relative '../support/devise'

RSpec.describe ImportsController, type: :controller do
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
				import = create(:import)
				user2 = create(:user)
				params = { id: user2.id }
				get :show, params: params
				expect(response).to redirect_to("/users/sign_in")
			end
		end
		context "as an authenticated user" do
			login_user
			it "shows an import record when #show action invoked" do
				import = create(:import)
				import.update(user_id: @user.id)	#Make sure it's the same user
				params = { id: @user.id }
				get :show, params: params
				expect(response).to have_http_status(:success)
			end
		end
	end

	describe "#create" do
		context "as an UNauthenticated user" do
			it "makes redirection to sign in when #create action invoked" do
				@file = fixture_file_upload('files/test1ok.csv', 'text/csv')
				file = Hash.new
				file['file'] = @file
				post :create, params: file
				expect(response).to redirect_to("/users/sign_in")
			end
		end
		context "as an authenticated user" do
			login_user
			it "makes redirection to imports index when #create action invoked" do
				@file = fixture_file_upload('files/test1ok.csv', 'text/csv')
				file = Hash.new
				file['file'] = @file
				post :create, params: file
				expect(response).to redirect_to("/imports")
			end

			it "imports 4 records successfully from a file with 4 well formed registers" do
				@file = fixture_file_upload('files/test1ok.csv', 'text/csv')
				file = Hash.new
				file['file'] = @file
				expect {
					post :create, params: file
				}.to change(Import, :count).by 4
			end
		end
	end

	describe "#update" do
		context "as an UNauthenticated user" do
			it "makes redirection to sign in when #create action invoked" do
				import = create(:import, tel: "(+57) 301 226 83 00" )
				params = { id: import.id, import: { tel: "(+57) 301 226 83 95"}}
				patch :update, params: params
				expect(response).to redirect_to("/users/sign_in")
			end
		end
		context "as an authenticated user" do
			login_user
			it "updates tel information in an import record" do
				import = create(:import, tel: "(+57) 301 226 83 00" )
				import.update(user_id: @user.id) #Make ure it's the same user.
				params = { id: import.id, import: { tel: "(+57) 301 226 83 95"}}
				patch :update, params: params
				expect(import.reload.tel).to include("95")
			end

			it "does not updates tel information wuth a different user" do
				import = create(:import, tel: "(+57) 301 226 83 00" )
				user2 = create(:user)
				import.update(user_id: user2.id) #Make ure it's the same user.
				params = { id: import.id, import: { tel: "(+57) 301 226 83 95"}}
				patch :update, params: params
				expect(import.reload.tel).to include("00")
			end
		end
		
	end

	describe "#destroy" do
		context "as an UNauthenticated user" do
			login_user
			it "makes redirection to sign in when #destroy action invoked" do
				import = create(:import, tel: "(+57) 301 226 83 00" )
				params = { id: import.id }
				sign_out @user
				delete :destroy, params: params
				expect(response).to redirect_to("/users/sign_in")
			end
		end
		context "as an authenticated user" do
			login_user
			    it "destroys an import" do
			      import = create(:import)
			      import.update(user_id: @user.id) #We have to make sure it's the same user
			      params = { id: import.id }
			      expect {
			        delete :destroy, params: params
			      }.to change(@user.imports, :count).by(-1)
			    end

			    it "does not destroy an import from an user.id other than the current_user.id" do
			      user2 = create(:user)
			      import = create(:import)
			      import.update(user_id: user2.id)

			      params = { id: import.id }
			      expect {
			        delete :destroy, params: params
			      }.to_not change(Contact, :count)
			    end
		end
		
	end

	after do
	  User.destroy_all
	end
end
