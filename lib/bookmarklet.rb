# Perl version by John Gruber, adapted into Ruby from
# http://daringfireball.net/2007/03/javascript_bookmarklet_builder
require 'uri'
module Bookmarklet
  def Bookmarklet.escape(unformatted_source)
    source = unformatted_source
    source.gsub!(/^\s*\/\/.+\n/m, '')  # Kill comments.
    source.gsub!(/\t/m,   ' ')         # Tabs to spaces
    source.gsub!(/ +/m,   ' ')         # Space runs to one space
    source.gsub!(/^\s+/m, '')          # Kill line-leading whitespace
    source.gsub!(/\s+$/m, '')          # Kill line-ending whitespace
    source.gsub!(/\n/m,   '')          # Kill newlines
    # "javascript:" + URI.escape(source, /['" \x00-\x1f\x7f-\xff]/)
    "javascript:#{source}" 
  end
end
