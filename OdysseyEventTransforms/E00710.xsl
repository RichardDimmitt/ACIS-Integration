<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<!-- ********************************************************************-->
<!-- ************* template for E00710 Defendant SSN Change *************-->
<!-- ********************************************************************-->
  <xsl:template name="E00710">
    <xsl:variable name="DefendantID">
      <xsl:value-of select="/Integration/Case/Charge[1]/@InternalPartyID"/>
    </xsl:variable>
    <xsl:variable name="SSN">
      <xsl:value-of select="/Integration/Party[@InternalPartyID=$DefendantID]/SocialSecurityNumber[@Current='true']"/>
    </xsl:variable>

    <xsl:if test="/Integration/Party[@InternalPartyID=$DefendantID]/SocialSecurityNumber[@Current='true']">

    <Event>
      <xsl:attribute name="EventID">
        <xsl:text>E00710</xsl:text>
      </xsl:attribute>
      <xsl:attribute name="TrailerRecord">
        <xsl:text>TotalEventRec</xsl:text>
      </xsl:attribute>
      <!--Flag-->
      <Data Position="1" Length="6" Segment="Flag">
        <xsl:text>E00710</xsl:text>
      </Data>

      <!--CraiOffenseNumber-->
      <Data Position='2' Length='2' Segment='CraiOffenseNumber' AlwaysNull="true" />
      <!--CraiOtherNumber-->
      <Data Position='3' Length='2' Segment='CraiOtherNumber' AlwaysNull="true" />


      <!--Defendant SSN Old-->
      <Data Position='4' Length='9' Segment='CRRSSN-OLD' AlwaysNull="true"/>

      <!--Defendant SSN-->
      <Data Position='5' Length='9' Segment='CRRSSN'>
        <xsl:value-of select="translate($SSN, '-', '')"/>
      </Data>

      <!-- Padding at the end to form the total length 200 -->
      <Data Position='6' Length='172' Segment='Filler' AlwaysNull="true"/>
    </Event>

    </xsl:if>

  </xsl:template>
</xsl:stylesheet>
