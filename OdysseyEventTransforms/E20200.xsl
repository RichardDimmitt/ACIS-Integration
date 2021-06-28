<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <!-- ********************************************************************-->
  <!-- ************** template for E20200 FTA Date Change *****************-->
  <!-- ********************************************************************-->
  <xsl:template name="E20200">
    <xsl:for-each select="/Integration/Case/Charge/ChargeHistory[@Stage='Case Filing']">
      <Event>
        <xsl:attribute name="EventID">
          <xsl:text>E20200</xsl:text>
        </xsl:attribute>
        <xsl:attribute name="TrailerRecord">
          <xsl:text>TotalEventRec</xsl:text>
        </xsl:attribute>
        <!--Flag-->
        <Data Position="1" Length="6" Segment="Flag">
          <xsl:text>E20200</xsl:text>
        </Data>
        <!--Offense Number-->
        <Data Position='2' Length='2' Segment='CROLNO'>
          <xsl:call-template name="GetLeadZero">
            <xsl:with-param name="Nbr" select="ChargeNumber"/>
          </xsl:call-template>
        </Data>
        <!--CraiOtherNumber-->
        <Data Position='3' Length='2' Segment='CraiOtherNumber' AlwaysNull="true" />
        <!--Failure to Appear Dater Before-->
        <Data Position='4' Length='8' Segment='CRDVIO-OLD' AlwaysNull="true" />
        <!--Failure to Appear Date After-->
        <Data Position='5' Length='8' Segment='CRDVIO'>
          <xsl:call-template name="formatDateYYYYMMDD">
            <xsl:with-param name="date" select="/Integration/Case/CaseEvent[EventType[contains('EWFTA FTA', @Word)] and Deleted='false'][last()]/EventDate"/>
          </xsl:call-template>
        </Data>
        <!-- Padding at the end to form the total length -->
        <Data Position='6' Length='174' Segment='Filler' AlwaysNull="true"/>
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







