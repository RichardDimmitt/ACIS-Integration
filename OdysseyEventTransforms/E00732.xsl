<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <!-- ************************************************************************************-->
  <!-- *** template for E00732 FingerPrint Reason Change **********************************-->
  <!-- *** Change Log:                                                                  ***-->
  <!-- *** 8/10/2021: Implemented the following business logic rules based              ***-->
  <!-- ***            on ALI error report information  INT-6264                         ***-->
  <!-- ***            Note*, we do not check to see that the arrest date is blank as    ***-->
  <!-- ***            EW does not enforce this.  The E70030 transform will not send the ***-->
  <!-- ***            arrest date if the check digit is not available which should keep ***-->
  <!-- ***            this error from presenting itself                                 ***-->
  <!-- ***             - REASON CODE IS ONLY ALLOWED WHEN CHECK DIGIT AND DOA ARE BLANK ***-->
  <!-- ************************************************************************************-->
  <xsl:template name="E00732">
    <xsl:variable name="ArrestDate">
      <xsl:call-template name="formatDateYYYYMMDD">
        <xsl:with-param name="date" select="/Integration/Case/Charge/BookingAgency/ArrestDate[1]"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="CheckDigit">
      <xsl:value-of select="/Integration/Case/Charge/ChargeHistory[@CurrentCharge='true']/Additional/*[contains(name(),'NCFingerprint')]/CheckDigitNumber[1]"/>
    </xsl:variable>
    <xsl:variable name="FingerPrintReason">
      <xsl:value-of select="/Integration/Case/Charge/ChargeHistory[@CurrentCharge='true']/Additional/*[contains(name(),'NCFingerprint')]/Reason/@Word[1]"/>
    </xsl:variable>
     <xsl:if test="$FingerPrintReason != ''">
       <xsl:if test="$CheckDigit = ''">
        <Event>
          <xsl:attribute name="EventID">
            <xsl:text>E00732</xsl:text>
          </xsl:attribute>
          <xsl:attribute name="TrailerRecord">
            <xsl:text>TotalEventRec</xsl:text>
          </xsl:attribute>
          <!-- Flag -->
          <Data Position="1" Length="6" Segment="Flag">
            <xsl:text>E00732</xsl:text>
          </Data>
          <!--CraiOffenseNumber-->
          <Data Position='2' Length='2' Segment='CraiOffenseNumber' AlwaysNull="true" />
          <!--CraiOtherNumber-->
          <Data Position='3' Length='2' Segment='CraiOtherNumber' AlwaysNull="true" />
          <!-- FingerPrint Reason Code Old -->
          <Data Position='4' Length='2' Segment='CRRREA-OLD' AlwaysNull="true"/>
          <!-- FingerPrint Reason Code -->
          <Data Position='5' Length='2' Segment='CRRREA'>
            <xsl:value-of select="/Integration/Case/Charge/ChargeHistory[@CurrentCharge='true']/Additional/*[contains(name(),'NCFingerprint')]/Reason/@Word[1]"/>
          </Data>
          <!-- Filler -->
          <Data Position='6' Length='186' Segment='Filler' AlwaysNull="true"/>
        </Event>
      </xsl:if>
    </xsl:if>
  </xsl:template>
</xsl:stylesheet>





