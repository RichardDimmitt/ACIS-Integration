<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:template name="OdysseyNodeCheck">
  <!-- ****************************************************************************-->
  <!-- **** template to check to see if the message was generated from         ****-->
  <!-- **** a Node that is not live on Odyssey and not the AOC Expunction Unit ****-->
  <!-- **** This exclusion list will grow as more Odyssey courts go live       ****-->
  <!-- ****************************************************************************-->
    <xsl:if test="/Integration/Case/Court[not(NodeID='104000000')]">
        <xsl:text>X</xsl:text>
    </xsl:if>
  </xsl:template>
</xsl:stylesheet>
