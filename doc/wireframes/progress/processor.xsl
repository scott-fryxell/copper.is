<stylesheet version="1.0" xmlns="http://www.w3.org/1999/XSL/Transform"
                          xmlns:xi="http://www.w3.org/2001/XInclude">

  <template match="node()|@*">
    <copy><apply-templates select="node()|@*"/></copy>
  </template>
<import href="agents.xsl"/>

  <template match="xi:include">
    <variable name="href"     select="@href"/>
    <variable name="xpointer" select="@xpointer"/>
    <variable name="a"  select="substring($xpointer, 5)"/>
    <variable name="b"  select="string-length($a)"/>
    <apply-templates select="document($href)" mode="include">
      <with-param name="id" select="substring($a, 1, $b - 2)"/>
    </apply-templates>
  </template>

  <template match="/" mode="include">
    <param name="id"/>
    <variable name="uid" select="id($id)"/>
    <variable name="ids" select="//*[@id = $id]"/>
    <choose>
      <when test="count($uid) = 0">
        <apply-templates select="$ids[1]"/>
      </when>
      <otherwise>
        <apply-templates select="$uid"/>
      </otherwise>
    </choose>
  </template>

</stylesheet>