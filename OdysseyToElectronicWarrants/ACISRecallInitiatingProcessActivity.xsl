<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:strip-space elements="*"/>
  <xsl:output omit-xml-declaration="yes"/>
  <!--  *****************************************************************************************  * -->
<!--  *  Template to determine if a E11410 ACIS message as processed.                              * -->
<!--  *  Modification History.                                                                     * -->
<!--  *  2021-06-10 RED initial creation                                                           * -->
<!--  *******************************************************************************************  * -->
  <xsl:template name="ACISRecallInitiatingProcessActivity">
    <xsl:choose>
      <!-- A criminal case event has been added by someone other that system (Electronic Warrants) -->
      <xsl:when test="/Integration/ControlPoint['SAVE-CR-EVENT' and @UserID!='system']">
        <!-- The has has at least one warrantID cross reference number -->
        <xsl:if test="/Integration/Case/CaseCrossReference[CaseCrossReferenceType/@Word='EWWRNTID']/CrossCaseNumber">
          <!-- *************************************************************** -->
          <!-- *** Check for E50100 Disposition Change Event               *** -->
          <!-- *** CD, SI, VD, Dispositions to recall                      *** -->
          <!-- *************************************************************** -->
          <xsl:if test="/Integration/Case/CaseEvent[@Op='A']/EventType[contains('ACISMODCD ACISMODSI ACISMODVD',@Word)]">
            <updateType>
              <xsl:text>recall-unserved-initiating-process</xsl:text>
            </updateType>
            <reason>
              <xsl:text>Court Update</xsl:text>
            </reason>
          </xsl:if>
        </xsl:if>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>



