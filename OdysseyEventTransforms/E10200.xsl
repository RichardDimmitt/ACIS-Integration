<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<!-- **********************************************************************-->
<!-- ******************* template for E10200 Craibond *********************-->
<!-- **********************************************************************-->
<!-- *** Note, This event is not properly documented and there are no   ***-->
<!-- ***       examples of this event in their production logs.         ***-->
<!-- ***       The NCAWARE source code provided by the AOC suggest we   ***-->
<!-- ***       should be sending this information in the E10227 event   ***-->
<!-- ***       instead.                                                 ***-->
<!-- ***       This event is being added at the request of the AOC      ***-->
<!-- ***       against our recommendations.                             ***-->
<!-- *** Change Log: 7-21-2021: RED Initial Creation                    ***-->
<!-- **********************************************************************-->
<!-- ***  Copybook: Crim.Prod.Copylib(CraiBonod)                        ***-->
<!-- ***                                                                ***-->
<!-- *** 01     Crai-Bond-Record                                        ***-->
<!-- *** 05     Crai-Bond-Data                                          ***-->
<!-- *** 10     Crai-Bond-Line-Number             9(02)                 ***-->
<!-- *** 10     Crai-Bond-Type                    X(03)                 ***-->
<!-- *** 10     Crai-Bond-Amount                  9(07)                 ***-->
<!-- ***        Crai-Bond-Amount-R                                      ***-->
<!-- *** 10     Redefines Crai-Bond-Amount	  X(07)                 ***-->
<!-- *** 10	Crai-Bond-Serial-Number           X(10)                 ***-->
<!-- *** 10	Crai-Bond-Issue-Date              X(08)                 ***-->
<!-- *** 10	Crai-Bond-Termination-Date        X(08)                 ***-->
<!-- *** 10	Crai-Bondsman-Ssn                 X(09)                 ***-->
<!-- *** 10	Crai-Surety-Name                  X(28)                 ***-->
<!-- *** 10	Crai-Judge-Id                     X(06)                 ***-->
<!-- *** 10	Crai-Bond-Vision-Link-Code        X(10)                 ***-->
<!-- *** 10	Filler                            X(58)                 ***-->
<!-- **********************************************************************-->
  <xsl:template name="E10200">
    <Event>
      <xsl:attribute name="EventID">
        <xsl:text>E10200</xsl:text>
      </xsl:attribute>
      <xsl:attribute name="TrailerRecord">
        <xsl:text>TotalEventRec</xsl:text>
      </xsl:attribute>
      <!--Flag-->
      <Data Position="1" Length="1" Segment="Flag">
        <xsl:text>B</xsl:text>
      </Data>
      <!--Crai-Bond-Line-Number-->
      <Data Position='2' Length='2' Segment='CraiBondLineNumber' AlwaysNull="true" />
      <!--Crai-Bond-Type-->
      <Data Position='3' Length='3' Segment='CRRBONDT'>
        <xsl:call-template name="GetACISBondTypeCode">
          <xsl:with-param name="code" select ="/Integration/BondSetting[Deleted='false'][last()]/BondSettingHistories[last()]/BondSettingHistory/Primary/SettingBondType/Specified/SpecifiedType/@Word"/>
        </xsl:call-template>
      </Data>
      <!--Crai-Bond-Amount-->
      <xsl:variable name="BondAmount">
        <xsl:value-of select="/Integration/BondSetting[Deleted='false'][last()]/BondSettingHistories[last()]/BondSettingHistory/Primary/Amount"/>
      </xsl:variable>
      <Data Position='4' Length='7' Segment='CRRBONDA'>
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
     <!-- Crai-Bond-Serial-Number -->
      <Data Position='5' Length='10' Segment='CraiBondSerialNumber' AlwaysNull="true"/>
      <Data Position='6' Length='8' Segment='CraiBondIssueDate' AlwaysNull="true"/>
      <Data Position='7' Length='8' Segment='CraiBondTerminationDate' AlwaysNull="true"/>
      <Data Position='8' Length='9' Segment='CraiBondsmanSsn' AlwaysNull="true"/>
      <Data Position='9' Length='28' Segment='CraiSuretyName' AlwaysNull="true"/>
      <Data Position='10' Length='6' Segment='CraiJudgeId' AlwaysNull="true"/>
      <Data Position='11' Length='10' Segment='CraiBondVisionLinkCode' AlwaysNull="true"/>
      <Data Position='12' Length='58' Segment='Filler' AlwaysNull="true"/>
    </Event>
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









