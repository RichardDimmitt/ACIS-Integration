<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <!-- ********************************************************************-->
  <!-- ************* template for E10100 Service Record *******************-->
  <!-- ********************************************************************-->
  <xsl:template name="E10100">
    <Event>
      <xsl:attribute name="EventID">
        <xsl:text>E10100</xsl:text>
      </xsl:attribute>
      <!--Flag-->
      <Data Position="1" Length="1" Segment="Flag">
        <xsl:text>S</xsl:text>
      </Data>
      <!--Service Date-->
      <Data Position='2' Length='8' Segment='CRRDTS'>
        <xsl:call-template name="formatDateYYYYMMDD">
          <xsl:with-param name="date" select="/Integration/IntegrationConditions/IntegrationCondition/ProcessActionDate"/>
        </xsl:call-template>
      </Data>
      <!--Hearing Date-->
      <Data Position='3' Length='8' Segment='CRRTDT'>
        <xsl:call-template name="formatDateYYYYMMDD">
          <xsl:with-param name="date" select="/Integration/Case/Hearing[last()]/Setting/HearingDate"/>
        </xsl:call-template>
      </Data>
      <!--Hearing Time Period Indicator (AM / PM)-->
      <Data Position='4' Length='2' Segment='CRRCRT'>
        <xsl:value-of select="substring-after(/Integration/Case/Hearing[last()]/Setting/StartTime,' ')"/>
      </Data>
      <!--Hearing Court Room Location-->
      <Data Position='5' Length='4' Segment='CRRRNO'>
        <xsl:value-of select="/Integration/Case/Hearing[last()]/Setting/CourtResource[Type/@Word='LOC']/Code/@Word[1]"/>
      </Data>
      <!--Incident Number-->
      <Data Position='6' Length='20' Segment='CRRINC'>
        <xsl:value-of select="/Integration/Case/Charge/ReportingAgency/ControlNumber[1]"/>
      </Data>
      <!--Fingerprint Number-->
      <Data Position='7' Length='8' Segment='CRSCDT' >
        <xsl:value-of select="/Integration/Case/Charge/ChargeHistory[@Stage='Case Filing']/Additional/*[contains(name(),'NCFingerprint')]/CheckDigitNumber[1]"/>
      </Data>
      <!--Date of Arrest-->
      <Data Position='8' Length='8' Segment='CRSDOA'>
        <xsl:call-template name="formatDateYYYYMMDD">
          <xsl:with-param name="date" select="/Integration/Case/Charge/BookingAgency/ArrestDate[1]"/>
        </xsl:call-template>
      </Data>
      <!--FingerPrint Reason Code-->
      <Data Position='9' Length='2' Segment='CRRREA'>
        <xsl:choose>
        <!-- No charges have a finger print number -->
          <xsl:when test="(/Integration/Case/Charge[not (ChargeHistory[@Stage='Case Filing']/Additional/*[contains(name(),'NCFingerprint')]/CheckDigitNumber)])">
        <!-- No charges have a fingerprint override reason -->
            <xsl:if test="/Integration/Case/Charge[not(ChargeHistory[@Stage='Case Filing']/Additional/*[contains(name(),'NCFingerprint')]/Reason/@Word)]">
               <!-- Provide default value -->
              <xsl:value-of select="'NF'"/>
            </xsl:if>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="/Integration/Case/Charge/ChargeHistory[@Stage='Case Filing']/Additional/*[contains(name(),'NCFingerprint')]/Reason/@Word[1]"/>
          </xsl:otherwise>
        </xsl:choose>
      </Data>
      <!--NA Vision Link Code-->
      <Data Position='10' Length='10' Segment='NA-VISIONLINKCODE' AlwaysNull="true" />
      <!--Domestic Violence Indicator-->
      <Data Position='11' Length='1' Segment='CRRDOMVL' >
        <xsl:choose>
          <xsl:when test="(/Integration/Case/Charge//Additional/NCDomesticViolence/IsDomesticViolence='true')">
            <xsl:value-of select="'Y'"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="'N'"/>
          </xsl:otherwise>
        </xsl:choose>
      </Data>
      <!--Victim Rights Indicator-->
      <Data Position='12' Length='1' Segment='CRRVRA'>
        <xsl:choose>
          <xsl:when test="(/Integration/Case/Charge//Additional/NCVictimsRights/IsVictimsRights='true')">
            <xsl:value-of select="'Y'"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="'N'"/>
          </xsl:otherwise>
        </xsl:choose>
      </Data>
      <!-- Padding at the end to form the total length -->
      <Data Position='13' Length='27' Segment='Filler' AlwaysNull="true"/>
    </Event>
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
</xsl:stylesheet>






