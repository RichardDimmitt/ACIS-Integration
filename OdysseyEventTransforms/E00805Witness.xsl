<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <!-- ********************************************************************-->
  <!-- ******** template for E00805 Witness *****************-->
  <!-- ********************************************************************-->
  <xsl:template name="E00805Witness">
    <xsl:for-each select="/Integration/Case/CaseParty[Connection[contains('D S WIT VIC',@Word) and not(RemovedDate)]]">
      <xsl:variable name="complainantID">
        <xsl:value-of select="@InternalPartyID"/>
      </xsl:variable>
      <xsl:variable name="ZIP" select="substring(/Integration/Party[@InternalPartyID=$complainantID]/Address[@PartyCurrent='true']/Zip,1,5)"/>
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
          <xsl:call-template name="GetACISWitness">
            <xsl:with-param name="code" select ="Connection[1]/@Word"/>
          </xsl:call-template>
        </Data>
        <!--Witness Address Note, do not send address information for foreign addresses-->
          <!-- Note, this is being broken into two parts in order to handle multipart addresses per NCAOC requirments. -->
        <Data Position='4' Length='20' Segment='CRWADPart1'>
          <xsl:choose>
            <xsl:when test="(/Integration/Party[@InternalPartyID=$complainantID]/Address[@PartyCurrent='true']/@Type='Standard')">
              <xsl:value-of select="substring(/Integration/Party[@InternalPartyID=$complainantID]/Address[@PartyCurrent='true']/AddressLine2,1,20)"/>
            </xsl:when>
            <xsl:when test="(/Integration/Party[@InternalPartyID=$complainantID]/Address[@PartyCurrent='true']/@Type='Standard With Attention')">
              <xsl:value-of select="substring(/Integration/Party[@InternalPartyID=$complainantID]/Address[@PartyCurrent='true']/AddressLine2,1,20)"/>
            </xsl:when>
            <xsl:when test="(/Integration/Party[@InternalPartyID=$complainantID]/Address[@PartyCurrent='true']/@Type='Non Standard')">
              <xsl:value-of select="substring(/Integration/Party[@InternalPartyID=$complainantID]/Address[@PartyCurrent='true']/AddressLine1,1,20)"/>
            </xsl:when>
            <xsl:when test="(/Integration/Party[@InternalPartyID=$complainantID]/Address[@PartyCurrent='true']/@Type='Foreign')">
              <xsl:value-of select="''"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="''"/>
            </xsl:otherwise>
          </xsl:choose>
        </Data>
        <Data Position='4' Length='15' Segment='CRWADPart2'>
          <xsl:choose>
            <xsl:when test="(/Integration/Party[@InternalPartyID=$complainantID]/Address[@PartyCurrent='true']/@Type='Standard')">
              <xsl:if test="substring(/Integration/Party[@InternalPartyID=$complainantID]/Address[@PartyCurrent='true']/AddressLine2,21,15)">
                <xsl:value-of select="substring(/Integration/Party[@InternalPartyID=$complainantID]/Address[@PartyCurrent='true']/AddressLine2,21,15)"/>
                <xsl:value-of select="' '"/>
              </xsl:if>
              <xsl:value-of select="/Integration/Party[@InternalPartyID=$complainantID]/Address[@PartyCurrent='true']/AddressLine3"/>
            </xsl:when>
            <xsl:when test="(/Integration/Party[@InternalPartyID=$complainantID]/Address[@PartyCurrent='true']/@Type='Standard With Attention')">
              <xsl:if test="substring(/Integration/Party[@InternalPartyID=$complainantID]/Address[@PartyCurrent='true']/AddressLine2,21,15)">
                <xsl:value-of select="substring(/Integration/Party[@InternalPartyID=$complainantID]/Address[@PartyCurrent='true']/AddressLine2,21,15)"/>
                <xsl:value-of select="' '"/>
              </xsl:if>
              <xsl:value-of select="/Integration/Party[@InternalPartyID=$complainantID]/Address[@PartyCurrent='true']/AddressLine3"/>
              <xsl:if test="(/Integration/Party[@InternalPartyID=$complainantID]/Address[@PartyCurrent='true']/Attention)">
                <xsl:value-of select="' / C/O '"/>
                <xsl:value-of select="/Integration/Party[@InternalPartyID=$complainantID]/Address[@PartyCurrent='true']/Attention"/>
              </xsl:if>
            </xsl:when>
            <xsl:when test="(/Integration/Party[@InternalPartyID=$complainantID]/Address[@PartyCurrent='true']/@Type='Non Standard')">
              <xsl:if test="substring(/Integration/Party[@InternalPartyID=$complainantID]/Address[@PartyCurrent='true']/AddressLine1,21,15)">
                <xsl:value-of select="substring(/Integration/Party[@InternalPartyID=$complainantID]/Address[@PartyCurrent='true']/AddressLine1,21,15)"/>
                <xsl:value-of select="' '"/>
              </xsl:if>
              <xsl:value-of select="/Integration/Party[@InternalPartyID=$complainantID]/Address[@PartyCurrent='true']/AddressLine2"/>
            </xsl:when>
            <xsl:when test="(/Integration/Party[@InternalPartyID=$complainantID]/Address[@PartyCurrent='true']/@Type='Foreign')">
              <xsl:value-of select="''"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="''"/>
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
          <xsl:choose>
            <xsl:when  test="($ZIP='00000')">
              <xsl:value-of select="''"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$ZIP"/>
            </xsl:otherwise>
          </xsl:choose>
        </Data>
        <!--Address ZIP + 4-->
        <Data Position='8' Length='4' Segment='CRWEZP'>
          <xsl:choose>
            <xsl:when  test="($ZIP='00000')">
              <xsl:value-of select="''"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="substring-after(/Integration/Party[@InternalPartyID=$complainantID]/Address[@PartyCurrent='true']/Zip,'-')"/>
            </xsl:otherwise>
          </xsl:choose>
        </Data>
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
    </xsl:for-each>
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
      <xsl:when test="(contains($desc,'Airport')) and not(contains($desc,'Communications'))">
        <xsl:value-of select="'APD'"/>
      </xsl:when>
      <!--City Police Department-->
      <xsl:when test="(contains($desc,'Police Department')) and not(contains($desc,'College')) and not(contains($desc,'University')) and not(contains($desc,'Company')) and not(contains($desc,'Special')) and not(contains($desc,'Hospital')) and not(contains($desc,'Campus')) and not(contains($desc,'School')) and not(contains($desc,'Railway')) and not(contains($desc,'Harbor')) and not(contains($desc,'District')) and not(contains($desc,'NC ')) and not(contains($desc,'North Carolina')) and not(contains($desc,'TVA')) and not(contains($desc,'Healthcare')) and not(contains($desc,'County'))">
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
      <xsl:when test="(contains($desc,'Corrections'))">
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
      <xsl:when test="(contains($desc,'Sheriff')) and not(contains($desc,' VA '))">
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
  <!-- ********************************************************************-->
  <!-- ************ template for mapping witness types ********************-->
  <!-- *** D-Witness for the defense              ***-->
  <!-- *** S-Witness for the State                ***-->
  <!-- *** WIT-Witness                            ***-->
  <!-- *** VIC-Victim                             ***-->
  <!-- ********************************************************************-->
  <xsl:template name="GetACISWitness">
    <xsl:param name ="code"/>
    <xsl:choose>
      <xsl:when test="($code='VIC')">
        <xsl:value-of select="'V'"/>
      </xsl:when>
      <xsl:when test="($code='S')">
        <xsl:value-of select="'S'"/>
      </xsl:when>
      <xsl:when test="($code='D')">
        <xsl:value-of select="'D'"/>
      </xsl:when>
      <xsl:when test="($code='WIT')">
        <xsl:value-of select="'S'"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="'S'"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>

