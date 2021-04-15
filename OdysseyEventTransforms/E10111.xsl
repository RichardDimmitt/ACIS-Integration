<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <!-- ***************************************************************************-->
  <!-- ************* template for E10111 Forward or Return to Clerk **************-->
  <!-- ***************************************************************************-->
  <xsl:template name="E10111">
    <Event>
      <xsl:attribute name="EventID">
        <xsl:text>E10111</xsl:text>
      </xsl:attribute>
      <xsl:attribute name="TrailerRecord">
        <xsl:text>TotalEventRec</xsl:text>
      </xsl:attribute>
      <!--Flag-->
      <Data Position="1" Length="6" Segment="Flag">
        <xsl:text>E10111</xsl:text>
      </Data>
      <!--Filler-->
      <Data Position='2' Length='4' Segment='FILLER' AlwaysNull="true" />
      <!--Re-delivery date-->
      <Data Position='3' Length='8' Segment='CRRDTP' AlwaysNull="true" />
      <!--Previous Return to Clerk Date-->
      <Data Position='4' Length='8' Segment='CRRUSV' AlwaysNull="true" />
      <!--Re-delivery date-->
      <Data Position='5' Length='8' Segment='CRRDTP'>
        <xsl:call-template name="formatDateYYYYMMDD">
          <xsl:with-param name="date" select="/Integration/IntegrationConditions/IntegrationCondition/ProcessActionDate"/>
        </xsl:call-template>
      </Data>
      <!--Previous Return to Clerk Date-->
      <Data Position='6' Length='8' Segment='CRRUSV' AlwaysNull="true" />
      <!--Filler-->
      <Data Position='7' Length='158' Segment='FILLER' AlwaysNull="true" />
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






