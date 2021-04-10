<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
 <xsl:template name="Trailer">
  <Trailer>
    <xsl:variable name="TotalOffenseRecords">
      <xsl:value-of select="count(/Integration/Case/Charge/ChargeHistory[@Stage='Case Filing']) "/>
    </xsl:variable>
    <xsl:variable name="TotalAliasRecords">
      <xsl:choose>
        <xsl:when  test="/Integration[IntegrationConditions/IntegrationCondition/ACISEvent='E00660']/Party[@InternalPartyID=/Integration/Case/Charge[1]/@InternalPartyID]/PartyName[not(@Current='true')]">2</xsl:when>
        <xsl:otherwise>1</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="TotalComplaintRecords">
      <xsl:choose>
        <xsl:when  test="/Integration/Case/CaseParty[Connection/@Word='CMPL']">1</xsl:when>
        <xsl:otherwise>0</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="TotalWitnessRecords">
      <xsl:choose>
        <xsl:when  test="/Integration/Case/CaseParty[Connection/@Word='WIT']">1</xsl:when>
        <xsl:otherwise>0</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <!-- Check for Event Records -->
    <xsl:variable name="E00740">
      <xsl:choose>
        <xsl:when  test="/Integration[IntegrationConditions/IntegrationCondition/ACISEvent='E00740']/Party[@InternalPartyID=/Integration/Case/Charge[1]/@InternalPartyID]/OtherID[OtherIDAgency/@Word='LID']">1</xsl:when>
        <xsl:otherwise>0</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="E10161">
      <xsl:choose>
        <xsl:when  test="/Integration[IntegrationConditions/IntegrationCondition/ACISEvent='E10161']/Case/CaseCrossReference[CaseCrossReferenceType/@Word='LECN']">1</xsl:when>
        <xsl:otherwise>0</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="TotalEventRecords">
      <xsl:value-of select="$E00740 + $E10161"/>
    </xsl:variable>
    <xsl:variable name="TotalRecordsSent">
      <xsl:value-of select="2+$TotalOffenseRecords + $TotalAliasRecords + $TotalComplaintRecords + $TotalWitnessRecords + $TotalEventRecords"/>
    </xsl:variable>
    <!-- Build Final Trailer Record -->
    <Data Position='1' Length='1' Segment='Flag'>T</Data>
    <Data Position='2' Length='3' Segment='TotalRecordsSent'>
      <xsl:call-template name="PaddWithZeros">
        <xsl:with-param name="Value" select="$TotalRecordsSent"/>
        <xsl:with-param name="Length" select="3"/>
      </xsl:call-template>
    </Data>
    <Data Position='3' Length='2' Segment='TotalOffenseRec'>
      <xsl:call-template name="PaddWithZeros">
        <xsl:with-param name="Value" select="$TotalOffenseRecords"/>
        <xsl:with-param name="Length" select="2"/>
      </xsl:call-template>
    </Data>
    <Data Position='4' Length='3' Segment='TotalAliasRec'>
      <xsl:call-template name="PaddWithZeros">
        <xsl:with-param name="Value" select="$TotalAliasRecords"/>
        <xsl:with-param name="Length" select="3"/>
      </xsl:call-template>
    </Data>
    <Data Position='5' Length='3' Segment='TotalWitnessRec'>
      <xsl:call-template name="PaddWithZeros">
        <xsl:with-param name="Value" select="$TotalComplaintRecords + $TotalWitnessRecords"/>
        <xsl:with-param name="Length" select="3"/>
      </xsl:call-template>
    </Data>
    <Data Position='6' Length='2' Segment='TotalSpecCondRec'>00</Data>
    <Data Position='7' Length='2' Segment='TotalNpcRec'>00</Data>
    <Data Position='8' Length='3' Segment='TotalEventRec'>
      <xsl:call-template name="PaddWithZeros">
        <xsl:with-param name="Value" select="$TotalEventRecords"/>
        <xsl:with-param name="Length" select="3"/>
      </xsl:call-template>
    </Data>
    <Data Position='9' Length='3' Segment='TotalDispositionRec'>000</Data>
    <Data Position='10' Length='3' Segment='TotalJudgementRec'>000</Data>
    <Data Position='11' Length='10' Segment='TotalVisionLinkCode'>0 </Data>
  </Trailer>
  </xsl:template>
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


