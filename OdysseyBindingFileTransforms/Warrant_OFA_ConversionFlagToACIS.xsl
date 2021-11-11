<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<!-- ******************************************************************************-->
<!-- *** This templae addresses sending in the 'Conversion Flag' to ACIS.       ***-->
<!-- *** This is needed when a OFA is issued from an ACIS case that did not     ***-->
<!-- *** originate from Odyssey.  The message flips a flag in ACIS that then    ***-->
<!-- *** ensures that updates to the ACIS case are written back the MQ so that  ***-->
<!-- *** they can be picked up and processed back into Odyssey and Electronic   ***-->
<!-- *** warrants.                                                              ***-->
<!-- *** Note*, there is not binding file or technical artifact for this        ***-->
<!-- *** message.  It was developed strictly off an email from the client       ***-->
<!-- ******************************************************************************-->
<!-- *** 11-05-21 Initial Creation, INT-6692                                    ***-->
<!-- ******************************************************************************-->
  <xsl:import href="https://raw.githubusercontent.com/RichardDimmitt/ACIS-Integration/main/OdysseyEventTransforms/ConversionFlagMessage.xsl"/>
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
      <ConversionFlagMessage>
        <xsl:call-template name="ConversionFlagMessage"/>
      </ConversionFlagMessage>
    </OdysseyACISMessage>
  </xsl:template>
</xsl:stylesheet>

