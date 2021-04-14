<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <!-- ********************************************************************-->
  <!-- ******** template for E00660 Defendant Name and Alias Name**********-->
  <!-- ********************************************************************-->
  <xsl:template name="E00660CurrentName">
    <xsl:variable name="DefendantID">
      <xsl:value-of select="/Integration/Case/Charge[1]/@InternalPartyID"/>
    </xsl:variable>
      <Event>
        <xsl:attribute name="EventID">
          <xsl:text>E00660</xsl:text>
        </xsl:attribute>
        <xsl:attribute name="TrailerRecord">
          <xsl:text>TotalAliasRec</xsl:text>
        </xsl:attribute>
        <!--Flag-->
        <Data Position="1" Length="1" Segment="Flag">
          <xsl:text>A</xsl:text>
        </Data>
        <!--Defendant Name-->
        <Data Position="2" Length="28" Segment="CRRNAM">
          <xsl:value-of select="/Integration/Party[@InternalPartyID=$DefendantID]/PartyName[@Current='true']/FormattedName"/>
        </Data>
        <!--NA Vision Link Code-->
        <Data Position='3' Length='10' Segment='NA-VISIONLINKCODE' AlwaysNull="true" />
        <!-- Padding at the end to form the total length -->
        <Data Position='4' Length='36' Segment='Filler' AlwaysNull="true"/>
      </Event>
  </xsl:template>
</xsl:stylesheet>







