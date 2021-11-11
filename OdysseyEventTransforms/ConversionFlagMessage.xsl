<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <!-- ************************************************************************-->
  <!-- **********  Template for Conversion Flag Message           *************-->
  <!-- **** 11-05-21 Initial Creation, INT-6692                            ****-->
  <!-- ************************************************************************-->
  <xsl:template name="ConversionFlagMessage">
      <Data Position="1" Length="3" Segment="CraiKeyCounty">
        <xsl:call-template name="FormatCountyKey">
          <xsl:with-param name="KeyValue" select="/Integration/Case/CaseNumber"/>
        </xsl:call-template>
      </Data>
      <Data Position="2" Length="2" Segment="CraiKeyCentury">
        <xsl:variable name="caseYear">
          <xsl:value-of select="substring(/Integration/Case/CaseNumber,1,2)"/>
        </xsl:variable>
        <xsl:choose>
          <xsl:when test="$caseYear &gt; '50'">
            <xsl:text>19</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>20</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </Data>
      <Data Position="3" Length="2" Segment="CraiKeyYear">
        <xsl:value-of select="$caseYear"/>
      </Data>
      <Data Position="4" Length="6" Segment="CraiKeySequence">
        <xsl:choose>
          <xsl:when test="substring(/Integration/Case/CaseNumber,3,3)='CRS'">
            <xsl:value-of select="substring(/Integration/Case/CaseNumber,6,6)"/>
          </xsl:when>
          <xsl:when test="substring(/Integration/Case/CaseNumber,3,2)='CR'">
            <xsl:value-of select="substring(/Integration/Case/CaseNumber,5,6)"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="substring(/Integration/Case/CaseNumber,5,6)"/>
          </xsl:otherwise>
        </xsl:choose>
      </Data>
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




