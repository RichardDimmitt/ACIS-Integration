<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:s="http://niem.gov/niem/structures/2.0" xmlns:msxsl="urn:schemas-microsoft-com:xslt" version="1.0" exclude-result-prefixes="msxsl">
  <xsl:output omit-xml-declaration="yes"/>
  <xsl:output method="xml" indent="yes"/>
  <xsl:template match="/">
    <xsl:variable name="CaseNumber">
      <xsl:value-of select="/message/PreFinalTransformXml/Integration/Case/CaseNumber"/>
    </xsl:variable>
    <xsl:variable name="CaseType">
      <xsl:value-of select="substring($CaseNumber,3,3)"/>
    </xsl:variable>
    <Message MessageType="AddCaseCrossReferenceNumber" UserID="1" Source="Tyler">
      <xsl:attribute name="ReferenceNumber">
        <xsl:value-of select="/message/PreFinalTransformXml/Integration/@MessageGUID"/>
      </xsl:attribute>
      <xsl:attribute name="NodeID">
        <xsl:value-of select="/message/PreFinalTransformXml/Integration/Case/Assignment/Court/NodeID"/>
      </xsl:attribute>
      <xsl:attribute name="Source">
        <xsl:value-of select="$CaseNumber"/>
      </xsl:attribute>
      <CaseID>
        <xsl:value-of select="/message/PreFinalTransformXml/Integration/Case/@InternalID"/>
      </CaseID>
      <CrossReferenceNumber>
        <!-- County -->
        <xsl:value-of select="substring-after($CaseNumber,'-')"/>
        <!-- Century -->
        <xsl:text>20</xsl:text>
        <!-- Year -->
        <xsl:value-of select="substring($CaseNumber,1,2)"/>
        <!-- Sequence -->
        <xsl:choose>
          <xsl:when test="$CaseType='CRS'">
              <xsl:value-of select="substring($CaseNumber,6,6)"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="substring($CaseNumber,5,6)"/>
          </xsl:otherwise>
        </xsl:choose>
        <!-- CaseType -->
        <xsl:choose>
          <xsl:when test="$CaseType='CRS'">
            <xsl:text>S</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>D</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </CrossReferenceNumber>
      <CrossReferenceNumberType>
        <xsl:text>ACIS</xsl:text>
      </CrossReferenceNumberType>
    </Message>
  </xsl:template>
</xsl:stylesheet>




