<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<!-- ********************************************************************-->
<!-- ******** template for E11410 Order for Arrest Date Change **********-->
<!-- *** 10/22/2021 - Updated to send information based on whether a  ***-->
<!-- ***              probation violation exists on the case INT-6683 ***-->
<!-- ********************************************************************-->
  <xsl:template name="E11410OFA">
    <xsl:variable name="probationViolationCodeList" select="'5030 5032 5033 5038 5040'"/>
    <!-- If there are probation violations on the case, only send a message for those offenses. -->
    <xsl:choose>
      <xsl:when test="/Integration/Case/Charge/ChargeHistory[@Stage='Case Filing' and Statute/StatuteCode[contains(concat(' ', $probationViolationCodeList, ' '), concat(' ', @Word, ' '))]]">
        <xsl:for-each select="/Integration/Case/Charge/ChargeHistory[@Stage='Case Filing' and Statute/StatuteCode[contains(concat(' ', $probationViolationCodeList, ' '), concat(' ', @Word, ' '))]]">
          <Event>
            <xsl:attribute name="EventID">
              <xsl:text>E11410</xsl:text>
            </xsl:attribute>
            <xsl:attribute name="TrailerRecord">
              <xsl:text>TotalEventRec</xsl:text>
            </xsl:attribute>
            <!--Flag-->
            <Data Position="1" Length="6" Segment="Flag">
              <xsl:text>E11410</xsl:text>
            </Data>
            <Data Position='2' Length='2' Segment='CraiOffenseNumber'>
              <xsl:call-template name="GetLeadZero">
                <xsl:with-param name="Nbr" select="ChargeNumber"/>
              </xsl:call-template>
            </Data>
            <Data Position='3' Length='2' Segment='CraiOtherNumber' AlwaysNull="true"/>
            <!-- Order for Arrest Date Before -->
            <Data Position='4' Length='8' Segment='CRIODT-OLD' AlwaysNull="true"/>
            <!-- Order for Arrest Date -->
            <Data Position='5' Length='8' Segment='CRIODT'>
              <xsl:call-template name="formatDateYYYYMMDD">
                <xsl:with-param name="date" select="/Integration/IntegrationConditions/IntegrationCondition/ProcessActionDate"/>
              </xsl:call-template>
            </Data>
            <!-- Padding at the end to form the total length 200 -->
            <Data Position='6' Length='174' Segment='Filler' AlwaysNull="true"/>
          </Event>
        </xsl:for-each>
      </xsl:when>
      <!-- If there are no probation offenses on the case, send a message for each charge on the case. -->
      <xsl:otherwise>
        <xsl:for-each select="/Integration/Case/Charge/ChargeHistory[@Stage='Case Filing']">
          <Event>
            <xsl:attribute name="EventID">
              <xsl:text>E11410</xsl:text>
            </xsl:attribute>
            <xsl:attribute name="TrailerRecord">
              <xsl:text>TotalEventRec</xsl:text>
            </xsl:attribute>
            <!--Flag-->
            <Data Position="1" Length="6" Segment="Flag">
              <xsl:text>E11410</xsl:text>
            </Data>
            <Data Position='2' Length='2' Segment='CraiOffenseNumber'>
              <xsl:call-template name="GetLeadZero">
                <xsl:with-param name="Nbr" select="ChargeNumber"/>
              </xsl:call-template>
            </Data>
            <Data Position='3' Length='2' Segment='CraiOtherNumber' AlwaysNull="true"/>
            <!-- Order for Arrest Date Before -->
            <Data Position='4' Length='8' Segment='CRIODT-OLD' AlwaysNull="true"/>
            <!-- Order for Arrest Date -->
            <Data Position='5' Length='8' Segment='CRIODT'>
              <xsl:call-template name="formatDateYYYYMMDD">
                <xsl:with-param name="date" select="/Integration/IntegrationConditions/IntegrationCondition/ProcessActionDate"/>
              </xsl:call-template>
            </Data>
            <!-- Padding at the end to form the total length 200 -->
            <Data Position='6' Length='174' Segment='Filler' AlwaysNull="true"/>
          </Event>
        </xsl:for-each>
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






