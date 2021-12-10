<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<!-- ****************************************************************************** -->
<!-- *** This templae addresses the binding files below                         *** -->
<!-- *** ReleaseOrderIssueMessageToAcis.xml                                     *** -->
<!-- *** 6/13/21: Removed the following events per ODY-346620                   *** -->
<!-- ***          E30010 Trial Court Session Information Change                 *** -->
<!-- ***          E30060 Superior Court Session Information Change              *** -->
<!-- ***          E00730 Fingerprint Number, Date of Arrest Change              *** -->
<!-- ***          E00732 Fingerprint Reason Change                              *** -->
<!-- ***          E10110 Service Date Change                                    *** -->
<!-- *** 7/13/21: Removed the following events per INT-5966                     *** -->
<!-- ***          E30100 Case Reinstated Indicator Change                       *** -->
<!-- *** 7/21/21: Replaced the E10227 event with the new E10200 event           *** -->
<!-- ***          per INT-5966                                                  *** -->
<!-- *** 12/9/21: Updated to no longer send the E00705 or E10200 events if the  *** -->
<!-- ***          RO is a 'Subsequent' RO that is issued after the OFA          *** -->
<!-- ****************************************************************************** -->
  <xsl:import href="https://raw.githubusercontent.com/RichardDimmitt/ACIS-Integration/main/OdysseyEventTransforms/HeaderForAddMessage.xsl"/>
  <xsl:import href="https://raw.githubusercontent.com/RichardDimmitt/ACIS-Integration/main/OdysseyEventTransforms/HeaderForLeadAndRelatedCases.xsl"/>
  <xsl:import href="https://raw.githubusercontent.com/RichardDimmitt/ACIS-Integration/main/OdysseyEventTransforms/E00635.xsl"/>
  <xsl:import href="https://raw.githubusercontent.com/RichardDimmitt/ACIS-Integration/main/OdysseyEventTransforms/E00630.xsl"/>
  <xsl:import href="https://raw.githubusercontent.com/RichardDimmitt/ACIS-Integration/main/OdysseyEventTransforms/E00620.xsl"/>
  <xsl:import href="https://raw.githubusercontent.com/RichardDimmitt/ACIS-Integration/main/OdysseyEventTransforms/E00621.xsl"/>
  <xsl:import href="https://raw.githubusercontent.com/RichardDimmitt/ACIS-Integration/main/OdysseyEventTransforms/E00710.xsl"/>
  <xsl:import href="https://raw.githubusercontent.com/RichardDimmitt/ACIS-Integration/main/OdysseyEventTransforms/E00640.xsl"/>
  <xsl:import href="https://raw.githubusercontent.com/RichardDimmitt/ACIS-Integration/main/OdysseyEventTransforms/E00725.xsl"/>
  <xsl:import href="https://raw.githubusercontent.com/RichardDimmitt/ACIS-Integration/main/OdysseyEventTransforms/E00660.xsl"/>
  <xsl:import href="https://raw.githubusercontent.com/RichardDimmitt/ACIS-Integration/main/OdysseyEventTransforms/E30010.xsl"/>
  <xsl:import href="https://raw.githubusercontent.com/RichardDimmitt/ACIS-Integration/main/OdysseyEventTransforms/E30060.xsl"/>
  <xsl:import href="https://raw.githubusercontent.com/RichardDimmitt/ACIS-Integration/main/OdysseyEventTransforms/E00732.xsl"/>
  <xsl:import href="https://raw.githubusercontent.com/RichardDimmitt/ACIS-Integration/main/OdysseyEventTransforms/E00730.xsl"/>
  <xsl:import href="https://raw.githubusercontent.com/RichardDimmitt/ACIS-Integration/main/OdysseyEventTransforms/E00705.xsl"/>
  <xsl:import href="https://raw.githubusercontent.com/RichardDimmitt/ACIS-Integration/main/OdysseyEventTransforms/E10200.xsl"/>
  <xsl:import href="https://raw.githubusercontent.com/RichardDimmitt/ACIS-Integration/main/OdysseyEventTransforms/E10110.xsl"/>
  <xsl:import href="https://raw.githubusercontent.com/RichardDimmitt/ACIS-Integration/main/OdysseyEventTransforms/E00740.xsl"/>
  <xsl:import href="https://raw.githubusercontent.com/RichardDimmitt/ACIS-Integration/main/OdysseyEventTransforms/E30300.xsl"/>
  <xsl:import href="https://raw.githubusercontent.com/RichardDimmitt/ACIS-Integration/main/OdysseyEventTransforms/E30310.xsl"/>
  <xsl:import href="https://raw.githubusercontent.com/RichardDimmitt/ACIS-Integration/main/OdysseyEventTransforms/E30320.xsl"/>
  <xsl:import href="https://raw.githubusercontent.com/RichardDimmitt/ACIS-Integration/main/OdysseyEventTransforms/E10100.xsl"/>
  <xsl:import href="https://raw.githubusercontent.com/RichardDimmitt/ACIS-Integration/main/OdysseyEventTransforms/E99000RO.xsl"/>
  <xsl:import href="https://raw.githubusercontent.com/RichardDimmitt/ACIS-Integration/main/OdysseyEventTransforms/E11410.xsl"/>
  <xsl:import href="https://raw.githubusercontent.com/RichardDimmitt/ACIS-Integration/main/OdysseyEventTransforms/E30100.xsl"/>
  <xsl:import href="https://raw.githubusercontent.com/RichardDimmitt/ACIS-Integration/main/OdysseyEventTransforms/E20200.xsl"/>
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
        <xsl:call-template name="HeaderForLeadAndRelatedCases"/>
        <xsl:call-template name='E00635'/>
        <xsl:call-template name='E00630'/>
        <xsl:call-template name='E00620'/>
        <xsl:call-template name='E00621'/>
        <xsl:call-template name='E00710'/>
        <xsl:call-template name='E00640'/>
        <xsl:call-template name='E00725'/>
        <xsl:call-template name='E00660'/>

        <xsl:if test="$RoType='regular'">
          <xsl:call-template name='E00705'/>
          <xsl:call-template name="E10200"/>
        </xsl:if>

        <xsl:call-template name='E00740'/>
        <xsl:call-template name='E30300'/>
        <xsl:call-template name='E30310'/>
        <xsl:call-template name='E30320'/>
        <xsl:call-template name='E10100'/>
        <xsl:call-template name='E99000RO'/>
        <xsl:call-template name='E11410'/>
        <xsl:call-template name="E20200"/>
      </UpdateMessage>
    </OdysseyACISMessage>
  </xsl:template>
</xsl:stylesheet>









