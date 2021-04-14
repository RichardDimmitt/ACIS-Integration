<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:template name="HeaderForAddMessage">
  <!-- ********************************************************************-->
  <!-- ********** template for Header Record for Add Messages *************-->
  <!-- ********************************************************************-->
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
        <xsl:text>A</xsl:text>
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
        <!-- We are not going to send hearing information for the moment as we will need to map there 973 ACIS codes -->
        <!--<xsl:value-of select="/Integration/Case/Hearing[last()]/Setting/CourtResource[Type/@Word='LOC']/Code/@Word[1]"/>-->
      </Data>
      <Data Position="20" Length="6" Segment="CraiHdrCourtroomFiller">
        <!-- They said they don't need this -->
        <!-- <xsl:value-of select="/Integration/@MessageID"/> -->
      </Data>
      <!-- Filler to create total required length -->
      <Data Position='21' Length='9' Segment='Filler' AlwaysNull="true"/>
    </Header>
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
</xsl:stylesheet>











