<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<!-- ********************************************************************-->
<!-- ******** template for E11410 Order for Arrest Date Change **********-->
<!-- ********************************************************************-->
  <xsl:template name="E11410">
    <Event>
      <xsl:attribute name="EventID">
        <xsl:text>E11410</xsl:text>
      </xsl:attribute>
      <xsl:attribute name="TrailerRecord">
        <xsl:text>TotalEventRec</xsl:text>
      </xsl:attribute>
      <!--Flag-->
      <Data Position="1" Length="6" Segment="Flag">
        <xsl:text>E11410</xsl:text>
      </Data>
      <Data Position='2' Length='2' Segment='CraiOffenseNumber' AlwaysNull="true"/>
      <Data Position='3' Length='2' Segment='CraiOtherNumber' AlwaysNull="true"/>
      <!-- Order for Arrest Date Before -->
      <Data Position='4' Length='8' Segment='CRIODT-OLD' AlwaysNull="true"/>
      <!-- Order for Arrest Date -->
      <Data Position='5' Length='8' Segment='CRIODT' AlwaysNull="true"/>
      <!-- Padding at the end to form the total length 200 -->
      <Data Position='6' Length='174' Segment='Filler' AlwaysNull="true"/>
    </Event>
  </xsl:template>
</xsl:stylesheet>


