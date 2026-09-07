<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:db="http://docbook.org/ns/docbook">

  <xsl:output method="text" encoding="UTF-8" omit-xml-declaration="yes"/>
  <xsl:strip-space elements="*"/>

  <xsl:template match="/">
    <xsl:apply-templates select="//db:article"/>
  </xsl:template>

  <xsl:template match="db:article">
    <xsl:text>article&#10;</xsl:text>
    <xsl:choose>
      <xsl:when test="db:section">
        <xsl:apply-templates select="db:section"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="db:para | db:itemizedlist | db:blockquote"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="db:section">
    <xsl:apply-templates select="db:title"/>
    <xsl:apply-templates select="db:para | db:itemizedlist | db:blockquote"/>
  </xsl:template>

  <xsl:template match="db:title">
    <xsl:text>  h1 </xsl:text>
    <xsl:value-of select="normalize-space(.)"/>
    <xsl:text>&#10;</xsl:text>
  </xsl:template>

  <xsl:template match="db:para">
    <xsl:text>  p </xsl:text>
    <xsl:value-of select="normalize-space(.)"/>
    <xsl:text>&#10;</xsl:text>
  </xsl:template>

  <xsl:template match="db:itemizedlist">
    <xsl:text>  ul&#10;</xsl:text>
    <xsl:apply-templates select="db:listitem"/>
  </xsl:template>

  <xsl:template match="db:listitem">
    <xsl:text>    li </xsl:text>
    <xsl:value-of select="normalize-space(.)"/>
    <xsl:text>&#10;</xsl:text>
  </xsl:template>

  <xsl:template match="db:blockquote">
    <xsl:text>  blockquote&#10;</xsl:text>
    <xsl:for-each select="db:para">
      <xsl:text>    p </xsl:text>
      <xsl:value-of select="normalize-space(.)"/>
      <xsl:text>&#10;</xsl:text>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="db:info"/>
</xsl:stylesheet>
