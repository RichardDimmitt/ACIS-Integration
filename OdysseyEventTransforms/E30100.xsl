<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <!-- ********************************************************************-->
  <!-- ********* template for E30100 Case Reinstated Indicator Change *****-->
  <!-- *** 6/21/2021: Update to only send one event for count one as    ***-->
  <!-- ***            opposed to sending an event for each charge       ***-->
  <!-- ***            due to ALI errors reported: INT-5776              ***-->
  <!-- ********************************************************************-->
  <xsl:template name="E30100">
      <Event>
        <xsl:attribute name="EventID">
          <xsl:text>E30100</xsl:text>
        </xsl:attribute>
        <xsl:attribute name="TrailerRecord">
          <xsl:text>TotalEventRec</xsl:text>
        </xsl:attribute>
        <!--Flag-->
        <Data Position="1" Length="6" Segment="Flag">
          <xsl:text>E30100</xsl:text>
        </Data>
        <!--Offense Number-->
        <Data Position='2' Length='2' Segment='CROLNO'>
          <xsl:text>01</xsl:text>
        </Data>
        <!--CraiOtherNumber-->
        <Data Position='3' Length='2' Segment='CraiOtherNumber' AlwaysNull="true"/>
        <!-- Case Reinstatment Code - Before -->
        <Data Position="4" Length="1" Segment="CRRRNS-OLD" AlwaysNull="true"/>
        <!-- Case Reinstatment Code  -->
        <Data Position="5" Length="1" Segment="CRRRNS">
          <xsl:text>Y</xsl:text>
        </Data>
        <!-- Padding at the end to form the total length -->
        <Data Position='6' Length='188' Segment='Filler' AlwaysNull="true"/>
      </Event>
  </xsl:template>
  <!-- ********************************************************************-->
  <!-- ****************** template for leading zeros **********************-->
  <!-- ********************************************************************-->
  <xsl:template name="GetLeadZero">
    <xsl:param name="Nbr"/>
    <xsl:choose>
      <xsl:when  test="(string-length($Nbr) &lt; 2)">
        <xsl:value-of  select="concat('0',$Nbr)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of  select="$Nbr"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>






