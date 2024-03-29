<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:strip-space elements="*"/>
  <xsl:output omit-xml-declaration="yes"/>
  <!--  *****************************************************************************************  * -->
<!--  *  Template to determine if a E11410 ACIS message as processed.                              * -->
<!--  *  Modification History.                                                                     * -->
<!--  *  2021-06-10 RED initial creation                                                           * -->
<!--  *******************************************************************************************  * -->
  <xsl:template name="ACISRecallOFAActivity">
    <xsl:choose>
      <!-- A criminal case event has been added by someone other that system (Electronic Warrants) -->
      <xsl:when test="/Integration/ControlPoint['SAVE-CR-EVENT' and @UserID!='system']">
        <!-- The has has at least one warrantID cross reference number -->
        <xsl:if test="/Integration/Case/CaseCrossReference[CaseCrossReferenceType/@Word='EWWRNTID']/CrossCaseNumber">
          <!-- *************************************************************** -->
          <!-- *** Check for E11410 OFA Date Change Event                  *** -->
          <!-- *************************************************************** -->
          <xsl:if test="/Integration/Case/CaseEvent[@Op='A']/EventType[@Word='ACISOFA']">
            <updateType>
              <xsl:text>recall-unserved-OFA</xsl:text>
            </updateType>
            <reason>
              <xsl:text>Court Update</xsl:text>
            </reason>
          </xsl:if>
          <!-- *************************************************************** -->
          <!-- *** Check for E50100 Disposition Change Event               *** -->
          <!-- *** CD, CV, DC, DD, FE, HC, JR, JU, MA, NB, NP, OT, PC, PO  *** -->
          <!-- *** PR, RM, SI, ST, TD, VD, WC, WD, WE, WM, WP              *** -->
          <!-- *** Dispositions to Recall                                  *** -->
          <!-- *************************************************************** -->
          <xsl:if test="/Integration/Case/CaseEvent[@Op='A']/EventType[contains('ACISMODCD ACISMODCV ACISMODDC ACISMODDD ACISMODFE ACISMODHC ACISMODJR ACISMODJU ACISMODMA ACISMODNB ACISMODNP ACISMODOT ACISMODPC ACISMODPO ACISMODPR ACISMODRM ACISMODSI ACISMODST ACISMODTD ACISMODVD ACISMODWC ACISMODWD ACISMODWE ACISMODWM ACISMODWP',@Word)]">
            <updateType>
              <xsl:text>recall-unserved-OFA-by-count</xsl:text>
            </updateType>
            <offenseCount>
              <xsl:value-of select="/Integration/Case/Charge[@InternalChargeID=/Integration/Case/CaseEvent[@Op='A']/ChargeID/@InternalChargeID]/ChargeHistory[@Stage='Case Filing']/ChargeNumber"/>
            </offenseCount>
            <reason>
              <xsl:text>Court Update</xsl:text>
            </reason>
          </xsl:if>
        </xsl:if>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>



