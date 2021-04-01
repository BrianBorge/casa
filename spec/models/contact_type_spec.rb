require "rails_helper"

RSpec.describe ContactType, :disable_bullet, type: :model do
  let(:contact_type) { create(:contact_type, name: "Name") }

  describe "#create", :disable_bullet do
    it "does have a name" do
      is_expected.to validate_presence_of(:name)
    end
  end

  describe "#update", :disable_bullet do
    it "can update to a valid name" do
      contact_type.name = "New name"
      contact_type.save
      expect(contact_type.name).to eq("New name")
    end

    it "can't update to an invalid name" do
      contact_type.name = nil
      expect { contact_type.save! }.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Name can't be blank")
    end

    it "can update contact type group" do
      new_group = create(:contact_type_group, name: "New contact group")
      contact_type.contact_type_group_id = new_group.id
      expect(contact_type.contact_type_group.name).to eq("New contact group")
    end

    it "can deactivate contact type " do
      contact_type.active = false
      expect(contact_type.active?).to be_falsey
    end
  end
end
