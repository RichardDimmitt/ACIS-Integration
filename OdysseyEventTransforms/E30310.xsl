<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<!-- ********************************************************************-->
<!-- ************* template for E30310 Interpreter Used Flag ************-->
<!-- *** Change Log:                                                  ***-->
<!-- *** 7-15-2021: Updated to provide 'Y/N' based on if the case     ***-->
<!-- ***            event IUIA has been recorded on the case.INT-5946 ***-->
<!-- ********************************************************************-->
  <xsl:template name="E30310">
    <Event>
      <xsl:attribute name="EventID">
        <xsl:text>E30310</xsl:text>
      </xsl:attribute>
      <xsl:attribute name="TrailerRecord">
        <xsl:text>TotalEventRec</xsl:text>
      </xsl:attribute>
      <!--Flag-->
      <Data Position="1" Length="6" Segment="Flag">
        <xsl:text>E30310</xsl:text>
      </Data>
      <Data Position='2' Length='2' Segment='CraiOffenseNumber' AlwaysNull="true"/>
      <Data Position='3' Length='2' Segment='CraiOtherNumber' AlwaysNull="true"/>
      <!-- Interpreter Used (Y/N) Old -->
      <Data Position='4' Length='1' Segment='CRRINTU-OLD' AlwaysNull="true"/>
      <!-- Interpreter Used (Y/N)-->
      <Data Position='5' Length='1' Segment='CRRINTU'>
        <xsl:choose>
          <xsl:when test="/Integration/Case/CaseEvent[Deleted='false' and EventType/@Word='IUIA']">
            <xsl:text>Y</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>N</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </Data>
      <!-- Padding at the end to form the total length 200 -->
      <Data Position='6' Length='188' Segment='Filler' AlwaysNull="true"/>
    </Event>
  </xsl:template>
</xsl:stylesheet>


