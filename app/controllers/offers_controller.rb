# frozen_string_literal: true

class OffersController < ApplicationController
  before_action :set_offer, only: %i[show]

  def index
    @offers = Offer.published.all.order(premium: :desc)
  end
end
