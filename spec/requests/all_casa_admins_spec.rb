require "rails_helper"

RSpec.describe "/all_casa_admins", :disable_bullet, type: :request do
  let(:admin) { create(:all_casa_admin) }

  before(:each) { sign_in admin }

  describe "GET /edit", :disable_bullet do
    context "with a all_casa_admin signed in" do
      it "renders a successful response" do
        get edit_all_casa_admins_path

        expect(response).to be_successful
      end
    end
  end

  describe "PATCH /update", :disable_bullet do
    context "with valid parameters" do
      it "updates the all_casa_admin" do
        patch all_casa_admins_path, params: {all_casa_admin: {email: "newemail@example.com"}}
        expect(response).to have_http_status(:redirect)

        expect(admin.email).to eq "newemail@example.com"
      end
    end

    context "with invalid parameters" do
      it "does not update the all_casa_admin" do
        other_admin = create(:all_casa_admin)
        patch all_casa_admins_path, params: {all_casa_admin: {email: other_admin.email}}
        expect(response).to have_http_status(:ok)

        expect(admin.email).to_not eq "newemail@example.com"
      end
    end
  end

  describe "PATCH /update_password", :disable_bullet do
    context "with valid parameters" do
      let(:params) do
        {
          all_casa_admin: {
            password: "newpassword",
            password_confirmation: "newpassword"
          }
        }
      end

      it "updates the all_casa_admin password" do
        patch update_password_all_casa_admins_path, params: params
        expect(response).to have_http_status(:redirect)
        expect(admin.valid_password?("newpassword")).to be true
      end
    end

    context "with invalid parameters" do
      let(:params) do
        {
          all_casa_admin: {
            password: "newpassword",
            password_confirmation: "badmatch"
          }
        }
      end

      it "does not update the all_casa_admin password" do
        patch update_password_all_casa_admins_path, params: params
        expect(response).to have_http_status(:ok)
        expect(admin.reload.valid_password?("newpassword")).to be false
      end
    end
  end
end
