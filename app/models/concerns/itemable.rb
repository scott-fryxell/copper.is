module Itemable
  extend ActiveSupport::Concern

  included do
    @nested = false
  end

  def as_item_attributes

    unless @nested
      %Q[
        itemscope itemtype='page'
        itemid='#{self.item_id}'
        itemprop='author_state'
        data-author_state='#{self.author_state}'
      ]
    end
  end

  def item_id
    "/pages/#{self.id}"
  end

  def nested?
    return @nested
  end

end
