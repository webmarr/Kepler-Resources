<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [
  <!ENTITY nbsp    "&#160;">
  <!ENTITY thinsp  "&#8201;">
  <!ENTITY rsquo   "&#8217;">
  <!ENTITY laquo   "&#171;">
  <!ENTITY raquo   "&#187;">
  <!ENTITY ldquo   "&#8220;">
  <!ENTITY rdquo   "&#8221;">
  <!ENTITY ndash   "&#8211;">
  <!ENTITY mdash   "&#8212;">
  <!ENTITY hellip  "&#8230;">
  <!ENTITY lsquo   "&#8216;">
]>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:xs="http://www.w3.org/2001/XMLSchema" 
 xmlns:epub="http://www.idpf.org/2007/ops"
 xmlns="http://www.w3.org/1999/xhtml"
 exclude-result-prefixes="xs epub" version="3.0">
 
 <xsl:character-map name="spaces-only">
  <xsl:output-character character="&#160;"  string="&amp;#160;"/>
  <xsl:output-character character="&#8201;" string="&amp;#x2009;"/>
 </xsl:character-map>
 
 <xsl:output method="xhtml" indent="yes" use-character-maps="spaces-only" include-content-type="no"/>
 
 <xsl:variable name="bookTitle" select="/livre/ident/tit"/>
 
 <xsl:template match="/livre">
  
  <xsl:result-document href="cover.xhtml">
   <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html&gt;&#10;</xsl:text>
   <html xmlns="http://www.w3.org/1999/xhtml" lang="fr-FR" xml:lang="fr-FR" xmlns:epub="http://www.idpf.org/2007/ops">
    <head>
     <title><xsl:value-of select="$bookTitle"/></title>
     <link href="../Styles/styles.css" rel="stylesheet" type="text/css"/>
    </head>
    <body epub:type="cover" class="bodypp">
     <section epub:type="cover" class="sectionpp">
      <img src="../Images/cover.jpg" alt="Couverture" class="imagepp"/>
     </section>
    </body>
   </html>
  </xsl:result-document>
  
  <xsl:result-document href="chap_01_titlePage.xhtml">
   <xsl:call-template name="document-structure">
    <xsl:with-param name="title-value" select="$bookTitle"/><xsl:with-param name="body-type" select="'frontmatter'"/>
    <xsl:with-param name="content">
     <section class="titlepage" epub:type="titlepage" role="doc-titlepage">
      <xsl:apply-templates select="ident/ftit | ident/auteur | ident/tit | ident/edit"/>
     </section>
    </xsl:with-param>
   </xsl:call-template>
  </xsl:result-document>
  
  <xsl:result-document href="chap_02_copyright.xhtml">
   <xsl:call-template name="document-structure">
    <xsl:with-param name="title-value" select="'Copyright'"/><xsl:with-param name="body-type" select="'frontmatter'"/>
    <xsl:with-param name="content">
     <section class="copyright" epub:type="copyright-page" role="doc-copyright">
      <xsl:apply-templates select="ident/info | ident/copy | ident/ean | ident/coned"/>
     </section>
    </xsl:with-param>
   </xsl:call-template>
  </xsl:result-document>
  
  <xsl:for-each select="ident/dedi">
   <xsl:result-document href="chap_03_dedi_{format-number(position(), '00')}.xhtml">
    <xsl:call-template name="document-structure">
     <xsl:with-param name="title-value" select="''"/><xsl:with-param name="body-type" select="'frontmatter'"/>
     <xsl:with-param name="content"><section epub:type="dedication" role="doc-dedication"><xsl:apply-templates select="."/></section></xsl:with-param>
    </xsl:call-template>
   </xsl:result-document>
  </xsl:for-each>
  
  <xsl:for-each select="ident/exer">
   <xsl:result-document href="chap_03_exer_{format-number(position(), '00')}.xhtml">
    <xsl:call-template name="document-structure">
     <xsl:with-param name="title-value" select="''"/><xsl:with-param name="body-type" select="'frontmatter'"/>
     <xsl:with-param name="content"><section epub:type="epigraph" role="doc-epigraph"><xsl:apply-templates select="."/></section></xsl:with-param>
    </xsl:call-template>
   </xsl:result-document>
  </xsl:for-each>
  
  <xsl:for-each select="//part">
   <xsl:variable name="pPos" select="format-number(position(), '00')"/>
   <xsl:result-document href="chap_04_part_{$pPos}.xhtml">
    <xsl:call-template name="document-structure">
     <xsl:with-param name="title-value" select="tit"/><xsl:with-param name="body-type" select="'bodymatter'"/>
     <xsl:with-param name="content"><section class="part" role="doc-part"><xsl:apply-templates select="tit"/></section></xsl:with-param>
    </xsl:call-template>
   </xsl:result-document>
   
   <xsl:for-each select="chap">
    <xsl:variable name="cPos" select="format-number(position(), '00')"/>
    <xsl:result-document href="chap_04_part_{$pPos}_chap_{$cPos}.xhtml">
     <xsl:call-template name="document-structure">
      <xsl:with-param name="title-value" select="if(.//n or .//tit) then (.//n | .//tit) else $bookTitle"/>
      <xsl:with-param name="body-type" select="'bodymatter'"/>
      <xsl:with-param name="content">
       <section class="chapter" role="doc-chapter" id="{@id}">
        <xsl:apply-templates select="node() except defnotes"/>
       </section>
       <xsl:apply-templates select="defnotes"/>
      </xsl:with-param>
     </xsl:call-template>
    </xsl:result-document>
   </xsl:for-each>
  </xsl:for-each>
  
  <xsl:for-each select="//appen">
   <xsl:result-document href="chap_05_appen_{format-number(position(), '00')}.xhtml">
    <xsl:call-template name="document-structure">
     <xsl:with-param name="title-value" select="tit"/><xsl:with-param name="body-type" select="'backmatter'"/>
     <xsl:with-param name="content">
      <section class="appendix" role="doc-appendix">
       <xsl:apply-templates select="node() except defnotes"/>
      </section>
      <xsl:apply-templates select="defnotes"/>
     </xsl:with-param>
    </xsl:call-template>
   </xsl:result-document>
  </xsl:for-each>
  
  <xsl:for-each select="//collec">
   <xsl:result-document href="chap_06_collec_{format-number(position(), '00')}.xhtml">
    <xsl:call-template name="document-structure">
     <xsl:with-param name="title-value" select="tit"/><xsl:with-param name="body-type" select="'backmatter'"/>
     <xsl:with-param name="content"><section class="collec"><xsl:apply-templates/></section></xsl:with-param>
    </xsl:call-template>
   </xsl:result-document>
  </xsl:for-each>
 </xsl:template>
 
 <xsl:template name="document-structure">
  <xsl:param name="title-value"/><xsl:param name="body-type"/><xsl:param name="content"/>
  <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html&gt;&#10;</xsl:text>
  <html xmlns="http://www.w3.org/1999/xhtml" xmlns:epub="http://www.idpf.org/2007/ops" xml:lang="fr-FR" lang="fr-FR">
   <head><title><xsl:value-of select="$title-value"/></title><link href="../Styles/styles.css" rel="stylesheet" type="text/css"/></head>
   <body epub:type="{$body-type}"><xsl:sequence select="$content"/></body>
  </html>
 </xsl:template>
 
 <xsl:template match="apnb">
  <xsl:variable name="num" select="count(preceding::apnb) + 1"/>
  <sup class="noteref">
   <a epub:type="noteref" role="doc-noteref" href="#{@id}" id="back-{@id}">
    <xsl:value-of select="$num"/>
   </a>
  </sup>
 </xsl:template>
 
 <xsl:template match="ntb">
  <aside epub:type="footnote" role="doc-footnote" id="{@id}">
   <div class="footnote-content">
    <xsl:apply-templates select="p"/>
   </div>
  </aside>
 </xsl:template>
 
 <xsl:template match="ntb/p">
  <xsl:variable name="num" select="count(../preceding::ntb) + 1"/>
  <p>
   <xsl:variable name="cls" select="normalize-space(concat(if(@align) then concat('align-', @align) else '', ' ', if(@retrait) then concat('retrait-', @retrait) else ''))"/>
   <xsl:if test="$cls != ''"><xsl:attribute name="class" select="$cls"/></xsl:if>
   
   <a href="#back-{../@id}" role="doc-backlink" epub:type="backlink" class="footnote-number">
    <xsl:value-of select="$num"/>    
   </a>
   <xsl:text>. </xsl:text>
   <xsl:apply-templates/>
  </p>
 </xsl:template>
 
 <xsl:template match="ident/tit | part/tit | appen/tit | collec/tit"><h1><xsl:apply-templates/></h1></xsl:template>
 <xsl:template match="chap/n"><h2><xsl:apply-templates/></h2></xsl:template>
 <xsl:template match="cint"><h3><xsl:apply-templates/></h3></xsl:template>
 <xsl:template match="p">
  <p>
   <xsl:variable name="cls" select="normalize-space(concat(if(@align) then concat('align-', @align) else '', ' ', if(@retrait) then concat('retrait-', @retrait) else ''))"/>
   <xsl:if test="$cls != ''"><xsl:attribute name="class" select="$cls"/></xsl:if>
   <xsl:apply-templates/>
  </p>
 </xsl:template>
 <xsl:template match="auteur"><p class="auteur"><xsl:apply-templates/></p></xsl:template>
 <xsl:template match="ident/ftit | ident/edit | ident/info | ident/copy | ident/ean | ident/coned"><p class="{local-name()}"><xsl:apply-templates/></p></xsl:template>
 <xsl:template match="dedi | exer | dev"><div><xsl:apply-templates/></div></xsl:template>
 <xsl:template match="img"><img class="width100" src="../Images/{@src}" alt="{@src}"/></xsl:template>
 <xsl:template match="rp"><span epub:type="pagebreak" role="doc-pagebreak" id="page{@folio}" title="{@folio}"></span></xsl:template>
 <xsl:template match="pc"><span class="pc"><xsl:apply-templates/></span></xsl:template>
 <xsl:template match="i"><i><xsl:apply-templates/></i></xsl:template>
 <xsl:template match="b"><b><xsl:apply-templates/></b></xsl:template>
 <xsl:template match="sup"><sup><xsl:apply-templates/></sup></xsl:template>
 <xsl:template match="sub | inf"><sub><xsl:apply-templates/></sub></xsl:template>
 <xsl:template match="br"><br/></xsl:template>
 <xsl:template match="bl"><div class="space-v{@v}" aria-hidden="true">&#160;</div></xsl:template>
 <xsl:template match="text()"><xsl:value-of select="."/></xsl:template>
 
</xsl:stylesheet>
