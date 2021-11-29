<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<!-- *****************************************************************************-->
<!-- ************* template for E10227 Bond Amount / Type Delete *****************-->
  <!-- *** Change Log:                                                         ***-->
  <!-- *** 11/29/2021: Initial Creation - INT-6617                             ***-->
  <!-- ***************************************************************************-->
  <xsl:template name="E10227Delete">
    <Event>
      <xsl:attribute name="EventID">
        <xsl:text>E10227</xsl:text>
      </xsl:attribute>
      <xsl:attribute name="TrailerRecord">
        <xsl:text>TotalEventRec</xsl:text>
      </xsl:attribute>
      <!--Flag-->
      <Data Position="1" Length="6" Segment="Flag">
        <xsl:text>E10227</xsl:text>
      </Data>
      <!--CraiOffenseNumber-->
      <Data Position='2' Length='2' Segment='CraiOffenseNumber' AlwaysNull="true" />
      <!--CraiOtherNumber-->
      <Data Position='3' Length='2' Segment='CraiOtherNumber' AlwaysNull="true" />
      <!-- Bond Type Old -->
      <Data Position='4' Length='3' Segment='CRRBONDT-OLD' AlwaysNull="true"/>
      <!-- Bond Amount Old -->
      <Data Position='5' Length='7' Segment='CRRBONDA-OLD' AlwaysNull="true"/>
      <!-- Bond Type -->
      <Data Position='6' Length='3' Segment='CRRBONDT' AlwaysNull="true"/>
      <!-- Bond Amount -->
      <Data Position='7' Length='7' Segment='CRRBONDA' AlwaysNull="true"/>
      <!-- Padding at the end to form the total length 200 -->
      <Data Position='8' Length='170' Segment='Filler' AlwaysNull="true"/>
    </Event>
  </xsl:template>
</xsl:stylesheet>














