<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:strip-space elements="*"/>
  <xsl:output omit-xml-declaration="yes"/>
  <!--  *****************************************************************************************  * -->
<!--  *  Template to record if a process has been deleted.                                         * -->
<!--  *  Modification History.                                                                     * -->
<!--  *  2021-06-10 RED initial creation                                                           * -->
<!--  *******************************************************************************************  * -->
  <xsl:template name="ODYProcessDeleted">
    <xsl:choose>
      <!-- A criminal case event has been added by someone other that system (Electronic Warrants) -->
      <xsl:when test="/Integration/ControlPoint['SAVE-CR-EVENT' and @UserID!='system']">
        <!-- The has has at least one warrantID cross reference number -->
        <xsl:if test="/Integration/Case/CaseCrossReference[CaseCrossReferenceType/@Word='EWWRNTID']/CrossCaseNumber">
          <!-- The PD-Process Deleted case event was added to the case. -->
          <xsl:if test="/Integration/Case/CaseEvent[@Op='A']/EventType[@Word='PD']">
            <updateType>
              <xsl:text>delete</xsl:text>
            </updateType>
            <deletionReason>
              <xsl:text>delete</xsl:text>
            </deletionReason>
          </xsl:if>
        </xsl:if>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>









