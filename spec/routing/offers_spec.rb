# frozen_string_literal: true

require 'rails_helper'
RSpec.describe 'Offers', type: :routing do
  it 'routes to #index' do
    expect(get: root_path).to route_to('offers#index')
  end
end
