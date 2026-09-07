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
    <xsl:apply-templates select="db:section | db:para | db:itemizedlist | db:blockquote"/>
  </xsl:template>

  <xsl:template match="db:section">
    <xsl:apply-templates select="db:title"/>
    <xsl:apply-templates select="db:para | db:itemizedlist | db:blockquote | db:section"/>
  </xsl:template>

  <xsl:template match="db:title">
    <xsl:variable name="depth" select="count(ancestor::db:section)"/>
    <xsl:choose>
      <xsl:when test="$depth = 1">
        <xsl:text>  h1 </xsl:text>
      </xsl:when>
      <xsl:when test="$depth = 2">
        <xsl:text>  h2 </xsl:text>
      </xsl:when>
      <xsl:when test="$depth = 3">
        <xsl:text>  h3 </xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>  h4 </xsl:text>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates select="node()"/>
    <xsl:text>&#10;</xsl:text>
  </xsl:template>

  <xsl:template match="db:para">
    <xsl:text>  p.&#10;    </xsl:text>
    <xsl:apply-templates select="node()"/>
    <xsl:text>&#10;</xsl:text>
  </xsl:template>

  <xsl:template match="db:emphasis[@role='strong' or @role='bold']">
    <xsl:text>&lt;strong&gt;</xsl:text>
    <xsl:apply-templates select="node()"/>
    <xsl:text>&lt;/strong&gt;</xsl:text>
  </xsl:template>

  <xsl:template match="db:emphasis[not(@role) or @role='italic']">
    <xsl:text>&lt;em&gt;</xsl:text>
    <xsl:apply-templates select="node()"/>
    <xsl:text>&lt;/em&gt;</xsl:text>
  </xsl:template>

  <xsl:template match="db:literal">
    <xsl:text>&lt;code&gt;</xsl:text>
    <xsl:apply-templates select="node()"/>
    <xsl:text>&lt;/code&gt;</xsl:text>
  </xsl:template>

  <xsl:template match="db:itemizedlist">
    <xsl:text>  ul&#10;</xsl:text>
    <xsl:apply-templates select="db:listitem"/>
  </xsl:template>

  <xsl:template match="db:listitem">
    <xsl:text>    li.&#10;      </xsl:text>
    <xsl:choose>
      <xsl:when test="db:para">
        <xsl:apply-templates select="db:para/node()"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="node()"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text>&#10;</xsl:text>
  </xsl:template>

  <xsl:template match="db:blockquote">
    <xsl:text>  blockquote&#10;</xsl:text>
    <xsl:for-each select="db:para">
      <xsl:text>    p.&#10;      </xsl:text>
      <xsl:apply-templates select="node()"/>
      <xsl:text>&#10;</xsl:text>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="db:info"/>
</xsl:stylesheet>
