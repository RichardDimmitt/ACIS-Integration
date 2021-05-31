<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <!-- ***************************************************************************-->
  <!-- *** template for E00630 Defendant Adress Change City, State, Zip **********-->
  <!-- ***************************************************************************-->
  <xsl:template name="E00630">
    <xsl:variable name="DefendantID">
      <xsl:value-of select="/Integration/Case/CaseParty[./Connection/@BaseConnection='DF']/@InternalPartyID"/>
    </xsl:variable>
    <xsl:variable name="ZIP" select="substring(/Integration/Party[@InternalPartyID=$DefendantID]/Address[@PartyCurrent='true']/Zip,1,5)"/>
    <xsl:if test="/Integration/Party[@InternalPartyID=$DefendantID]/Address[@PartyCurrent='true']/Foreign='false'">
      <Event>
        <xsl:attribute name="EventID">
          <xsl:text>E00630</xsl:text>
        </xsl:attribute>
        <xsl:attribute name="TrailerRecord">
          <xsl:text>TotalEventRec</xsl:text>
        </xsl:attribute>
        <!-- Flag -->
        <Data Position="1" Length="6" Segment="Flag">
          <xsl:text>E00630</xsl:text>
        </Data>
        <!--CraiOffenseNumber-->
        <Data Position='2' Length='2' Segment='CraiOffenseNumber' AlwaysNull="true" />
        <!--CraiOtherNumber-->
        <Data Position='3' Length='2' Segment='CraiOtherNumber' AlwaysNull="true" />
        <!-- Defendant Address City Old -->
        <Data Position='4' Length='15' Segment='CRRCTY-OLD' AlwaysNull="true"/>
        <!-- Defendant Address State Old -->
        <Data Position='5' Length='2' Segment='CRRDST-OLD' AlwaysNull="true"/>
        <!-- Defendant Address Zip Old -->
        <Data Position='6' Length='5' Segment='CRRZIP-OLD' AlwaysNull="true"/>
        <!-- Defendant Address Zip+4 Old -->
        <Data Position='7' Length='4' Segment='CRREZP-OLD' AlwaysNull="true"/>
        <!-- Defendant Address City 2 -->
        <Data Position='8' Length='15' Segment='CRRCTY'>
          <xsl:value-of select="/Integration/Party[@InternalPartyID=$DefendantID]/Address[@PartyCurrent='true']/City"/>
        </Data>
        <!-- Defendant Address State -->
        <Data Position='9' Length='2' Segment='CRRDST'>
          <xsl:value-of select="/Integration/Party[@InternalPartyID=$DefendantID]/Address[@PartyCurrent='true']/State"/>
        </Data>
        <!-- Defendant Address Zip -->
        <Data Position='10' Length='5' Segment='CRRZIP'>
          <xsl:choose>
            <xsl:when  test="($ZIP='00000')">
              <xsl:value-of select="''"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$ZIP"/>
            </xsl:otherwise>
          </xsl:choose>
        </Data>
        <!-- Defendant Address Zip+4 -->
        <Data Position='11' Length='4' Segment='CRRZIP'>
          <xsl:choose>
            <xsl:when  test="($ZIP='00000')">
              <xsl:value-of select="''"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="substring-after(/Integration/Party[@InternalPartyID=$DefendantID]/Address[@PartyCurrent='true']/Zip,'-')"/>
            </xsl:otherwise>
          </xsl:choose>
        </Data>
        <!-- Filler -->
        <Data Position='12' Length='138' Segment='Filler' AlwaysNull="true"/>
      </Event>
    </xsl:if>
  </xsl:template>
</xsl:stylesheet>
