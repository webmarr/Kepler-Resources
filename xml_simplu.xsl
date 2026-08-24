<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:epub="http://www.idpf.org/2007/ops"
 xmlns:local="urn:local-functions"
 xmlns="http://www.w3.org/1999/xhtml" exclude-result-prefixes="xs local" version="3.0">

 <xsl:template match="node()|@*" name="identity">
  <xsl:choose>
   <xsl:when test="self::*">
    <xsl:element name="{local-name()}">
     <xsl:apply-templates select="@*|node()"/>
    </xsl:element>
   </xsl:when>
   <xsl:otherwise>
    <xsl:copy>
     <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
   </xsl:otherwise>
  </xsl:choose>
 </xsl:template>

 <xsl:output method="xhtml" indent="yes" encoding="UTF-8" include-content-type="no"/>
 <xsl:variable name="existaNchap" select="exists(//h2[@class='nchap'])"/>
 <xsl:variable name="allNotes" select="//defnotes/p[@class='ntb']"/>

 <!-- ==========================================================
      FIX 1: grupare corectă chiar și când h1/Journal/h2.nchap
      sunt îngropate într-un div (nu copii direcți ai corps)
      ========================================================== -->

 <!-- returnează elementul de titlu real (h1/Journal/h2.nchap),
      fie el însuși $item, fie un descendent-fiu direct al lui $item -->
 <xsl:function name="local:heading-node" as="element()?">
  <xsl:param name="item" as="element()"/>
  <xsl:sequence select="
   if ($item[self::h1 or self::Journal or self::h2[@class='nchap']])
   then $item
   else ($item/(h1 | Journal | h2[@class='nchap']))[1]"/>
 </xsl:function>

 <xsl:function name="local:is-chapter-start" as="xs:boolean">
  <xsl:param name="item" as="element()"/>
  <xsl:sequence select="exists(local:heading-node($item))"/>
 </xsl:function>

 <!-- ==========================================================
      FIX 2: hartă pagină -> fișier, pentru rescrierea linkurilor
      de index de tip href="#pageNNN" după spargerea în fișiere
      ========================================================== -->
 <xsl:variable name="pageToFile">
  <xsl:for-each-group select="livre/corps/*"
   group-starting-with="h1 | Journal | h2[@class='nchap'] | *[h1 or Journal or h2[@class='nchap']]">
   <xsl:variable name="pos" select="format-number(position(), '00')"/>
   <xsl:variable name="is-front" select="not(local:is-chapter-start(.))"/>
   <xsl:variable name="file-name" select="concat('chap_', $pos, '_', if ($is-front) then 'intro' else 'chapitre', '.xhtml')"/>
   <xsl:for-each select="current-group()//RP | current-group()//span[starts-with(@id,'page')]">
    <xsl:variable name="pid" select="if (self::RP) then @page else substring-after(@id,'page')"/>
    <page xmlns="" num="{$pid}" file="{$file-name}"/>
   </xsl:for-each>
  </xsl:for-each-group>
 </xsl:variable>

 <xsl:key name="page-file-key" match="page" use="@num"/>

 <xsl:template match="/">

  <xsl:variable name="groupInfo">
   <xsl:for-each-group select="livre/corps/*"
    group-starting-with="h1 | Journal | h2[@class='nchap'] | *[h1 or Journal or h2[@class='nchap']]">
    <group
     pos="{format-number(position(), '00')}"
     is-front="{not(local:is-chapter-start(.))}"/>
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

     <nav epub:type="toc" id="toc" role="doc-toc" aria-label="Table des mati&#232;res">
      <h1>Table des mati&#232;res</h1>
      <ol>
       <xsl:for-each-group select="livre/corps/*"
        group-starting-with="h1 | Journal | h2[@class='nchap'] | *[h1 or Journal or h2[@class='nchap']]">
        <xsl:variable name="pos" select="format-number(position(), '00')"/>
        <xsl:variable name="is-front" select="not(local:is-chapter-start(.))"/>
        <li>
         <a href="chap_{$pos}_{if ($is-front) then 'intro' else 'chapitre'}.xhtml">
          <xsl:choose>
           <xsl:when test="$is-front">Introduction</xsl:when>
           <xsl:otherwise>
            <xsl:variable name="rawTitle">
             <xsl:apply-templates select="local:heading-node(.)" mode="getText"/>
            </xsl:variable>
            <xsl:variable name="firstSegment" select="normalize-space(tokenize(normalize-space($rawTitle), '#')[1])"/>
            <xsl:value-of select="if ($firstSegment != '') then $firstSegment else normalize-space($rawTitle)"/>
           </xsl:otherwise>
          </xsl:choose>
         </a>
        </li>
       </xsl:for-each-group>
      </ol>
     </nav>

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

     <xsl:if test="//RP">
      <nav epub:type="page-list" id="page-list" hidden="" role="doc-pagelist" aria-label="Liste des pages">
       <h2>Liste des pages</h2>
       <ol>
        <xsl:for-each-group select="livre/corps/*"
         group-starting-with="h1 | Journal | h2[@class='nchap'] | *[h1 or Journal or h2[@class='nchap']]">
         <xsl:variable name="pos" select="format-number(position(), '00')"/>
         <xsl:variable name="is-front" select="not(local:is-chapter-start(.))"/>
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
  
  <xsl:result-document href="cover.xhtml" method="xhtml" encoding="UTF-8" indent="yes" include-content-type="no">
   <xsl:text disable-output-escaping="yes">&#10;&lt;!DOCTYPE html&gt;&#10;</xsl:text>
   <html xmlns="http://www.w3.org/1999/xhtml" xmlns:epub="http://www.idpf.org/2007/ops">
    <head>
     <meta http-equiv="default-style" content="text/html; charset=utf-8"/>
     <title><xsl:value-of select="$cover-title"/></title>
     <link href="../Styles/magnard_vuibert_couverture.css" rel="stylesheet" type="text/css"/>
    </head>
    <body epub:type="cover">
     <section epub:type="cover">
      <h1 class="noprint">Couverture</h1>
      <div class="couverture">
       <a id="cover">
        <img alt="{$cover-alt}" class="img" src="../Images/cover.jpg"/>
       </a>
      </div>
     </section>
    </body>
   </html>
  </xsl:result-document>
  
  <xsl:for-each-group select="livre/corps/*"
   group-starting-with="h1 | Journal | h2[@class='nchap'] | *[h1 or Journal or h2[@class='nchap']]">
   <xsl:variable name="pos" select="format-number(position(), '00')"/>
   <xsl:variable name="is-front" select="not(local:is-chapter-start(.))"/>
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
          <xsl:apply-templates select="local:heading-node(.)" mode="getText"/>
         </xsl:variable>
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
       <section class="footnotes" epub:type="footnotes">
        <xsl:variable name="citedNoteIDs" select="current-group()//a[span[@class='apnb']]/substring-after(@href, 'N')"/>
        <xsl:apply-templates select="//defnotes/p[@class='ntb'][substring-after(a[1]/@id, 'N') = $citedNoteIDs]"/>
       </section>
      </section>
     </body>
    </html>
   </xsl:result-document>
  </xsl:for-each-group>

 </xsl:template>

 <xsl:template match="a[@id and not(node()) and following-sibling::node()[1][self::a[span[@class='apnb']]]]"/>

 <xsl:template match="a[span[@class='apnb']]">
  <xsl:variable name="n" select="replace(@href, '\D', '')"/> 
  <a class="_idFootnoteLink antsp" epub:type="noteref" role="doc-noteref" href="#footnote-{$n}" id="AN{$n}">
   <sup>
    <span class="note">
     <xsl:value-of select="$n"/>
    </span>
   </sup>
  </a>
 </xsl:template>

 <xsl:template match="p[@class='ntb']">
  <xsl:variable name="n" select="replace(a[1]/@id, '\D', '')"/>
  <aside id="footnote-{$n}" epub:type="footnote" role="doc-footnote">
   <p class="footnote-text">
    <a href="#AN{$n}"><xsl:value-of select="$n"/>.</a>
    <xsl:text>&#160;</xsl:text>
    <xsl:apply-templates select="node()[not(self::a)]"/>
   </p>
  </aside>
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
  <i><xsl:apply-templates/></i>
 </xsl:template>

 <xsl:template match="b">
  <b><xsl:apply-templates/></b>
 </xsl:template>

 <xsl:template match="span">
  <xsl:choose>
   <xsl:when test="@class">
    <span>
     <xsl:attribute name="class" select="@class"/>
     <xsl:apply-templates/>
    </span>
   </xsl:when>
   <xsl:otherwise>
    <xsl:apply-templates/>
   </xsl:otherwise>
  </xsl:choose>
 </xsl:template>
 <xsl:template match="br">
  <br/>
 </xsl:template>

 <xsl:template match="RP">
  <span epub:type="pagebreak" role="doc-pagebreak" id="page{@page}" title="{@page}"/>
 </xsl:template>

 <!-- marcaje de pagină deja prezente în sursă ca <span id="pageXXX" title="XXX"/>
      (ex. pagini din front-matter numerotate cu cifre romane: pageIII, pageIV...) -->
 <xsl:template match="span[starts-with(@id,'page')]">
  <span epub:type="pagebreak" role="doc-pagebreak" id="{@id}">
   <xsl:if test="@title">
    <xsl:attribute name="title" select="@title"/>
   </xsl:if>
   <xsl:apply-templates/>
  </span>
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

 <xsl:template match="h2[@class='nchap']">
  <h1 class="nchap">
   <xsl:apply-templates/>
  </h1>
 </xsl:template>

 <xsl:template match="p[@type='Etoile']">
  <p class="sep_etoile">&#160;<xsl:apply-templates/></p>
 </xsl:template>

 <xsl:template match="h2" priority="10">
  <xsl:element name="{if ($existaNchap) then 'h1' else 'h2'}">
   <xsl:if test="@class='nchap'"><xsl:attribute name="class">nchap</xsl:attribute></xsl:if>
   <xsl:apply-templates/>
  </xsl:element>
 </xsl:template>
 
 <xsl:template match="h3" priority="10">
  <xsl:element name="{if ($existaNchap) then 'h2' else 'h3'}">
   <xsl:copy-of select="@*"/>
   <xsl:apply-templates/>
  </xsl:element>
 </xsl:template>
 
 <xsl:template match="h4" priority="10">
  <xsl:element name="{if ($existaNchap) then 'h3' else 'h4'}">
   <xsl:copy-of select="@*"/>
   <xsl:apply-templates/>
  </xsl:element>
 </xsl:template>
 
 <xsl:template match="h5" priority="10">
  <xsl:element name="{if ($existaNchap) then 'h4' else 'h5'}">
   <xsl:copy-of select="@*"/>
   <xsl:apply-templates/>
  </xsl:element>
 </xsl:template>

 <xsl:template match="img">
  <xsl:element name="img">
   <xsl:apply-templates select="@*"/>
   <xsl:if test="not(@alt) or normalize-space(@alt)=''">
    <xsl:attribute name="alt" select="replace(tokenize(@src,'/')[last()], '\.[^.]+$', '')"/>
   </xsl:if>
   <xsl:apply-templates/>
  </xsl:element>
 </xsl:template>

 <!-- FIX 3: rescrie linkurile de index href="#pageNNN" către
      fișierul corect rezultat din spargere -->
 <xsl:template match="a[starts-with(@href,'#page')]">
  <xsl:variable name="pageNum" select="substring-after(@href,'#page')"/>
  <xsl:variable name="targetFile" select="key('page-file-key', $pageNum, $pageToFile)/@file"/>
  <a>
   <xsl:attribute name="href" select="if ($targetFile != '') then concat($targetFile, '#page', $pageNum) else @href"/>
   <xsl:apply-templates select="@*[not(local-name()='href')]|node()"/>
  </a>
 </xsl:template>

 <xsl:template match="text()[not(ancestor::a)]">
  <xsl:analyze-string select="." regex="(https?://|www\.)[^\s]+">
   <xsl:matching-substring>
    <xsl:variable name="link-complet" select="."/>
    <xsl:variable name="punct-final" select="if (matches($link-complet, '[.,;!?]$')) then substring($link-complet, string-length($link-complet)) else ''"/>
    <xsl:variable name="link-curat" select="if ($punct-final != '') then substring($link-complet, 1, string-length($link-complet) - 1) else $link-complet"/>
    <xsl:variable name="href-final">
     <xsl:choose>
      <xsl:when test="starts-with($link-curat, 'www.')">
       <xsl:value-of select="concat('http://', $link-curat)"/>
      </xsl:when>
      <xsl:otherwise>
       <xsl:value-of select="$link-curat"/>
      </xsl:otherwise>
     </xsl:choose>
    </xsl:variable>
    <a href="{$href-final}">
     <xsl:value-of select="$link-curat"/>
    </a>
    <xsl:value-of select="$punct-final"/>
   </xsl:matching-substring>
   <xsl:non-matching-substring>
    <xsl:value-of select="."/>
   </xsl:non-matching-substring>
  </xsl:analyze-string>
 </xsl:template>
</xsl:stylesheet>
