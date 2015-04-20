# These helper methods can be called in your template to set variables to be used in the layout
# This module should be included in all views globally,
# to do so you may need to add this line to your ApplicationController
#   helper :layout
module LayoutHelper
  def cents_to_dollars(amount_in_cents)
    amount_in_dollars = "%.2f" % (amount_in_cents / 100.0)
  end
end
