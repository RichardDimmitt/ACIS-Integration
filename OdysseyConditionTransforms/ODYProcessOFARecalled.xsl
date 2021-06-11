<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:strip-space elements="*"/>
  <xsl:output omit-xml-declaration="yes"/>
  <!--  *****************************************************************************************  * -->
<!--  *  Template to determine if a E11410 ACIS message as processed.                              * -->
<!--  *  Modification History.                                                                     * -->
<!--  *  2021-06-10 RED initial creation                                                           * -->
<!--  *******************************************************************************************  * -->
  <xsl:template name="ODYProcessOFARecalled">
    <xsl:choose>
      <!-- A criminal case event has been added by someone other that system (Electronic Warrants) -->
      <xsl:when test="/Integration/ControlPoint['SAVE-CR-EVENT' and @UserID!='system']">
        <!-- The has has at least one warrantID cross reference number -->
        <xsl:if test="/Integration/Case/CaseCrossReference[CaseCrossReferenceType/@Word='EWWRNTID']/CrossCaseNumber">
          <!-- The EWR - Processed Recalled case event was added to the case. -->
          <xsl:if test="/Integration/Case/CaseEvent[@Op='A']/EventType[@Word='EWR']">
            <updateType>
              <xsl:text>recall-unserved-OFA</xsl:text>
            </updateType>
          </xsl:if>
        </xsl:if>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>
