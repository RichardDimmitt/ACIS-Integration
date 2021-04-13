<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <!-- ********************************************************************-->
  <!-- ******** template for E00805 Complainant *****************-->
  <!-- ********************************************************************-->
  <xsl:template name="E00805Complaintant">
    <xsl:variable name="complainantID">
      <xsl:value-of select="/Integration/Case/CaseParty[Connection/@Word='CMPL']/@InternalPartyID"/>
    </xsl:variable>
    <Event>
      <xsl:attribute name="EventID">
        <xsl:text>E00805</xsl:text>
      </xsl:attribute>
      <xsl:attribute name="TrailerRecord">
        <xsl:text>TotalWitnessRec</xsl:text>
      </xsl:attribute>
      <!--Flag-->
      <Data Position='1' Length='1' Segment='Flag'>
        <xsl:text>W</xsl:text>
      </Data>
      <!--Witness Name-->
      <Data Position='2' Length='28' Segment='CRWNAM'>
        <xsl:value-of select="/Integration/Party[@InternalPartyID=$complainantID]/PartyName[@Current='true']/FormattedName"/>
      </Data>
      <!--Witness Type-->
      <Data Position='3' Length='1' Segment='CRWTYP'>
        <xsl:text>C</xsl:text>
      </Data>
      <!--Witness Address Line 1-->
      <Data Position='4' Length='35' Segment='CRWAD'>
        <xsl:choose>
          <xsl:when test="(/Integration/Party[@InternalPartyID=$complainantID]/Address[@PartyCurrent='true']/@Type='Standard')">
            <xsl:value-of select="/Integration/Party[@InternalPartyID=$complainantID]/Address[@PartyCurrent='true']/AddressLine2"/>
          </xsl:when>
          <xsl:when test="(/Integration/Party[@InternalPartyID=$complainantID]/Address[@PartyCurrent='true']/@Type='Standard With Attention')">
            <xsl:value-of select="/Integration/Party[@InternalPartyID=$complainantID]/Address[@PartyCurrent='true']/AddressLine2"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="/Integration/Party[@InternalPartyID=$complainantID]/Address[@PartyCurrent='true']/AddressLine1"/>
          </xsl:otherwise>
        </xsl:choose>
      </Data>
      <!--Witness Address City-->
      <Data Position='5' Length='15' Segment='CRWCTY'>
        <xsl:value-of select="/Integration/Party[@InternalPartyID=$complainantID]/Address[@PartyCurrent='true']/City"/>
      </Data>
      <!--Witness Address State-->
      <Data Position='6' Length='2' Segment='CRWSTX'>
        <xsl:value-of select="/Integration/Party[@InternalPartyID=$complainantID]/Address[@PartyCurrent='true']/State"/>
      </Data>
      <!--Witness Address ZIP-->
      <Data Position='7' Length='5' Segment='CRWZIP'>
        <xsl:value-of select="/Integration/Party[@InternalPartyID=$complainantID]/Address[@PartyCurrent='true']/Zip"/>
      </Data>
      <!--Address ZIP + 4-->
      <Data Position='8' Length='4' Segment='CRWEZP' AlwaysNull="true" />
      <!--Witness Home Phone Number-->
      <Data Position='9' Length='10' Segment='CRWPNO'  AlwaysNull="true" />
      <!--Witness Officer Agency-->
      <Data Position='10' Length='3' Segment='CRWAGY'>
        <xsl:value-of select="/Integration/Party[@InternalPartyID=$complainantID]/Officer/Agency/@Word"/>
      </Data>
      <!--Witness Officer Number-->
      <Data Position='11' Length='6' Segment='CRWONO'>
        <xsl:value-of select="/Integration/Party[@InternalPartyID=$complainantID]/Officer/BadgeNumber"/>
      </Data>
      <!--Witness Supoena Requested Indicator-->
      <Data Position='12' Length='1' Segment='CRWSCK' AlwaysNull="true" />
      <!--Witness Supoena Issue Date-->
      <Data Position='13' Length='8' Segment='CRWDSD' AlwaysNull="true" />
      <!--Witness Supoena Served Date-->
      <Data Position='14' Length='8' Segment='CRWSPSV' AlwaysNull="true" />
      <!--Witness Method of Service-->
      <Data Position='15' Length='1' Segment='CRWMSV' AlwaysNull="true" />
      <!--Witness Business Phone Number-->
      <Data Position='16' Length='10' Segment='CRWWPN'>
        <xsl:value-of select="translate(/Integration/Party[@InternalPartyID=$complainantID]/Phone[@Current='true' and Type/@Word='WORK']/Number,'-','')"/>
      </Data>
      <!--NA Vision Link Code-->
      <Data Position='17' Length='10' Segment='NA-VISIONLINKCODE' AlwaysNull="true" />
      <!--NA Vision Link Number-->
      <Data Position='18' Length='3' Segment='NA-VISIONLINKNUMBER' AlwaysNull="true" />
      <!--Witness Line Number-->
      <Data Position='19' Length='2' Segment='CRWLNO' AlwaysNull="true" />
      <!-- Padding at the end to form the total length -->
      <Data Position='20' Length='47' Segment='Filler' AlwaysNull="true"/>
    </Event>
  </xsl:template>
</xsl:stylesheet>





