# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::OffersController, type: :controller do
  let(:offer) { create(:offer) }
  let(:advertiser_name) { Faker::Name.name }
  let(:attributes) do
    {
      advertiser_name: advertiser_name,
      url: 'http://site.com',
      description: 'text here',
      starts_at: Time.current,
      premium: true
    }
  end

  describe '#index' do
    context 'when is success' do
      it 'returns http success' do
        get :index
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe '#show' do
    context 'when resource is found' do
      it 'returns http success' do
        get :show, params: { id: offer.id }
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe '#new' do
    it 'returns http success' do
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe '#create' do
    context 'when created' do
      it 'created' do
        expect  do
          post :create, params: { offer: attributes }
        end.to change(Offer, :count).by(1)
      end

      it 'redirect to offers' do
        post :create, params: { offer: attributes }
        expect(response).to redirect_to(admin_offers_path)
      end
    end

    it 'create is fail' do
      attributes[:url] = ''
      post :create, params: { offer: attributes }
      expect(response).to render_template(:new)
    end
  end

  describe '#edit' do
    it 'returns http success' do
      get :edit, params: { id: offer.id }
      expect(response).to have_http_status(:success)
    end
  end

  describe '#update' do
    context 'when accepted' do
      before { put :update, params: { id: offer.id, offer: attributes } }

      it 'change name' do
        expect(offer.reload.advertiser_name).to eq(advertiser_name)
      end

      it 'redirect to offers' do
        expect(response).to redirect_to(admin_offers_path)
      end
    end

    it 'update is fail' do
      attributes[:url] = ''
      put :update, params: { id: offer.id, offer: attributes }
      expect(response).to render_template(:edit)
    end
  end

  describe '#update_status' do
    context 'when accepted' do
      before { put :update_status, params: { offer_id: offer.id, status: true } }

      it 'change status' do
        expect(offer.reload.disabled).to be_truthy
      end

      it 'redirect to offers' do
        expect(response).to redirect_to(admin_offers_path)
      end
    end
  end

  describe '#destroy' do
    it 'destroy is redirect_to' do
      delete :destroy, params: { id: offer.id }
      expect(response).to redirect_to(admin_offers_path)
    end

    it 'destroy is deleted' do
      expect do
        delete :destroy, params: { id: offer.id }
      end.to change(Offer, :count).by(0)
    end
  end
end
