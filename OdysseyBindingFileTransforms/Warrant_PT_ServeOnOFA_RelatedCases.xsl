<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<!-- ****************************************************************************** -->
<!-- *** This templae addresses the binding files below                         *** -->
<!-- *** PTServeOnOFA.xml                                                       *** -->
<!-- ****************************************************************************** -->
  <xsl:import href="https://raw.githubusercontent.com/RichardDimmitt/ACIS-Integration/main/OdysseyEventTransforms/HeaderForAddMessage.xsl"/>
  <xsl:import href="https://raw.githubusercontent.com/RichardDimmitt/ACIS-Integration/main/OdysseyEventTransforms/HeaderForLeadAndRelatedCases.xsl"/>
  <xsl:import href="https://raw.githubusercontent.com/RichardDimmitt/ACIS-Integration/main/OdysseyEventTransforms/E30010.xsl"/>
  <xsl:import href="https://raw.githubusercontent.com/RichardDimmitt/ACIS-Integration/main/OdysseyEventTransforms/E30060.xsl"/>
  <xsl:import href="https://raw.githubusercontent.com/RichardDimmitt/ACIS-Integration/main/OdysseyEventTransforms/E10110.xsl"/>
  <xsl:import href="https://raw.githubusercontent.com/RichardDimmitt/ACIS-Integration/main/OdysseyEventTransforms/E30300.xsl"/>
  <xsl:import href="https://raw.githubusercontent.com/RichardDimmitt/ACIS-Integration/main/OdysseyEventTransforms/E10161.xsl"/>
  <xsl:import href="https://raw.githubusercontent.com/RichardDimmitt/ACIS-Integration/main/OdysseyEventTransforms/E30310.xsl"/>
  <xsl:import href="https://raw.githubusercontent.com/RichardDimmitt/ACIS-Integration/main/OdysseyEventTransforms/E30320.xsl"/>
  <xsl:import href="https://raw.githubusercontent.com/RichardDimmitt/ACIS-Integration/main/OdysseyEventTransforms/E11410OFAReset.xsl"/>
  <xsl:import href="https://raw.githubusercontent.com/RichardDimmitt/ACIS-Integration/main/OdysseyEventTransforms/E30100.xsl"/>
  <xsl:import href="https://raw.githubusercontent.com/RichardDimmitt/ACIS-Integration/main/OdysseyEventTransforms/E20200.xsl"/>
  <xsl:strip-space elements="*"/>
  <xsl:output method="xml" indent="no"/>
  <xsl:template match="Integration">
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
      <xsl:attribute name="CaseID">
        <xsl:value-of select="/Integration/Case/@InternalID"/>
      </xsl:attribute>
      <xsl:attribute name="CaseNumber">
        <xsl:value-of select="/Integration/Case/CaseNumber"/>
      </xsl:attribute>
      <AddMessage>
        <xsl:call-template name="HeaderForAddMessage"/>
      </AddMessage>
      <UpdateMessage>
        <xsl:call-template name="HeaderForLeadAndRelatedCases"/>
        <xsl:call-template name="E30010"/>
        <xsl:call-template name="E30060"/>
        <xsl:call-template name="E10110"/>
        <xsl:call-template name="E30300"/>
        <xsl:call-template name="E10161"/>
        <xsl:call-template name="E30310"/>
        <xsl:call-template name="E30320"/>
        <xsl:call-template name="E11410OFAReset"/>
        <xsl:call-template name="E30100"/>
        <xsl:call-template name="E20200"/>
      </UpdateMessage>
    </OdysseyACISMessage>
  </xsl:template>
</xsl:stylesheet>












