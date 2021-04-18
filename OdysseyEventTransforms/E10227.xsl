<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<!-- ********************************************************************-->
	<!-- ************* template for E10227 Bond Amount / Type Change **********-->
	<!-- ********************************************************************-->
  <xsl:template name="E10227">
    <xsl:if test="/Integration/BondSetting/BondSettingHistories/BondSettingHistory[last()]/BondSettingDetails/BondSettingDetail/Amount">
      <Event>
        <xsl:attribute name="EventID">
          <xsl:text>E10227</xsl:text>
        </xsl:attribute>
        <xsl:attribute name="TrailerRecord">
          <xsl:text>TotalEventRec</xsl:text>
        </xsl:attribute>
        <!--Flag-->
        <Data Position="1" Length="1" Segment="Flag">
          <xsl:text>E10227</xsl:text>
        </Data>
        <Data Position='2' Length='2' Segment='CraiServiceDateOLD' AlwaysNull="true"/>
        <Data Position='3' Length='2' Segment='CraiServiceDate' AlwaysNull="true"/>
        <!-- Bond Type Old -->
        <Data Position='4' Length='3' Segment='CRRBONDT-OLD' AlwaysNull="true"/>
        <!-- Bond Amount Old -->
        <Data Position='5' Length='7' Segment='CRRBONDA-OLD' AlwaysNull="true"/>
        <!-- Bond Type -->
        <Data Position='6' Length='3' Segment='CRRBONDT'>
          <xsl:value-of select="/Integration/Case/Charge[1]/ChargeHistory[@Stage='Case Filing']/BondType/@Word"/>
          <xsl:choose>
          <!-- Secured -->
            <xsl:when test="/Integration/BondSetting/BondSettingHistories/BondSettingHistory[last()]/BondSettingConditions/BondSettingCondition/ConditionType/@Word='RSECBD'">
              <xsl:text>SEC</xsl:text>
            </xsl:when>
            <!-- Unsecured -->
            <xsl:when test="/Integration/BondSetting/BondSettingHistories/BondSettingHistory[last()]/BondSettingConditions/BondSettingCondition/ConditionType/@Word='RUNSCBD'">
              <xsl:text>UNS</xsl:text>
            </xsl:when>
            <!-- Written Promise To Appear -->
            <xsl:when test="/Integration/BondSetting/BondSettingHistories/BondSettingHistory[last()]/BondSettingConditions/BondSettingCondition/ConditionType/@Word='RWRPRM'">
              <xsl:text>WPA</xsl:text>
            </xsl:when>
            <!-- Custody Release -->
            <xsl:when test="/Integration/BondSetting/BondSettingHistories/BondSettingHistory[last()]/BondSettingConditions/BondSettingCondition/ConditionType/@Word='RCUSREL'">
              <xsl:text>CUS</xsl:text>
            </xsl:when>
            <xsl:otherwise>
              <xsl:text/>
            </xsl:otherwise>
          </xsl:choose>
        </Data>
        <!-- Bond Amount -->
        <xsl:variable name="BondAmount">
          <xsl:value-of select="/Integration/BondSetting/BondSettingHistories/BondSettingHistory[last()]/BondSettingDetails/BondSettingDetail/Amount"/>
        </xsl:variable>
        <Data Position='7' Length='7' Segment='CRRBONDA'>
          <xsl:choose>
            <xsl:when test="contains($BondAmount,'.')='true'">
              <xsl:call-template name="PaddWithZeros">
                <xsl:with-param name="Value" select="substring-before($BondAmount,'.')"/>
                <xsl:with-param name="Length" select="7"/>
              </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
              <xsl:call-template name="BondAmount">
                <xsl:with-param name="Value" select="$BondAmount"/>
                <xsl:with-param name="Length" select="7"/>
              </xsl:call-template>
            </xsl:otherwise>
          </xsl:choose>
        </Data>
        <!-- Padding at the end to form the total length 200 -->
        <Data Position='8' Length='170' Segment='Filler' AlwaysNull="true"/>
      </Event>
    </xsl:if>
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
        <xsl:if test="($PaddingNeeded = 4)">
          <xsl:value-of  select="concat('0000',$Value)"/>
        </xsl:if>
        <xsl:if test="($PaddingNeeded = 5)">
          <xsl:value-of  select="concat('00000',$Value)"/>
        </xsl:if>
        <xsl:if test="($PaddingNeeded = 6)">
          <xsl:value-of  select="concat('000000',$Value)"/>
        </xsl:if>
        <xsl:if test="($PaddingNeeded = 7)">
          <xsl:value-of  select="concat('0000000',$Value)"/>
        </xsl:if>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of  select="$Value"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>


