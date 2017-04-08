module Spree
  Order.class_eval do
    def available_payment_methods
      @available_payment_methods ||= 
        ((PaymentMethod.available(:front_end) + PaymentMethod.available(:both)).uniq).reject { |pm| pm.class == Spree::PaymentMethod::Voucher }
    end

    def display_voucher_total
      Spree::Money.new(voucher_total, { currency: currency })
    end

    def display_total_minus_pending_vouchers
      Spree::Money.new(total_minus_pending_vouchers, { currency: currency })
    end

    def voucher_total
      (self.payments.select { |p| p.persisted? && p.voucher? && (p.pending? || p.checkout?)}.map(&:amount)).sum
    end

    def total_minus_pending_vouchers
      total - voucher_total
    end

    Spree::Order.state_machine.after_transition  :to => :complete, :do => :activate_vouchers
    Spree::Order.state_machine.after_transition  :to => :canceled, :do => :deactivate_vouchers

    def vouchers
      line_items.map(&:vouchers).flatten
    end

    private
      def deactivate_vouchers
        vouchers.each do |voucher|
          voucher.update_attributes(active: false)
        end
      end

      def activate_vouchers
        vouchers.each do |voucher|
          voucher.update_attributes(active: true)
        end
      end
  end
end
