<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <!-- ********************************************************************-->
  <!-- ************* template for E50001 Offense Record *******************-->
  <!-- ********************************************************************-->
  <xsl:template name="E50001">
    <xsl:for-each select="/Integration/Case/Charge/ChargeHistory[@Stage='Case Filing']">
      <Event>
        <xsl:attribute name="EventID">
          <xsl:text>E50001</xsl:text>
        </xsl:attribute>
        <xsl:attribute name="TrailerRecord">
          <xsl:text>TotalOffenseRec</xsl:text>
        </xsl:attribute>
        <!--Flag-->
        <Data Position="1" Length="1" Segment="Flag">
          <xsl:text>O</xsl:text>
        </Data>
        <!--Offense Number-->
        <Data Position='2' Length='2' Segment='CROLNO'>
          <xsl:call-template name="GetLeadZero">
            <xsl:with-param name="Nbr" select="ChargeNumber"/>
          </xsl:call-template>
        </Data>
        <!--Charged Offense Code-->
        <Data Position='3' Length='6' Segment='CROFFC'>
          <xsl:value-of select="Statute/StatuteCode/@Word"/>
        </Data>
        <!--Charged Offense Date-->
        <Data Position='4' Length='8' Segment='CROCDT'>
          <xsl:call-template name="formatDateYYYYMMDD">
            <xsl:with-param name="date" select="../ChargeOffenseDate"/>
          </xsl:call-template>
        </Data>
        <!--Charge Offense Type (degree)-->
        <Data Position='5' Length='1' Segment='CRFCTP'>
          <xsl:value-of select="substring(Statute/Degree/@Word,1,1)"/>
        </Data>
        <!--Charged Freeform Offense Text-->
        <Data Position='6' Length='45' Segment='CRFCOF45'>
          <xsl:value-of select="Statute/StatuteDescription"/>
        </Data>
        <!--Charged Freeform Offense General Statute Number-->
        <Data Position='7' Length='15' Segment='CRFCGS'>
          <xsl:value-of select="Statute/StatuteNumber"/>
        </Data>
        <!--Worthless Check Amount-->
        <Data Position='8' Length='7' Segment='CRIWCA-X' >
          <xsl:value-of select="Additional/NCWorthlessCheck/CheckAmount"/>
        </Data>
        <!--Charged Speed-->
        <Data Position='9' Length='3' Segment='CRICSP' >
          <xsl:value-of select="Additional//Speed[1]"/>
        </Data>
        <!--Posted Speed-->
        <Data Position='10' Length='2' Segment='CRICSZ'  >
          <xsl:value-of select="Additional//SpeedLimit[1]"/>
        </Data>
        <!--Civil Revocation Effective / EndDate-->
        <Data Position='11' Length='8' Segment='CRICVRE' AlwaysNull="true" />
        <!--NA Vision Link Code-->
        <Data Position='12' Length='13' Segment='NA-VISIONLINKCODE' AlwaysNull="true" />
        <!--Civil Revocation End Date-->
        <Data Position='13' Length='8' Segment='UNK-CvrEndDate' AlwaysNull="true" />
      </Event>
    </xsl:for-each>
  </xsl:template>
  <!-- ********************************************************************-->
  <!-- ****************** template for YYYYMMDD ***************************-->
  <!-- ********************************************************************-->
  <xsl:template name="formatDateYYYYMMDD">
    <xsl:param name="date"/>
    <xsl:if test="$date!=''">
      <xsl:variable name="month">
        <xsl:call-template name="GetLeadZero">
          <xsl:with-param name="Nbr" select="substring-before($date,'/')"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:variable name="daytemp" select="substring-after($date,'/')"/>
      <xsl:variable name="day">
        <xsl:call-template name="GetLeadZero">
          <xsl:with-param name="Nbr" select="substring-before($daytemp,'/')"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:variable name="year" select="substring-after($daytemp,'/')"/>
      <xsl:value-of select="concat($year,$month,$day)"/>
    </xsl:if>
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
  <xsl:template name="PaddWithZeros">
    <xsl:param name="Value"/>
    <xsl:param name="Length"/>
    <!-- ********************************************************************-->
  <!-- ****************** template for padding zeros **********************-->
  <!-- ********************************************************************-->
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
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of  select="$Value"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>



