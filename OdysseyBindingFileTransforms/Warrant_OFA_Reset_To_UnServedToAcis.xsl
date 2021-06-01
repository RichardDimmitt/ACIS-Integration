<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<!-- ****************************************************************************** -->
<!-- *** This templae addresses the binding files below                         *** -->
<!-- *** PTResetToUnserveOnOFA.xml                                              *** -->
<!-- ****************************************************************************** -->
  <xsl:import href="https://raw.githubusercontent.com/RichardDimmitt/ACIS-Integration/main/OdysseyEventTransforms/HeaderForAddMessage.xsl"/>
  <xsl:import href="https://raw.githubusercontent.com/RichardDimmitt/ACIS-Integration/main/OdysseyEventTransforms/HeaderForUpdateMessage.xsl"/>
  <xsl:import href="https://raw.githubusercontent.com/RichardDimmitt/ACIS-Integration/main/OdysseyEventTransforms/E30010.xsl"/>
  <xsl:import href="https://raw.githubusercontent.com/RichardDimmitt/ACIS-Integration/main/OdysseyEventTransforms/E30060.xsl"/>
  <xsl:import href="https://raw.githubusercontent.com/RichardDimmitt/ACIS-Integration/main/OdysseyEventTransforms/E30300.xsl"/>
  <xsl:import href="https://raw.githubusercontent.com/RichardDimmitt/ACIS-Integration/main/OdysseyEventTransforms/E30310.xsl"/>
  <xsl:import href="https://raw.githubusercontent.com/RichardDimmitt/ACIS-Integration/main/OdysseyEventTransforms/E30320.xsl"/>
  <xsl:import href="https://raw.githubusercontent.com/RichardDimmitt/ACIS-Integration/main/OdysseyEventTransforms/E11410OFA.xsl"/>
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
        <xsl:call-template name="HeaderForUpdateMessage.xsl"/>
        <xsl:call-template name="E30010"/>
        <xsl:call-template name="E30060"/>
        <xsl:call-template name="E30300"/>
        <xsl:call-template name="E30310"/>
        <xsl:call-template name="E30320"/>
        <xsl:call-template name="E11410OFA"/>
        <xsl:call-template name="E20200"/>
      </UpdateMessage>
    </OdysseyACISMessage>
  </xsl:template>
</xsl:stylesheet>















