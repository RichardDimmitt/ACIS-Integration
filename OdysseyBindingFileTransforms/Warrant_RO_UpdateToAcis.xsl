<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<!-- ****************************************************************************** -->
<!-- *** This templae addresses the binding files below                         *** -->
<!-- *** ReleaseOrderCourtInterpreterUpdateToAcis.xml                           *** -->
<!-- *** ReleaseOrderCourtUpdateToAcis.xml                                      *** -->
<!-- *** ReleaseOrderInterpreterUpdateToAcis.xml                                *** -->
<!-- *** ReleaseOrderReleaseConditionsUpdateToAcis.xml                          *** -->
<!-- *** ReleaseOrderSummaryUpdateToAcis.xml                                    *** -->
<!-- *** ReleaseOrderUpdateToAcis.xml                                           *** -->
<!-- *** 12/9/21: Updated to no longer send the E00705 or E10227 events if the  *** -->
<!-- ***          RO is a 'Subsequent' RO that is issued after the OFA          *** -->
<!-- ****************************************************************************** -->
  <xsl:import href="https://raw.githubusercontent.com/RichardDimmitt/ACIS-Integration/main/OdysseyEventTransforms/HeaderForAddMessage.xsl"/>
  <xsl:import href="https://raw.githubusercontent.com/RichardDimmitt/ACIS-Integration/main/OdysseyEventTransforms/HeaderForUpdateMessage.xsl"/>
  <xsl:import href="https://raw.githubusercontent.com/RichardDimmitt/ACIS-Integration/main/OdysseyEventTransforms/E30010.xsl"/>
  <xsl:import href="https://raw.githubusercontent.com/RichardDimmitt/ACIS-Integration/main/OdysseyEventTransforms/E30060.xsl"/>
  <xsl:import href="https://raw.githubusercontent.com/RichardDimmitt/ACIS-Integration/main/OdysseyEventTransforms/E00732.xsl"/>
  <xsl:import href="https://raw.githubusercontent.com/RichardDimmitt/ACIS-Integration/main/OdysseyEventTransforms/E00705.xsl"/>
  <xsl:import href="https://raw.githubusercontent.com/RichardDimmitt/ACIS-Integration/main/OdysseyEventTransforms/E00730.xsl"/>
  <xsl:import href="https://raw.githubusercontent.com/RichardDimmitt/ACIS-Integration/main/OdysseyEventTransforms/E30300.xsl"/>
  <xsl:import href="https://raw.githubusercontent.com/RichardDimmitt/ACIS-Integration/main/OdysseyEventTransforms/E30310.xsl"/>
  <xsl:import href="https://raw.githubusercontent.com/RichardDimmitt/ACIS-Integration/main/OdysseyEventTransforms/E30320.xsl"/>
  <xsl:import href="https://raw.githubusercontent.com/RichardDimmitt/ACIS-Integration/main/OdysseyEventTransforms/E10227.xsl"/>
  <xsl:strip-space elements="*"/>
  <xsl:output method="xml" indent="no"/>
  <xsl:template match="Integration">
    <xsl:variable name="OFAIssued">
      <xsl:choose>
        <xsl:when test="/Integration/Case/CaseEvent[Deleted='false']/EventType/@Word='OFAI'">
          <xsl:text>true</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>false</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="NonOFAProcessList" select="'CS MO WFAI'"/>
    <xsl:variable name="NonOFAInitiatingProcess">
      <xsl:choose>
        <xsl:when test="/Integration/Case/CaseEvent[Deleted='false' and EventType[contains(concat(' ', $NonOFAProcessList, ' '), concat(' ', @Word, ' '))]]">
          <xsl:text>true</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>false</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="RoType">
      <xsl:choose>
        <xsl:when test="$NonOFAInitiatingProcess='true' and $OFAIssued='false'">
          <xsl:text>regular</xsl:text>
        </xsl:when>
        <xsl:when test="$NonOFAInitiatingProcess='true' and $OFAIssued='true'">
          <xsl:text>subsequent</xsl:text>
        </xsl:when>
        <xsl:when test="$NonOFAInitiatingProcess='false' and $OFAIssued='true'">
          <xsl:text>regular</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>regular</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
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
      <xsl:attribute name="ReleaseOrderType">
        <xsl:value-of select="$RoType"/>
      </xsl:attribute>
      <AddMessage>
        <xsl:call-template name="HeaderForAddMessage"/>
      </AddMessage>
      <UpdateMessage>
        <xsl:call-template name="HeaderForUpdateMessage"/>
        <xsl:call-template name='E30010'/>
        <xsl:call-template name='E30060'/>
        <xsl:call-template name='E00732'/>
        <xsl:if test="$RoType='regular'">
          <xsl:call-template name='E00705'/>
        </xsl:if>
        <xsl:call-template name='E00730'/>
        <xsl:call-template name='E30300'/>
        <xsl:call-template name='E30310'/>
        <xsl:call-template name='E30320'/>
        <xsl:if test="$RoType='regular'">
          <xsl:call-template name='E10227'/>
        </xsl:if>
      </UpdateMessage>
    </OdysseyACISMessage>
  </xsl:template>
</xsl:stylesheet>





