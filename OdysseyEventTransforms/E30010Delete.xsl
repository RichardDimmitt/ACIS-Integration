<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <!-- ********************************************************************-->
  <!-- **** template for E30010 Trail Court Session Information Change*****-->
  <!-- **** Note, this is only sent if it's a District CR case          ***-->
  <!-- *** Change Log:                                                  ***-->
  <!-- *** 11/29/2021: Initial Creation - INT-6617                      ***-->
  <!-- ********************************************************************-->
  <xsl:template name="E30010Delete">
    <xsl:variable name="CaseType">
      <xsl:value-of select="substring(/Integration/Case/CaseNumber,3,3)"/>
    </xsl:variable>
    <xsl:if test="$CaseType!='CRS'">
      <Event>
        <xsl:attribute name="EventID">
          <xsl:text>E30010</xsl:text>
        </xsl:attribute>
        <xsl:attribute name="TrailerRecord">
          <xsl:text>TotalEventRec</xsl:text>
        </xsl:attribute>
        <!--Flag-->
        <Data Position='1' Length='6' Segment='Flag'>
          <xsl:text>E30010</xsl:text>
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
        <Data Position='8' Length='8' Segment='CRRTDT' AlwaysNull="true" />
        <!--Hearing Court Room Location-->
        <Data Position='9' Length='4' Segment='CRRRNO' AlwaysNull="true" />
        <!--Hearing Time Period Indicator (AM / PM)-->
        <Data Position='10' Length='2' Segment='CRRCRT' AlwaysNull="true" />
        <!--Padding at the end to form the total length-->
        <Data Position='11' Length='162' Segment='Filler' AlwaysNull="true" />
      </Event>
    </xsl:if>
  </xsl:template>
</xsl:stylesheet>





