<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<!--*************************************************************************************
 *  ACISWFAI - Warrant for Arrest Issued - Case Add To ACIS
 *  Modification History.
 *  2021-04-11 RED initial creation
 *************************************************************************************-->
<xsl:import href="https://raw.githubusercontent.com/RichardDimmitt/ACIS-Integration/main/OdysseyConditionTransforms/OdysseyNodeCheck.xsl"/>
  <xsl:output method="xml" encoding="UTF-8" omit-xml-declaration="yes"/>
  <xsl:template match="/">
    <xsl:apply-templates select="/Integration"/>
  </xsl:template>
  <xsl:template match="/Integration">
    <xsl:variable name="ProcessActionEvent" select="'WFAI'"/>
    <xsl:variable name="CheckCourtNode">
      <xsl:call-template name="OdysseyNodeCheck"/>
    </xsl:variable>
    <xsl:choose>
      <!-- Check to see if the event that was added matches the pipeline completion event variable -->
      <xsl:when test="/Integration/Case/CaseEvent[@Op='A']/EventType[contains('EWCWFA EWCWFAWC EWCFW',@Word)]">
        <!-- Check to see if the last case event added from the array of process action events matches the process action event variable -->
        <xsl:if test="/Integration/Case/CaseEvent[EventType[contains('EWA CSAROA WFAIP MO CS OFAI RO WFAI WFAREJ CSREJ OFAREJ ROREJ MOREJ WFARS CSS OFARS EWRS WFAR CSR OFAR EWR WFARI CSRI OFARI EWRI WFADEL CSDEL OFADEL RODEL MODEL WFAAR CSAR OFAAR ROAR EWAR WFARU CSU OFARU EWRU PD',@Word)]][last()]/EventType/@Word=$ProcessActionEvent">
         <!-- Check to see if the message was generated from a Node that is not live on Odyssey and not the AOC Expunction Unit -->
         <xsl:if test="$CheckCourtNode='X'">
          <!-- Specify the Transaction Type used by the header record (A-Add, U-Update) -->
          <TransactionType>A</TransactionType>
          <!-- Specify the ACIS Process Type code which is required by some ACIS Event Messages -->
          <ProcessType>W</ProcessType>
          <ProcessActionType><xsl:value-of select="$ProcessActionEvent"/></ProcessActionType>
          <!-- Specify the date the process action occured which is required by some ACIS Event Messages -->
          <ProcessActionDate><xsl:value-of select="/Integration/Case/CaseEvent[EventType[contains('EWA CSAROA WFAIP MO CS OFAI RO WFAI WFAREJ CSREJ OFAREJ ROREJ MOREJ WFARS CSS OFARS EWRS WFAR CSR OFAR EWR WFARI CSRI OFARI EWRI WFADEL CSDEL OFADEL RODEL MODEL WFAAR CSAR OFAAR ROAR EWAR WFARU CSU OFARU EWRU PD',@Word)]][last()]/EventType[@Word=$ProcessActionEvent]/../EventDate"/></ProcessActionDate>
        </xsl:if>
        </xsl:if>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>



