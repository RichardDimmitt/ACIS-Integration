<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<!-- *****************************************************************************-->
<!-- ************* template for E10227 Bond Amount / Type Change *****************-->
<!-- *** 7/21/21: Updated amount to not provide 'cent' information INT-5966    ***-->
<!-- *** 8/17/21: Updated to not send if no bond setting is available INT-6325 ***-->
<!-- *****************************************************************************-->
  <xsl:template name="E10227">
    <xsl:if test="/Integration/BondSetting[Deleted='false'][last()]/BondSettingHistories[last()]/BondSettingHistory/Primary/SettingBondType/Specified/SpecifiedType">
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
      <Data Position='6' Length='3' Segment='CRRBONDT'>
        <xsl:call-template name="GetACISBondTypeCode">
          <xsl:with-param name="code" select ="/Integration/BondSetting[Deleted='false'][last()]/BondSettingHistories[last()]/BondSettingHistory/Primary/SettingBondType/Specified/SpecifiedType/@Word"/>
        </xsl:call-template>
      </Data>
      <!-- Bond Amount -->
      <xsl:variable name="BondAmount">
        <xsl:value-of select="/Integration/BondSetting[Deleted='false'][last()]/BondSettingHistories[last()]/BondSettingHistory/Primary/Amount"/>
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
            <xsl:call-template name="PaddWithZeros">
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
  <!-- *******************************************************************-->
  <!-- ********* template for mapping ACIS bond type codes ***************-->
  <!-- *** CSH Cash                                                    ***-->
  <!-- *** CUS Custody Release                                         ***-->
  <!-- *** PTR Pretrial Release                                        ***-->
  <!-- *** SEC Secured                                                 ***-->
  <!-- *** UNS Unsecured                                               ***-->
  <!-- *** WPA Written Promise to Appear                               ***-->
  <!-- *******************************************************************-->
  <xsl:template name="GetACISBondTypeCode">
    <xsl:param name ="code"/>
    <xsl:choose>
      <!--Corporate Surety Bond  - Civil and Probate-->
      <xsl:when test="($code='COR')">
        <xsl:value-of select="'SEC'"/>
      </xsl:when>
      <!--Secured Bond - Property by Accommodation-->
      <xsl:when test="($code='SECPA')">
        <xsl:value-of select="'SEC'"/>
      </xsl:when>
      <!--Custody Release-->
      <xsl:when test="($code='CUS')">
        <xsl:value-of select="'CUS'"/>
      </xsl:when>
      <!--Secured Bond - Property by Defendant-->
      <xsl:when test="($code='SECPD')">
        <xsl:value-of select="'SEC'"/>
      </xsl:when>
      <!--Secured Bond - Cash by Accommodation-->
      <xsl:when test="($code='SECCA')">
        <xsl:value-of select="'SEC'"/>
      </xsl:when>
      <!--Pre-Trial Release Program-->
      <xsl:when test="($code='PTR')">
        <xsl:value-of select="'PTR'"/>
      </xsl:when>
      <!--Secured Bond - Cash by Defendant-->
      <xsl:when test="($code='SECCD')">
        <xsl:value-of select="'SEC'"/>
      </xsl:when>
      <!--Unsecured Bond-->
      <xsl:when test="($code='UNS')">
        <xsl:value-of select="'UNS'"/>
      </xsl:when>
      <!--Written Promise to Appear-->
      <xsl:when test="($code='WPA')">
        <xsl:value-of select="'WPA'"/>
      </xsl:when>
      <!--Deed of Trust-  Civil and Probate-->
      <xsl:when test="($code='DOT')">
        <xsl:value-of select="'SEC'"/>
      </xsl:when>
      <!--Secured Bond - Professional Surety-->
      <xsl:when test="($code='SECPS')">
        <xsl:value-of select="'SEC'"/>
      </xsl:when>
      <!--Cash - Civil and Probate-->
      <xsl:when test="($code='CSH')">
        <xsl:value-of select="'CSH'"/>
      </xsl:when>
      <!--Bond to Stay Summary Ejectment-->
      <xsl:when test="($code='BTSSE')">
        <xsl:value-of select="'SEC'"/>
      </xsl:when>
      <!--Appeal Bond-->
      <xsl:when test="($code='APPB')">
        <xsl:value-of select="'UNS'"/>
      </xsl:when>
      <!--Bond to Discharge Claim of Lien-->
      <xsl:when test="($code='BDCL')">
        <xsl:value-of select="'SEC'"/>
      </xsl:when>
      <!--Defendant Bond to Claim and Delivery-->
      <xsl:when test="($code='DBCD')">
        <xsl:value-of select="'SEC'"/>
      </xsl:when>
      <!--Bond to Keep Possession of Motor Vehicle Taken Lienor-->
      <xsl:when test="($code='BMV')">
        <xsl:value-of select="'SEC'"/>
      </xsl:when>
      <!--Bond to Stay Execution on Possession Judgment-->
      <xsl:when test="($code='BSEJ')">
        <xsl:value-of select="'SEC'"/>
      </xsl:when>
      <!--Bond to Secure Pretrial Release of Motor Vehicle-->
      <xsl:when test="($code='BPTMV')">
        <xsl:value-of select="'SEC'"/>
      </xsl:when>
      <!--Secured Legacy-->
      <xsl:when test="($code='SECL')">
        <xsl:value-of select="'SEC'"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="'SEC'"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>









