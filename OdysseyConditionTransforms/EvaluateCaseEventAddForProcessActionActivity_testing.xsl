<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:CMCodeQueryHelper="urn:CMCodeQueryHelper" exclude-result-prefixes="xsl msxsl script CMCodeQueryHelper">
  <xsl:strip-space elements="*"/>
  <xsl:output omit-xml-declaration="yes"/>
  <!-- ********************************************************************************************************-->
  <!-- **** Master Template for evaluating case event history to determine which CIP Pacakge should fire.  ****-->
  <!-- **** Each CIP condition calls this template with the correct set of case events                     ****-->
  <!-- **** Modification History.                                                                          ****-->
  <!-- **** 2021-07-09 RED initial creation                                                                ****-->
  <!-- ********************************************************************************************************-->
  <xsl:template name="EvaluateCaseAdd">
    <xsl:param name="ProcessActionEvent"/>
    <xsl:param name="ProcessType"/>
    <xsl:param name="NodeID"/>
    <!-- ********************************************************************************************************-->
    <!-- **** Check to see if the message was generated from a Node that is not live on Odyssey              ****-->
    <!-- **** This check looks at the new Is Odyssey Live orgchart attribute                                 ****-->
    <!-- **** Cases assigned to the 'AOC Expunction Unit' are also excluded                                  ****-->
    <!-- ********************************************************************************************************-->
    <xsl:variable name="NodeIDFilterStart">
      <xsl:text>/OrgMap/OrgChart//Node[@ID='</xsl:text>
    </xsl:variable>
    <xsl:variable name="NodeIDFilterEnd">
      <xsl:text>']</xsl:text>
    </xsl:variable>
    <xsl:variable name="NodeIDFilter">
      <xsl:value-of  select="concat($NodeIDFilterStart,$NodeID,$NodeIDFilterEnd)"/>
    </xsl:variable>
    <xsl:variable name="OdysseyLiveFlag">
      <xsl:value-of select="CMCodeQueryHelper:GetOrgChartAttribute(string($NodeIDFilter),'OdysseyLiveFlag')"/>
    </xsl:variable>
    <xsl:variable name="PublishMessageToACIS">
      <xsl:choose>
        <xsl:when test="$NodeID='104000000'">
          <xsl:text>false</xsl:text>
        </xsl:when>
        <xsl:when test="$OdysseyLiveFlag='1'">
          <xsl:text>false</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>true</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <!-- ********************************************************************************************************-->
    <!-- **** Determine if:                                                                                  ****-->
    <!-- **** 1 - The case event that was added matches the process action event provided by the condition   ****-->
    <!-- **** 2 - The node that the case is assigned is not live on Odyssey                                  ****-->
    <!-- **** 3 - The case does not have the ACISFILTER case flag added                                      ****-->
    <!-- ********************************************************************************************************-->
    <xsl:choose>
      <xsl:when test="/Integration/Case/CaseEvent[@Op='A' and Deleted='false']/EventType[@Word=$ProcessActionEvent]">
        <xsl:if test="$PublishMessageToACIS='true'">
          <xsl:if test="/Integration/Case[not(CaseFlag/@Word='ACISFILTER')]">
            <ProcessType>
              <xsl:value-of select="$ProcessType"/>
            </ProcessType>
            <ProcessActionType>
              <xsl:value-of select="$ProcessActionEvent"/>
            </ProcessActionType>
            <ProcessActionDate>
              <xsl:value-of select="/Integration/Case/CaseEvent[@Op='A' and Deleted='false']/EventType[@Word=$ProcessActionEvent]/../EventDate"/>
            </ProcessActionDate>
          </xsl:if>
        </xsl:if>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>




