<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <!-- ********************************************************************-->
  <!-- ************* template for E00740 LID Number Delete ****************-->
  <!-- *** Change Log:                                                  ***-->
  <!-- *** 11/29/2021: Initial Creation - INT-6617                      ***-->
  <!-- ********************************************************************-->
  <xsl:template name="E00740Delete">
    <Event>
      <xsl:attribute name="EventID">
        <xsl:text>E00740</xsl:text>
      </xsl:attribute>
      <xsl:attribute name="TrailerRecord">
        <xsl:text>TotalEventRec</xsl:text>
      </xsl:attribute>
      <!--Flag-->
      <Data Position="1" Length="6" Segment="Flag">
        <xsl:text>E00740</xsl:text>
      </Data>
      <!--CraiOffenseNumber-->
      <Data Position='2' Length='2' Segment='CraiOffenseNumber' AlwaysNull="true" />
      <!--CraiOtherNumber-->
      <Data Position='3' Length='2' Segment='CraiOtherNumber' AlwaysNull="true" />
      <!--pidBefore-->
      <Data Position='4' Length='15' Segment='pidBefore' AlwaysNull="true" />
      <!--LID Number-->
      <Data Position='5' Length='15' Segment='CRRLID' AlwaysNull="true" />
      <!-- Padding at the end to form the total length -->
      <Data Position='6' Length='160' Segment='Filler' AlwaysNull="true"/>
    </Event>
  </xsl:template>
</xsl:stylesheet>






