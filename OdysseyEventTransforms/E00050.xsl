<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:template name="E00050">
  <!-- ********************************************************************-->
  <!-- **************** template for E00050 Case Add **********************-->
  <!-- ********************************************************************-->
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
      <!--Issue date-->
      <Data Position="8" Length="8" Segment="CRRIDT">
        <xsl:choose>
          <xsl:when test="(/Integration/IntegrationConditions/IntegrationCondition/ProcessActionType='MOREJ')">
            <xsl:call-template name="formatDateYYYYMMDD">
              <xsl:with-param name="date" select="/Integration/Case/Charge[1]/ChargeOffenseDate"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="formatDateYYYYMMDD">
              <xsl:with-param name="date" select="/Integration/IntegrationConditions/IntegrationCondition/ProcessActionDate"/>
            </xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>
      </Data>
      <!--NA-FILLER-20-->
      <Data Position="9" Length="20" Segment="NA-FILLER-20" AlwaysNull="true"/>
      <!-- Note, do not send address information for foreign addresses -->
      <xsl:if test="(/Integration/Party[@InternalPartyID=$DefendantID]/Address[@PartyCurrent='true']/Foreign='false')">
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
      </xsl:if>
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
      <!--Citation Number / Warrant Number-->
      <Data Position="18" Length="8" Segment="CRRWNO">
        <xsl:choose>
          <xsl:when test="(/Integration/Citation[1]/CitationNumber)">
            <xsl:value-of select="/Integration/Citation[1]/CitationNumber"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="translate(/Integration/Case/CaseCrossReference[CaseCrossReferenceType/@Word='PROC']/CrossCaseNumber,'-','')"/>
          </xsl:otherwise>
        </xsl:choose>
      </Data>
      <!--Citation Validation Character-->
      <Data Position="19" Length="1" Segment="CRRWCDT">
        <xsl:value-of select="/Integration/Citation[1]/CheckDigit"/>
      </Data>
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
      <Data Position="24" Length="1" Segment="CRRCDL">
        <xsl:call-template name="GetACISCDLCode">
          <xsl:with-param name="code" select ="/Integration/Party[@InternalPartyID=$DefendantID]/DriversLicense[@Current='true']/DriversLicenseType/@Word"/>
        </xsl:call-template>
      </Data>
      <!--Citation Commerical Vehicle Indicator-->
      <Data Position="25" Length="1" Segment="CRRCMV">
        <xsl:choose>
          <xsl:when test="(/Integration/Citation[1]/Vehicle/CommercialVehicleFlag='true')">
            <xsl:value-of select="'Y'"/>
          </xsl:when>
          <xsl:when test="(/Integration/Citation[1]/Vehicle/CommercialVehicleFlag='false')">
            <xsl:value-of select="'N'"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="''"/>
          </xsl:otherwise>
        </xsl:choose>
      </Data>
      <!--Citation Hazardous Materials Indicator-->
      <Data Position="26" Length="1" Segment="CRRHAZ">
        <xsl:choose>
          <xsl:when test="(/Integration/Citation[1]/Vehicle/HazardousVehicleFlag='true')">
            <xsl:value-of select="'Y'"/>
          </xsl:when>
          <xsl:when test="(/Integration/Citation[1]/Vehicle/HazardousVehicleFlag='false')">
            <xsl:value-of select="'N'"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="''"/>
          </xsl:otherwise>
        </xsl:choose>
      </Data>
      <!--Citation SHP Troop-->
      <Data Position="27" Length="1" Segment="CRRTRP">
        <xsl:value-of select="substring(/Integration/Citation[1]/Incident/SHPTroop,1,1)"/>
      </Data>
      <!--Citation SHP District-->
      <Data Position="28" Length="1" Segment="CRRTRP">
        <xsl:value-of select="substring(/Integration/Citation[1]/Incident/SHPDistrict,1,1)"/>
      </Data>
      <!--Citation Accident Indicator-->
      <Data Position="29" Length="1" Segment="CRRACC">
        <xsl:choose>
          <xsl:when test="(/Integration/Citation/Incident/Fatalities)">
            <xsl:value-of select="'F'"/>
            <!-- Fatality -->
      </xsl:when>
          <xsl:when test="(/Integration/Citation/Incident/NumberOfInjuries)">
            <xsl:value-of select="'I'"/>
            <!-- Personal Injury -->
      </xsl:when>
          <xsl:when test="(/Integration/Citation/Incident/Property)">
            <xsl:value-of select="'P'"/>
            <!-- Property Damage -->
      </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="'N'"/>
            <!-- Near Accident or No Accident -->
      </xsl:otherwise>
        </xsl:choose>
      </Data>
      <!--Citation Highway-->
      <Data Position="30" Length="6" Segment="CRRROD">
        <xsl:value-of select="/Integration/Citation[1]/Incident/HighwayType/@Word"/>
        <xsl:value-of select="/Integration/Citation[1]/Incident/StreetType/@Word"/>
      </Data>
      <!--Citation SHP Area-->
      <Data Position="31" Length="2" Segment="CRRARE">
        <xsl:value-of select="/Integration/Citation[1]/Incident/SHPAreaType/@Word"/>
      </Data>
      <!--Citation Vehicle License Plate-->
      <Data Position="32" Length="10" Segment="CRRVLN">
        <xsl:value-of select="/Integration/Citation[1]/Vehicle/LicensePlate"/>
      </Data>
      <!--Citation Vehicle State-->
      <Data Position="33" Length="2" Segment="CRRVLS">
        <xsl:value-of select="/Integration/Citation[1]/Vehicle/LicenseState/@Word"/>
      </Data>
      <!--Citation Vehicle Type-->
      <Data Position="34" Length="4" Segment="CRRVTY">
        <xsl:value-of select="/Integration/Citation[1]/Vehicle/VehicleType/@Word"/>
      </Data>
      <!--Citation Tailer Type-->
      <Data Position="35" Length="4" Segment="CRRTTY">
        <xsl:value-of select="/Integration/Citation[1]/Vehicle/TrailerType/@Word"/>
      </Data>
      <!--Vision Link Code-->
      <Data Position="36" Length="10" Segment="NA-VISIONLINKCODE" AlwaysNull="true"/>
      <!--Domestic Violence Indicator-->
      <Data Position="37" Length="1" Segment="CRRDOMVL">
        <xsl:choose>
          <xsl:when test="(/Integration/Case/Charge//Additional/NCDomesticViolence/IsDomesticViolence='true')">
            <xsl:value-of select="'Y'"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="'N'"/>
          </xsl:otherwise>
        </xsl:choose>
      </Data>
      <!--Fingerprint Required Indicator-->
      <Data Position="38" Length="1" Segment="UNK-CraiFingerprintInd">
        <xsl:choose>
          <xsl:when test="(/Integration/Case/Charge//Additional//IsFingerprintRequired='true')">
            <xsl:value-of select="'Y'"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="'N'"/>
          </xsl:otherwise>
        </xsl:choose>
      </Data>
      <!--Victim Rights Indicator-->
      <Data Position="39" Length="1" Segment="CRRVRA">
        <xsl:choose>
          <xsl:when test="(/Integration/Case/Charge//Additional/NCVictimsRights/IsVictimsRights='true')">
            <xsl:value-of select="'Y'"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="'N'"/>
          </xsl:otherwise>
        </xsl:choose>
      </Data>
      <!--NA-FILLER-97-->
      <Data Position="40" Length="97" Segment="NA-FILLER-97" AlwaysNull="true"/>
      <!--NA-FILLER-1-->
      <Data Position="41" Length="1" Segment="NA-FILLER-1" AlwaysNull="true"/>
      <!--NA-FILLER-1-->
      <Data Position="42" Length="1" Segment="NA-FILLER-1" AlwaysNull="true"/>
      <!-- Filler to create total required length -->
      <Data Position='43' Length='0' Segment='Filler' AlwaysNull="true"/>
    </Event>
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
  <!-- *******************************************************************-->
  <!-- **************** template for mapping DL Type codes ***************-->
  <!-- *******************************************************************-->
  <xsl:template name="GetACISCDLCode">
    <xsl:param name ="code"/>
    <xsl:choose>
      <xsl:when test="($code='CDLA')">
        <xsl:value-of select="'Y'"/>
      </xsl:when>
      <xsl:when test="($code='CDLB')">
        <xsl:value-of select="'Y'"/>
      </xsl:when>
      <xsl:when test="($code='CDLC')">
        <xsl:value-of select="'Y'"/>
      </xsl:when>
      <xsl:when test="($code='CDLP')">
        <xsl:value-of select="'Y'"/>
      </xsl:when>
      <xsl:when test="($code='CDLU')">
        <xsl:value-of select="'Y'"/>
      </xsl:when>
      <xsl:when test="($code='SBB')">
        <xsl:value-of select="'Y'"/>
      </xsl:when>
      <xsl:when test="($code='SBC')">
        <xsl:value-of select="'Y'"/>
      </xsl:when>
      <xsl:when test="($code='ID')">
        <xsl:value-of select="'N'"/>
      </xsl:when>
      <xsl:when test="($code='LP')">
        <xsl:value-of select="'N'"/>
      </xsl:when>
      <xsl:when test="($code='MC')">
        <xsl:value-of select="'N'"/>
      </xsl:when>
      <xsl:when test="($code='MLP')">
        <xsl:value-of select="'N'"/>
      </xsl:when>
      <xsl:when test="($code='OCU')">
        <xsl:value-of select="'N'"/>
      </xsl:when>
      <xsl:when test="($code='RCA')">
        <xsl:value-of select="'N'"/>
      </xsl:when>
      <xsl:when test="($code='RCB')">
        <xsl:value-of select="'N'"/>
      </xsl:when>
      <xsl:when test="($code='RGC')">
        <xsl:value-of select="'N'"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="'N'"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>


















