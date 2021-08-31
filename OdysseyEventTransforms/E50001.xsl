<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <!-- **************************************************************************-->
  <!-- ************* template for E50001 Offense Record ************************-->
  <!-- *** Change Log:                                                        ***-->
  <!-- *** 4-23-2021: Updated the check amount to be the total amount         ***-->
  <!-- *** 6-01-2021: Updated check amount logic ref ODY-345442               ***-->
  <!-- *** 6-07-2021: Updated to include offense 9955 to reflect CVR INT-5646 ***-->
  <!-- *** 6-18-2021: Update the CVR CROCDT value to tbe the first charge     ***-->
  <!-- ***            offense date instead of the case event date INT-5755    ***-->
  <!-- *** 6-22-2021: Update the CROCDT value to be the offense date of the   ***-->
  <!-- ***            first charge instead of the ofense date of that specific***-->
  <!-- ***            offense INT-5779                                        ***-->
  <!-- *** 7-14-2021: Update the logic that includes the 9955 CVR offense to  ***-->
  <!-- ***            to look for the precence of one of three case event     ***-->
  <!-- ***            codes, EWCVR CVR PROVCVR                                ***-->
  <!-- *** 8-07-2021: Corrected CVR offense logic INT-6272                    ***-->
  <!-- *** 8-30-2021: Updated to support multiple speeding additional charge  ***-->
  <!-- ***            components INT-6354                                     ***-->
  <!-- **************************************************************************-->
  <xsl:template name="E50001">
    <xsl:variable name="maxChargeNumber">
      <xsl:for-each select="/Integration/Case/Charge/ChargeHistory">
        <xsl:sort select="ChargeNumber" data-type="number" order="descending"/>
        <xsl:if test="position() = 1">
          <xsl:value-of select="ChargeNumber"/>
        </xsl:if>
      </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="ActualSpeed">
      <xsl:choose>
        <xsl:when test="/Integration/Case/Charge/ChargeHistory[@Stage='Case Filing']/Additional/SpeedingFineCalculationByMPH">
          <xsl:value-of select="/Integration/Case/Charge/ChargeHistory[@Stage='Case Filing']/Additional/SpeedingFineCalculationByMPH/SpeedActual"/>
        </xsl:when>
        <xsl:when test="/Integration/Case/Charge/ChargeHistory[@Stage='Case Filing']/Additional/NCHighSpeedingExempt">
          <xsl:value-of select="/Integration/Case/Charge/ChargeHistory[@Stage='Case Filing']/Additional/NCHighSpeedingExempt/Speed"/>
        </xsl:when>
        <xsl:when test="/Integration/Case/Charge/ChargeHistory[@Stage='Case Filing']/Additional/NCHighSpeeding">
          <xsl:value-of select="/Integration/Case/Charge/ChargeHistory[@Stage='Case Filing']/Additional/NCHighSpeeding/Speed"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="'0'"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="PostedSpeed">
      <xsl:choose>
        <xsl:when test="/Integration/Case/Charge/ChargeHistory[@Stage='Case Filing']/Additional/SpeedingFineCalculationByMPH">
          <xsl:value-of select="/Integration/Case/Charge/ChargeHistory[@Stage='Case Filing']/Additional/SpeedingFineCalculationByMPH/SpeedPosted"/>
        </xsl:when>
        <xsl:when test="/Integration/Case/Charge/ChargeHistory[@Stage='Case Filing']/Additional/NCHighSpeedingExempt">
          <xsl:value-of select="/Integration/Case/Charge/ChargeHistory[@Stage='Case Filing']/Additional/NCHighSpeedingExempt/SpeedLimit"/>
        </xsl:when>
        <xsl:when test="/Integration/Case/Charge/ChargeHistory[@Stage='Case Filing']/Additional/NCHighSpeeding">
          <xsl:value-of select="/Integration/Case/Charge/ChargeHistory[@Stage='Case Filing']/Additional/NCHighSpeeding/SpeedLimit"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="'0'"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
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
            <xsl:with-param name="date" select="/Integration/Case/Charge[1]/ChargeOffenseDate"/>
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
          <xsl:variable name="CheckAmount">
            <xsl:choose>
              <xsl:when test="Additional/NCWorthlessCheck/CheckAmount">
                <xsl:value-of select="Additional/NCWorthlessCheck/CheckAmount"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="'0'"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
          <xsl:variable name="ServiceFee">
            <xsl:choose>
              <xsl:when test="Additional/NCWorthlessCheck/ServiceFee">
                <xsl:value-of select="Additional/NCWorthlessCheck/ServiceFee"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="'0'"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
          <xsl:variable name="ProcessingFee">
            <xsl:choose>
              <xsl:when test="Additional/NCWorthlessCheck/ProcessingFee">
                <xsl:value-of select="Additional/NCWorthlessCheck/ProcessingFee"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="'0'"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
          <xsl:variable name="TotalAmount">
            <xsl:value-of select="Additional/NCWorthlessCheck/TotalAmount"/>
          </xsl:variable>
          <xsl:variable name="ACISAmount">
            <xsl:choose>
              <xsl:when test="Additional/NCWorthlessCheck/TotalAmount">
                <xsl:value-of select="$TotalAmount"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="$CheckAmount+$ServiceFee+$ProcessingFee"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
          <xsl:choose>
            <xsl:when test="contains($ACISAmount,'.')='true'">
              <xsl:call-template name="PaddWithZeros">
                <xsl:with-param name="Value" select="translate($ACISAmount,'.','')"/>
                <xsl:with-param name="Length" select="7"/>
              </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
              <xsl:call-template name="PaddWithZeros">
                <xsl:with-param name="Value" select="concat($ACISAmount,'00')"/>
                <xsl:with-param name="Length" select="7"/>
              </xsl:call-template>
            </xsl:otherwise>
          </xsl:choose>
        </Data>
        <!--Charged Speed-->
        <Data Position='9' Length='3' Segment='CRICSP' >
          <xsl:choose>
            <xsl:when test="Additional/*[contains(name(),'Speeding')]">
              <xsl:call-template name="PaddWithZeros">
                <xsl:with-param name="Value" select="$ActualSpeed"/>
                <xsl:with-param name="Length" select="3"/>
              </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="'000'"/>
            </xsl:otherwise>
          </xsl:choose>
        </Data>
        <!--Posted Speed-->
        <Data Position='10' Length='2' Segment='CRICSZ'  >
          <xsl:choose>
            <xsl:when test="Additional/*[contains(name(),'Speeding')]">
              <xsl:call-template name="PaddWithZeros">
                <xsl:with-param name="Value" select="$PostedSpeed"/>
                <xsl:with-param name="Length" select="2"/>
              </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="'00'"/>
            </xsl:otherwise>
          </xsl:choose>
        </Data>
        <!--Civil Revocation Effective / EndDate-->
        <Data Position='11' Length='8' Segment='CRICVRE' AlwaysNull="true" />
        <!--NA Vision Link Code-->
        <Data Position='12' Length='10' Segment='NA-VISIONLINKCODE' AlwaysNull="true" />
        <!-- Padding at the end to form the total length -->
        <Data Position='13' Length='92' Segment='Filler' AlwaysNull="true"/>
      </Event>
    </xsl:for-each>
    <!-- ***************************************************** -->
    <!-- Section to build CVR Offense based on case event data -->
    <!-- ***************************************************** -->
    <xsl:variable name="CVREventCodeList" select="'EWCVR CVR PROVCVR'"/>
    <xsl:if test="/Integration/Case/CaseEvent[Deleted='false' and EventType[contains(concat(' ', $CVREventCodeList, ' '), concat(' ', @Word, ' '))]]">
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
            <xsl:with-param name="Nbr" select="$maxChargeNumber+1"/>
          </xsl:call-template>
        </Data>
        <!--Charged Offense Code-->
        <Data Position='3' Length='6' Segment='CROFFC'>
          <xsl:text>9955</xsl:text>
        </Data>
        <!--Charged Offense Date-->
        <Data Position='4' Length='8' Segment='CROCDT'>
          <xsl:call-template name="formatDateYYYYMMDD">
            <xsl:with-param name="date" select="/Integration/Case/Charge[1]/ChargeOffenseDate"/>
          </xsl:call-template>
        </Data>
        <!--Charge Offense Type (degree)-->
        <Data Position='5' Length='1' Segment='CRFCTP'>
          <xsl:text>T</xsl:text>
        </Data>
        <!--Charged Freeform Offense Text-->
        <Data Position='6' Length='45' Segment='CRFCOF45'>
          <xsl:text>CIVIL REVOCATION DRIVER'S LICENSE (30 DAYS)</xsl:text>
        </Data>
        <!--Charged Freeform Offense General Statute Number-->
        <Data Position='7' Length='15' Segment='CRFCGS'>
          <xsl:text>20-16.5</xsl:text>
        </Data>
        <!--Worthless Check Amount-->
        <Data Position='8' Length='7' Segment='CRIWCA-X' >
          <xsl:text>0000000</xsl:text>
        </Data>
        <!--Charged Speed-->
        <Data Position='9' Length='3' Segment='CRICSP' >
          <xsl:call-template name="PaddWithZeros">
            <xsl:with-param name="Value" select="$ActualSpeed"/>
            <xsl:with-param name="Length" select="3"/>
          </xsl:call-template>
        </Data>
        <!--Posted Speed-->
        <Data Position='10' Length='2' Segment='CRICSZ'  >
          <xsl:call-template name="PaddWithZeros">
            <xsl:with-param name="Value" select="$PostedSpeed"/>
            <xsl:with-param name="Length" select="2"/>
          </xsl:call-template>
        </Data>
        <!--Civil Revocation Effective / EndDate-->
        <Data Position='11' Length='8' Segment='CRICVRE'>
          <xsl:call-template name="formatDateYYYYMMDD">
            <xsl:with-param name="date" select="/Integration/Case/CaseEvent[Deleted='false' and EventType[contains(concat(' ', $CVREventCodeList, ' '), concat(' ', @Word, ' '))]]/EventDate"/>
          </xsl:call-template>
        </Data>
        <!--NA Vision Link Code-->
        <Data Position='12' Length='10' Segment='NA-VISIONLINKCODE' AlwaysNull="true" />
        <!-- Padding at the end to form the total length -->
        <Data Position='13' Length='92' Segment='Filler' AlwaysNull="true"/>
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
      <xsl:when  test="(string-length($Nbr) &lt; 2)">
        <xsl:value-of  select="concat('0',$Nbr)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of  select="$Nbr"/>
      </xsl:otherwise>
    </xsl:choose>
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
        <xsl:if test="($PaddingNeeded = 5)">
          <xsl:value-of  select="concat('00000',$Value)"/>
        </xsl:if>
        <xsl:if test="($PaddingNeeded = 6)">
          <xsl:value-of  select="concat('000000',$Value)"/>
        </xsl:if>
        <xsl:if test="($PaddingNeeded = 7)">
          <xsl:value-of  select="concat('0000000',$Value)"/>
        </xsl:if>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of  select="$Value"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>




























