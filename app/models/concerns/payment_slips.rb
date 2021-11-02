module PaymentSlips
  extend ActiveSupport::Concern

  include I18nEnums

  PaymentSlips::PAYMENT_SLIPS = %w(qr).freeze

  included do
    i18n_enum :payment_slip, PaymentSlips::PAYMENT_SLIPS, queries: true, scopes: true

    def bank?
      false
    end

    def post?
      !bank?
    end

    def with_reference?
      false
    end

    def bank_with_reference?
      bank? && with_reference?
    end
  end

end
