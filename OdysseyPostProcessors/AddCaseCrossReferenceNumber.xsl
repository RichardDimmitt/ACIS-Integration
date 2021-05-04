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
        <xsl:call-template name="FormatCountyKey">
          <xsl:with-param name="KeyValue" select="/message/PreFinalTransformXml/Integration/Case/CaseNumber"/>
        </xsl:call-template>
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
    <!-- ********************************************************************-->
  <!-- *************** template for formating County Key ******************-->
  <!-- ********************************************************************-->
  <xsl:template name="FormatCountyKey">
    <xsl:param name="KeyValue"/>
    <xsl:variable name="StartValue" select="substring-after($KeyValue,'-')"/>
    <xsl:variable name="CountyNumber" select="substring-before($StartValue,'-')"/>
    <xsl:variable name="FinalValue">
      <xsl:call-template name="PaddWithZeros">
        <xsl:with-param name="Value" select="$CountyNumber"/>
        <xsl:with-param name="Length" select="3"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of  select="$FinalValue"/>
  </xsl:template>
  <!-- ********************************************************************-->
  <!-- ****************** template for padding zeros **********************-->
  <!-- ********************************************************************-->
  <xsl:template name="PaddWithZeros">
    <xsl:param name="Value"/>
    <xsl:param name="Length"/>
    <xsl:variable name="PaddingNeeded" select="$Length - string-length($Value)"/>
    <xsl:choose>
      <xsl:when  test="($PaddingNeeded &gt; 0)">
        <xsl:if test="($PaddingNeeded = 1)">
          <xsl:value-of  select="concat('0',$Value)"/>
        </xsl:if>
        <xsl:if test="($PaddingNeeded = 2)">
          <xsl:value-of  select="concat('00',$Value)"/>
        </xsl:if>
        <xsl:if test="($PaddingNeeded = 3)">
          <xsl:value-of  select="concat('000',$Value)"/>
        </xsl:if>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of  select="$Value"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>






