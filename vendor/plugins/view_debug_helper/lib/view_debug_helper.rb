# Add something like the following to get debug output in separate popup
#  <botton onclick="show_debug_popup(); return false;">Show debug popup</button>
#  <%= debug_popup %>
#
# Alternatively if you want to render the table inline you can use <%= debug_inline %>
module ViewDebugHelper

  def debug_popup
    @raw = false
    popup_create do |script|
      script << add("<html><head><title>Rails Debug Console_#{@controller.class.name}</title>")
      script << add("<style type='text/css'> body {background-color:#FFFFFF;} </style>" )
      render_style(script)
      script << add('</head><body>' )
      render_table(script)
      script << add('</body></html>')
    end
  end

  def debug_inline
    @raw = true
    script = ""
    render_style(script)
    render_table(script)
    script
  end

  private

  IGNORE = ['template_root', 'template_class', 'response', '_response', 'template', 'session', '_session', 'url', 'params', '_params', 'variables_added', 'ignore_missing_templates', 'cookies', '_cookies', 'request', '_request', 'logger', 'flash', '_flash', 'headers', '_headers', 'before_filter_chain_aborted' ] unless const_defined?(:IGNORE)
  ASSIGN_IGNORE = [ "@_current_render", "@_first_render", "@_request",
                        "@assigns", "@assigns_added", "@authorization_engine",
                        "@cached_content_for_layout", "@content_for_layout",
                        "@content_for_title", "@controller", "@cookies",
                        "@current_user", "@current_user_session", "@helpers",
                        "@output_buffer", "@raw", "@real_format",
                        "@show_title", "@template", "@template_format",
                        "@view_paths"] unless const_defined?(:ASSIGN_IGNORE)

  def render_style(script)
    script << add("<style type='text/css'> table.debug {width:100%;border: 0;} table.debug th {text-align: left; background-color:#CCCCCC;font-weight: bold;} table.debug td {background-color:#EEEEEE; vertical-align: top;} table.debug td.key {color: blue;} table.debug td {color: green;}</style>" )
  end

  def render_table(script)
    script << add("<table class='debug'><colgroup id='key-column'/>" )
    popup_header(script, 'Rails Debug Console')

    if !@controller.request.request_parameters.nil? && !@controller.request.request_parameters.empty?
      popup_header(script, 'Request Parameters:')
      @controller.request.request_parameters.each do |key, value|
        popup_data(script, h(key), h(value.inspect).gsub(/,/, ',<br/>')) unless IGNORE.include?(key)
      end
    end

    if !@controller.request.path_parameters.nil? && !@controller.request.path_parameters.empty?
      popup_header(script, 'Path Parameters:')
      @controller.request.path_parameters.each do |key, value|
        popup_data(script, h(key), h(value.inspect).gsub(/,/, ',<br/>')) unless IGNORE.include?(key)
      end
    end

    if !@controller.request.query_parameters.nil? && !@controller.request.query_parameters.empty?
      popup_header(script, 'Query Parameters:')
      @controller.request.query_parameters.each do |key, value|
        popup_data(script, h(key), h(value.inspect).gsub(/,/, ',<br/>')) unless IGNORE.include?(key)
      end
    end

    dump_vars(script, 'Session Variables:', @controller.session.instance_variable_get("@data"))

    dump_vars(script, 'Flash Variables:', @controller.flash)

    if view_debug_display_assigns and not assigned_variables.empty?
      popup_header(script, 'Assigned Template Variables:')
      assigned_variables.each do |k|
        popup_data(script, h(k), dump_obj(instance_variable_get(k)))
      end
    end

    script << add('</table>')
  end

  # GROSS HAX LOL
  #
  # There is apparently not a sane way to get at the instance variables passed
  # to the ActionView::Base object by the controller, so use introspection and
  # a blacklist to block all the suspicious customers.
  def assigned_variables
    instance_variables.reject {|k| ASSIGN_IGNORE.include?(k)}
  end

  def dump_vars(script, header, vars)
    return if vars.nil? or vars.empty?
    popup_header(script, header)
    vars.each {|k, v| popup_data(script, h(k), dump_obj(v)) unless IGNORE.include?(k)}
  end

  def popup_header(script, heading)
    ; script << add( "<tr><th colspan='2'>#{heading}</th></tr>" );
  end

  def popup_data(script, key, value)
    ; script << add( "<tr><td class='key'>#{key}</td><td>#{value.gsub(/\r|\n/, '<br/>')}</td></tr>" );
  end

  def popup_create
    script = "<script language='javascript'>\n<!--\n"
    script << "function show_debug_popup() {\n"
    script << "_rails_console = window.open(\"\",\"#{@controller.class.name.tr(':','')}\",\"width=680,height=600,resizable,scrollbars=yes\");\n"
    yield script
    script << "_rails_console.document.close();\n"
    script << "}\n"
    script << "-->\n</script>"
  end

  def add(msg)
    if @raw
      msg
    else
      "_rails_console.document.write(\"#{msg}\")\n"
    end
  end

  def dump_obj(object)
    return '...' if object.class.name == 'ActionController::Pagination::Paginator'
    begin
      Marshal::dump(object)
      "<pre>#{h(object.to_yaml).gsub("  ", "&nbsp; ").gsub("\n", "<br/>" )}</pre>"
    rescue Object => e
      # Object couldn't be dumped, perhaps because of singleton methods -- this is the fallback
      "<pre>#{h(object.inspect)}</pre>"
    end
  end
end

class ActionController::Base
  alias :original_flash :flash
  def flash
    original_flash
  end
  @@view_debug_display_assigns = true
  cattr_accessor :view_debug_display_assigns
  helper_method :view_debug_display_assigns
end
