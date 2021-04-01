require "rails_helper"

RSpec.describe CaseContactDecorator, :disable_bullet do
  describe "#duration_minutes", :disable_bullet do
    context "when duration_minutes is less than 60" do
      it "returns only minutes" do
        case_contact = create(:case_contact, duration_minutes: 30)

        expect(case_contact.decorate.duration_minutes).to eq "30 minutes"
      end
    end

    context "when duration_minutes is greater than 60" do
      it "returns minutes and hours" do
        case_contact = create(:case_contact, duration_minutes: 135)

        expect(case_contact.decorate.duration_minutes).to eq "2 hours 15 minutes"
      end
    end
  end

  describe "#contact_made", :disable_bullet do
    context "when contact_made is false" do
      it "returns No Contact Made" do
        case_contact = create(:case_contact, contact_made: false)

        expect(case_contact.decorate.contact_made).to eq "No Contact Made"
      end
    end

    context "when contact_made is true" do
      it "returns Yes" do
        case_contact = create(:case_contact, contact_made: true)

        expect(case_contact.decorate.contact_made).to be_nil
      end
    end
  end

  describe "#contact_types", :disable_bullet do
    subject(:contact_types) { decorated_case_contact.contact_types }

    let(:case_contact) { build(:case_contact, contact_types: contact_types) }
    let(:decorated_case_contact) do
      described_class.new(case_contact)
    end

    context "when the contact_types is an empty array" do
      let(:contact_types) { [] }

      it { is_expected.to eql("No contact type specified") }
    end

    context "when the contact_types is an array with three or more values" do
      let(:contact_types) do
        [
          build(:contact_type, name: "School"),
          build(:contact_type, name: "Therapist"),
          build(:contact_type, name: "Bio Parent")
        ]
      end

      it { is_expected.to eql("School, Therapist, and Bio Parent") }
    end

    context "when the contact types is an array with less than three values" do
      let(:contact_types) do
        [
          build(:contact_type, name: "School"),
          build(:contact_type, name: "Therapist")
        ]
      end

      it { is_expected.to eql("School and Therapist") }
    end
  end

  describe "#medium_icon_classes", :disable_bullet do
    context "when medium type is in-person" do
      it "returns the proper font-awesome classes" do
        case_contact = create(:case_contact, medium_type: "in-person").decorate

        expect(case_contact.medium_icon_classes).to eql("fas fa-users")
      end
    end

    context "when medium type is text/email" do
      it "returns the proper font-awesome classes" do
        case_contact = create(:case_contact, medium_type: "text/email").decorate

        expect(case_contact.medium_icon_classes).to eql("fas fa-envelope")
      end
    end

    context "when medium type is video" do
      it "returns the proper font-awesome classes" do
        case_contact = create(:case_contact, medium_type: "video").decorate

        expect(case_contact.medium_icon_classes).to eql("fas fa-video")
      end
    end

    context "when medium type is voice-only" do
      it "returns the proper font-awesome classes" do
        case_contact = create(:case_contact, medium_type: "voice-only").decorate

        expect(case_contact.medium_icon_classes).to eql("fas fa-phone-square-alt")
      end
    end

    context "when medium type is letter" do
      it "returns the proper font-awesome classes" do
        case_contact = create(:case_contact, medium_type: "letter").decorate

        expect(case_contact.medium_icon_classes).to eql("fas fa-file-alt")
      end
    end

    context "when medium type is anything else" do
      it "returns the proper font-awesome classes" do
        case_contact = create(:case_contact, medium_type: "foo").decorate

        expect(case_contact.medium_icon_classes).to eql("fas fa-question")
      end
    end
  end

  describe "#subheading", :disable_bullet do
    context "when all information is available" do
      it "returns a properly formatted string" do
        contact_group = create(:contact_type_group, name: "Group X")
        contact_type = create(:contact_type, contact_type_group: contact_group, name: "Type X")
        case_contact = create(:case_contact, occurred_at: "2020-12-01", duration_minutes: 99, contact_made: false, miles_driven: 100, want_driving_reimbursement: true)
        case_contact.contact_types = [contact_type]

        expect(case_contact.decorate.subheading).to eq(
          "December 1, 2020 | 1 hour 39 minutes | No Contact Made | 100 miles driven | Reimbursement"
        )
      end
    end

    context "when some information is missing" do
      it "returns a properly formatted string without extra pipes" do
        contact_group = create(:contact_type_group, name: "Group X")
        contact_type = create(:contact_type, contact_type_group: contact_group, name: "Type X")
        case_contact = create(:case_contact, occurred_at: "2020-12-01", duration_minutes: 99, contact_made: true, miles_driven: 100, want_driving_reimbursement: true)
        case_contact.contact_types = [contact_type]

        expect(case_contact.decorate.subheading).to eq(
          "December 1, 2020 | 1 hour 39 minutes | 100 miles driven | Reimbursement"
        )
      end
    end
  end
end
