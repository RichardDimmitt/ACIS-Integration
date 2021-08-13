<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:strip-space elements="*"/>
  <xsl:output omit-xml-declaration="yes"/>
  <!--  *******************************************************************************************  * -->
  <!--  *  Modification History.                                                                     * -->
  <!--  *  2021-08-11 RED initial creation INT-6263                                                  * -->
  <!--  *******************************************************************************************  * -->
  <xsl:template name="ODYCaseAssignedToExpunctionUnit">
    <xsl:choose>
     <!-- ***************************************************************************************************** -->
     <!-- *** Check to determine if the case was updated by someone other than ACIS or Electronic Warrants  *** -->
     <!-- ***************************************************************************************************** -->
      <xsl:when test="/Integration/ControlPoint['SAVE-CR-CASE' and @UserID!='system' and @UserID != 'ewarrants' and @UserID != 'ACISIntegration']">
        <!-- ********************************************************************************** -->
        <!-- *** Check to determine if the case has at least one warrantID cross reference  *** -->
        <!-- ********************************************************************************** -->
        <xsl:if test="/Integration/Case/CaseCrossReference[CaseCrossReferenceType/@Word='EWWRNTID']/CrossCaseNumber">
          <!-- ********************************************************************************** -->
          <!-- *** Check to determine if the case was re-assigned to the AOC Expunction Unit  *** -->
          <!-- ********************************************************************************** -->
          <xsl:if test="/Integration/Case/Assignment[@Op='A' and @Current='true']/Court/NodeID[@Op='A' and .='104000000']">
            <xsl:if test="/Integration/Case/Assignment[@Op='E' and TransferOutDate/@Op='E']/Court[not(NodeID='104000000')]">
              <updateType>
                <xsl:text>delete</xsl:text>
              </updateType>
              <deletionReason>
                <xsl:text>Case was assigned to expuntion unit</xsl:text>
              </deletionReason>
            </xsl:if>
          </xsl:if>
          <!-- **************************************************************************************** -->
          <!-- *** Check to determine if the case assignment was edited to the AOC Expunction Unit  *** -->
          <!-- **************************************************************************************** -->
          <xsl:if test="/Integration/Case/Assignment[@Op='E' and @Current='true']/Court/NodeID[@Op='E' and .='104000000']">
            <updateType>
              <xsl:text>delete</xsl:text>
            </updateType>
            <deletionReason>
              <xsl:text>Update To Odyssey Applied By ACIS</xsl:text>
            </deletionReason>
          </xsl:if>
        </xsl:if>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>






