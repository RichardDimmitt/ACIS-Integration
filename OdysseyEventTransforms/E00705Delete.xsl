<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <!-- ***************************************************************************-->
  <!-- *** template for E00705 Citation #, Check Digit, and Arrest #    **********-->
  <!-- *** Change Log:                                                         ***-->
  <!-- *** 11/29/2021: Initial Creation - INT-6617                             ***-->
  <!-- ***************************************************************************-->
  <xsl:template name="E00705Delete">
    <Event>
      <xsl:attribute name="EventID">
        <xsl:text>E00705</xsl:text>
      </xsl:attribute>
      <xsl:attribute name="TrailerRecord">
        <xsl:text>TotalEventRec</xsl:text>
      </xsl:attribute>
      <!-- Flag -->
      <Data Position="1" Length="6" Segment="Flag">
        <xsl:text>E00705</xsl:text>
      </Data>
      <!--CraiOffenseNumber-->
      <Data Position='2' Length='2' Segment='CraiOffenseNumber' AlwaysNull="true" />
      <!--CraiOtherNumber-->
      <Data Position='3' Length='2' Segment='CraiOtherNumber' AlwaysNull="true" />
      <!-- Citation Number Old -->
      <Data Position='4' Length='8' Segment='CRRWNO-OLD' AlwaysNull="true"/>
      <!-- Citation Validation Character Old -->
      <Data Position='5' Length='1' Segment='CRRWCDT-OLD' AlwaysNull="true"/>
      <!-- Citation Arrest Number Old -->
      <Data Position='6' Length='10' Segment='CRRARRNM-OLD' AlwaysNull="true"/>
      <!-- Citation Number -->
      <Data Position='7' Length='8' Segment='CRRWNO'>
        <xsl:value-of select="/Integration/Citation/CitationNumber"/>
      </Data>
      <!-- Citation Validation Character -->
      <Data Position='8' Length='1' Segment='CRRWCDT'>
        <xsl:value-of select="/Integration/Citation/CheckDigit"/>
      </Data>
      <!-- Citation Arrest Number -->
      <Data Position='9' Length='10' Segment='CRRARRNM' AlwaysNull="true"/>
      <!-- Filler -->
      <Data Position='10' Length='152' Segment='Filler' AlwaysNull="true"/>
    </Event>
  </xsl:template>
</xsl:stylesheet>







