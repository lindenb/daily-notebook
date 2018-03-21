<?xml version='1.0'  encoding="UTF-8" ?>
<xsl:stylesheet xmlns:d="http://www.drugbank.ca" xmlns:xsl='http://www.w3.org/1999/XSL/Transform' version='1.0'>
<xsl:output method="text"/>

<xsl:template match="d:drugbank">
<xsl:apply-templates select="d:drug"/>
</xsl:template>

<xsl:template match="d:drug">
<xsl:value-of select="d:name/text()"/>
<xsl:text>	</xsl:text>
<xsl:for-each select="d:groups/d:group">
	<xsl:if test='position()>1'>-&gt;</xsl:if>
	<xsl:value-of select="./text()"/>
</xsl:for-each>
<xsl:text>	</xsl:text>
<xsl:for-each select="d:calculated-properties/d:property[d:kind/text()='InChIKey']/d:value">
	<xsl:if test='position()>1'> </xsl:if>
	<xsl:value-of select="./text()"/>
</xsl:for-each>
<xsl:text>	</xsl:text>
<xsl:for-each select="d:external-identifiers/d:external-identifier[d:resource/text()='ChEMBL']/d:identifier">
	<xsl:if test='position()>1'> </xsl:if>
	<xsl:value-of select="./text()"/>
</xsl:for-each>
<xsl:text>	</xsl:text>
<xsl:for-each select="d:external-identifiers/d:external-identifier[d:resource/text()='PubChem Compound']/d:identifier">
	<xsl:if test='position()>1'> </xsl:if>
	<xsl:value-of select="./text()"/>
</xsl:for-each>
<xsl:text>	</xsl:text>
<xsl:for-each select="d:external-identifiers/d:external-identifier[d:resource/text()='PubChem Substance']/d:identifier">
	<xsl:if test='position()>1'> </xsl:if>
	<xsl:value-of select="./text()"/>
</xsl:for-each>
<xsl:text>
</xsl:text>
</xsl:template>

</xsl:stylesheet>
