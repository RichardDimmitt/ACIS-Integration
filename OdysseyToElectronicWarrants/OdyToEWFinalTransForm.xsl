<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:strip-space elements="*"/>
  <xsl:output method="xml" indent="no"/>
  <xsl:template match="Integration">
    <OdysseyEWUpdateMessage>
      <xsl:attribute name="MessageGUID">
        <xsl:value-of select="/Integration/@MessageGUID"/>
      </xsl:attribute>
      <xsl:attribute name="MessageID">
        <xsl:value-of select="/Integration/@MessageID"/>
      </xsl:attribute>
      <xsl:attribute name="Timestamp">
        <xsl:value-of select="/Integration/ControlPoint/@Timestamp"/>
      </xsl:attribute>
      <xsl:attribute name="CaseID">
        <xsl:value-of select="/Integration/Case/@InternalID"/>
      </xsl:attribute>
      <xsl:attribute name="CaseNumber">
        <xsl:value-of select="/Integration/Case/CaseNumber"/>
      </xsl:attribute>
      <warrantID>
        <xsl:value-of select="/Integration/Case/CaseCrossReference[@CurrentIterator='True']/CrossCaseNumber"/>
      </warrantID>
      <updateType>
        <xsl:value-of select="/Integration/IntegrationConditions/IntegrationCondition/updateType"/>
      </updateType>
      <xsl:if test="/Integration/IntegrationConditions/IntegrationCondition/offenseCount">
        <offenseCount>
          <xsl:value-of select="/Integration/IntegrationConditions/IntegrationCondition/offenseCount"/>
        </offenseCount>
      </xsl:if>
      <xsl:if test="/Integration/IntegrationConditions/IntegrationCondition/deletionReason">
        <deletionReason>
          <xsl:value-of select="/Integration/IntegrationConditions/IntegrationCondition/deletionReason"/>
        </deletionReason>
      </xsl:if>
      <reason>
        <xsl:value-of select="/Integration/IntegrationConditions/IntegrationCondition/reason"/>
      </reason>
    </OdysseyEWUpdateMessage>
  </xsl:template>
</xsl:stylesheet>










