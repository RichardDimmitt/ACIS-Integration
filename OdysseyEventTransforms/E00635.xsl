<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <!-- ********************************************************************-->
  <!-- ************* template for E00635 Race/Gender Change ***************-->
  <!-- ********************************************************************-->
  <xsl:template name="E00635">
    <xsl:variable name="DefendantID">
      <xsl:value-of select="/Integration/Case/Charge[1]/@InternalPartyID"/>
    </xsl:variable>
    <Event>
      <xsl:attribute name="EventID">
        <xsl:text>E00635</xsl:text>
      </xsl:attribute>
      <xsl:attribute name="TrailerRecord">
        <xsl:text>TotalEventRec</xsl:text>
      </xsl:attribute>
      <!--Flag-->
      <Data Position="1" Length="6" Segment="Flag">
        <xsl:text>E00635</xsl:text>
      </Data>
      <Data Position='2' Length='2' Segment='CraiServiceDateOLD' AlwaysNull="true"/>
      <Data Position='3' Length='2' Segment='CraiServiceDate' AlwaysNull="true"/>
      <!--Defendant Race Old-->
      <Data Position="4" Length="1" Segment="CRRACE-OLD"/>
      <!--Defendant Sex Old-->
      <Data Position="5" Length="1" Segment="CRRSEX-OLD"/>
      <!--Defendant Race-->
      <Data Position="6" Length="1" Segment="CRRACE">
        <xsl:call-template name="GetACISRaceCode">
          <xsl:with-param name="code" select ="/Integration/Party[@InternalPartyID=$DefendantID]/Race/@Word"/>
        </xsl:call-template>
      </Data>
      <!--Defendant Sex-->
      <Data Position="7" Length="1" Segment="CRRSEX">
        <xsl:call-template name="GetACISSexCode">
          <xsl:with-param name="code" select ="substring(/Integration/Party[@InternalPartyID=$DefendantID]/Gender/@Word,1,1)"/>
        </xsl:call-template>
      </Data>
      <!-- Padding at the end to form the total length -->
      <Data Position='8' Length='186' Segment='Filler' AlwaysNull="true"/>
    </Event>
  </xsl:template>
  <!-- ********************************************************************-->
  <!-- ****************** template for mapping race codes *****************-->
  <!-- ********************************************************************-->
  <xsl:template name="GetACISRaceCode">
    <xsl:param name ="code"/>
    <xsl:choose>
      <xsl:when test="($code='A')">
        <xsl:value-of select="'A'"/>
      </xsl:when>
      <xsl:when test="($code='AB')">
        <xsl:value-of select="'U'"/>
      </xsl:when>
      <xsl:when test="($code='B')">
        <xsl:value-of select="'B'"/>
      </xsl:when>
      <xsl:when test="($code='I')">
        <xsl:value-of select="'I'"/>
      </xsl:when>
      <xsl:when test="($code='R')">
        <xsl:value-of select="'U'"/>
      </xsl:when>
      <xsl:when test="($code='S')">
        <xsl:value-of select="'H'"/>
      </xsl:when>
      <xsl:when test="($code='U')">
        <xsl:value-of select="'U'"/>
      </xsl:when>
      <xsl:when test="($code='W')">
        <xsl:value-of select="'W'"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="'O'"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <!-- ********************************************************************-->
  <!-- ****************** template for mapping sex codes *****************-->
  <!-- ********************************************************************-->
  <xsl:template name="GetACISSexCode">
    <xsl:param name ="code"/>
    <xsl:choose>
      <xsl:when test="($code='F')">
        <xsl:value-of select="'F'"/>
      </xsl:when>
      <xsl:when test="($code='M')">
        <xsl:value-of select="'M'"/>
      </xsl:when>
      <xsl:when test="($code='G')">
        <xsl:value-of select="'F'"/>
      </xsl:when>
      <xsl:when test="($code='N')">
        <xsl:value-of select="'M'"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="'U'"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>


