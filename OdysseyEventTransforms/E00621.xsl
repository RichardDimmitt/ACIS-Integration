<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <!-- ***************************************************************************-->
  <!-- ******* template for E00621 Defendant Adress Change Line 2 ****************-->
  <!-- ***************************************************************************-->
  <xsl:template name="E00621">
    <xsl:variable name="DefendantID">
      <xsl:value-of select="/Integration/Case/CaseParty[./Connection/@BaseConnection='DF']/@InternalPartyID"/>
    </xsl:variable>
    <xsl:if test="/Integration/Party[@InternalPartyID=$DefendantID]/Address[@PartyCurrent='true']">
      <Event>
        <xsl:attribute name="EventID">
          <xsl:text>E00621</xsl:text>
        </xsl:attribute>
        <xsl:attribute name="TrailerRecord">
          <xsl:text>TotalEventRec</xsl:text>
        </xsl:attribute>
        <!-- Flag -->
        <Data Position="1" Length="6" Segment="Flag">
          <xsl:text>E00621</xsl:text>
        </Data>
        <!--CraiOffenseNumber-->
        <Data Position='2' Length='2' Segment='CraiOffenseNumber' AlwaysNull="true" />
        <!--CraiOtherNumber-->
        <Data Position='3' Length='2' Segment='CraiOtherNumber' AlwaysNull="true" />
        <!-- CraiDefSecondAddress OLD -->
        <Data Position='4' Length='15' Segment='CRREAD-OLD' AlwaysNull="true"/>
        <!-- CraiDefSecondAddress -->
        <Data Position='5' Length='15' Segment='CRREAD'>
          <xsl:choose>
            <xsl:when test="(/Integration/Party[@InternalPartyID=$DefendantID]/Address[@PartyCurrent='true']/@Type='Standard')">
              <xsl:value-of select="/Integration/Party[@InternalPartyID=$DefendantID]/Address[@PartyCurrent='true']/AddressLine3"/>
            </xsl:when>
            <xsl:when test="(/Integration/Party[@InternalPartyID=$DefendantID]/Address[@PartyCurrent='true']/@Type='Standard With Attention')">
              <xsl:value-of select="/Integration/Party[@InternalPartyID=$DefendantID]/Address[@PartyCurrent='true']/AddressLine3"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="/Integration/Party[@InternalPartyID=$DefendantID]/Address[@PartyCurrent='true']/AddressLine2"/>
            </xsl:otherwise>
          </xsl:choose>
        </Data>
        <!-- Filler -->
        <Data Position='6' Length='160' Segment='Filler' AlwaysNull="true"/>
      </Event>
    </xsl:if>
  </xsl:template>
</xsl:stylesheet>


