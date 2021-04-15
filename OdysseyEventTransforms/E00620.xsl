<?xml version="1.0" encoding="utf-8"?>
  <!-- ***************************************************************************-->
  <!-- ******* template for E00620 Defendant Adress Change Line 1 ****************-->
  <!-- ***************************************************************************-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<!-- Defendant Adress Change Line 1 -->
  <xsl:template name="E00620">
    <xsl:variable name="DefendantID">
      <xsl:value-of select="/Integration/Case/CaseParty[./Connection/@BaseConnection='DF']/@InternalPartyID"/>
    </xsl:variable>
    <xsl:if test="/Integration/Party[@InternalPartyID=$DefendantID]/Address[@PartyCurrent='true']">
      <Event>
        <xsl:attribute name="EventID">
          <xsl:text>E00620</xsl:text>
        </xsl:attribute>
        <xsl:attribute name="TrailerRecord">
          <xsl:text>TotalEventRec</xsl:text>
        </xsl:attribute>
        <!-- Flag -->
        <Data Position="1" Length="6" Segment="Flag">
          <xsl:text>E00620</xsl:text>
        </Data>
        <!--CraiOffenseNumber-->
        <Data Position='2' Length='2' Segment='CraiOffenseNumber' AlwaysNull="true" />
        <!--CraiOtherNumber-->
        <Data Position='3' Length='2' Segment='CraiOtherNumber' AlwaysNull="true" />
        <!-- Defendant Address Line 1 Old -->
        <Data Position='2' Length='20' Segment='CRRADDOLD' AlwaysNull="true"/>
        <!-- Defendant Address Line 1 -->
        <Data Position='3' Length='20' Segment='CRRADD'>
          <xsl:choose>
       <!-- For standard addresses, line 1 is actually line 2. -->
            <xsl:when test="(/Integration/Party[@InternalPartyID=$DefendantID]/Address[@PartyCurrent='true']/@Type='Standard')">
              <xsl:value-of select="/Integration/Party[@InternalPartyID=$DefendantID]/Address[@PartyCurrent='true']/AddressLine2"/>
            </xsl:when>
            <!-- "Standard with Attention", "Non Standard" -->
            <xsl:otherwise>
              <xsl:value-of select="/Integration/Party[@InternalPartyID=$DefendantID]/Address[@PartyCurrent='true']/AddressLine1"/>
            </xsl:otherwise>
          </xsl:choose>
        </Data>
      </Event>
    </xsl:if>
  </xsl:template>
</xsl:stylesheet>

