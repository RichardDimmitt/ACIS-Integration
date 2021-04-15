<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <!-- ***************************************************************************-->
  <!-- ************* template for E99000 OFA Related Case Comment Information ****-->
  <!-- ***************************************************************************-->
  <xsl:template name="E99000OFA">
    <xsl:for-each select="/Integration/Case/CaseCrossReference/CaseCrossReferenceType[contains('REL RELLD',@Word)]/..">
      <Event>
        <xsl:attribute name="EventID">
          <xsl:text>E99000</xsl:text>
        </xsl:attribute>
        <xsl:attribute name="TrailerRecord">
          <xsl:text>TotalEventRec</xsl:text>
        </xsl:attribute>
        <!--Flag-->
        <Data Position="1" Length="6" Segment="Flag">
          <xsl:text>E99000</xsl:text>
        </Data>
        <!--Filler-->
        <Data Position='2' Length='4' Segment='Filler' AlwaysNull="true" />
        <!--Order For Arrest Reason-->
        <Data Position='3' Length='40' Segment='UNK-ofaReasonCode'>
          <xsl:text>OFA FTA-CS OR CITATION</xsl:text>
        </Data>
        <!--Order for Arrest Issue Date-->
        <Data Position='4' Length='54' Segment='CRIODT'>
          <xsl:text>ISSUED ON </xsl:text> <xsl:value-of select="/Integration/IntegrationConditions/IntegrationCondition/ProcessActionDate"/><xsl:text> RELATED TO CASE</xsl:text>
        </Data>
        <!--Related Case Number-->
        <Data Position='5' Length='13' Segment='UNK-relatedCase'>
          <xsl:value-of select="CrossCaseNumber"/>
        </Data>
        <!--Filler-->
        <Data Position='6' Length='83' Segment='Filler' AlwaysNull="true" />
      </Event>
   </xsl:for-each>
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



