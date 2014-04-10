# the asset path will include the asset_host with this change
class ActionController::Base
  def self.helpers
    @helper_proxy ||= begin
      proxy = ActionView::Base.new
      proxy.config = config.inheritable_copy
      proxy.extend(_helpers)
    end
  end
end
