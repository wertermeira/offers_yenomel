# frozen_string_literal: true

require 'rails_helper'
RSpec.describe 'Admin/Offers', type: :routing do
  it 'routes to #index' do
    expect(get: admin_offers_path).to route_to('admin/offers#index')
  end

  it 'routes to #new' do
    expect(get: new_admin_offer_path).to route_to('admin/offers#new')
  end

  it 'routes to #create' do
    expect(post: admin_offers_path).to route_to('admin/offers#create')
  end

  it 'routes to #show' do
    expect(get: admin_offer_path(1)).to route_to('admin/offers#show', id: '1')
  end

  it 'routes to #edit' do
    expect(get: edit_admin_offer_path(1)).to route_to('admin/offers#edit', id: '1')
  end

  it 'routes to #update' do
    expect(put: admin_offer_path(1)).to route_to('admin/offers#update', id: '1')
  end

  it 'routes to #update_status' do
    expect(put: admin_offer_update_status_path(offer_id: 1)).to route_to('admin/offers#update_status', offer_id: '1')
  end

  it 'routes to #destroy' do
    expect(delete: admin_offer_path(1)).to route_to('admin/offers#destroy', id: '1')
  end
end
