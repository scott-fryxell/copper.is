<?xml version="1.0" encoding="UTF-8"?>
<stylesheet version="1.0" xmlns="http://www.w3.org/1999/XSL/Transform" 
                          xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                          xmlns:html="http://www.w3.org/1999/xhtml">

  <!-- Insert IE-only code -->
  <template match="html:head[string(system-property('xsl:vendor')) = 'Microsoft']">
    <element name="head" namespace="http://www.w3.org/1999/xhtml">
      <element name="script" namespace="http://www.w3.org/1999/xhtml">
        (function() {
          var l = String.fromCharCode(60), r = String.fromCharCode(62);
          document.write(l + 'object id="AdobeSVG"   classid="clsid:78156A80-C6A1-4BBF-8E6A-3CD390EEB4E2"' + r + l + '/object' + r);
          document.namespaces("svg").doImport("#AdobeSVG");
        })();
      </element>
      <element name="script" namespace="http://www.w3.org/1999/xhtml">
        <attribute name="for">window</attribute>
        <attribute name="event">onbeforeunload</attribute>
        <text>
          document.body.innerHTML = "";
        </text>
      </element>
      <apply-templates select="node()|@*"/>
    </element>
  </template>

  <!-- Prefix SVG elements if Internet Explorer -->
  <template match="*[string(system-property('xsl:vendor')) = 'Microsoft' and namespace-uri()='http://www.w3.org/2000/svg']">
    <element name="svg:{local-name()}">
      <apply-templates select="node()|@*[name()!='xmlns']"/>
    </element>
  </template>

</stylesheet>