<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<!-- ************************************************************************************-->
	<!-- *** template for E00730 FingerPrint Number, Date of Arrest Delete ******************-->
	<!-- *** Change Log:                                                                  ***-->
	<!-- *** 8/11/2021: INT-6271                                                          ***-->
	<!-- ************************************************************************************-->
	<xsl:template name="E00730">
		<Event>
			<xsl:attribute name="EventID">
				<xsl:text>E00730</xsl:text>
			</xsl:attribute>
			<xsl:attribute name="TrailerRecord">
				<xsl:text>TotalEventRec</xsl:text>
			</xsl:attribute>
			<!-- Flag -->
			<Data Position="1" Length="6" Segment="Flag">
				<xsl:text>E00730</xsl:text>
			</Data>
			<!--CraiOffenseNumber-->
			<Data Position='2' Length='2' Segment='CraiOffenseNumber' AlwaysNull="true"/>
			<!--CraiOtherNumber-->
			<Data Position='3' Length='2' Segment='CraiOtherNumber' AlwaysNull="true"/>
			<!-- Fingerprint Number Old -->
			<Data Position='4' Length='7' Segment='CRSCDT-OLD' AlwaysNull="true"/>
			<!-- Date of Arrest Old -->
			<Data Position='5' Length='8' Segment='CRSDOA-OLD' AlwaysNull="true"/>
			<!-- Fingerprint Number -->
			<Data Position='6' Length='7' Segment='CRSCDT' AlwaysNull="true"/>
			<!-- Date of Arrest -->
			<Data Position='7' Length='8' Segment='CRSDOA' AlwaysNull="true"/>
			<!-- Filler -->
			<Data Position='8' Length='160' Segment='Filler' AlwaysNull="true"/>
		</Event>
	</xsl:template>
</xsl:stylesheet>
