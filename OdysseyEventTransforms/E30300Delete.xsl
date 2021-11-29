<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <!-- **************************************************************************-->
  <!-- ************* template for E30300 Interpreter Flag Delete  ***************-->
  <!-- *** Change Log:                                                        ***-->
  <!-- *** 11/29/2021: Initial Creation - INT-6617                            ***-->
  <!-- **************************************************************************-->
  <xsl:template name="E30300Delete">
    <Event>
      <xsl:attribute name="EventID">
        <xsl:text>E30300</xsl:text>
      </xsl:attribute>
      <xsl:attribute name="TrailerRecord">
        <xsl:text>TotalEventRec</xsl:text>
      </xsl:attribute>
      <!--Flag-->
      <Data Position="1" Length="6" Segment="Flag">
        <xsl:text>E30300</xsl:text>
      </Data>
      <!--CraiOffenseNumber-->
      <Data Position='2' Length='2' Segment='CraiOffenseNumber' AlwaysNull="true" />
      <!--CraiOtherNumber-->
      <Data Position='3' Length='2' Segment='CraiOtherNumber' AlwaysNull="true" />
      <!-- Interpreter Flag (SP/OTS/ASL) Old -->
      <Data Position='4' Length='3' Segment='CRRINT-OLD' AlwaysNull="true"/>
      <!-- Interpreter Flag (SP/OTS/ASL) -->
      <Data Position='5' Length='3' Segment='CRRINT' AlwaysNull="true"/>
      <!-- Padding at the end to form the total length 200 -->
      <Data Position='6' Length='184' Segment='Filler' AlwaysNull="true"/>
    </Event>
  </xsl:template>
</xsl:stylesheet>







