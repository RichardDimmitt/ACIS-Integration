<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <!-- **************************************************************************-->
  <!-- ************* template for E30300 Interpreter Flag Change ***************-->
  <!-- *** Change Log:                                                        ***-->
  <!-- *** 8-09-2021: Updated to provide a default value of 999 in the event  ***-->
  <!--                the Odyssey language code is not a valid ACIS code      ***-->
  <!-- ***            ODY-350220                                              ***-->
  <!-- *** 8-13-2021: Updated to not provide a default value of 999 in the    ***-->
  <!--                event there is no language specified in Odyssey INT-6313*** -->
  <!-- **************************************************************************-->
  <xsl:template name="E30300">
    <xsl:variable name="DefendantID">
      <xsl:value-of select="/Integration/Case/Charge[1]/@InternalPartyID"/>
    </xsl:variable>
    <xsl:variable name="LanguageCode">
      <xsl:value-of select="/Integration/Party[@InternalPartyID=$DefendantID and NeedsInterpreter='true']/Language[@PrimaryLanguage='true']/@Word"/>
    </xsl:variable>
    <xsl:variable name="ACISLanguageList" select="'999 AMH ARB ASE BOS CES CHK CLY CMN CMO FRA GUJ HAK HAT HAU HIN HND HNJ IBO IND JPN JRA KAR KHM KLU KOR KQO LAO MAH MNG MYA NEP PAN PBT PES POL POR RAD RUS SPA SRP SWH TGL THA TIR UND URD VIE YUE'"/>
    <Langugage>
      <xsl:value-of select="$LanguageCode"/>
    </Langugage>
    <Event>
      <xsl:attribute name="EventID">
        <xsl:text>E30300</xsl:text>
      </xsl:attribute>
      <xsl:attribute name="TrailerRecord">
        <xsl:text>TotalEventRec</xsl:text>
      </xsl:attribute>
      <!--Flag-->
      <Data Position="1" Length="6" Segment="Flag">
        <xsl:text>E30300</xsl:text>
      </Data>
      <!--CraiOffenseNumber-->
      <Data Position='2' Length='2' Segment='CraiOffenseNumber' AlwaysNull="true" />
      <!--CraiOtherNumber-->
      <Data Position='3' Length='2' Segment='CraiOtherNumber' AlwaysNull="true" />
      <!-- Interpreter Flag (SP/OTS/ASL) Old -->
      <Data Position='4' Length='3' Segment='CRRINT-OLD' AlwaysNull="true"/>
      <!-- Interpreter Flag (SP/OTS/ASL) -->
      <Data Position='5' Length='3' Segment='CRRINT'>
        <xsl:choose>
          <xsl:when test="$LanguageCode = ''">
            <xsl:value-of select="''"/>
          </xsl:when>
          <xsl:when test="contains(concat(' ', $ACISLanguageList, ' '), concat(' ', $LanguageCode, ' '))">
            <xsl:value-of select="$LanguageCode"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>999</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </Data>
      <!-- Padding at the end to form the total length 200 -->
      <Data Position='6' Length='184' Segment='Filler' AlwaysNull="true"/>
    </Event>
  </xsl:template>
</xsl:stylesheet>






