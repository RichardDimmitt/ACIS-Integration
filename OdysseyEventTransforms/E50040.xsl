<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <!-- ********************************************************************-->
  <!-- ***************** template for E50040 BAC Change *******************-->
  <!-- ********************************************************************-->
  <xsl:template name="E50040">
    <xsl:for-each select="/Integration/Case/Charge/ChargeHistory[@Stage='Case Filing']/Additional/NCImpliedConsent[BreathTestResult]">
      <Event>
        <xsl:attribute name="EventID">
          <xsl:text>E50040</xsl:text>
        </xsl:attribute>
        <xsl:attribute name="TrailerRecord">
          <xsl:text>TotalEventRec</xsl:text>
        </xsl:attribute>
        <!--Flag-->
        <Data Position="1" Length="6" Segment="Flag">
          <xsl:text>E50040</xsl:text>
        </Data>
        <!--Offense Number-->
        <Data Position='2' Length='2' Segment='CROLNO'>
          <xsl:call-template name="GetLeadZero">
            <xsl:with-param name="Nbr" select="../../ChargeNumber"/>
          </xsl:call-template>
        </Data>
        <!--CraiOtherNumber-->
        <Data Position='3' Length='2' Segment='CraiOtherNumber'>
          <xsl:text>00</xsl:text>
        </Data>
        <!-- CriduiBefore -->
        <Data Position="4" Length="2" Segment="CRIDUI-BEFORE" AlwaysNull="true"/>
        <!-- Charged Blood Alcohol Content  -->
        <Data Position="5" Length="2" Segment="CRIDUI">
          <xsl:value-of select="substring-after(BreathTestResult,'.')"/>
        </Data>
        <!-- Padding at the end to form the total length -->
        <Data Position='6' Length='186' Segment='Filler' AlwaysNull="true"/>
      </Event>
    </xsl:for-each>
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



