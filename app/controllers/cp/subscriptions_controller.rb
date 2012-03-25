class Cp::SubscriptionsController < Cp::BaseController
  before_filter :get_subscribable
  
  def subscribe
    @subscription = @subscribable.subscriptions.build(:subscriber_id => @current_user.id)
    if @subscription.save
      flash[:notice] = "You are now subscribed to this #{@subscribable.class.to_s}, and will receive an e-mail when there is new activity."
    else
      flash[:alert] = "Couldn't subscribe you to this #{@subscribable.class.to_s}."
    end
    redirect_to [:cp, @subscribable]
  end
  
  def unsubscribe
    if @subscribable.subscribers.delete(@current_user)
      flash[:notice] = "You are now unsubscribed from this #{@subscribable.class.to_s}, and will no longer receive e-mails when there is new activity."
    else
      flash[:alert] = "You are not subscribed to this #{@subscribable.class.to_s}!"
    end
    redirect_to [:cp, @subscribable]
  end
  
  protected
    def get_subscribable
      params.each do |name, value|
        if name =~ /(.+)_id$/
          return @subscribable = $1.classify.constantize.find(value)
        end
      end
      nil
    end
end
