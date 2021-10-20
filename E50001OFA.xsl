<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <!-- **************************************************************************-->
  <!-- ************* template for E50001 OFA Offense Record *********************-->
  <!-- *** Change Log:                                                        ***-->
  <!-- *** 10-18-2021: Initial Creation, INT-6616                             ***-->
  <!-- **************************************************************************-->
  <xsl:template name="E50001OFA">
    <xsl:if test="/Integration/Case/CaseEvent[@Op='A']/ChargeID/@InternalChargeID">
      <xsl:for-each select="/Integration/Case/CaseEvent[@Op='A']/ChargeID">
        <xsl:variable name="chargeID">
          <xsl:value-of select="@InternalChargeID"/>
        </xsl:variable>
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
              <xsl:with-param name="Nbr" select="/Integration/Case/Charge[@InternalChargeID=$chargeID]/ChargeHistory[@CurrentCharge='true']/ChargeNumber"/>
            </xsl:call-template>
          </Data>
          <!--Charged Offense Code-->
          <Data Position='3' Length='6' Segment='CROFFC'>
            <xsl:value-of select="/Integration/Case/Charge[@InternalChargeID=$chargeID]/ChargeHistory[@CurrentCharge='true']/Statute/StatuteCode/@Word"/>
          </Data>
          <!--Charged Offense Date-->
          <Data Position='4' Length='8' Segment='CROCDT'>
            <xsl:call-template name="formatDateYYYYMMDD">
              <xsl:with-param name="date" select="/Integration/Case/Charge[@InternalChargeID=$chargeID]/ChargeOffenseDate"/>
            </xsl:call-template>
          </Data>
          <!--Charge Offense Type (degree)-->
          <Data Position='5' Length='1' Segment='CRFCTP'>
            <xsl:value-of select="substring(/Integration/Case/Charge[@InternalChargeID=$chargeID]/ChargeHistory[@CurrentCharge='true']/Statute/Degree/@Word,1,1)"/>
          </Data>
          <!--Charged Freeform Offense Text-->
          <Data Position='6' Length='45' Segment='CRFCOF45' AlwaysNull="true"/>
          <!--Charged Freeform Offense General Statute Number-->
          <Data Position='7' Length='15' Segment='CRFCGS' AlwaysNull="true"/>
          <!--Worthless Check Amount-->
          <Data Position='8' Length='7' Segment='CRIWCA-X'>
            <xsl:text>0000000</xsl:text>
          </Data>
          <!--Charged Speed-->
          <Data Position='9' Length='3' Segment='CRICSP' AlwaysNull="true"/>
          <!--Posted Speed-->
          <Data Position='10' Length='2' Segment='CRICSZ' AlwaysNull="true"/>
          <!--Civil Revocation Effective / EndDate-->
          <Data Position='11' Length='8' Segment='CRICVRE' AlwaysNull="true" />
          <!--NA Vision Link Code-->
          <Data Position='12' Length='10' Segment='NA-VISIONLINKCODE' AlwaysNull="true" />
          <!-- Alcohol Content -->
          <Data Position='13' Length='2' Segment='CRDAC' AlwaysNull="true"/>
          <!-- Gang Related Indicator -->
          <Data Position='14' Length='1' Segment='CRDGANG' AlwaysNull="true"/>
          <!--CVR Provisional Date -->
          <Data Position='15' Length='8' Segment='CRICVRP' AlwaysNull="true"/>
          <!-- Padding at the end to form the total length -->
          <Data Position='16' Length='81' Segment='Filler' AlwaysNull="true"/>
        </Event>
      </xsl:for-each>
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



































