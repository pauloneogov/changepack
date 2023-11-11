# typed: false
# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Notification do
  it { is_expected.to belong_to(:account) }
  it { is_expected.to have_many(:deliveries) }
  it { is_expected.to have_many(:users).through(:deliveries) }
  it { is_expected.to validate_presence_of(:type) }

  describe '#channels' do
    subject { notification.valid? }

    let(:notification) { build(:notification, :custom, channels: [channel].flatten) }

    context 'when channel is email' do
      let(:channel) { 'email' }

      it { is_expected.to be_truthy }
    end

    context 'when channel is web' do
      let(:channel) { 'web' }

      it { is_expected.to be_truthy }
    end

    context 'when channel is email and web' do
      let(:channel) { %w[email web] }

      it { is_expected.to be_truthy }
    end

    context 'when channel is sms' do
      let(:channel) { 'sms' }

      it { is_expected.to be_falsey }
    end
  end
end
