# frozen_string_literal: true

module Admin
  class OffersController < ApplicationController
    before_action :set_offer, only: %i[edit update show destroy update_status]

    def index
      @offers = Offer.all.order(id: :desc)
    end

    def new
      @offer = Offer.new
    end

    def create
      @offer = Offer.new(offer_params)
      if @offer.save
        redirect_to admin_offers_path, notice: 'Created!'
      else
        render :new
      end
    end

    def edit; end

    def update
      if @offer.update(offer_params)
        redirect_to admin_offers_path, notice: 'Accepted!'
      else
        render :edit
      end
    end

    def show; end

    def update_status
      if @offer.update(disabled: params[:status])
        redirect_to admin_offers_path, notice: 'Accepted!'
      else
        redirect_to admin_offers_path, alert: 'Something wrong happened'
      end
    end

    def destroy
      @offer.destroy
      redirect_to admin_offers_path, notice: 'Registered!'
    end

    private

    def set_offer
      @offer = Offer.find(params[:id] || params[:offer_id])
    end

    def offer_params
      params.require(:offer).permit(:advertiser_name, :url, :description, :starts_at, :ends_at, :premium)
    end
  end
end
