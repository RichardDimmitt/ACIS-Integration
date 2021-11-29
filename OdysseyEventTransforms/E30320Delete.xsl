<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<!-- **************************************************************************-->
<!-- ************* template for E30320 Interpreter Freeform Language **********-->
<!-- *** Change Log:                                                        ***-->
<!-- *** 11/29/2021: Initial Creation - INT-6617                            ***-->
<!-- **************************************************************************-->
  <xsl:template name="E30320Delete">
    <Event>
      <xsl:attribute name="EventID">
        <xsl:text>E30320</xsl:text>
      </xsl:attribute>
      <xsl:attribute name="TrailerRecord">
        <xsl:text>TotalEventRec</xsl:text>
      </xsl:attribute>
      <!--Flag-->
      <Data Position="1" Length="6" Segment="Flag">
        <xsl:text>E30320</xsl:text>
      </Data>
      <Data Position='2' Length='2' Segment='CraiServiceDateOLD' AlwaysNull="true"/>
      <Data Position='3' Length='2' Segment='CraiServiceDate' AlwaysNull="true"/>
      <!-- Interpreter Freeform Language Old -->
      <Data Position='4' Length='14' Segment='CRRINTFF-OLD' AlwaysNull="true"/>
      <!-- Interpreter Freeform Language -->
      <Data Position='5' Length='14' Segment='CRRINTFF' AlwaysNull="true"/>
      <!-- Padding at the end to form the total length 200 -->
      <Data Position='6' Length='162' Segment='Filler' AlwaysNull="true"/>
    </Event>
  </xsl:template>
</xsl:stylesheet>


