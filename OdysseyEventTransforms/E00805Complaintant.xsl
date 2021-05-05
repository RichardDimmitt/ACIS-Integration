<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:user="http://tylertechnologies.com" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:reslib="urn:reslib" xmlns:CMCodeQueryHelper="urn:CMCodeQueryHelper" xmlns:ExternalReference="urn:ExternalReference" exclude-result-prefixes="xsl msxsl CMCodeQueryHelper ExternalReference">
  <!-- ********************************************************************-->
  <!-- ******** template for E00805 Complainant *****************-->
  <!-- ********************************************************************-->
  <xsl:template name="E00805Complaintant">
    <xsl:variable name="complainantID">
      <xsl:choose>
        <xsl:when test="/Integration/Case/CaseParty/Connection/@Word='LEO'">
          <xsl:value-of select="/Integration/Case/CaseParty[Connection/@Word='LEO']/@InternalPartyID"/>
        </xsl:when>
        <xsl:when test="/Integration/Case/CaseParty/Connection/@Word='CMPL'">
          <xsl:value-of select="/Integration/Case/CaseParty[Connection/@Word='CMPL']/@InternalPartyID"/>
        </xsl:when>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="/Integration/Case/CaseParty/Connection[contains('LEO CMPL',@Word)]">
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
        <!--Witness Address Line 1 Note, do not send address information for foreign addresses-->
        <Data Position='4' Length='35' Segment='CRWAD'>
          <xsl:choose>
            <xsl:when test="(/Integration/Party[@InternalPartyID=$complainantID]/Officer/Agency/@Word)">
              <xsl:value-of select="CMCodeQueryHelper:GetCodeAttributeByWord('Justice', 'uAgency', string(/Integration/Party[@InternalPartyID=$complainantID]/Officer/Agency/@Word), '0', 'street1')"/>
            </xsl:when>
            <xsl:when test="(/Integration/Party[@InternalPartyID=$complainantID]/Address[@PartyCurrent='true']/@Type='Standard')">
              <xsl:value-of select="/Integration/Party[@InternalPartyID=$complainantID]/Address[@PartyCurrent='true']/AddressLine2"/>
            </xsl:when>
            <xsl:when test="(/Integration/Party[@InternalPartyID=$complainantID]/Address[@PartyCurrent='true']/@Type='Standard With Attention')">
              <xsl:value-of select="/Integration/Party[@InternalPartyID=$complainantID]/Address[@PartyCurrent='true']/AddressLine2"/>
            </xsl:when>
            <xsl:when test="(/Integration/Party[@InternalPartyID=$complainantID]/Address[@PartyCurrent='true']/@Type='Non Standard')">
              <xsl:value-of select="/Integration/Party[@InternalPartyID=$complainantID]/Address[@PartyCurrent='true']/AddressLine1"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="''"/>
            </xsl:otherwise>
          </xsl:choose>
        </Data>
        <!--Witness Address City-->
        <Data Position='5' Length='15' Segment='CRWCTY'>
          <xsl:choose>
            <xsl:when test="(/Integration/Party[@InternalPartyID=$complainantID]/Officer/Agency/@Word)">
              <xsl:value-of select="CMCodeQueryHelper:GetCodeAttributeByWord('Justice', 'uAgency', string(/Integration/Party[@InternalPartyID=$complainantID]/Officer/Agency/@Word), '0', 'city')"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="/Integration/Party[@InternalPartyID=$complainantID]/Address[@PartyCurrent='true']/City"/>
            </xsl:otherwise>
          </xsl:choose>
        </Data>
        <!--Witness Address State-->
        <Data Position='6' Length='2' Segment='CRWSTX'>
          <xsl:choose>
            <xsl:when test="(/Integration/Party[@InternalPartyID=$complainantID]/Officer/Agency/@Word)">
              <xsl:value-of select="CMCodeQueryHelper:GetCodeAttributeByWord('Justice', 'uAgency', string(/Integration/Party[@InternalPartyID=$complainantID]/Officer/Agency/@Word), '0', 'st')"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="/Integration/Party[@InternalPartyID=$complainantID]/Address[@PartyCurrent='true']/State"/>
            </xsl:otherwise>
          </xsl:choose>
        </Data>
        <!--Witness Address ZIP-->
        <Data Position='7' Length='5' Segment='CRWZIP'>
          <xsl:choose>
            <xsl:when test="(/Integration/Party[@InternalPartyID=$complainantID]/Officer/Agency/@Word)">
              <xsl:value-of select="CMCodeQueryHelper:GetCodeAttributeByWord('Justice', 'uAgency', string(/Integration/Party[@InternalPartyID=$complainantID]/Officer/Agency/@Word), '0', 'zip')"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="/Integration/Party[@InternalPartyID=$complainantID]/Address[@PartyCurrent='true']/Zip"/>
            </xsl:otherwise>
          </xsl:choose>
        </Data>
        <!--Address ZIP + 4-->
        <Data Position='8' Length='4' Segment='CRWEZP' AlwaysNull="true" />
        <!--Witness Home Phone Number-->
        <Data Position='9' Length='10' Segment='CRWPNO'  AlwaysNull="true" />
        <!--Witness Officer Agency-->
        <Data Position='10' Length='3' Segment='CRWAGY'>
          <xsl:call-template name="GetACISAgency">
            <xsl:with-param name="desc" select = "/Integration/Party[@InternalPartyID=$complainantID]/Officer/Agency"/>
          </xsl:call-template>
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
          <xsl:choose>
            <xsl:when test="(/Integration/Party[@InternalPartyID=$complainantID]/Officer/Agency/@Word)">
              <xsl:value-of select="translate(CMCodeQueryHelper:GetCodeAttributeByWord('Justice', 'uAgency', string(/Integration/Party[@InternalPartyID=$complainantID]/Officer/Agency/@Word), '0', 'phone'),'-','')"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="translate(/Integration/Party[@InternalPartyID=$complainantID]/Phone[@Current='true' and Type/@Word='WORK']/Number,'-','')"/>
            </xsl:otherwise>
          </xsl:choose>
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
    </xsl:if>
  </xsl:template>
  <!-- ********************************************************************-->
  <!-- **************** template for mapping agency codes *****************-->
  <!-- ********************************************************************-->
  <xsl:template name="GetACISAgency">
    <xsl:param name ="desc"/>
    <xsl:choose>
      <!--Alcohol Beverage Control-->
      <xsl:when test="(contains($desc,'ABC'))">
        <xsl:value-of select="'ABC'"/>
      </xsl:when>
      <!--State Alcohol Law Enforcement-->
      <xsl:when test="(contains($desc,'Alcohol Law Enforcement'))">
        <xsl:value-of select="'ALE'"/>
      </xsl:when>
      <!--International Airport Police-->
      <xsl:when test="(contains($desc,'Airport'))">
        <xsl:value-of select="'APD'"/>
      </xsl:when>
      <!--City Police Department-->
      <xsl:when test="(contains($desc,'Police Department'))">
        <xsl:value-of select="'CPD'"/>
      </xsl:when>
      <!--Clerk of Superior Court-->
      <xsl:when test="(contains($desc,'Superior'))">
        <xsl:value-of select="'CSC'"/>
      </xsl:when>
      <!--Division of Community Corrections-->
      <xsl:when test="(contains($desc,'Correctional'))">
        <xsl:value-of select="'DCC'"/>
      </xsl:when>
      <!--Division of Motor Vehicles-->
      <xsl:when test="(contains($desc,'Motor Vehicles'))">
        <xsl:value-of select="'DMV'"/>
      </xsl:when>
      <!--Federal Bureau of Investigation-->
      <xsl:when test="(contains($desc,'Federal Bureau of Investigation'))">
        <xsl:value-of select="'FBI'"/>
      </xsl:when>
      <!--NC License & Theft Division-->
      <xsl:when test="(contains($desc,'License And Theft'))">
        <xsl:value-of select="'L-T'"/>
      </xsl:when>
      <!--Magistrate-->
      <xsl:when test="(contains($desc,'Magistrate'))">
        <xsl:value-of select="'MAG'"/>
      </xsl:when>
      <!--State Bureau of Investigation-->
      <xsl:when test="(contains($desc,'State Bureau Of Investigation'))">
        <xsl:value-of select="'SBI'"/>
      </xsl:when>
      <!--County Sheriff Department-->
      <xsl:when test="(contains($desc,'Sheriff'))">
        <xsl:value-of select="'SFF'"/>
      </xsl:when>
      <!--State Highway Patrol-->
      <xsl:when test="(contains($desc,'State Highway Patrol'))">
        <xsl:value-of select="'SHP'"/>
      </xsl:when>
      <!--Wildlife Resources Commission-->
      <xsl:when test="(contains($desc,'Wildlife Resource Commission'))">
        <xsl:value-of select="'WRC'"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="'OTH'"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>





















