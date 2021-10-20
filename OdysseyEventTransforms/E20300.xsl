<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <!-- **************************************************************************-->
  <!-- *** Template for E20300 Probation Violation Date Change                ***-->
  <!-- *** Change Log:                                                        ***-->
  <!-- *** 10-18-2021: Initial Creation, INT-6616                             ***-->
  <!-- **************************************************************************-->
  <xsl:template name="E20300">
    <xsl:if test="/Integration/Case/CaseEvent[EventType/ @Word='PV' and Deleted='false']">
      <xsl:variable name="probationViolationDate">
        <xsl:call-template name="formatDateYYYYMMDD">
          <xsl:with-param name="date" select="/Integration/Case/CaseEvent[EventType/ @Word='PV' and Deleted='false'][last()]/EventDate"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:variable name="probationViolationCodeList" select="'5030 5032 5033 5038 5040'"/>
      <xsl:variable name="maxProbationViolationCountNumber">
        <xsl:for-each select="/Integration/Case/Charge/ChargeHistory[@Stage='Case Filing' and Statute/StatuteCode[contains(concat(' ', $probationViolationCodeList, ' '), concat(' ', @Word, ' '))]]">
          <xsl:sort select="ChargeNumber" data-type="number" order="descending"/>
          <xsl:if test="position() = 1">
            <xsl:value-of select="ChargeNumber"/>
          </xsl:if>
        </xsl:for-each>
      </xsl:variable>
      <xsl:choose>
        <xsl:when test="/Integration/Case/CaseEvent[@Op='A']/ChargeID/@InternalChargeID">
          <xsl:for-each select="/Integration/Case/CaseEvent[@Op='A']/ChargeID">
            <xsl:variable name="chargeID">
              <xsl:value-of select="@InternalChargeID"/>
            </xsl:variable>
            <Event>
              <xsl:attribute name="EventID">
                <xsl:text>E20300</xsl:text>
              </xsl:attribute>
              <xsl:attribute name="TrailerRecord">
                <xsl:text>TotalEventRec</xsl:text>
              </xsl:attribute>
              <Data Position="1" Length="6" Segment="Flag">
                <xsl:text>E20300</xsl:text>
              </Data>
              <Data Position='2' Length='2' Segment='CROLNO'>
                <xsl:call-template name="GetLeadZero">
                  <xsl:with-param name="Nbr" select="/Integration/Case/Charge[@InternalChargeID=$chargeID]/ChargeHistory[@CurrentCharge='true']/ChargeNumber"/>
                </xsl:call-template>
              </Data>
              <Data Position='3' Length='2' Segment='CraiOtherNumber' AlwaysNull="true" />
              <Data Position='4' Length='8' Segment='CRIVDT-OLD' AlwaysNull="true" />
              <Data Position='5' Length='8' Segment='CRIVDT'>
                <xsl:value-of select="$probationViolationDate"/>
              </Data>
              <Data Position='6' Length='174' Segment='Filler' AlwaysNull="true"/>
            </Event>
          </xsl:for-each>
        </xsl:when>
        <xsl:when test="$maxProbationViolationCountNumber!=''">
          <Event>
            <xsl:attribute name="EventID">
              <xsl:text>E20300</xsl:text>
            </xsl:attribute>
            <xsl:attribute name="TrailerRecord">
              <xsl:text>TotalEventRec</xsl:text>
            </xsl:attribute>
            <Data Position="1" Length="6" Segment="Flag">
              <xsl:text>E20300</xsl:text>
            </Data>
            <Data Position='2' Length='2' Segment='CROLNO'>
              <xsl:call-template name="GetLeadZero">
                <xsl:with-param name="Nbr" select="$maxProbationViolationCountNumber"/>
              </xsl:call-template>
            </Data>
            <Data Position='3' Length='2' Segment='CraiOtherNumber' AlwaysNull="true" />
            <Data Position='4' Length='8' Segment='CRIVDT-OLD' AlwaysNull="true" />
            <Data Position='5' Length='8' Segment='CRIVDT'>
              <xsl:value-of select="$probationViolationDate"/>
            </Data>
            <Data Position='6' Length='174' Segment='Filler' AlwaysNull="true"/>
          </Event>
        </xsl:when>
        <xsl:otherwise/>
      </xsl:choose>
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
</xsl:stylesheet>















