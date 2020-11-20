# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Offer, type: :model do
  context 'when db schema' do
    let(:model) { described_class.column_names }

    %w[advertiser_name url description starts_at ends_at premium disabled].each do |column|
      it "have column #{column}" do
        expect(model).to include(column)
      end
    end
  end

  describe 'when validation' do
    %i[advertiser_name url description starts_at].each do |field|
      it { is_expected.to validate_presence_of(field) }
    end

    it { is_expected.to validate_length_of(:description).is_at_most(500) }
    it { is_expected.to validate_uniqueness_of(:advertiser_name) }
    it { is_expected.to allow_value('https://site.com').for(:url) }
    it { is_expected.to allow_value('http://site.com').for(:url) }
    it { is_expected.not_to allow_value('url.site').for(:url) }

    context 'when validate starts_at' do
      let(:attributes) do
        {
          advertiser_name: Faker::Name.name,
          url: 'https://site.com',
          description: 'text here',
          starts_at: Time.current
        }
      end

      it 'is valid' do
        expect(described_class.new(attributes)).to be_valid
      end

      it 'is invalid' do
        attributes[:starts_at] = (Time.current - 1.day)
        expect(described_class.new(attributes)).not_to be_valid
      end

      it 'is invalid (message)' do
        attributes[:starts_at] = (Time.current - 1.day)
        described = described_class.new(attributes)
        described.valid?
        expect(described.errors[:starts_at]).to match_array([I18n.t('errors.messages.starts_at_invalid')])
      end
    end
  end

  describe 'when scope' do
    let(:scope_published) do
      described_class.where('starts_at <= :datetime AND (ends_at > :datetime OR ends_at IS NULL) AND disabled = false',
                            datetime: Time.current.to_s(:db_datetime)).to_sql
    end

    it '.published' do
      expect(described_class.published.to_sql).to eq(scope_published)
    end
  end

  describe 'when offer enabled or disabled' do
    let(:time) { Time.current }
    let!(:offer) { create(:offer, starts_at: time, disabled: false, ends_at: time + 1.day) }

    it 'offer enabled' do
      travel 1.minute do
        expect(described_class.published.find_by(id: offer.id)).to be_truthy
      end
      travel_back
    end

    it 'offer disabled time' do
      travel 2.days do
        expect(described_class.published.find_by(id: offer.id)).to be_falsey
      end
      travel_back
    end

    it 'offer disabled' do
      offer.update(disabled: true)
      travel 2.days do
        expect(described_class.published.find_by(id: offer.id)).to be_falsey
      end
      travel_back
    end
  end
end
