<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<!-- ****************************************************************************** -->
<!-- *** This templae addresses the binding files below for the instance of     *** -->
<!-- *** when a process is recalled PT_NONOFA_Reset_To_Unserved_ACIS            *** -->
<!-- *** PTActionsAwareToAcis.xml                                               *** -->
<!-- ****************************************************************************** -->
  <xsl:import href="https://raw.githubusercontent.com/RichardDimmitt/ACIS-Integration/main/OdysseyEventTransforms/HeaderForAddMessage.xsl"/>
  <xsl:import href="https://raw.githubusercontent.com/RichardDimmitt/ACIS-Integration/main/OdysseyEventTransforms/HeaderForUpdateMessage.xsl"/>
  <xsl:import href="https://raw.githubusercontent.com/RichardDimmitt/ACIS-Integration/main/OdysseyEventTransforms/E10110Reset.xsl"/>
  <xsl:import href="https://raw.githubusercontent.com/RichardDimmitt/ACIS-Integration/main/OdysseyEventTransforms/E30010Reset.xsl"/>
  <xsl:import href="https://raw.githubusercontent.com/RichardDimmitt/ACIS-Integration/main/OdysseyEventTransforms/E30060Reset.xsl"/>
  <xsl:import href="https://raw.githubusercontent.com/RichardDimmitt/ACIS-Integration/main/OdysseyEventTransforms/E30320Reset.xsl"/>
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
        <xsl:call-template name="HeaderForUpdateMessage"/>
        <xsl:call-template name="E10110Reset"/>
        <xsl:call-template name="E30010Reset"/>
        <xsl:call-template name="E30060Reset"/>
        <xsl:call-template name="E30320Reset"/>
      </UpdateMessage>
    </OdysseyACISMessage>
  </xsl:template>
</xsl:stylesheet>






