module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    class BogusGateway < Gateway
      def authorize(money, creditcard, options = {})
        money = amount(money)
        case creditcard.number
        when '4111111111111111'
          Response.new(true, SUCCESS_MESSAGE, {:authorized_amount => money}, :test => true, :authorization => AUTHORIZATION )
        when '1111111111111111'
          Response.new(false, FAILURE_MESSAGE, {:authorized_amount => money, :error => FAILURE_MESSAGE }, :test => true)
        else
          raise Error, ERROR_MESSAGE
        end      
      end
  
      def purchase(money, creditcard, options = {})
        money = amount(money)
        case creditcard.number
        when '4111111111111111'
          Response.new(true, SUCCESS_MESSAGE, {:paid_amount => money}, :test => true)
        when '1111111111111111'
          Response.new(false, FAILURE_MESSAGE, {:paid_amount => money, :error => FAILURE_MESSAGE },:test => true)
        else
          raise Error, ERROR_MESSAGE
        end
      end
 
      def credit(money, ident, options = {})
        money = amount(money)
        case ident
        when '4111111111111111'
          raise Error, CREDIT_ERROR_MESSAGE
        when '1111111111111111'
          Response.new(false, FAILURE_MESSAGE, {:paid_amount => money, :error => FAILURE_MESSAGE }, :test => true)
        else
          Response.new(true, SUCCESS_MESSAGE, {:paid_amount => money}, :test => true)
        end
      end
 
      def capture(money, ident, options = {})
        money = amount(money)
        case ident
        when '4111111111111111'
          raise Error, CAPTURE_ERROR_MESSAGE
        when '1111111111111111'
          Response.new(false, FAILURE_MESSAGE, {:paid_amount => money, :error => FAILURE_MESSAGE }, :test => true)
        else
          Response.new(true, SUCCESS_MESSAGE, {:paid_amount => money}, :test => true)
        end
      end

      def void(ident, options = {})
        case ident
        when '4111111111111111'
          raise Error, VOID_ERROR_MESSAGE
        when '1111111111111111'
          Response.new(false, FAILURE_MESSAGE, {:authorization => ident, :error => FAILURE_MESSAGE }, :test => true)
        else
          Response.new(true, SUCCESS_MESSAGE, {:authorization => ident}, :test => true)
        end
      end
      
      def store(creditcard, options = {})
        case creditcard.number
        when '4111111111111111'
          Response.new(true, SUCCESS_MESSAGE, {:billingid => '1'}, :test => true, :authorization => AUTHORIZATION )
        when '1111111111111111'
          Response.new(false, FAILURE_MESSAGE, {:billingid => nil, :error => FAILURE_MESSAGE }, :test => true)
        else
          raise Error, ERROR_MESSAGE
        end              
      end
      
      def unstore(identification, options = {})
        case identification
        when '4111111111111111'
          Response.new(true, SUCCESS_MESSAGE, {}, :test => true)
        when '1111111111111111'
          Response.new(false, FAILURE_MESSAGE, {:error => FAILURE_MESSAGE },:test => true)
        else
          raise Error, UNSTORE_ERROR_MESSAGE
        end
      end
    end
  end
end
