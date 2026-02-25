<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:epub="http://www.idpf.org/2007/ops"
 xmlns="http://www.w3.org/1999/xhtml" exclude-result-prefixes="xs" version="3.0">
 <!--
  FIX: xmlns="" pe elementele de continut.
  Adaugarea xmlns="http://www.w3.org/1999/xhtml" pe xsl:stylesheet
  face ca toate elementele literale (p, div, h1, i, b, span, br, img)
  sa fie automat in namespace-ul XHTML. Saxon nu va mai adauga xmlns=""
  pe niciunul dintre ele.

  Entitatile numerice: cu method="xhtml" encoding="UTF-8", caracterele
  Unicode (U+2004, U+2009, U+00AB, U+00BB) sunt serializate ca bytes
  UTF-8 directi. Este comportamentul corect pentru EPUB3/XHTML5.
-->
 <xsl:output method="xhtml" indent="yes" encoding="UTF-8" include-content-type="no"/>
 <xsl:template match="/">
  <xsl:result-document href="nav.xhtml" method="xhtml" encoding="UTF-8" indent="yes" include-content-type="no">
   <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html&gt;&#10;</xsl:text>
   <html xmlns="http://www.w3.org/1999/xhtml" xmlns:epub="http://www.idpf.org/2007/ops" lang="fr-FR"
    xml:lang="fr-FR">
    <head>
     <title>Table des matières</title>
     <link href="../Styles/styles.css" rel="stylesheet" type="text/css"/>
    </head>
    <body>
     <nav epub:type="toc" id="toc" role="doc-toc">
      <h1>Table des mati&#232;res</h1>
      <ol>
       <xsl:for-each-group select="livre/corps/*" group-starting-with="h1 | Journal">
        <xsl:variable name="pos" select="format-number(position(), '00')"/>
        <xsl:variable name="is-front" select="not(self::h1 or self::Journal)"/>
        <li>
         <a href="chap_{$pos}_{if ($is-front) then 'intro' else 'chapitre'}.xhtml">
          <xsl:choose>
           <xsl:when test="$is-front">Introduction</xsl:when>
           <xsl:otherwise>
            <xsl:variable name="cleanTitle">
             <xsl:apply-templates select="." mode="getText"/>
            </xsl:variable>
            <xsl:value-of select="normalize-space($cleanTitle)"/>
           </xsl:otherwise>
          </xsl:choose>
         </a>
        </li>
       </xsl:for-each-group>
      </ol>
     </nav>
    </body>
   </html>
  </xsl:result-document>
  <xsl:for-each-group select="livre/corps/*" group-starting-with="h1 | Journal">
   <xsl:variable name="pos" select="format-number(position(), '00')"/>
   <xsl:variable name="is-front" select="not(self::h1 or self::Journal)"/>
   <xsl:variable name="file-name" select="concat('chap_', $pos, '_', if ($is-front) then 'intro' else 'chapitre', '.xhtml')"/>
   <xsl:result-document href="{$file-name}" method="xhtml" encoding="UTF-8" indent="yes" include-content-type="no">
    <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html&gt;&#10;</xsl:text>
    <html xmlns="http://www.w3.org/1999/xhtml" xmlns:epub="http://www.idpf.org/2007/ops"
     lang="fr-FR" xml:lang="fr-FR">
     <head>
      <title>
       <xsl:choose>
        <xsl:when test="not($is-front)">
         <xsl:variable name="cleanTitle">
          <xsl:apply-templates select="." mode="getText"/>
         </xsl:variable>
         <xsl:value-of select="normalize-space($cleanTitle)"/>
        </xsl:when>
        <xsl:otherwise>Introduction</xsl:otherwise>
       </xsl:choose>
      </title>
      <link href="../Styles/styles.css" rel="stylesheet" type="text/css"/>
     </head>
     <body epub:type="{if ($is-front) then 'frontmatter' else 'bodymatter'}">
      <section epub:type="{if ($is-front) then 'introduction' else 'chapter'}"
       role="{if ($is-front) then 'doc-introduction' else 'doc-chapter'}">
       <xsl:apply-templates select="current-group()"/>
      </section>
     </body>
    </html>
   </xsl:result-document>
  </xsl:for-each-group>
 </xsl:template>
 <xsl:template match="br" mode="getText">
  <xsl:text> </xsl:text>
 </xsl:template>
 <xsl:template match="RP | span[@class = 'nchap']" mode="getText"/>
 <xsl:template match="*" mode="getText">
  <xsl:apply-templates mode="getText"/>
 </xsl:template>
 <xsl:template match="h1">
  <h1 class="ChapTit">
   <xsl:apply-templates/>
  </h1>
 </xsl:template>
 <xsl:template match="p">
  <p>
   <xsl:if test="@class">
    <xsl:attribute name="class" select="@class"/>
   </xsl:if>
   <xsl:apply-templates/>
  </p>
 </xsl:template>
 <xsl:template match="i">
  <i>
   <xsl:apply-templates/>
  </i>
 </xsl:template>
 <xsl:template match="b">
  <b>
   <xsl:apply-templates/>
  </b>
 </xsl:template>
 <xsl:template match="span">
  <span>
   <xsl:if test="@class">
    <xsl:attribute name="class" select="@class"/>
   </xsl:if>
   <xsl:apply-templates/>
  </span>
 </xsl:template>
 <xsl:template match="br">
  <br/>
 </xsl:template>
 <xsl:template match="RP">
  <span epub:type="pagebreak" role="doc-pagebreak" id="page{@page}" title="{@page}"/>
 </xsl:template>
 <xsl:template match="Exergue">
  <div class="Exergue">
   <xsl:apply-templates/>
  </div>
 </xsl:template>
 <xsl:template match="Journal">
  <h1 class="journal">
   <xsl:apply-templates/>
  </h1>
 </xsl:template>
 <xsl:template match="img">
   <img src="../Images/{@src}.png" alt="{@src}"/>
 </xsl:template>
</xsl:stylesheet>
