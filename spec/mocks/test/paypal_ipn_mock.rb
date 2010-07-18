require 'net/http'

module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    module Integrations #:nodoc:
      module Paypal
        class Notification < ActiveMerchant::Billing::Integrations::Notification
          include PostsData

          # Was the transaction complete?
          def complete?
              status == "Completed"
          end

          def received_at
            Time.parse params['payment_date']
          end

          def status
            params['payment_status']
          end

          # Id of this transaction (paypal number)
          def transaction_id
            params['txn_id']
          end

          # What type of transaction are we dealing with?
          #  "cart" "send_money" "web_accept" are possible here.
          def type
            params['txn_type']
          end

          # the money amount we received in X.2 decimal.
          def gross
            params['mc_gross']
          end

          # the markup paypal charges for the transaction
          def fee
  params['mc_fee']
          end

          # What currency have we been dealing with
          def currency
            params['mc_currency']
          end

          def item_id
            params['item_number'] || params['custom']
          end

          # This is the invoice which you passed to paypal
          def invoice
            params['invoice']
          end

          # Was this a test transaction?
          def test?
            params['test_ipn'] == '1'
          end

          def account
            params['business'] || params['receiver_email']
          end

          def acknowledge
            params["acknowledge"] == "true"
          end
        end
      end
    end
  end
end
