<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:template name="E00015">
  <!-- ********************************************************************-->
  <!-- **************** template for E00015 Case Delete********************-->
  <!-- ********************************************************************-->
    <!--Flag-->
    <Event>
      <xsl:attribute name="EventID">
        <xsl:text>E00015</xsl:text>
      </xsl:attribute>
      <Data Position="1" Length="1" Segment="Flag">
        <xsl:text>R</xsl:text>
      </Data>
      <!--Hold Reason-->
      <Data Position='1' Length='25' Segment='UNK-HOLDREASON'>
        <xsl:text>OTHER</xsl:text>
      </Data>
      <!--Hold Text-->
      <Data Position='2' Length='20' Segment='UNK-HOLDTEXT' AlwaysNull="true" />
      <!--Hold Comment-->
      <Data Position='3' Length='255' Segment='UNK-HOLDCOMMENT'>
        <xsl:text>PROCESS DELETED FROM ELECTRONIC WARRANTS</xsl:text>
      </Data>
      <!--Filler - 19 Characters-->
      <Data Position='4' Length='19' Segment='NA-FILLER-19' AlwaysNull="true" />
      <!-- Padding at the end to form the total length -->
      <Data Position='5' Length='0' Segment='Filler' AlwaysNull="true"/>
    </Event>
  </xsl:template>
</xsl:stylesheet>





