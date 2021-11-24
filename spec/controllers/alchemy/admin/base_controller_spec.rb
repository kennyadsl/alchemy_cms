# frozen_string_literal: true

require 'rails_helper'

describe Alchemy::Admin::BaseController do
  describe '#options_from_params' do
    subject { controller.send(:options_from_params) }

    before do
      expect(controller).to receive(:params).at_least(:once) do
        ActionController::Parameters.new(options: options)
      end
    end

    context "params[:options] are Rails parameters" do
      let(:options) do
        ActionController::Parameters.new('hello' => 'world')
      end

      it "returns the options as permitted parameters with indifferent access" do
        expect(subject).to be_permitted
        expect(subject[:hello]).to eq('world')
      end
    end

    context "params[:options] is nil" do
      let(:options) { nil }

      it "returns an empty permitted parameters hash" do
        is_expected.to eq(ActionController::Parameters.new.permit!)
      end
    end
  end

  describe '#raise_exception?' do
    subject { controller.send(:raise_exception?) }

    context 'in test mode' do
      before { expect(Rails.env).to receive(:test?).and_return true }
      it { is_expected.to be_truthy }
    end

    context 'not in test mode' do
      before { expect(Rails.env).to receive(:test?).and_return false }
      it { is_expected.to be_falsey }

      context 'and in page preview' do
        before { expect(controller).to receive(:is_page_preview?).and_return true }
        it { is_expected.to be_truthy }
      end

      context 'and not in page preview' do
        before { expect(controller).to receive(:is_page_preview?).and_return false }
        it { is_expected.to be_falsey }
      end
    end
  end

  describe '#set_translation' do
    context 'with unavailable locale in the session' do
      before do
        allow(I18n).to receive(:default_locale) { :es }
        allow(I18n).to receive(:available_locales) { [:es] }
        allow(controller).to receive(:session) { { alchemy_locale: 'kl'} }
      end

      it "sets I18n.locale to the default locale" do
        controller.send(:set_translation)
        expect(::I18n.locale).to eq(:es)
      end
    end
  end

  describe '#is_page_preview?' do
    subject { controller.send(:is_page_preview?) }

    it { is_expected.to be_falsey }

    context 'is pages controller and show action' do
      before do
        expect(controller).to receive(:controller_path).and_return('alchemy/admin/pages')
        expect(controller).to receive(:action_name).and_return('show')
      end

      it { is_expected.to be_truthy }
    end
  end

  context 'when current_alchemy_user is present' do
    let!(:page_1) { create(:alchemy_page, name: 'Page 1') }
    let!(:page_2) { create(:alchemy_page, name: 'Page 2') }
    let(:user)    { create(:alchemy_dummy_user, :as_admin) }

    context 'and she has locked pages' do
      before do
        allow(controller).to receive(:current_alchemy_user) { user }
        [page_1, page_2].each_with_index do |p, i|
          p.update_columns(locked_at: i.months.ago, locked_by: user.id)
        end
      end

      it 'loads locked pages ordered by locked_at date' do
        controller.send(:load_locked_pages)
        expect(assigns(:locked_pages).pluck(:name)).to eq(['Page 2', 'Page 1'])
      end
    end

    describe "#notify_error_tracker" do
      it "does not throw an error if the proc is nil" do
        allow(Alchemy::ErrorTracking).to receive(:notification_handler).and_return(nil)
        expect { controller.send(:notify_error_tracker, StandardError.new) }.not_to raise_error
      end

      it "calls error notification handler" do
        error = StandardError.new
        expect(Alchemy::ErrorTracking.notification_handler).to receive(:call).with(error)
        controller.send(:notify_error_tracker, error)
      end
    end
  end
end
