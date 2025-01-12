# frozen_string_literal: true

require "rails_helper"

RSpec.describe Alchemy::Admin::ElementsController do
  before do
    authorize_user(:as_admin)
  end

  describe "#fold" do
    context "folded element with ingredients" do
      let(:element) { create(:alchemy_element, :with_ingredients, folded: true) }

      context "with validations" do
        let(:element) { create(:alchemy_element, :with_ingredients, name: :all_you_can_eat) }

        it "saves without running validations" do
          post fold_admin_element_path(id: element.id, format: :js)
          expect(element.reload).to be_folded
        end
      end
    end
  end
end
