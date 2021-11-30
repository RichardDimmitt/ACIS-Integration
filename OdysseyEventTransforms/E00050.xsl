<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<!-- *************************************************************************-->
	<!-- **************** template for E00050 Case Add ***************************-->
	<!-- *** 08-17-21 Updated to provide the default value of N for the CRRCMV ***-->
	<!-- ***          segment in the event that the commerical DL indicator    ***-->
	<!-- ***          is provided but no commerical vehicle flag is provided   ***-->
	<!-- ***          in the IXML INT-6319                                     ***-->
        <!-- *** 08-30-21 Updated to base the CRRCDL segemet off the CDL flag in   ***-->
        <!-- ***          the Citation IXML as opposed to the DL Type INT-6351     ***-->
        <!-- *** 08/30/21 Updated to remove '.' from the formatted name INT-6382   ***-->
        <!-- *** 09/20/21 Updated to provide the default value of 'X' for the race ***-->
        <!-- ***          and sex if the defendant is a business INT-6570          ***-->
        <!-- *** 11/29/21 Updated the logic of the CRRTTY segement to provide the  ***-->
        <!-- ***          default value of 'U' if the CRRVTY is TTT and there is   ***-->
        <!-- ***          no CRRTTY available INT-66990                            ***-->
	<!-- *************************************************************************-->
  <xsl:template name="E00050">
    <xsl:variable name="DefendantID">
      <xsl:value-of select="/Integration/Case/Charge[1]/@InternalPartyID"/>
    </xsl:variable>
    <xsl:variable name="ZIP" select="substring(/Integration/Party[@InternalPartyID=$DefendantID]/Address[@PartyCurrent='true']/Zip,1,5)"/>
    <xsl:variable name="CommercialDL">
      <xsl:choose>
        <xsl:when test="/Integration/Citation[Citee/DriversLicense/IsCDL='true']">
          <xsl:value-of select="'Y'"/>
        </xsl:when>
        <xsl:when test="/Integration/Citation[not(Citee/DriversLicense/IsCDL='true')]">
          <xsl:value-of select="'N'"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="''"/>
        </xsl:otherwise>
      </xsl:choose>
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
        <xsl:value-of select="translate(/Integration/Party[@InternalPartyID=$DefendantID]/PartyName[@Current='true']/FormattedName,'.','')"/>
      </Data>
      <!--Defendant Race-->
      <Data Position="4" Length="1" Segment="CRRACE">
        <xsl:choose>
          <xsl:when test="/Integration/Party[@InternalPartyID=29120335]/PartyName[@Current='true']/NameType='Business'">
            <xsl:value-of select="'X'"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="GetACISRaceCode">
              <xsl:with-param name="code" select="/Integration/Party[@InternalPartyID=$DefendantID]/Race/@Word"/>
            </xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>
      </Data>
      <!--Defendant Sex-->
      <Data Position="5" Length="1" Segment="CRRSEX">
        <xsl:choose>
          <xsl:when test="/Integration/Party[@InternalPartyID=29120335]/PartyName[@Current='true']/NameType='Business'">
            <xsl:value-of select="'X'"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="GetACISSexCode">
              <xsl:with-param name="code" select="substring(/Integration/Party[@InternalPartyID=$DefendantID]/Gender/@Word,1,1)"/>
            </xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>
      </Data>
      <!--Defendant Address City-->
      <Data Position="6" Length="15" Segment="CRRCTY">
        <xsl:choose>
          <xsl:when test="/Integration/Party[@InternalPartyID=$DefendantID]/Address[@PartyCurrent='true']/@Type='Foreign'">
            <xsl:value-of select="''"/>
          </xsl:when>
          <xsl:when test="/Integration/Party[@InternalPartyID=$DefendantID]/Address[@PartyCurrent='true']/City">
            <xsl:value-of select="/Integration/Party[@InternalPartyID=$DefendantID]/Address[@PartyCurrent='true']/City"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="'UNKNOWN'"/>
          </xsl:otherwise>
        </xsl:choose>
      </Data>
      <!--Defendant Address State-->
      <Data Position="7" Length="2" Segment="CRRDST">
        <xsl:choose>
          <xsl:when test="/Integration/Party[@InternalPartyID=$DefendantID]/Address[@PartyCurrent='true']/@Type='Foreign'">
            <xsl:value-of select="''"/>
          </xsl:when>
          <xsl:when test="/Integration/Party[@InternalPartyID=$DefendantID]/Address[@PartyCurrent='true']/State">
            <xsl:value-of select="/Integration/Party[@InternalPartyID=$DefendantID]/Address[@PartyCurrent='true']/State"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="'OT'"/>
          </xsl:otherwise>
        </xsl:choose>
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
      <!--Defendant Address Line 1 Note, do not send address information for foreign addresses-->
      <Data Position="10" Length="20" Segment="CRRADD">
        <xsl:choose>
          <xsl:when test="(/Integration/Party[@InternalPartyID=$DefendantID]/Address[@PartyCurrent='true']/@Type='Standard')">
            <xsl:value-of select="/Integration/Party[@InternalPartyID=$DefendantID]/Address[@PartyCurrent='true']/AddressLine2"/>
          </xsl:when>
          <xsl:when test="(/Integration/Party[@InternalPartyID=$DefendantID]/Address[@PartyCurrent='true']/@Type='Standard With Attention')">
            <xsl:value-of select="/Integration/Party[@InternalPartyID=$DefendantID]/Address[@PartyCurrent='true']/AddressLine2"/>
          </xsl:when>
          <xsl:when test="(/Integration/Party[@InternalPartyID=$DefendantID]/Address[@PartyCurrent='true']/@Type='Non Standard')">
            <xsl:value-of select="/Integration/Party[@InternalPartyID=$DefendantID]/Address[@PartyCurrent='true']/AddressLine1"/>
          </xsl:when>
          <xsl:when test="(/Integration/Party[@InternalPartyID=$DefendantID]/Address[@PartyCurrent='true']/@Type='Foreign')">
            <xsl:value-of select="''"/>
          </xsl:when>
        </xsl:choose>
      </Data>
      <!--Defendant Address Line 2 Note, do not send address information for foreign addresses-->
      <Data Position="11" Length="15" Segment="CRREAD">
        <xsl:choose>
          <xsl:when test="(/Integration/Party[@InternalPartyID=$DefendantID]/Address[@PartyCurrent='true']/@Type='Standard')">
            <xsl:value-of select="/Integration/Party[@InternalPartyID=$DefendantID]/Address[@PartyCurrent='true']/AddressLine3"/>
          </xsl:when>
          <xsl:when test="(/Integration/Party[@InternalPartyID=$DefendantID]/Address[@PartyCurrent='true']/@Type='Standard With Attention')">
            <xsl:value-of select="/Integration/Party[@InternalPartyID=$DefendantID]/Address[@PartyCurrent='true']/AddressLine3"/>
          </xsl:when>
          <xsl:when test="(/Integration/Party[@InternalPartyID=$DefendantID]/Address[@PartyCurrent='true']/@Type='Non Standard')">
            <xsl:value-of select="/Integration/Party[@InternalPartyID=$DefendantID]/Address[@PartyCurrent='true']/AddressLine2"/>
          </xsl:when>
          <xsl:when test="(/Integration/Party[@InternalPartyID=$DefendantID]/Address[@PartyCurrent='true']/@Type='Foreign')">
            <xsl:value-of select="''"/>
          </xsl:when>
        </xsl:choose>
      </Data>
      <!--Defendant Address ZIP-->
      <Data Position="12" Length="5" Segment="CRRZIP">
        <xsl:choose>
          <xsl:when test="($ZIP='00000')">
            <xsl:value-of select="''"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$ZIP"/>
          </xsl:otherwise>
        </xsl:choose>
      </Data>
      <!--Defendant Address ZIP + 4-->
      <Data Position="13" Length="4" Segment="CRREZP">
        <xsl:choose>
          <xsl:when test="($ZIP='00000')">
            <xsl:value-of select="''"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="substring-after(/Integration/Party[@InternalPartyID=$DefendantID]/Address[@PartyCurrent='true']/Zip,'-')"/>
          </xsl:otherwise>
        </xsl:choose>
      </Data>
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
      <Data Position="16" Length="6" Segment="CRRCTM">
        <xsl:choose>
          <xsl:when test="(/Integration/Case/Charge/ChargeOffenseTime)">
            <xsl:call-template name="formatTimeHHMMAMPM">
              <xsl:with-param name="time" select="translate(/Integration/Case/Charge/ChargeOffenseTime,':','')"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>0001MM</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </Data>
      <!--NA-FILLER-20-->
      <Data Position="17" Length="20" Segment="NA-FILLER-20" AlwaysNull="true"/>
      <!--Citation Number-->
      <Data Position="18" Length="8" Segment="CRRWNO">
        <xsl:value-of select="/Integration/Citation[1]/CitationNumber"/>
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
        <xsl:choose>
          <xsl:when test="(/Integration/Party[@InternalPartyID=$DefendantID]/DriversLicense[@Current='true']/DriversLicenseNumber)">
            <xsl:call-template name="PaddWithZeros">
              <xsl:with-param name="Value" select="/Integration/Party[@InternalPartyID=$DefendantID]/DriversLicense[@Current='true']/DriversLicenseNumber"/>
              <xsl:with-param name="Length" select="8"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="''"/>
          </xsl:otherwise>
        </xsl:choose>
      </Data>
      <!--Defendant DL State-->
      <Data Position="23" Length="2" Segment="CRRSIL">
        <xsl:value-of select="/Integration/Party[@InternalPartyID=$DefendantID]/DriversLicense[@Current='true']/DriversLicenseState/@Word"/>
      </Data>
      <!--Citation Commerical DL Indicator-->
      <Data Position="24" Length="1" Segment="CRRCDL">
        <xsl:value-of select="$CommercialDL"/>
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
          <xsl:when test="($CommercialDL != '')">
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
          <xsl:when test="($CommercialDL != '')">
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
        <xsl:choose>
          <xsl:when test="(/Integration/Citation[1]/Vehicle[VehicleType/@Word='TTT' and not(TrailerType/@Word)])">
            <xsl:value-of select="'U'"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="/Integration/Citation[1]/Vehicle/TrailerType/@Word"/>
          </xsl:otherwise>
        </xsl:choose>
      </Data>
      <!--Vision Link Code-->
      <Data Position="36" Length="10" Segment="NA-VISIONLINKCODE" AlwaysNull="true"/>
      <!--Domestic Violence Indicator-->
      <Data Position="37" Length="1" Segment="CRRDOMVL">
        <xsl:choose>
          <xsl:when test="(/Integration/Case/Charge//Additional/NCDomesticViolence/IsDomesticViolence='true')">
            <xsl:value-of select="'Y'"/>
          </xsl:when>
          <xsl:when test="(/Integration/Case/Charge//Additional/NCDomesticViolence/IsDomesticViolence='false')">
            <xsl:value-of select="'N'"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="''"/>
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
          <xsl:when test="(/Integration/Case/Charge//Additional/NCVictimsRights/IsVictimsRights='false')">
            <xsl:value-of select="'N'"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="''"/>
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
	<!-- ****************** template for formatting time **********************-->
	<!-- ********************************************************************-->
  <xsl:template name="formatTimeHHMMAMPM">
    <xsl:param name="time"/>
    <xsl:variable name="timetemp" select="substring-before($time,' ')"/>
    <xsl:variable name="AMPM" select="substring-after($time,' ')"/>
    <xsl:variable name="finalTime">
      <xsl:call-template name="PaddWithZeros">
        <xsl:with-param name="Value" select="$timetemp"/>
        <xsl:with-param name="Length" select="4"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="concat($finalTime,$AMPM)"/>
  </xsl:template>
  <!-- ********************************************************************-->
	<!-- ****************** template for leading zeros **********************-->
	<!-- ********************************************************************-->
  <xsl:template name="GetLeadZero">
    <xsl:param name="Nbr"/>
    <xsl:choose>
      <xsl:when test="(string-length($Nbr) &lt; 2)">
        <xsl:value-of select="concat('0',$Nbr)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$Nbr"/>
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
      <xsl:when test="($PaddingNeeded &gt; 0)">
        <xsl:if test="($PaddingNeeded = 1)">
          <xsl:value-of select="concat('0',$Value)"/>
        </xsl:if>
        <xsl:if test="($PaddingNeeded = 2)">
          <xsl:value-of select="concat('00',$Value)"/>
        </xsl:if>
        <xsl:if test="($PaddingNeeded = 3)">
          <xsl:value-of select="concat('000',$Value)"/>
        </xsl:if>
        <xsl:if test="($PaddingNeeded = 4)">
          <xsl:value-of select="concat('0000',$Value)"/>
        </xsl:if>
        <xsl:if test="($PaddingNeeded = 5)">
          <xsl:value-of select="concat('00000',$Value)"/>
        </xsl:if>
        <xsl:if test="($PaddingNeeded = 6)">
          <xsl:value-of select="concat('000000',$Value)"/>
        </xsl:if>
        <xsl:if test="($PaddingNeeded = 7)">
          <xsl:value-of select="concat('0000000',$Value)"/>
        </xsl:if>
        <xsl:if test="($PaddingNeeded = 8)">
          <xsl:value-of select="concat('00000000',$Value)"/>
        </xsl:if>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$Value"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <!-- ********************************************************************-->
	<!-- ****************** template for mapping race codes *****************-->
	<!-- ********************************************************************-->
  <xsl:template name="GetACISRaceCode">
    <xsl:param name="code"/>
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
    <xsl:param name="code"/>
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
    <xsl:param name="code"/>
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
        <xsl:value-of select="''"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>














