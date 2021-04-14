<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:template name="E30060">
  <!-- ************************************************************************-->
  <!-- **** template for E30060 Superior Court Session Information Change *****-->
  <!-- **** Note, this is only sent if it's a Superior CRS case                -->
  <!-- ************************************************************************-->
    <xsl:variable name="CaseType">
      <xsl:value-of select="substring(/Integration/Case/CaseNumber,3,3)"/>
    </xsl:variable>
    <xsl:if test="$CaseType='CRS'">
      <Event>
        <xsl:attribute name="EventID">
          <xsl:text>E30060</xsl:text>
        </xsl:attribute>
        <xsl:attribute name="TrailerRecord">
          <xsl:text>TotalEventRec</xsl:text>
        </xsl:attribute>
        <!--Flag-->
        <Data Position='1' Length='6' Segment='Flag'>
          <xsl:text>E30060</xsl:text>
        </Data>
        <!--Filler-->
        <Data Position='2' Length='4' Segment='Filler' AlwaysNull="true" />
        <!--Unknown - Assume case type from File number-->
        <Data Position='3' Length='0' Segment='CraiCaseTypeOld' AlwaysNull="true" />
        <!--Hearing Date-->
        <Data Position='4' Length='8' Segment='CRRTDTOld' AlwaysNull="true" />
        <!--Hearing Court Room Location-->
        <Data Position='5' Length='4' Segment='CRRRNOOld' AlwaysNull="true" />
        <!--Hearing Time Period Indicator (AM / PM)-->
        <Data Position='6' Length='2' Segment='CRRCRTOld' AlwaysNull="true" />
        <!--Unknown - Assume case type from File number-->
        <Data Position='7' Length='0' Segment='CraiCaseType' AlwaysNull="true" />
        <!--Hearing Date-->
        <Data Position='8' Length='8' Segment='CRRTDT'>
          <xsl:call-template name="formatDateYYYYMMDD">
            <xsl:with-param name="date" select="/Integration/Case/Hearing[last()]/Setting/HearingDate"/>
          </xsl:call-template>
        </Data>
        <!--Hearing Court Room Location-->
        <Data Position='9' Length='4' Segment='CRRRNO'>
          <xsl:value-of select="/Integration/Case/Hearing[last()]/Setting/CourtResource[Type/@Word='LOC']/Code/@Word[1]"/>
        </Data>
        <!--Hearing Time Period Indicator (AM / PM)-->
        <Data Position='10' Length='2' Segment='CRRCRT'>
          <xsl:value-of select="substring-after(/Integration/Case/Hearing[last()]/Setting/StartTime,' ')"/>
        </Data>
        <!--Padding at the end to form the total length-->
        <Data Position='11' Length='162' Segment='Filler' AlwaysNull="true" />
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
</xsl:stylesheet>


