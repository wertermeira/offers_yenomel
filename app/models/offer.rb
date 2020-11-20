# frozen_string_literal: true

class Offer < ApplicationRecord
  validates :advertiser_name, :url, :description, :starts_at, presence: true
  validates :advertiser_name, uniqueness: true
  validates :description, length: { maximum: 500 }, allow_blank: true
  validates :url, format: { with: URI::DEFAULT_PARSER.make_regexp }, if: -> { url.present? }

  after_validation :validate_starts_at, if: -> { errors.blank? && new_record? }

  def time_format(datetime)
    datetime.strftime('%H:%M') unless datetime.blank?
  end

  def message_status
    I18n.t("offer_messages.status_#{status}")
  end

  def disabled_status
    I18n.t("offer_messages.button_#{disabled}")
  end

  def status
    return false if disabled

    starts_at <= Time.current && (ends_at.nil? || ends_at > Time.current)
  end

  scope :published, lambda {
                      where('starts_at <= :datetime AND (ends_at > :datetime OR ends_at IS NULL) AND disabled = false',
                            datetime: Time.current.to_s(:db_datetime))
                    }

  private

  def validate_starts_at
    msg = I18n.t('errors.messages.starts_at_invalid')
    errors.add(:starts_at, msg) if starts_at < (Time.current - 1.minute)
  end
end
