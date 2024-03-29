<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <!-- ************************************************************************************-->
  <!-- *** template for E00732 FingerPrint Reason Delete **********************************-->
  <!-- *** Change Log:                                                                  ***-->
  <!-- *** 11/29/2021: Initial Creation - INT-6617                                      ***-->
  <!-- ************************************************************************************-->
  <xsl:template name="E00732Delete">
    <Event>
      <xsl:attribute name="EventID">
        <xsl:text>E00732</xsl:text>
      </xsl:attribute>
      <xsl:attribute name="TrailerRecord">
        <xsl:text>TotalEventRec</xsl:text>
      </xsl:attribute>
      <!-- Flag -->
      <Data Position="1" Length="6" Segment="Flag">
        <xsl:text>E00732</xsl:text>
      </Data>
      <!--CraiOffenseNumber-->
      <Data Position='2' Length='2' Segment='CraiOffenseNumber' AlwaysNull="true" />
      <!--CraiOtherNumber-->
      <Data Position='3' Length='2' Segment='CraiOtherNumber' AlwaysNull="true" />
      <!-- FingerPrint Reason Code Old -->
      <Data Position='4' Length='2' Segment='CRRREA-OLD' AlwaysNull="true"/>
      <!-- FingerPrint Reason Code -->
      <Data Position='5' Length='2' Segment='CRRREA' AlwaysNull="true"/>
      <!-- Filler -->
      <Data Position='6' Length='186' Segment='Filler' AlwaysNull="true"/>
    </Event>
  </xsl:template>
</xsl:stylesheet>








