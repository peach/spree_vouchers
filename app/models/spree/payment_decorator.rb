module Spree
  Payment.class_eval do

#TODO: Upgrade soidus v2.4 this method not exist  
#    delegate :voucher?, to: :payment_method
#    durably_decorate :build_source, mode: 'soft', sha: '885462e553687d3221c410a8a85d19f553da36db' do
#      return unless new_record?
#      if source_attributes.present? && source.blank? && payment_method.try(:payment_source_class)
#        if payment_method.payment_source_class == Spree::Voucher
#          self.source = Voucher.where(number: source_attributes[:number]).first
#        elsif payment_method.payment_source_class
#          self.source = payment_method.payment_source_class.new(source_attributes)
#          self.source.payment_method_id = payment_method.id
#          self.source.user_id = self.order.user_id if self.order
#        end
#      end
#    end

    durably_decorate :invalidate_old_payments, mode: 'soft', sha: '6775533b1a50f5b2c5c61fe3012e838bee90bd54' do
      original_invalidate_old_payments unless voucher?
    end
  end
end
