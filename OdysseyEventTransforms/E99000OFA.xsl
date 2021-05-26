<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <!-- ***************************************************************************-->
  <!-- ************* template for E99000 OFA Related Case Comment Information ****-->
  <!-- ***************************************************************************-->
  <xsl:template name="E99000OFA">
    <xsl:choose>
      <xsl:when test="/Integration/Case[not(CaseCrossReference/CaseCrossReferenceType/(@CurrentIterator)]">
        <xsl:call-template name="RelatedCaseNumbers"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="LeadCaseNumber"/>
        <xsl:call-template name="RelatedCaseNumbers"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <!-- ********************************************************************-->
  <!-- ********** template for Lead Case                   ****************-->
  <!-- ********************************************************************-->
  <xsl:template name="LeadCaseNumber">
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
        <xsl:text>ISSUED ON </xsl:text>
        <xsl:value-of select="/Integration/IntegrationConditions/IntegrationCondition/ProcessActionDate"/>
        <xsl:text> RELATED TO CASE</xsl:text>
      </Data>
      <!--Related Case Number-->
      <Data Position='5' Length='13' Segment='UNK-relatedCase'>
        <xsl:value-of select="/Integration/Case/CaseNumber"/>
      </Data>
      <!--Filler-->
      <Data Position='6' Length='83' Segment='Filler' AlwaysNull="true" />
    </Event>
  </xsl:template>
  <!-- ********************************************************************-->
  <!-- ********** template for Related Cases               ****************-->
  <!-- ********************************************************************-->
  <xsl:template name="RelatedCaseNumbers">
    <xsl:for-each select="/Integration/Case/CaseCrossReference/CaseCrossReferenceType[@Word='REL' and not(@CurrentIterator)]/..">
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
          <xsl:text>ISSUED ON </xsl:text>
          <xsl:value-of select="/Integration/IntegrationConditions/IntegrationCondition/ProcessActionDate"/>
          <xsl:text> RELATED TO CASE</xsl:text>
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
</xsl:stylesheet>






