<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:epub="http://www.idpf.org/2007/ops"
 xmlns="http://www.w3.org/1999/xhtml" exclude-result-prefixes="xs" version="3.0">
 <!--
  FIX nav.xhtml (v2):
  1. Titluri curatate: tokenize pe '#' => pastram doar primul segment (titlul fara autor/subtitlu)
  2. Adaugat nav landmarks (obligatoriu EPUB Accessibility 1.1)
  3. Adaugat nav page-list generat dinamic din elementele RP (daca exista in document)
  4. Adaugat meta charset="UTF-8" in head (buna practica EPUB3)
  5. DOCTYPE pe linie separata de XML declaration (fix vizual Saxon)
  6. Acelasi fix tokenize aplicat si la <title> din fisierele capitol
-->
 <xsl:output method="xhtml" indent="yes" encoding="UTF-8" include-content-type="no"/>
 <xsl:template match="/">

  <!-- ============================================================ -->
  <!-- NAV.XHTML                                                    -->
  <!-- ============================================================ -->
  <xsl:variable name="groupInfo">
   <xsl:for-each-group select="livre/corps/*" group-starting-with="h1 | Journal">
    <group
     pos="{format-number(position(), '00')}"
     is-front="{not(self::h1 or self::Journal)}"/>
   </xsl:for-each-group>
  </xsl:variable>
  <xsl:result-document href="nav.xhtml" method="xhtml" encoding="UTF-8" indent="yes" include-content-type="no">
   <xsl:text disable-output-escaping="yes">&#10;&lt;!DOCTYPE html&gt;&#10;</xsl:text>
   <html xmlns="http://www.w3.org/1999/xhtml" xmlns:epub="http://www.idpf.org/2007/ops"
    lang="fr-FR" xml:lang="fr-FR">
    <head>
     <title>Table des mati&#232;res</title>
     <link href="../Styles/styles.css" rel="stylesheet" type="text/css"/>
    </head>
    <body>

     <!-- NAV 1: TOC - obligatoriu EPUB3 -->
     <nav epub:type="toc" id="toc" role="doc-toc" aria-label="Table des mati&#232;res">
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
            <xsl:variable name="rawTitle">
             <xsl:apply-templates select="." mode="getText"/>
            </xsl:variable>
            <!-- FIX: '#' este separator intre titlu si autor/subtitlu in XML sursa.
                 Pastram doar primul segment. Fallback la textul complet daca primul segment e gol. -->
            <xsl:variable name="firstSegment" select="normalize-space(tokenize(normalize-space($rawTitle), '#')[1])"/>
            <xsl:value-of select="if ($firstSegment != '') then $firstSegment else normalize-space($rawTitle)"/>
           </xsl:otherwise>
          </xsl:choose>
         </a>
        </li>
       </xsl:for-each-group>
      </ol>
     </nav>

     <!-- NAV 2: LANDMARKS - obligatoriu EPUB Accessibility 1.1 -->
     <nav epub:type="landmarks" id="landmarks" hidden="" aria-label="Landmarks">
      <h2>Landmarks</h2>
      <ol>
       <xsl:for-each select="$groupInfo/*[@is-front='true'][1]">
        <li><a epub:type="frontmatter" href="chap_{@pos}_intro.xhtml">D&#233;but</a></li>
       </xsl:for-each>
       <xsl:for-each select="$groupInfo/*[@is-front='false'][1]">
        <li><a epub:type="bodymatter" href="chap_{@pos}_chapitre.xhtml">Contenu principal</a></li>
       </xsl:for-each>
       <li><a epub:type="toc" href="nav.xhtml#toc">Table des mati&#232;res</a></li>
      </ol>
     </nav>

     <!-- NAV 3: PAGE-LIST - generat dinamic din RP, inclus doar daca exista in document -->
     <xsl:if test="//RP">
      <nav epub:type="page-list" id="page-list" hidden="" role="doc-pagelist" aria-label="Liste des pages">
       <h2>Liste des pages</h2>
       <ol>
        <xsl:for-each-group select="livre/corps/*" group-starting-with="h1 | Journal">
         <xsl:variable name="pos" select="format-number(position(), '00')"/>
         <xsl:variable name="is-front" select="not(self::h1 or self::Journal)"/>
         <xsl:variable name="file-name"
          select="concat('chap_', $pos, '_', if ($is-front) then 'intro' else 'chapitre', '.xhtml')"/>
         <xsl:for-each select="current-group()//RP">
          <li>
           <a href="{$file-name}#page{@page}">
            <xsl:value-of select="@page"/>
           </a>
          </li>
         </xsl:for-each>
        </xsl:for-each-group>
       </ol>
      </nav>
     </xsl:if>

    </body>
   </html>
  </xsl:result-document>

  <!-- ============================================================ -->
  <!-- FISIERE CAPITOL                                              -->
  <!-- ============================================================ -->
  <xsl:for-each-group select="livre/corps/*" group-starting-with="h1 | Journal">
   <xsl:variable name="pos" select="format-number(position(), '00')"/>
   <xsl:variable name="is-front" select="not(self::h1 or self::Journal)"/>
   <xsl:variable name="file-name" select="concat('chap_', $pos, '_', if ($is-front) then 'intro' else 'chapitre', '.xhtml')"/>
   <xsl:result-document href="{$file-name}" method="xhtml" encoding="UTF-8" indent="yes" include-content-type="no">
    <xsl:text disable-output-escaping="yes">&#10;&lt;!DOCTYPE html&gt;&#10;</xsl:text>
    <html xmlns="http://www.w3.org/1999/xhtml" xmlns:epub="http://www.idpf.org/2007/ops"
     lang="fr-FR" xml:lang="fr-FR">
     <head>
      <meta charset="UTF-8"/>
      <title>
       <xsl:choose>
        <xsl:when test="not($is-front)">
         <xsl:variable name="rawTitle">
          <xsl:apply-templates select="." mode="getText"/>
         </xsl:variable>
         <!-- Acelasi fix tokenize pentru <title> din pagina -->
         <xsl:variable name="firstSegment" select="normalize-space(tokenize(normalize-space($rawTitle), '#')[1])"/>
         <xsl:value-of select="if ($firstSegment != '') then $firstSegment else normalize-space($rawTitle)"/>
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

 <!-- ============================================================ -->
 <!-- TEMPLATE-URI MODE getText                                    -->
 <!-- ============================================================ -->
 <xsl:template match="br" mode="getText">
  <xsl:text> </xsl:text>
 </xsl:template>
 <xsl:template match="RP | span[@class = 'nchap']" mode="getText"/>
 <xsl:template match="*" mode="getText">
  <xsl:apply-templates mode="getText"/>
 </xsl:template>

 <!-- ============================================================ -->
 <!-- TEMPLATE-URI CONTINUT (neschimbate)                         -->
 <!-- ============================================================ -->
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
  <i><xsl:apply-templates/></i>
 </xsl:template>
 <xsl:template match="b">
  <b><xsl:apply-templates/></b>
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
