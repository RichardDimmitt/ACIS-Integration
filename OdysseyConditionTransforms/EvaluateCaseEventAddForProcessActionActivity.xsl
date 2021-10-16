  <xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:user="http://tylertechnologies.com" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:reslib="urn:reslib" xmlns:CMCodeQueryHelper="urn:CMCodeQueryHelper" xmlns:ExternalReference="urn:ExternalReference" version="1.0" exclude-result-prefixes="xsl msxsl CMCodeQueryHelper ExternalReference">
  <xsl:strip-space elements="*"/>
  <xsl:output omit-xml-declaration="yes"/>
  <!-- ********************************************************************************************************-->
  <!-- **** Master Template for evaluating case event history to determine which CIP Pacakge should fire.  ****-->
  <!-- **** Each CIP condition calls this template with the correct set of case events                     ****-->
  <!-- **** Modification History.                                                                          ****-->
  <!-- **** 2021-07-09 RED initial creation                                                                ****-->
  <!-- **** 2021-09-29 RED Updated to check the configuration of the Is Odyssey Live orgchart attribute in ****-->
  <!-- ****            order to determine if a message should be published: INT-6579                       ****-->
  <!-- **** 2021-10-15 RED Updated to include a check of the format of the case number. INT-6592           ****-->
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
    <!-- **** Check to determine if the case number can be sent to ACIS.                                     ****-->
    <!-- ****  1) The case number length must be 16 or 17 characters                                         ****-->
    <!-- ****  2) The case number must end in -M                                                             ****-->
    <!-- ****  3) There must be a CR or CRS case type key                                                    ****-->
    <!-- ****  4) There must be a 6 digit integer value to send for the case sequence number                 ****-->
    <!-- ****  5) There must be a 3 digit integer value to send for the county number                        ****-->
    <!-- ****  6) There must be a 2 digit integer value to send for the case year                            ****-->
    <!-- ********************************************************************************************************-->
    <xsl:variable name="CaseNumber">
      <xsl:value-of select="/Integration/Case/CaseNumber"/>
    </xsl:variable>
    <xsl:variable name="CaseNumberLength">
      <xsl:value-of select="string-length($CaseNumber)"/>
    </xsl:variable>
    <xsl:variable name="MagistrateCaseKey">
      <xsl:value-of select="substring($CaseNumber,$CaseNumberLength - 1,2)"/>
    </xsl:variable>
    <xsl:variable name="CraiKeyYear">
      <xsl:value-of select="substring($CaseNumber,1,2)"/>
    </xsl:variable>
    <xsl:variable name="CraiKeyCaseType">
      <xsl:choose>
        <xsl:when test="substring($CaseNumber,3,3)='CRS'">
          <xsl:text>CRS</xsl:text>
        </xsl:when>
        <xsl:when test="substring($CaseNumber,3,2)='CR'">
          <xsl:text>CR</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>INVALID</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="CraiKeySequence">
      <xsl:choose>
        <xsl:when test="$CraiKeyCaseType = 'CRS'">
          <xsl:value-of select="substring($CaseNumber,6,6)"/>
        </xsl:when>
        <xsl:when test="$CraiKeyCaseType='CR'">
          <xsl:value-of select="substring($CaseNumber,5,6)"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>INVALID</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="CraiKeyCounty">
      <xsl:call-template name="FormatCountyKey">
        <xsl:with-param name="KeyValue" select="$CaseNumber"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="CaseNumberFormatValid">
      <xsl:choose>
        <xsl:when test="$CaseNumberLength&gt;='16'">
          <xsl:if test="$CaseNumberLength&lt;='17'">
            <xsl:if test="$MagistrateCaseKey='-M'">
              <xsl:if test="$CraiKeyCaseType!='INVALID'">
                <xsl:if test="string(number($CraiKeySequence))!='NaN'">
                  <xsl:if test="string-length($CraiKeyCounty)='3'">
                    <xsl:if test="string(number($CraiKeyCounty))!='NaN'">
                      <xsl:if test="string(number($CraiKeyYear))!='NaN'">
                        <xsl:text>true</xsl:text>
                      </xsl:if>
                    </xsl:if>
                  </xsl:if>
                </xsl:if>
              </xsl:if>
            </xsl:if>
          </xsl:if>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>false</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <!-- ********************************************************************************************************-->
    <!-- **** Determine if:                                                                                  ****-->
    <!-- **** 1 - The case event that was added matches the process action event provided by the condition   ****-->
    <!-- **** 2 - The node that the case is assigned is not live on Odyssey                                  ****-->
    <!-- **** 3 - The case does not have the ACISFILTER case flag added                                      ****-->
    <!-- **** 4 - The case number is valid, meaning that it can be parsed and sent to ACIS                   ****-->
    <!-- ********************************************************************************************************-->
    <xsl:choose>
      <xsl:when test="/Integration/Case/CaseEvent[@Op='A' and Deleted='false']/EventType[@Word=$ProcessActionEvent]">
        <xsl:if test="$PublishMessageToACIS='true'">
          <xsl:if test="/Integration/Case[not(CaseFlag/@Word='ACISFILTER')]">
            <xsl:if test="$CaseNumberFormatValid='true'">
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
        </xsl:if>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  <!-- ********************************************************************-->
  <!-- *************** template for formating County Key ******************-->
  <!-- ********************************************************************-->
  <xsl:template name="FormatCountyKey">
    <xsl:param name="KeyValue"/>
    <xsl:variable name="StartValue" select="substring-after($KeyValue,'-')"/>
    <xsl:variable name="CountyNumber" select="substring-before($StartValue,'-')"/>
    <xsl:value-of  select="$CountyNumber"/>
  </xsl:template>
</xsl:stylesheet>









