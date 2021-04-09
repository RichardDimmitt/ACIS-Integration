<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:import href="https://raw.githubusercontent.com/RichardDimmitt/ACIS-Integration/main/Header.xsl"/>
  <xsl:import href="https://raw.githubusercontent.com/RichardDimmitt/ACIS-Integration/main/E00050.xsl"/>
  <xsl:strip-space elements="*"/>
  <xsl:output method="xml" indent="no" cdata-section-elements="DATA"/>
  <xsl:template match="Integration">
  <!-- **************************************************************************-->
  <!-- ********************* Build Root Element  ********************************-->
  <!-- **************************************************************************-->
    <OdysseyACISMessage>
      <xsl:attribute name="MessageGUID">
        <xsl:value-of select="/Integration/@MessageGUID"/>
      </xsl:attribute>
      <xsl:attribute name="MessageID">
        <xsl:value-of select="/Integration/@MessageID"/>
      </xsl:attribute>
      <xsl:attribute name="Timestamp">
        <xsl:value-of select="/Integration/ControlPoint/@Timestamp"/>
      </xsl:attribute>
      <xsl:attribute name="Condition">
        <xsl:value-of select="/Integration/IntegrationConditions/IntegrationCondition[1]/@Word"/>
      </xsl:attribute>
      <xsl:apply-imports/>
    </OdysseyACISMessage>
  </xsl:template>
</xsl:stylesheet>



