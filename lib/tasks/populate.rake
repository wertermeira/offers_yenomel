# frozen_string_literal: true

namespace :populate do
  include FactoryBot::Syntax::Methods if Rails.env.development?

  desc 'Send offers'
  task offers: :environment do
    10.times do
      create(:offer)
    end
  end
end
