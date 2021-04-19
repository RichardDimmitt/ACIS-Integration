<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<!-- ********************************************************************-->
<!-- ************* template for E00725 Defendant DL Change **************-->
<!-- ********************************************************************-->
  <xsl:template name="E00725">
    <xsl:variable name="DefendantID">
      <xsl:value-of select="/Integration/Case/Charge[1]/@InternalPartyID"/>
    </xsl:variable>
    <Event>
      <xsl:attribute name="EventID">
        <xsl:text>E00725</xsl:text>
      </xsl:attribute>
      <xsl:attribute name="TrailerRecord">
        <xsl:text>TotalEventRec</xsl:text>
      </xsl:attribute>
      <!--Flag-->
      <Data Position="1" Length="1" Segment="Flag">
        <xsl:text>E00725</xsl:text>
      </Data>
      <!--CraiOffenseNumber-->
      <Data Position='2' Length='2' Segment='CraiOffenseNumber' AlwaysNull="true" />
      <!--CraiOtherNumber-->
      <Data Position='3' Length='2' Segment='CraiOtherNumber' AlwaysNull="true" />
      <!--Defendant DL Number Old-->
      <Data Position='4' Length='25' Segment='CRRDLNOLD' AlwaysNull="true"/>
      <!--Defendant DL State Old-->
      <Data Position='4' Length='2' Segment='CRRSILOLD' AlwaysNull="true"/>
      <!--Defendant DL Number-->
      <Data Position='5' Length='25' Segment='CRRDLN'>
        <xsl:value-of select="/Integration/Party[@InternalPartyID=$DefendantID]/DriversLicense[@Current='true']/DriversLicenseNumber"/>
      </Data>
      <!--Defendant DL State-->
      <Data Position='6' Length='2' Segment='CRRSIL'>
        <xsl:value-of select="/Integration/Party[@InternalPartyID=$DefendantID]/DriversLicense[@Current='true']/DriversLicenseState/@Word"/>
      </Data>
      <!-- Padding at the end to form the total length 200 -->
      <Data Position='7' Length='136' Segment='Filler' AlwaysNull="true"/>
    </Event>
  </xsl:template>
  <!-- ********************************************************************-->
  <!-- ****************** template for padding zeros **********************-->
  <!-- ********************************************************************-->
  <xsl:template name="PaddWithZeros">
    <xsl:param name="Value"/>
    <xsl:param name="Length"/>
    <xsl:variable name="PaddingNeeded" select="$Length - string-length($Value)"/>
    <xsl:choose>
      <xsl:when  test="($PaddingNeeded &gt; 0)">
        <xsl:if test="($PaddingNeeded = 1)">
          <xsl:value-of  select="concat('0',$Value)"/>
        </xsl:if>
        <xsl:if test="($PaddingNeeded = 2)">
          <xsl:value-of  select="concat('00',$Value)"/>
        </xsl:if>
        <xsl:if test="($PaddingNeeded = 3)">
          <xsl:value-of  select="concat('000',$Value)"/>
        </xsl:if>
        <xsl:if test="($PaddingNeeded = 4)">
          <xsl:value-of  select="concat('0000',$Value)"/>
        </xsl:if>
      </xsl:when>
      <xsl:if test="($PaddingNeeded = 5)">
        <xsl:value-of  select="concat('00000',$Value)"/>
      </xsl:if>
      <xsl:if test="($PaddingNeeded = 6)">
        <xsl:value-of  select="concat('000000',$Value)"/>
      </xsl:if>
      <xsl:if test="($PaddingNeeded = 7)">
        <xsl:value-of  select="concat('0000000',$Value)"/>
      </xsl:if>
      <xsl:if test="($PaddingNeeded = 8)">
        <xsl:value-of  select="concat('00000000',$Value)"/>
      </xsl:if>
      <xsl:if test="($PaddingNeeded = 9)">
        <xsl:value-of  select="concat('000000000',$Value)"/>
      </xsl:if>
      <xsl:otherwise>
        <xsl:value-of  select="$Value"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>

