Spree::Order.class_eval do
  private
    # need to handle zero params coming in when no amount due (due to voucher application)
    durably_decorate :update_params_payment_source, mode: 'soft', sha: '0571a0e4f43726a52b6191e5fbdda578904226df' do
      # respond_to check is necessary due to issue described in #2910
      if has_checkout_step?("payment") && self.payment?
        if @updating_params[:payment_source].present?
          if @updating_params[:order] && @updating_params[:order][:payments_attributes]
            source_params = @updating_params.delete(:payment_source)[@updating_params[:order][:payments_attributes].first[:payment_method_id].to_s]
  
            if source_params
              @updating_params[:order][:payments_attributes].first[:source_attributes] = source_params
            end
          end
        end

        if @updating_params[:order] && (@updating_params[:order][:payments_attributes] || @updating_params[:order][:existing_card])
          @updating_params[:order][:payments_attributes] ||= [{}]
          @updating_params[:order][:payments_attributes].first[:amount] = self.total
        end
      end
    end
end
