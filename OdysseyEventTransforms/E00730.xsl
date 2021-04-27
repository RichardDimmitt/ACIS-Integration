<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <!-- ***************************************************************************-->
  <!-- *** template for E00730 FingerPrint Number, Date of Arrest Change *********-->
  <!-- ***************************************************************************-->
  <xsl:template name="E00730">
    <xsl:if test="/Integration/Case/Charge[BookingAgency/ArrestDate][1]/BookingAgency/ArrestDate">
      <Event>
        <xsl:attribute name="EventID">
          <xsl:text>E00730</xsl:text>
        </xsl:attribute>
        <xsl:attribute name="TrailerRecord">
          <xsl:text>TotalEventRec</xsl:text>
        </xsl:attribute>
        <!-- Flag -->
        <Data Position="1" Length="6" Segment="Flag">
          <xsl:text>E00730</xsl:text>
        </Data>
        <!--CraiOffenseNumber-->
        <Data Position='2' Length='2' Segment='CraiOffenseNumber' AlwaysNull="true" />
        <!--CraiOtherNumber-->
        <Data Position='3' Length='2' Segment='CraiOtherNumber' AlwaysNull="true" />
        <!-- Fingerprint Number Old -->
        <Data Position='4' Length='7' Segment='CRSCDT-OLD' AlwaysNull="true"/>
        <!-- Date of Arrest Old -->
        <Data Position='5' Length='8' Segment='CRSDOA-OLD' AlwaysNull="true"/>
        <!-- Fingerprint Number -->
        <Data Position='6' Length='7' Segment='CRSCDT'>
          <xsl:value-of select="/Integration/Case/Charge/ChargeHistory[@Stage='Case Filing']/Additional/*[contains(name(),'NCFingerprint')]/CheckDigitNumber[1]"/>
        </Data>
        <!-- Date of Arrest -->
        <Data Position='7' Length='8' Segment='CRSDOA'>
          <xsl:call-template name="formatDateYYYYMMDD">
            <xsl:with-param name="date" select="/Integration/Case/Charge[BookingAgency/ArrestDate][1]/BookingAgency/ArrestDate"/>
          </xsl:call-template>
        </Data>
        <!-- Filler -->
        <Data Position='8' Length='160' Segment='Filler' AlwaysNull="true"/>
      </Event>
    </xsl:if>
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
      <xsl:when test="(string-length($Nbr) &lt; 2)">
        <xsl:value-of select="concat('0',$Nbr)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$Nbr"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>



