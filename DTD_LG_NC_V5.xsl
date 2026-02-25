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
 xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:epub="http://www.idpf.org/2007/ops"
 exclude-result-prefixes="xs epub" version="3.0">
 
 <xsl:character-map name="spaces-only">
  <xsl:output-character character="&#160;"  string="&amp;#160;"/>
  <xsl:output-character character="&#8201;" string="&amp;#x2009;"/>
 </xsl:character-map>
 
 <xsl:output method="xhtml" indent="yes" use-character-maps="spaces-only" include-content-type="no"/>
 
 <xsl:template match="/livre">
  <xsl:result-document href="nav.xhtml">
   <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html&gt;&#10;</xsl:text>
   <html xmlns="http://www.w3.org/1999/xhtml" xmlns:epub="http://www.idpf.org/2007/ops" lang="fr-FR" xml:lang="fr-FR">
    <head><title>Table des matières</title></head>
    <body>
     <nav epub:type="toc" id="toc" role="doc-toc">
      <h1>Table des matières</h1>
      <ol>
       <li><a href="chap_01_titlePage.xhtml"><xsl:value-of select="ident/tit"/></a></li>
       <xsl:for-each select="//part">
        <xsl:variable name="pPos" select="format-number(position(), '00')"/>
        <li>
         <a href="chap_04_part_{$pPos}.xhtml"><xsl:value-of select="tit"/></a>
         <ol>
          <xsl:for-each select="chap">
           <li><a href="chap_04_part_{$pPos}_chap_{format-number(position(), '00')}.xhtml"><xsl:value-of select=".//n | .//tit"/></a></li>
          </xsl:for-each>
         </ol>
        </li>
       </xsl:for-each>
      </ol>
     </nav>
     <xsl:if test="//rp">
      <nav epub:type="page-list" id="page-list" hidden="hidden">
       <ol>
        <xsl:for-each select="//rp">
         <xsl:variable name="p" select="format-number(count(ancestor::part/preceding-sibling::part) + 1, '00')"/>
         <xsl:variable name="c" select="format-number(count(ancestor::chap/preceding-sibling::chap) + 1, '00')"/>
         <li><a href="chap_04_part_{$p}_chap_{$c}.xhtml#page{@folio}"><xsl:value-of select="@folio"/></a></li>
        </xsl:for-each>
       </ol>
      </nav>
     </xsl:if>
    </body>
   </html>
  </xsl:result-document>
  
  <xsl:result-document href="chap_01_titlePage.xhtml">
   <xsl:call-template name="document-structure">
    <xsl:with-param name="title-value" select="ident/tit"/>
    <xsl:with-param name="body-type" select="'frontmatter'"/>
    <xsl:with-param name="content">
     <section class="titlepage" epub:type="titlepage" role="doc-titlepage">
      <xsl:apply-templates select="ident/ftit"/>
      <xsl:apply-templates select="ident/auteur"/>
      <xsl:apply-templates select="ident/tit"/>
      <xsl:apply-templates select="ident/edit"/>
     </section>
    </xsl:with-param>
   </xsl:call-template>
  </xsl:result-document>
  
  <xsl:result-document href="chap_02_copyright.xhtml">
   <xsl:call-template name="document-structure">
    <xsl:with-param name="title-value" select="'Copyright'"/>
    <xsl:with-param name="body-type" select="'frontmatter'"/>
    <xsl:with-param name="content">
     <section class="copyright" epub:type="copyright" role="doc-copyright">
      <xsl:apply-templates select="ident/info"/>
      <xsl:apply-templates select="ident/copy"/>
      <xsl:apply-templates select="ident/ean"/>
      <xsl:apply-templates select="ident/coned"/>
     </section>
    </xsl:with-param>
   </xsl:call-template>
  </xsl:result-document>
  
  <xsl:for-each select="//part">
   <xsl:variable name="pPos" select="format-number(position(), '00')"/>
   <xsl:result-document href="chap_04_part_{$pPos}.xhtml">
    <xsl:call-template name="document-structure">
     <xsl:with-param name="title-value" select="tit"/>
     <xsl:with-param name="body-type" select="'bodymatter'"/>
     <xsl:with-param name="content">
      <section class="part" epub:type="part" role="doc-part" id="{@id}">
       <xsl:apply-templates select="tit"/>
      </section>
     </xsl:with-param>
    </xsl:call-template>
   </xsl:result-document>
   
   <xsl:for-each select="chap">
    <xsl:variable name="cPos" select="format-number(position(), '00')"/>
    <xsl:result-document href="chap_04_part_{$pPos}_chap_{$cPos}.xhtml">
     <xsl:call-template name="document-structure">
      <xsl:with-param name="title-value" select=".//n | .//tit"/>
      <xsl:with-param name="body-type" select="'bodymatter'"/>
      <xsl:with-param name="content">
       <section class="chapter" epub:type="chapter" role="doc-chapter" id="{@id}">
        <xsl:apply-templates/>
       </section>
      </xsl:with-param>
     </xsl:call-template>
    </xsl:result-document>
   </xsl:for-each>
  </xsl:for-each>
 </xsl:template>
 
 <xsl:template name="document-structure">
  <xsl:param name="title-value"/><xsl:param name="body-type"/><xsl:param name="content"/>
  <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html&gt;&#10;</xsl:text>
  <html xmlns="http://www.w3.org/1999/xhtml" xmlns:epub="http://www.idpf.org/2007/ops" xml:lang="fr-FR" lang="fr-FR">
   <head>
    <title><xsl:value-of select="$title-value"/></title>
    <link href="../Styles/styles.css" rel="stylesheet" type="text/css"/>
   </head>
   <body epub:type="{$body-type}"><xsl:sequence select="$content"/></body>
  </html>
 </xsl:template>
 
 <xsl:template match="apnb">
  <xsl:variable name="num" select="count(preceding::apnb) + 1"/>
  <sup class="noteref"><a epub:type="noteref" role="doc-noteref" href="#{@id}" id="back-{@id}"><xsl:value-of select="$num"/></a></sup>
 </xsl:template>
 
 <xsl:template match="defnotes"><section epub:type="footnotes" role="doc-footnotes" class="footnotes"><xsl:apply-templates/></section></xsl:template>
 
 <xsl:template match="ntb">
  <xsl:variable name="num" select="count(preceding::ntb) + 1"/>
  <aside epub:type="footnote" role="doc-footnote" id="{@id}">
   <p><a href="#back-{@id}" role="doc-backlink" epub:type="backlink" class="footnote-number"><xsl:value-of select="$num"/>. </a><xsl:apply-templates/></p>
  </aside>
 </xsl:template>
 
 <xsl:template match="ident/ftit"><p class="faux-titre"><xsl:apply-templates/></p></xsl:template>
 <xsl:template match="ident/auteur"><p class="auteur"><xsl:apply-templates/></p></xsl:template>
 <xsl:template match="ident/tit | part/tit"><h1><xsl:apply-templates/></h1></xsl:template>
 <xsl:template match="chap/n"><h2><xsl:apply-templates/></h2></xsl:template>
 <xsl:template match="cint"><h3><xsl:apply-templates/></h3></xsl:template>
 <xsl:template match="dedi"><div class="dedicace"><xsl:apply-templates/></div></xsl:template>
 <xsl:template match="exer"><div class="exergue"><xsl:apply-templates/></div></xsl:template>
 <xsl:template match="info"><p class="info"><xsl:apply-templates/></p></xsl:template>
 <xsl:template match="edit"><p class="edit"><xsl:apply-templates/></p></xsl:template>
 <xsl:template match="copy"><p class="copy"><xsl:apply-templates/></p></xsl:template>
 <xsl:template match="ean"><p class="ean"><xsl:apply-templates/></p></xsl:template>
 <xsl:template match="coned"><p class="coned"><xsl:apply-templates/></p></xsl:template>
 <xsl:template match="dev"><div><xsl:apply-templates/></div></xsl:template>
 
 <xsl:template match="p">
  <p>
   <xsl:variable name="cls" select="normalize-space(concat(if(@align) then concat('align-', @align) else '', ' ', if(@retrait) then concat('retrait-', @retrait) else ''))"/>
   <xsl:if test="$cls != ''"><xsl:attribute name="class" select="$cls"/></xsl:if>
   <xsl:apply-templates/>
  </p>
 </xsl:template>
 
 <xsl:template match="img"><figure><img class="width100" src="../Images/{@src}" alt="{@src}"/></figure></xsl:template>
 <xsl:template match="rp"><span epub:type="pagebreak" role="doc-pagebreak" id="page{@folio}" title="{@folio}"></span></xsl:template>
 <xsl:template match="pc"><span class="small-caps"><xsl:apply-templates/></span></xsl:template>
 <xsl:template match="i"><i><xsl:apply-templates/></i></xsl:template>
 <xsl:template match="b"><b><xsl:apply-templates/></b></xsl:template>
 <xsl:template match="sup"><sup><xsl:apply-templates/></sup></xsl:template>
 <xsl:template match="sub | inf"><sub><xsl:apply-templates/></sub></xsl:template>
 <xsl:template match="br"><br/></xsl:template>
 <xsl:template match="bl"><div class="space-v{@v}" aria-hidden="true">&#160;</div></xsl:template>
 <xsl:template match="text()"><xsl:value-of select="."/></xsl:template>
 
</xsl:stylesheet>
