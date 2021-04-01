require "rails_helper"

RSpec.describe "case_contacts/index", :disable_bullet, type: :view do
  let(:user) { build_stubbed(:volunteer) }

  before do
    enable_pundit(view, user)
    allow(view).to receive(:current_user).and_return(user)
    case_contact = create(:case_contact)
    assign :case_contact, case_contact
    assign :casa_cases, [case_contact.casa_case]
    render template: "case_contacts/index"
  end

  it "Displays the Case Contacts title" do
    expect(rendered).to have_text("Case Contacts")
  end

  it "Has a New Case Contact button" do
    expect(rendered).to have_link(t("page.casa_case.new.title"), href: new_case_contact_path)
  end
end
