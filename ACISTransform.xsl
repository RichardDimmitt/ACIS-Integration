<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:strip-space elements="*"/>
  <xsl:output method="xml" indent="no" cdata-section-elements="DATA"/>
  <xsl:template match="Integration">
  <!-- **************************************************************************-->
  <!-- ********************* Build Root Element  ********************************-->
  <!-- **************************************************************************-->
    <OdysseyACISMessage>
      <xsl:attribute name="MessageGUID">
        <xsl:value-of select="/Integration/@MessageGUID"/>
      </xsl:attribute>
      <xsl:attribute name="MessageID">
        <xsl:value-of select="/Integration/@MessageID"/>
      </xsl:attribute>
      <xsl:attribute name="Timestamp">
        <xsl:value-of select="/Integration/ControlPoint/@Timestamp"/>
      </xsl:attribute>
      <xsl:attribute name="Condition">
        <xsl:value-of select="/Integration/IntegrationConditions/IntegrationCondition[1]/@Word"/>
      </xsl:attribute>
      <!-- ***************************************************************************************-->
  <!-- ********* Include events based on integration condition and data available ************-->
  <!-- ***************************************************************************************-->
      <!-- Header Record-->
      <xsl:call-template name="HeaderRecord"/>
      <!-- Case Data -->
      <xsl:if test="/Integration/IntegrationConditions/IntegrationCondition/ACISEvent='E00050'">
        <xsl:call-template name="E00050"/>
      </xsl:if>
      <!-- Complaintant Information -->
      <xsl:if test="/Integration/IntegrationConditions/IntegrationCondition/ACISEvent='E00805'">
        <xsl:if test="/Integration/Case/CaseParty/Connection/@Word='CMPL'">
          <xsl:call-template name="E00805Complaintant"/>
        </xsl:if>
      </xsl:if>
      <!-- Witness Information -->
      <xsl:if test="/Integration/IntegrationConditions/IntegrationCondition/ACISEvent='E00805'">
        <xsl:if test="/Integration/Case/CaseParty/Connection/@Word='WIT'">
          <xsl:call-template name="E00805Witness"/>
        </xsl:if>
      </xsl:if>
      <!-- Defendant Names -->
      <xsl:if test="/Integration/IntegrationConditions/IntegrationCondition/ACISEvent='E00660'">
        <xsl:call-template name="E00660"/>
      </xsl:if>
      <!-- Offense Record -->
      <xsl:if test="/Integration/IntegrationConditions/IntegrationCondition/ACISEvent='E50001'">
        <xsl:call-template name="E50001"/>
      </xsl:if>
      <!-- LID Number Change -->
      <xsl:if test="/Integration/IntegrationConditions/IntegrationCondition/ACISEvent='E00740'">
        <xsl:call-template name="E00740"/>
      </xsl:if>
      <!-- OCA Number Change -->
      <xsl:if test="/Integration/IntegrationConditions/IntegrationCondition/ACISEvent='E10161'">
        <xsl:call-template name="E10161"/>
      </xsl:if>
      <!-- Service Record -->
      <xsl:if test="/Integration/IntegrationConditions/IntegrationCondition/ACISEvent='E10100'">
        <xsl:call-template name="E10100"/>
      </xsl:if>
      <!-- Trailer Record TrailerRecord -->
      <xsl:call-template name="TrailerRecord"/>
    </OdysseyACISMessage>
  </xsl:template>
  <!-- ********************************************************************-->
  <!-- **************** template for Header Record ************************-->
  <!-- ********************************************************************-->
  <xsl:template name="HeaderRecord">
    <Header>
      <Data Position="1" Length="1" Segment="Flag">
        <xsl:text>H</xsl:text>
      </Data>
      <Data Position="2" Length="3" Segment="CraiKeyCounty">
        <xsl:value-of select="substring-after(/Integration/Case/CaseNumber,'-')"/>
      </Data>
      <Data Position="3" Length="2" Segment="CraiKeyCentury">
        <xsl:text>20</xsl:text>
      </Data>
      <Data Position="4" Length="2" Segment="CraiKeyYear">
        <xsl:value-of select="substring(/Integration/Case/CaseNumber,1,2)"/>
      </Data>
      <Data Position="5" Length="6" Segment="CraiKeySequence">
        <xsl:value-of select="substring(/Integration/Case/CaseNumber,5,6)"/>
      </Data>
      <Data Position="6" Length="3" Segment="CraiKeyCaseType">
        <xsl:value-of select="substring(/Integration/Case/CaseNumber,3,2)"/>
      </Data>
      <Data Position="7" Length="14" Segment="CraiCreatedDtTs">
        <xsl:call-template name="formatDateYYYYMMDDHHMMSS">
          <xsl:with-param name="dateTime" select="/Integration/Case/Assignment[1]/TimestampCreate"/>
        </xsl:call-template>
      </Data>
      <Data Position="8" Length="14" Segment="CraiUpdatedDtTs">
        <xsl:call-template name="formatDateYYYYMMDDHHMMSS">
          <xsl:with-param name="dateTime" select="/Integration/ControlPoint/@Timestamp"/>
        </xsl:call-template>
      </Data>
      <Data Position="9" Length="9" Segment="CraiOperatorId">
        <xsl:text>AWAR101</xsl:text>
      </Data>
      <Data Position="10" Length="1" Segment="CraiTransactionType">
        <xsl:value-of select="/Integration/IntegrationConditions/IntegrationCondition[1]/TransactionType"/>
      </Data>
      <Data Position="11" Length="15" Segment="CraiLidNo">
        <xsl:value-of select="/Integration/Party[@InternalPartyID=/Integration/Case/Charge[1]/@InternalPartyID]/OtherID[OtherIDAgency/@Word='LID']/OtherIDNumber"/>
      </Data>
      <Data Position="12" Length="8" Segment="CraiWarrantNumber">
        <xsl:value-of select="/Integration/Case/CaseCrossReference[CaseCrossReferenceType/@Word='PROC']/CrossCaseNumber"/>
      </Data>
      <Data Position="13" Length="8" Segment="CraiOfaWarrantNumber" AlwaysNull="true"/>
      <Data Position="14" Length="10" Segment="CraiArrestNumber">
        <xsl:value-of select="/Integration/Case/Charge/BookingAgency/ControlNumber[1]"/>
      </Data>
      <Data Position="15" Length="10" Segment="CraiOfaArrestNumber" AlwaysNull="true"/>
      <Data Position="16" Length="13" Segment="CraiComplaintNumber" AlwaysNull="true"/>
      <Data Position="17" Length="6" Segment="CraiCreateSubSs" AlwaysNull="true"/>
      <Data Position="18" Length="6" Segment="CraiUpdateSubSs" AlwaysNull="true"/>
      <Data Position="19" Length="4" Segment="CraiHdrCourtroom">
        <xsl:value-of select="/Integration/Case/Hearing[last()]/Setting/CourtResource[Type/@Word='LOC']/Code/@Word[1]"/>
      </Data>
      <Data Position="20" Length="6" Segment="CraiHdrCourtroomFiller">
        <xsl:value-of select="/Integration/@MessageID"/>
      </Data>
    </Header>
  </xsl:template>
  <!-- ********************************************************************-->
  <!-- **************** template for E00050 Case Add **********************-->
  <!-- ********************************************************************-->
  <xsl:template name="E00050">
    <xsl:variable name="DefendantID">
      <xsl:value-of select="/Integration/Case/Charge[1]/@InternalPartyID"/>
    </xsl:variable>
    <Event>
      <xsl:attribute name="EventID">
        <xsl:text>E00050</xsl:text>
      </xsl:attribute>
      <!--Flag-->
      <Data Position="1" Length="1" Segment="Flag">
        <xsl:text>C</xsl:text>
      </Data>
      <!--Process Type-->
      <Data Position="2" Length="1" Segment="CRRPRC">
        <xsl:value-of select="/Integration/IntegrationConditions/IntegrationCondition/ProcessType"/>
      </Data>
      <!--Defendant Name-->
      <Data Position="3" Length="28" Segment="CRRNAM">
        <xsl:value-of select="/Integration/Party[@InternalPartyID=$DefendantID]/PartyName[@Current='true']/FormattedName"/>
      </Data>
      <!--Defendant Race-->
      <Data Position="4" Length="1" Segment="CRRACE">
        <xsl:call-template name="GetACISRaceCode">
          <xsl:with-param name="code" select ="/Integration/Party[@InternalPartyID=$DefendantID]/Race/@Word"/>
        </xsl:call-template>
      </Data>
      <!--Defendant Sex-->
      <Data Position="5" Length="1" Segment="CRRSEX">
        <xsl:call-template name="GetACISSexCode">
          <xsl:with-param name="code" select ="substring(/Integration/Party[@InternalPartyID=$DefendantID]/Gender/@Word,1,1)"/>
        </xsl:call-template>
      </Data>
      <!--Defendant Address City-->
      <Data Position="6" Length="15" Segment="CRRCTY">
        <xsl:value-of select="/Integration/Party[@InternalPartyID=$DefendantID]/Address[@PartyCurrent='true']/City"/>
      </Data>
      <!--Defendant Address State-->
      <Data Position="7" Length="2" Segment="CRRDST">
        <xsl:value-of select="/Integration/Party[@InternalPartyID=$DefendantID]/Address[@PartyCurrent='true']/State"/>
      </Data>
      <!--Citation Issue date-->
      <Data Position="8" Length="8" Segment="CRRIDT" AlwaysNull="true"/>
      <!--NA-FILLER-20-->
      <Data Position="9" Length="20" Segment="NA-FILLER-20" AlwaysNull="true"/>
      <!--Defendant Address Line 1 -->
      <Data Position="10" Length="20" Segment="CRRADD">
        <xsl:choose>
          <xsl:when test="(/Integration/Party[@InternalPartyID=$DefendantID]/Address[@PartyCurrent='true']/@Type='Standard')">
            <xsl:value-of select="/Integration/Party[@InternalPartyID=$DefendantID]/Address[@PartyCurrent='true']/AddressLine2"/>
          </xsl:when>
          <xsl:when test="(/Integration/Party[@InternalPartyID=$DefendantID]/Address[@PartyCurrent='true']/@Type='Standard With Attention')">
            <xsl:value-of select="/Integration/Party[@InternalPartyID=$DefendantID]/Address[@PartyCurrent='true']/AddressLine2"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="/Integration/Party[@InternalPartyID=$DefendantID]/Address[@PartyCurrent='true']/AddressLine1"/>
          </xsl:otherwise>
        </xsl:choose>
      </Data>
      <!--Defendant Address Line 2-->
      <Data Position="11" Length="15" Segment="CRREAD">
        <xsl:choose>
          <xsl:when test="(/Integration/Party[@InternalPartyID=$DefendantID]/Address[@PartyCurrent='true']/@Type='Standard')">
            <xsl:value-of select="/Integration/Party[@InternalPartyID=$DefendantID]/Address[@PartyCurrent='true']/AddressLine3"/>
          </xsl:when>
          <xsl:when test="(/Integration/Party[@InternalPartyID=$DefendantID]/Address[@PartyCurrent='true']/@Type='Standard With Attention')">
            <xsl:value-of select="/Integration/Party[@InternalPartyID=$DefendantID]/Address[@PartyCurrent='true']/AddressLine3"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="/Integration/Party[@InternalPartyID=$DefendantID]/Address[@PartyCurrent='true']/AddressLine2"/>
          </xsl:otherwise>
        </xsl:choose>
      </Data>
      <!--Defendant Address ZIP-->
      <Data Position="12" Length="5" Segment="CRRZIP">
        <xsl:value-of select="/Integration/Party[@InternalPartyID=$DefendantID]/Address[@PartyCurrent='true']/Zip"/>
      </Data>
      <!--Defendant Address ZIP + 4-->
      <Data Position="13" Length="4" Segment="CRREZP" AlwaysNull="true"/>
      <!--Defendant SSN-->
      <Data Position="14" Length="9" Segment="CRRSSN">
        <xsl:value-of select="translate(/Integration/Party[@InternalPartyID=$DefendantID]/SocialSecurityNumber[@Current='true'],'-','')"/>
      </Data>
      <!--Defendant Date of Birth-->
      <Data Position="15" Length="8" Segment="CRRDOB">
        <xsl:call-template name="formatDateYYYYMMDD">
          <xsl:with-param name="date" select="/Integration/Party[@InternalPartyID=$DefendantID]/DateOfBirth[@Current='true']"/>
        </xsl:call-template>
      </Data>
      <!--Offense Time-->
      <Data Position="16" Length="6" Segment="CRRCTM" AlwaysNull="true"/>
      <!--NA-FILLER-20-->
      <Data Position="17" Length="20" Segment="NA-FILLER-20" AlwaysNull="true"/>
      <!--Citation Number-->
      <Data Position="18" Length="8" Segment="CRRWNO" AlwaysNull="true"/>
      <!--Citation Validation Character-->
      <Data Position="19" Length="1" Segment="CRRWCDT" AlwaysNull="true"/>
      <!--Jail Indicator-->
      <Data Position="20" Length="1" Segment="CRRJAIL" AlwaysNull="true"/>
      <!--Defendant Age-->
      <Data Position="21" Length="3" Segment="CRRAGE" AlwaysNull="true"/>
      <!--Defendant DL Number-->
      <Data Position="22" Length="25" Segment="CRRDLN">
        <xsl:value-of select="/Integration/Party[@InternalPartyID=$DefendantID]/DriversLicense[@Current='true']/DriversLicenseNumber"/>
      </Data>
      <!--Defendant DL State-->
      <Data Position="23" Length="2" Segment="CRRSIL">
        <xsl:value-of select="/Integration/Party[@InternalPartyID=$DefendantID]/DriversLicense[@Current='true']/DriversLicenseState/@Word"/>
      </Data>
      <!--Citation Commerical DL Indicator-->
      <Data Position="24" Length="1" Segment="CRRCDL" AlwaysNull="true"/>
      <!--Citation Commerical Vehicle Indicator-->
      <Data Position="25" Length="1" Segment="CRRCMV" AlwaysNull="true"/>
      <!--Citation Hazardous Materials Indicator-->
      <Data Position="26" Length="1" Segment="CRRHAZ" AlwaysNull="true"/>
      <!--Citation SHP Troop-->
      <Data Position="27" Length="1" Segment="CRRTRP" AlwaysNull="true"/>
      <!--Citation SHP District-->
      <Data Position="28" Length="1" Segment="CRRARE" AlwaysNull="true"/>
      <!--Citation Accident Indicator-->
      <Data Position="29" Length="1" Segment="CRRACC" AlwaysNull="true"/>
      <!--Citation Highway-->
      <Data Position="30" Length="6" Segment="CRRROD" AlwaysNull="true"/>
      <!--Citation SHP Agency-->
      <Data Position="31" Length="2" Segment="UNK-CraiShpCode" AlwaysNull="true"/>
      <!--Citation Vehicle License Plate-->
      <Data Position="32" Length="10" Segment="CRRVLN" AlwaysNull="true"/>
      <!--Citation Vehicle State-->
      <Data Position="33" Length="2" Segment="CRRVLS" AlwaysNull="true"/>
      <!--Citation Vehicle Type-->
      <Data Position="34" Length="4" Segment="CRRVTY" AlwaysNull="true"/>
      <!--Citation Tailer Type-->
      <Data Position="35" Length="4" Segment="CRRTTY" AlwaysNull="true"/>
      <!--Vision Link Code-->
      <Data Position="36" Length="10" Segment="NA-VISIONLINKCODE" AlwaysNull="true"/>
      <!--Domestic Violence Indicator-->
      <Data Position="37" Length="1" Segment="CRRDOMVL"/>
      <!--Fingerprint Required Indicator-->
      <Data Position="38" Length="1" Segment="UNK-CraiFingerprintInd"/>
      <!--Victim Rights Indicator-->
      <Data Position="39" Length="1" Segment="CRRVRA"/>
      <!--NA-FILLER-97-->
      <Data Position="40" Length="97" Segment="NA-FILLER-97" AlwaysNull="true"/>
      <!--NA-FILLER-1-->
      <Data Position="41" Length="1" Segment="NA-FILLER-1" AlwaysNull="true"/>
      <!--NA-FILLER-1-->
      <Data Position="42" Length="1" Segment="NA-FILLER-1" AlwaysNull="true"/>
    </Event>
  </xsl:template>
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
    </Event>
  </xsl:template>
  <!-- ********************************************************************-->
  <!-- ******** template for E00805 Witness *****************-->
  <!-- ********************************************************************-->
  <xsl:template name="E00805Witness">
    <xsl:variable name="complainantID">
      <xsl:value-of select="/Integration/Case/CaseParty[Connection/@Word='WIT']/@InternalPartyID"/>
    </xsl:variable>
    <Event>
      <xsl:attribute name="EventID">
        <xsl:text>E00805</xsl:text>
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
    </Event>
  </xsl:template>
  <!-- ********************************************************************-->
  <!-- ******** template for E00660 Defendant Name and Alias Name**********-->
  <!-- ********************************************************************-->
  <xsl:template name="E00660">
    <xsl:variable name="DefendantID">
      <xsl:value-of select="/Integration/Case/Charge[1]/@InternalPartyID"/>
    </xsl:variable>
    <Event>
      <xsl:attribute name="EventID">
        <xsl:text>E00660</xsl:text>
      </xsl:attribute>
      <!--Flag-->
      <Data Position="1" Length="1" Segment="Flag">
        <xsl:text>A</xsl:text>
      </Data>
      <!--Defendant Name-->
      <Data Position="2" Length="28" Segment="CRRNAM">
        <xsl:value-of select="/Integration/Party[@InternalPartyID=$DefendantID]/PartyName[@Current='true']/FormattedName"/>
      </Data>
      <!--NA Vision Link Code-->
      <Data Position='3' Length='10' Segment='NA-VISIONLINKCODE' AlwaysNull="true" />
    </Event>
    <xsl:for-each select="/Integration/Party[@InternalPartyID=$DefendantID]/PartyName[not(@Current='true')][1]">
      <Event>
        <xsl:attribute name="EventID">
          <xsl:text>E00660</xsl:text>
        </xsl:attribute>
        <!--Flag-->
        <Data Position="1" Length="1" Segment="Flag">
          <xsl:text>A</xsl:text>
        </Data>
        <!--Defendant Name-->
        <Data Position="2" Length="28" Segment="CRRNAM">
          <xsl:value-of select="FormattedName"/>
        </Data>
        <!--NA Vision Link Code-->
        <Data Position='3' Length='10' Segment='NA-VISIONLINKCODE' AlwaysNull="true" />
      </Event>
    </xsl:for-each>
  </xsl:template>
  <!-- ********************************************************************-->
  <!-- ************* template for E50001 Offense Record *******************-->
  <!-- ********************************************************************-->
  <xsl:template name="E50001">
    <xsl:for-each select="/Integration/Case/Charge/ChargeHistory[@Stage='Case Filing']">
      <Event>
        <xsl:attribute name="EventID">
          <xsl:text>E50001</xsl:text>
        </xsl:attribute>
        <!--Flag-->
        <Data Position="1" Length="1" Segment="Flag">
          <xsl:text>O</xsl:text>
        </Data>
        <!--Offense Number-->
        <Data Position='2' Length='2' Segment='CROLNO'>
          <xsl:call-template name="GetLeadZero">
            <xsl:with-param name="Nbr" select="ChargeNumber"/>
          </xsl:call-template>
        </Data>
        <!--Charged Offense Code-->
        <Data Position='3' Length='6' Segment='CROFFC'>
          <xsl:value-of select="Statute/StatuteCode/@Word"/>
        </Data>
        <!--Charged Offense Date-->
        <Data Position='4' Length='8' Segment='CROCDT'>
          <xsl:call-template name="formatDateYYYYMMDD">
            <xsl:with-param name="date" select="../ChargeOffenseDate"/>
          </xsl:call-template>
        </Data>
        <!--Charge Offense Type (degree)-->
        <Data Position='5' Length='1' Segment='CRFCTP'>
          <xsl:value-of select="substring(Statute/Degree/@Word,1,1)"/>
        </Data>
        <!--Charged Freeform Offense Text-->
        <Data Position='6' Length='45' Segment='CRFCOF45'>
          <xsl:value-of select="Statute/StatuteDescription"/>
        </Data>
        <!--Charged Freeform Offense General Statute Number-->
        <Data Position='7' Length='15' Segment='CRFCGS'>
          <xsl:value-of select="Statute/StatuteNumber"/>
        </Data>
        <!--Worthless Check Amount-->
        <Data Position='8' Length='7' Segment='CRIWCA-X' />
        <!--Charged Speed-->
        <Data Position='9' Length='3' Segment='CRICSP' />
        <!--Posted Speed-->
        <Data Position='10' Length='2' Segment='CRICSZ' />
        <!--Civil Revocation Effective / EndDate-->
        <Data Position='11' Length='8' Segment='CRICVRE' AlwaysNull="true" />
        <!--NA Vision Link Code-->
        <Data Position='12' Length='13' Segment='NA-VISIONLINKCODE' AlwaysNull="true" />
        <!--Civil Revocation End Date-->
        <Data Position='13' Length='8' Segment='UNK-CvrEndDate' AlwaysNull="true" />
      </Event>
    </xsl:for-each>
  </xsl:template>
  <!-- ********************************************************************-->
  <!-- ************* template for E00740 LID Number Change ****************-->
  <!-- ********************************************************************-->
  <xsl:template name="E00740">
    <Event>
      <xsl:attribute name="EventID">
        <xsl:text>E00740</xsl:text>
      </xsl:attribute>
      <!--Flag-->
      <Data Position="1" Length="6" Segment="Flag">
        <xsl:text>E00740</xsl:text>
      </Data>
      <!--CraiOffenseNumber-->
      <Data Position='2' Length='2' Segment='CraiOffenseNumber' AlwaysNull="true" />
      <!--CraiOtherNumber-->
      <Data Position='3' Length='2' Segment='CraiOtherNumber' AlwaysNull="true" />
      <!--pidBefore-->
      <Data Position='4' Length='15' Segment='pidBefore' AlwaysNull="true" />
      <!--LID Number-->
      <Data Position='5' Length='15' Segment='CRRLID'>
        <xsl:value-of select="/Integration/Party[@InternalPartyID=/Integration/Case/Charge[1]/@InternalPartyID]/OtherID[OtherIDAgency/@Word='LID']/OtherIDNumber"/>
      </Data>
    </Event>
  </xsl:template>
  <!-- ********************************************************************-->
  <!-- ************* template for E10161 OCA Number Change ****************-->
  <!-- ********************************************************************-->
  <xsl:template name="E10161">
    <Event>
      <xsl:attribute name="EventID">
        <xsl:text>E10161</xsl:text>
      </xsl:attribute>
      <!--Flag-->
      <Data Position="1" Length="6" Segment="Flag">
        <xsl:text>E10161</xsl:text>
      </Data>
      <!--Offense Number-->
      <Data Position='2' Length='2' Segment='CROLNO' AlwaysNull="true" />
      <!--CraiOtherNumber-->
      <Data Position='3' Length='2' Segment='CraiOtherNumber' AlwaysNull="true" />
      <!--OCA / Complaint Number Before-->
      <Data Position='4' Length='15' Segment='CRRCMPN' AlwaysNull="true" />
      <!--OCA / Complaint Number After-->
      <Data Position='5' Length='15' Segment='CRRCMPN'>
        <xsl:value-of select="/Integration/Case/CaseCrossReference[CaseCrossReferenceType/@Word='LECN']/CrossCaseNumber"/>
      </Data>
    </Event>
  </xsl:template>
  <!-- ********************************************************************-->
  <!-- ************* template for E10100 Service Record *******************-->
  <!-- ********************************************************************-->
  <xsl:template name="E10100">
    <Event>
      <xsl:attribute name="EventID">
        <xsl:text>E10100</xsl:text>
      </xsl:attribute>
      <!--Flag-->
      <Data Position="1" Length="1" Segment="Flag">
        <xsl:text>S</xsl:text>
      </Data>
      <!--Service Date-->
      <Data Position='2' Length='8' Segment='CRRDTS'>
        <xsl:call-template name="formatDateYYYYMMDD">
          <xsl:with-param name="date" select="/Integration/Case/CaseEvent/EventType[@Word='OFARS' or @Word='WFARS' or @Word='CSS' or @Word='EWRS']/../@Date[last()]"/>
        </xsl:call-template>
      </Data>
      <!--Hearing Date-->
      <Data Position='3' Length='8' Segment='CRRTDT'>
        <xsl:call-template name="formatDateYYYYMMDD">
          <xsl:with-param name="date" select="/Integration/Case/Hearing[last()]/Setting/HearingDate"/>
        </xsl:call-template>
      </Data>
      <!--Hearing Time Period Indicator (AM / PM)-->
      <Data Position='4' Length='2' Segment='CRRCRT'>
        <xsl:value-of select="substring-after(/Integration/Case/Hearing[last()]/Setting/StartTime,' ')"/>
      </Data>
      <!--Hearing Court Room Location-->
      <Data Position='5' Length='4' Segment='CRRRNO'>
        <xsl:value-of select="/Integration/Case/Hearing[last()]/Setting/CourtResource[Type/@Word='LOC']/Code/@Word[1]"/>
      </Data>
      <!--Incident Number-->
      <Data Position='6' Length='20' Segment='CRRINC'>
        <xsl:value-of select="/Integration/Case/Charge/ReportingAgency/ControlNumber[1]"/>
      </Data>
      <!--Fingerprint Number-->
      <Data Position='7' Length='8' Segment='CRSCDT' />
      <!--Date of Arrest-->
      <Data Position='8' Length='8' Segment='CRSDOA'>
        <xsl:value-of select="/Integration/Case/Charge/BookingAgency/ArrestDate[1]"/>
      </Data>
      <!--FingerPrint Reason Code-->
      <Data Position='9' Length='2' Segment='CRRREA' />
      <!--NA Vision Link Code-->
      <Data Position='10' Length='10' Segment='NA-VISIONLINKCODE' AlwaysNull="true" />
      <!--Domestic Violence Indicator-->
      <Data Position='11' Length='1' Segment='CRRDOMVL' />
      <!--Victim Rights Indicator-->
      <Data Position='12' Length='1' Segment='CRRVRA' />
    </Event>
  </xsl:template>
  <!-- ********************************************************************-->
  <!-- ****************** template for trailer record ***************************-->
  <!-- ********************************************************************-->
  <xsl:template name="TrailerRecord">
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
  <!-- ********************************************************************-->
  <!-- ****************** template for YYYYMMDD ***************************-->
  <!-- ********************************************************************-->
  <xsl:template name="formatDateYYYYMMDD">
    <xsl:param name="date"/>
    <xsl:if test="$date!=''">
      <xsl:variable name="month">
        <xsl:call-template name="GetLeadZero">
          <xsl:with-param name="Nbr" select="substring-before($date,'/')"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:variable name="daytemp" select="substring-after($date,'/')"/>
      <xsl:variable name="day">
        <xsl:call-template name="GetLeadZero">
          <xsl:with-param name="Nbr" select="substring-before($daytemp,'/')"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:variable name="year" select="substring-after($daytemp,'/')"/>
      <xsl:value-of select="concat($year,$month,$day)"/>
    </xsl:if>
  </xsl:template>
  <!-- ********************************************************************-->
  <!-- ****************** template for YYYYMMDDHHMMSS *********************-->
  <!-- ********************************************************************-->
  <xsl:template name="formatDateYYYYMMDDHHMMSS">
    <xsl:param name="dateTime"/>
    <xsl:if test="($dateTime!='')">
      <xsl:variable name="month">
        <xsl:call-template name="GetLeadZero">
          <xsl:with-param name="Nbr" select="substring-before($dateTime,'/')"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:variable name="daytemp" select="substring-after($dateTime,'/')"/>
      <xsl:variable name="day">
        <xsl:call-template name="GetLeadZero">
          <xsl:with-param name="Nbr" select="substring-before($daytemp,'/')"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:variable name="yearTemp" select="substring-before($dateTime,' ')"/>
      <xsl:variable name="yearTemp1" select="substring-after($yearTemp,'/')"/>
      <xsl:variable name="year" select="substring-after($yearTemp1,'/')"/>
      <xsl:variable name="TimeTemp" select="substring-after($dateTime,' ')"/>
      <xsl:variable name="hh">
        <xsl:call-template name="GetLeadZero">
          <xsl:with-param name="Nbr" select="substring-before($TimeTemp,':')"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:variable name="hhf">
        <xsl:if test="contains($dateTime, 'PM')">
          <xsl:value-of select="$hh+12"/>
        </xsl:if>
        <xsl:if test="not(contains($dateTime, 'PM') ) ">
          <xsl:value-of select="$hh"/>
        </xsl:if>
      </xsl:variable>
      <xsl:variable name="mmTemp" select="substring-after($TimeTemp,':')"/>
      <xsl:variable name="mm">
        <xsl:call-template name="GetLeadZero">
          <xsl:with-param name="Nbr" select="substring-before($mmTemp,':')"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:variable name="ssTemp" select="substring-after($mmTemp,':')"/>
      <xsl:variable name="ss">
        <xsl:if test="contains($ssTemp, 'AM') or contains($ssTemp, 'PM')">
          <xsl:call-template name="GetLeadZero">
            <xsl:with-param name="Nbr" select="substring-before($ssTemp,' ')"/>
          </xsl:call-template>
        </xsl:if>
        <xsl:if test="not(contains($ssTemp, 'AM') ) and not(contains($ssTemp, 'PM') ) ">
          <xsl:call-template name="GetLeadZero">
            <xsl:with-param name="Nbr" select="substring-before($ssTemp,':')"/>
          </xsl:call-template>
        </xsl:if>
      </xsl:variable>
      <xsl:value-of select="concat($year,$month,$day,$hh,$mm,$ss)"/>
    </xsl:if>
  </xsl:template>
  <!-- ********************************************************************-->
  <!-- ****************** template for leading zeros **********************-->
  <!-- ********************************************************************-->
  <xsl:template name="GetLeadZero">
    <xsl:param name="Nbr"/>
    <xsl:choose>
      <xsl:when  test="(string-length($Nbr) &lt; 2)">
        <xsl:value-of  select="concat('0',$Nbr)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of  select="$Nbr"/>
      </xsl:otherwise>
    </xsl:choose>
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







