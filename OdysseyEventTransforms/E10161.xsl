<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <!-- ********************************************************************-->
  <!-- ************* template for E10161 OCA Number Change ****************-->
  <!-- ********************************************************************-->
  <xsl:template name="E10161">
    <xsl:if test="/Integration/Case/CaseCrossReference[CaseCrossReferenceType/@Word='LECN']">
      <Event>
        <xsl:attribute name="EventID">
          <xsl:text>E10161</xsl:text>
        </xsl:attribute>
        <!--Flag-->
        <Data Position="1" Length="6" Segment="Flag">
          <xsl:text>E10161</xsl:text>
        </Data>
        <!--Offense Number-->
        <Data Position='2' Length='2' Segment='CROLNO' AlwaysNull="true" />
        <!--CraiOtherNumber-->
        <Data Position='3' Length='2' Segment='CraiOtherNumber' AlwaysNull="true" />
        <!--OCA / Complaint Number Before-->
        <Data Position='4' Length='15' Segment='CRRCMPN' AlwaysNull="true" />
        <!--OCA / Complaint Number After-->
        <Data Position='5' Length='15' Segment='CRRCMPN'>
          <xsl:value-of select="/Integration/Case/CaseCrossReference[CaseCrossReferenceType/@Word='LECN']/CrossCaseNumber"/>
        </Data>
      </Event>
    </xsl:if>
  </xsl:template>
</xsl:stylesheet>


