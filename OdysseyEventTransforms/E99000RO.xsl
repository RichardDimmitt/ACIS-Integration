<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <!-- ****************************************************************************-->
  <!-- **** template for E99000 Release Order Related Case Comment Information ****-->
  <!-- ****************************************************************************-->
  <xsl:template name="E99000RO">
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
        <!--Related Case Comment Information-->
        <Data Position='3' Length='54' Segment='roMessage'>
          <xsl:text>RELEASE ORDER ISSUED ON </xsl:text>
          <xsl:value-of select="/Integration/IntegrationConditions/IntegrationCondition/ProcessActionDate"/>
          <xsl:text> RELATED TO CASE</xsl:text>
        </Data>
        <!--Related Case Number-->
        <Data Position='4' Length='13' Segment='relatedCase'>
          <xsl:value-of select="CrossCaseNumber"/>
        </Data>
        <!--Filler-->
        <Data Position='5' Length='123' Segment='Filler' AlwaysNull="true" />
      </Event>
    </xsl:for-each>
  </xsl:template>
</xsl:stylesheet>


