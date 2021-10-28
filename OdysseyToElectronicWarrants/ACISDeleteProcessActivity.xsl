<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:strip-space elements="*"/>
  <xsl:output omit-xml-declaration="yes"/>
  <!--  *****************************************************************************************  * -->
<!--  *  Modification History.                                                                     * -->
<!--  *  2021-06-14 RED initial creation                                                           * -->
<!--  *******************************************************************************************  * -->
  <xsl:template name="ACISDeleteProcessActivity">
    <xsl:choose>
      <!-- A criminal case event has been added by someone other that system (Electronic Warrants) -->
      <xsl:when test="/Integration/ControlPoint['SAVE-CR-EVENT' and @UserID!='system']">
        <!-- The has has at least one warrantID cross reference number -->
        <xsl:if test="/Integration/Case/CaseCrossReference[CaseCrossReferenceType/@Word='EWWRNTID']/CrossCaseNumber">
          <!-- *************************************************************** -->
          <!-- *** Check for E00015 Case Deleted Event                     *** -->
          <!-- *************************************************************** -->
          <xsl:if test="/Integration/Case/CaseEvent[@Op='A']/EventType[@Word='ACISDEL']">
            <updateType>
              <xsl:text>delete</xsl:text>
            </updateType>
            <deletionReason>
              <xsl:text>Update To Odyssey Applied By ACIS</xsl:text>
            </deletionReason>
          </xsl:if>
          <!-- *************************************************************** -->
          <!-- *** Check for E00020 Case Expunged Event                    *** -->
          <!-- *************************************************************** -->
          <xsl:if test="/Integration/Case/CaseEvent[@Op='A']/EventType[@Word='ACISEXPUNG']">
            <updateType>
              <xsl:text>delete</xsl:text>
            </updateType>
            <deletionReason>
              <xsl:text>Update To Odyssey Applied By ACIS</xsl:text>
            </deletionReason>
          </xsl:if>
          <!-- *************************************************************** -->
          <!-- *** Check for E50100 Disposition Change Event               *** -->
          <!-- *** NS, Disposition to delete                               *** -->
          <!-- *************************************************************** -->
          <xsl:if test="/Integration/Case/CaseEvent[@Op='A']/EventType[@Word='ACISMODNS']">
            <updateType>
              <xsl:text>delete</xsl:text>
            </updateType>
            <deletionReason>
              <xsl:text>Court Update</xsl:text>
            </deletionReason>
          </xsl:if>
        </xsl:if>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>



