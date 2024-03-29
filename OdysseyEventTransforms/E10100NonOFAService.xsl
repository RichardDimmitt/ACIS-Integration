<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <!-- ************************************************************************************-->
  <!-- **************** template for E10100 Service Record On Non-OFA Service**************-->
  <!-- *** Change Log:                                                                  ***-->
  <!-- *** 8/11/2021: Initial Creation: INT-6269                                        ***-->
  <!-- *** 8/11/2021: Updated hearing information to pull from the most recent hearing  ***-->
  <!-- ***            and setting and also corrected substring logic on court room      ***-->
  <!-- ***            location INT-6273                                                 ***-->
  <!-- ************************************************************************************-->
  <xsl:template name="E10100NonOFAService">
    <xsl:variable name="FelonyPresent">
      <xsl:choose>
        <xsl:when test="substring(/Integration/Case/Charge/ChargeHistory[@Stage='Case Filing']/Statute/Degree/@Word,1,1)='F'">
          <xsl:value-of select="'1'"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="'0'"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="CurrentSettingID">
      <xsl:value-of select="/Integration/Case/Hearing[Setting[not(Cancelled='True')]][last()]/Setting[not(Cancelled='True')][last()]/@InternalSettingID"/>
    </xsl:variable>
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
            <xsl:with-param name="date" select="/Integration/Case/Hearing/Setting[@InternalSettingID=$CurrentSettingID]/HearingDate"/>
          </xsl:call-template>
      </Data>
      <!--Hearing Time Period Indicator (AM / PM)-->
      <Data Position='4' Length='2' Segment='CRRCRT'>
          <xsl:value-of select="substring-after(/Integration/Case/Hearing/Setting[@InternalSettingID=$CurrentSettingID]//StartTime,' ')"/>
      </Data>
      <!--Hearing Court Room Location-->
      <Data Position='5' Length='4' Segment='CRRRNO'>
          <xsl:value-of select="substring-after(/Integration/Case/Hearing/Setting[@InternalSettingID=$CurrentSettingID]/CourtResource[Type/@Word='LOC']/Code/@Word[1],'-')"/>
      </Data>
      <!--Incident Number-->
      <Data Position='6' Length='20' Segment='CRRINC'>
        <xsl:value-of select="/Integration/Case/Charge/ReportingAgency/ControlNumber[1]"/>
      </Data>
      <!--Fingerprint Number-->
      <Data Position='7' Length='8' Segment='CRSCDT' AlwaysNull="true" />
      <!--Date of Arrest-->
      <Data Position='8' Length='8' Segment='CRSDOA' AlwaysNull="true" />
      <!--FingerPrint Reason Code-->
      <Data Position='9' Length='2' Segment='CRRREA'>
       <!-- Send the Finger Print Reason Code of 'NF - Not Fingerprinted' if a felony charge is on the case -->
       <!-- Otherwise send a blank value -->
        <xsl:choose>
          <xsl:when test="$FelonyPresent = 1">
            <xsl:value-of select="'NF'"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="' '"/>
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
            <xsl:value-of select="' '"/>
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
            <xsl:value-of select="' '"/>
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



















