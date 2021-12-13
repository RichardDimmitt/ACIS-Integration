<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<!-- ****************************************************************************** -->
<!-- *** This templae addresses the binding files below                         *** -->
<!-- *** RODelete.xml                                                           *** -->
<!-- *** 11/29/2021: Updated to no longer send just the E10227 and E00730 event *** -->
<!-- ***             as previously instructed.  Based on new requirments, the   *** -->
<!-- ***             following is provided instead (INT-6617)                   *** -->
<!-- ***             E00705    Citation #, Check Digit, and Arrest #            *** -->
<!-- ***             E00740    LID Number Change                                *** -->
<!-- ***             E30300    Interpreter Flag Change                          *** -->
<!-- ***             E30310    Interpreter Used Flag                            *** -->
<!-- ***             E30320    Interpreter Freeform Language                    *** -->
<!-- ***             E10100    Service Record                                   *** -->
<!-- ***             E30010    Trial Court Session Information Change           *** -->
<!-- ***             E30060    Superior Court Session Information Change        *** -->
<!-- ***             E00732    FingerPrint Reason Change                        *** -->
<!-- ***             E00730    FingerPrint Number, Date of Arrest Change        *** -->
<!-- ***             E10227    Bond Amount / Type Change                        *** -->
<!-- *** 12/9/2021: Updated to no longer send the events below if the RO is a   *** -->
<!-- ***            'Subsequent' RO that is issued after the OFA (INT-6541)     *** -->
<!-- ***             E00705    Citation #, Check Digit, and Arrest #            *** -->
<!-- ***             E10100    Service Record                                   *** -->
<!-- ***             E00732     FingerPrint Reason Change                        *** -->
<!-- ***             E00730    FingerPrint Number, Date of Arrest Change        *** -->
<!-- ***             E10227    Bond Amount / Type Change                        *** -->
<!-- *** 12/13/2021: Updated to send the E30010 or E30060 event if the release  *** -->
<!-- ***             order being deleted is a subsequent release order.  This   *** -->
<!-- ***             will reset it to what it was in ACIS before. INT-6541      *** -->
<!-- ****************************************************************************** -->
  <xsl:import href="https://raw.githubusercontent.com/RichardDimmitt/ACIS-Integration/main/OdysseyEventTransforms/HeaderForAddMessage.xsl"/>
  <xsl:import href="https://raw.githubusercontent.com/RichardDimmitt/ACIS-Integration/main/OdysseyEventTransforms/HeaderForLeadAndRelatedCases.xsl"/>
  <xsl:import href="https://raw.githubusercontent.com/RichardDimmitt/ACIS-Integration/main/OdysseyEventTransforms/E00705Delete.xsl"/>
  <xsl:import href="https://raw.githubusercontent.com/RichardDimmitt/ACIS-Integration/main/OdysseyEventTransforms/E00730Delete.xsl"/>
  <xsl:import href="https://raw.githubusercontent.com/RichardDimmitt/ACIS-Integration/main/OdysseyEventTransforms/E00732Delete.xsl"/>
  <xsl:import href="https://raw.githubusercontent.com/RichardDimmitt/ACIS-Integration/main/OdysseyEventTransforms/E00740Delete.xsl"/>
  <xsl:import href="https://raw.githubusercontent.com/RichardDimmitt/ACIS-Integration/main/OdysseyEventTransforms/E10227Delete.xsl"/>
  <xsl:import href="https://raw.githubusercontent.com/RichardDimmitt/ACIS-Integration/main/OdysseyEventTransforms/E30010Delete.xsl"/>
  <xsl:import href="https://raw.githubusercontent.com/RichardDimmitt/ACIS-Integration/main/OdysseyEventTransforms/E30060Delete.xsl"/>
  <xsl:import href="https://raw.githubusercontent.com/RichardDimmitt/ACIS-Integration/main/OdysseyEventTransforms/E30300Delete.xsl"/>
  <xsl:import href="https://raw.githubusercontent.com/RichardDimmitt/ACIS-Integration/main/OdysseyEventTransforms/E30310Delete.xsl"/>
  <xsl:import href="https://raw.githubusercontent.com/RichardDimmitt/ACIS-Integration/main/OdysseyEventTransforms/E30320Delete.xsl"/>
  <xsl:import href="https://raw.githubusercontent.com/RichardDimmitt/ACIS-Integration/main/OdysseyEventTransforms/E30010.xsl"/>
  <xsl:import href="https://raw.githubusercontent.com/RichardDimmitt/ACIS-Integration/main/OdysseyEventTransforms/E30060.xsl"/>
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
        <xsl:if test="$RoType='regular'">
          <xsl:call-template name="E00705Delete"/>
          <xsl:call-template name="E10227Delete"/>
          <xsl:call-template name="E00730Delete"/>
          <xsl:call-template name="E00732Delete"/>
          <xsl:call-template name="E30010Delete"/>
          <xsl:call-template name="E30060Delete"/>
          <xsl:call-template name="E00740Delete"/>
          <xsl:call-template name="E30300Delete"/>
          <xsl:call-template name="E30310Delete"/>
          <xsl:call-template name="E30320Delete"/>
        </xsl:if>
        <xsl:if test="$RoType='subsequent'">
          <xsl:call-template name="E00740Delete"/>
          <xsl:call-template name="E30010"/>
          <xsl:call-template name="E30060"/>
          <xsl:call-template name="E30300Delete"/>
          <xsl:call-template name="E30310Delete"/>
          <xsl:call-template name="E30320Delete"/>
        </xsl:if>
      </UpdateMessage>
    </OdysseyACISMessage>
  </xsl:template>
</xsl:stylesheet>






