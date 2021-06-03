<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:strip-space elements="*"/>
  <xsl:output omit-xml-declaration="yes"/>
  <!--  *******************************************************************************************  * -->
<!--  *  Master Template for evaluating case event history to determine which CIP Pacakge          * -->
<!--  *  should fire.  Each CIP condition calls this template with the correct set of case events  * -->
<!--  *  Modification History.                                                                     * -->
<!--  *  2021-06-02 RED initial creation                                                           * -->
<!--  *******************************************************************************************  * -->
  <xsl:template name="EvaluateCaseEventHistory">
    <xsl:param name="PipeLineCompleteEvent"/>
    <xsl:param name="ProcessActionEvent"/>
    <xsl:param name="ProcessType"/>
    <xsl:param name="NodeID"/>
    <!-- ******************************************************************************-->
    <!-- **** Check to see if the message was generated from a Node that is not    ****-->
    <!-- **** live on Odyssey and not the AOC Expunction Unit                      ****-->
    <!-- **** This exclusion list will grow as more Odyssey courts go live         ****-->
    <!-- **** Ideally this needs to be updated to look at the new Is Odyssey Live  ****-->
    <!-- **** orgchart attribute                                                   ****-->
    <!-- ******************************************************************************-->
    <xsl:variable name="CheckCourtNode">
      <xsl:if test="$NodeID!='104000000'">
        <xsl:text>X</xsl:text>
      </xsl:if>
    </xsl:variable>
    <!-- ****************************************************************************-->
    <!-- **** Provide a listing of all the possible case events added by the EW  ****-->
    <!-- **** integration that could trigger a message to ACIS                   ****-->
    <!-- ****************************************************************************-->
    <xsl:variable name="EventTypeList" select="'EWA CSAROA WFAIP MO CS OFAI RO WFAI WFAREJ CSREJ OFAREJ ROREJ MOREJ WFARS CSS OFARS EWRS WFAR CSR OFAR EWR WFARI CSRI OFARI EWRI WFADEL CSDEL OFADEL RODEL MODEL WFAAR CSAR OFAAR ROAR EWAR WFARU CSU OFARU EWRU PD'"/>
    <!-- ****************************************************************************-->
    <!-- **** Set the variable for the Event ID of the Pipeline Complete Event   ****-->
    <!-- ****************************************************************************-->
    <xsl:variable name="PipelineCompleteEventID" select="/Integration/Case/CaseEvent[@Op='A']/EventType[contains(concat(' ', $PipeLineCompleteEvent, ' '), concat(' ', @Word, ' '))]/../@InternalEventID"/>
    <!-- *******************************************************************************************************-->
    <!--**** Determine if the process action event was added to the case before the pipeline complete event ****-->
    <!-- *******************************************************************************************************-->
    <xsl:choose>
      <xsl:when test="/Integration/Case/CaseEvent[@Op='A']/EventType[contains(concat(' ', $PipeLineCompleteEvent, ' '), concat(' ', @Word, ' '))]">
        <xsl:if test="/Integration/Case/CaseEvent[EventType[contains(concat(' ', $EventTypeList, ' '), concat(' ', @Word, ' '))] and Deleted='false' and @InternalEventID &lt; $PipelineCompleteEventID][last()]/EventType/@Word=$ProcessActionEvent">
          <xsl:if test="$CheckCourtNode='X'">
            <ProcessType>
              <xsl:value-of select="$ProcessType"/>
            </ProcessType>
            <ProcessActionType>
              <xsl:value-of select="$ProcessActionEvent"/>
            </ProcessActionType>
            <ProcessActionDate>
              <xsl:value-of select="/Integration/Case/CaseEvent[EventType[contains(concat(' ', $EventTypeList, ' '), concat(' ', @Word, ' '))] and Deleted='false' and @InternalEventID &lt; $PipelineCompleteEventID][last()]/EventType[@Word=$ProcessActionEvent]/../EventDate"/>
            </ProcessActionDate>
          </xsl:if>
        </xsl:if>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>









