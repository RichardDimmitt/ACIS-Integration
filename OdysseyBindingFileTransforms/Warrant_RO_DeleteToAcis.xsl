<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<!-- ****************************************************************************** -->
<!-- *** This templae addresses the binding files below                         *** -->
<!-- *** RODelete.xml                                                           *** -->
<!-- ****************************************************************************** -->
  <xsl:import href="https://raw.githubusercontent.com/RichardDimmitt/ACIS-Integration/main/OdysseyEventTransforms/HeaderForAddMessage.xsl"/>
  <xsl:import href="https://raw.githubusercontent.com/RichardDimmitt/ACIS-Integration/main/OdysseyEventTransforms/HeaderForUpdateMessage.xsl"/>
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
        <xsl:call-template name="E10227"/>
        <xsl:call-template name="E00730"/>
      </UpdateMessage>
    </OdysseyACISMessage>
  </xsl:template>
  <xsl:template name="E00730">
    <Event>
      <xsl:attribute name="EventID">
        <xsl:text>E00730</xsl:text>
      </xsl:attribute>
      <xsl:attribute name="TrailerRecord">
        <xsl:text>TotalEventRec</xsl:text>
      </xsl:attribute>
      <Data Position="1" Length="6" Segment="Flag">
        <xsl:text>E00730</xsl:text>
      </Data>
      <Data Position='2' Length='2'   Segment='CraiOffenseNumber' AlwaysNull="true"/>
      <Data Position='3' Length='2'   Segment='CraiOtherNumber'   AlwaysNull="true"/>
      <Data Position='4' Length='7'   Segment='CRSCDT-OLD'        AlwaysNull="true"/>
      <Data Position='5' Length='8'   Segment='CRSDOA-OLD'        AlwaysNull="true"/>
      <Data Position='6' Length='7'   Segment='CRSCDT'            AlwaysNull="true"/>
      <Data Position='7' Length='8'   Segment='CRSDOA'            AlwaysNull="true"/>
      <Data Position='8' Length='160' Segment='Filler'            AlwaysNull="true"/>
    </Event>
  </xsl:template>
  <xsl:template name="E10227">
    <Event>
      <xsl:attribute name="EventID">
        <xsl:text>E10227</xsl:text>
      </xsl:attribute>
      <xsl:attribute name="TrailerRecord">
        <xsl:text>TotalEventRec</xsl:text>
      </xsl:attribute>
      <Data Position="1" Length="6" Segment="Flag">
        <xsl:text>E10227</xsl:text>
      </Data>
      <Data Position='2' Length='2'   Segment='CraiOffenseNumber' AlwaysNull="true"/>
      <Data Position='3' Length='2'   Segment='CraiOtherNumber'   AlwaysNull="true"/>
      <Data Position='4' Length='3'   Segment='CRRBONDT-OLD'      AlwaysNull="true"/>
      <Data Position='5' Length='7'   Segment='CRRBONDA-OLD'      AlwaysNull="true"/>
      <Data Position='6' Length='3'   Segment='CRRBONDT'          AlwaysNull="true"/>
      <Data Position='7' Length='7'   Segment='CRRBONDA'          AlwaysNull="true"/>
      <Data Position='8' Length='170' Segment='Filler'            AlwaysNull="true"/>
    </Event>
  </xsl:template>
</xsl:stylesheet>





