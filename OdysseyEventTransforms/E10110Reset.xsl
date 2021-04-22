<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<!-- ********************************************************************-->
<!-- ************* template for E10110 Service Date Reset  **************-->
<!-- ********************************************************************-->
    <xsl:template name="E10110Reset">
    <Event>
      <xsl:attribute name="EventID">
        <xsl:text>E10110</xsl:text>
      </xsl:attribute>
      <xsl:attribute name="TrailerRecord">
        <xsl:text>TotalEventRec</xsl:text>
      </xsl:attribute>
      <!--Flag-->
      <Data Position="1" Length="6" Segment="Flag">
        <xsl:text>E10110</xsl:text>
      </Data>
      <Data Position='2' Length='2' Segment='CraiServiceDateOLD' AlwaysNull="true"/>
      <Data Position='3' Length='2' Segment='CraiServiceDate' AlwaysNull="true"/>
      <!-- Service Date Old -->
      <Data Position='4' Length='8' Segment='CRRDTS-OLD' AlwaysNull="true"/>
      <!--Service Date-->
      <Data Position='5' Length='8' Segment='CRRDTS' AlwaysNull="true"/>
      <!-- Padding at the end to form the total length 200 -->
      <Data Position='6' Length='174' Segment='Filler' AlwaysNull="true"/>
    </Event>
  </xsl:template>
</xsl:stylesheet>

