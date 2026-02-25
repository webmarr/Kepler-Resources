<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [
  <!ENTITY nbsp   "&#160;">
  <!ENTITY thinsp "&#8201;">
  <!ENTITY rsquo  "&#8217;">
  <!ENTITY laquo  "&#171;">
  <!ENTITY raquo  "&#187;">
  <!ENTITY ldquo  "&#8220;">
  <!ENTITY rdquo  "&#8221;">
  <!ENTITY ndash  "&#8211;">
  <!ENTITY mdash  "&#8212;">
  <!ENTITY hellip "&#8230;">
  <!ENTITY lsquo  "&#8216;">
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
    <head>
     <title>Table des matières</title>
     <link href="../Styles/styles.css" rel="stylesheet" type="text/css"/>
    </head>
    <body>
     <nav epub:type="toc" id="toc" role="doc-toc">
      <h1>Table des matières</h1>
      <ol>
       <li><a href="chap_01_titlePage.xhtml"><xsl:value-of select="ident/tit"/></a></li>
       <xsl:for-each select="corps/chap">
        <li><a href="chap_04_chap_{format-number(position(), '00')}.xhtml"><xsl:value-of select="tit"/></a></li>
       </xsl:for-each>
       <xsl:for-each select="//appen">
        <li><a href="chap_05_appen_{format-number(position(), '00')}.xhtml"><xsl:value-of select="tit"/></a></li>
       </xsl:for-each>
       <xsl:for-each select="//collec">
        <li><a href="chap_06_collec_{format-number(position(), '00')}.xhtml"><xsl:value-of select="tit"/></a></li>
       </xsl:for-each>
      </ol>
     </nav>
     <xsl:if test="//rp">
      <nav epub:type="page-list" id="page-list" hidden="hidden">
       <ol>
        <xsl:for-each select="//rp">
         <li><a href="chap_04_chap_{format-number(count(ancestor::chap/preceding-sibling::chap) + 1, '00')}.xhtml#page{@folio}"><xsl:value-of select="@folio"/></a></li>
        </xsl:for-each>
       </ol>
      </nav>
     </xsl:if>
    </body>
   </html>
  </xsl:result-document>
  
  <xsl:result-document href="chap_01_titlePage.xhtml">
   <xsl:call-template name="document-structure">
    <xsl:with-param name="title" select="string(/livre/ident/tit)"/>
    <xsl:with-param name="body-type" select="'frontmatter'"/>
    <xsl:with-param name="content">
     <section class="titlepage" epub:type="titlepage">
      <xsl:apply-templates select="ident/auteur | ident/tit | ident/edit"/>
     </section>
    </xsl:with-param>
   </xsl:call-template>
  </xsl:result-document>
  
  <xsl:result-document href="chap_02_copyright.xhtml">
   <xsl:call-template name="document-structure">
    <xsl:with-param name="title" select="string(/livre/ident/tit)"/>
    <xsl:with-param name="body-type" select="'frontmatter'"/>
    <xsl:with-param name="content">
     <section epub:type="chapter" role="doc-chapter">
      <xsl:apply-templates select="ident/info | ident/copy | ident/ean | ident/coned"/>
     </section>
    </xsl:with-param>
   </xsl:call-template>
  </xsl:result-document>
  
  <xsl:for-each select="//exer">
   <xsl:result-document href="chap_03_exergue_{format-number(position(), '00')}.xhtml">
    <xsl:call-template name="document-structure">
     <xsl:with-param name="title" select="string(/livre/ident/tit)"/>
     <xsl:with-param name="body-type" select="'frontmatter'"/>
     <xsl:with-param name="content">
      <section epub:type="chapter" role="doc-chapter">
       <div class="exer"><xsl:apply-templates/></div>
      </section>
     </xsl:with-param>
    </xsl:call-template>
   </xsl:result-document>
  </xsl:for-each>
  
  <xsl:for-each select="//dedi">
   <xsl:result-document href="chap_03_dedi_{format-number(position(), '00')}.xhtml">
    <xsl:call-template name="document-structure">
     <xsl:with-param name="title" select="string(/livre/ident/tit)"/>
     <xsl:with-param name="body-type" select="'frontmatter'"/>
     <xsl:with-param name="content">
      <section epub:type="chapter" role="doc-chapter">
       <div class="dedi"><xsl:apply-templates/></div>
      </section>
     </xsl:with-param>
    </xsl:call-template>
   </xsl:result-document>
  </xsl:for-each>
  
  <xsl:for-each select="corps/chap">
   <xsl:result-document href="chap_04_chap_{format-number(position(), '00')}.xhtml">
    <xsl:call-template name="document-structure">
     <xsl:with-param name="title" select="string(/livre/ident/tit)"/>
     <xsl:with-param name="body-type" select="'bodymatter'"/>
     <xsl:with-param name="content">
      <section class="chapter" id="{@id}" epub:type="chapter" role="doc-chapter">
       <xsl:apply-templates select="node() except tit"/>
      </section>
     </xsl:with-param>
    </xsl:call-template>
   </xsl:result-document>
  </xsl:for-each>
  
  <xsl:for-each select="//appen">
   <xsl:result-document href="chap_05_appen_{format-number(position(), '00')}.xhtml">
    <xsl:call-template name="document-structure">
     <xsl:with-param name="title" select="string(/livre/ident/tit)"/>
     <xsl:with-param name="body-type" select="'bodymatter'"/>
     <xsl:with-param name="content">
      <section epub:type="chapter" role="doc-chapter">
       <div class="appen"><xsl:apply-templates/></div>
      </section>
     </xsl:with-param>
    </xsl:call-template>
   </xsl:result-document>
  </xsl:for-each>
  
  <xsl:for-each select="//collec">
   <xsl:result-document href="chap_06_collec_{format-number(position(), '00')}.xhtml">
    <xsl:call-template name="document-structure">
     <xsl:with-param name="title" select="string(/livre/ident/tit)"/>
     <xsl:with-param name="body-type" select="'backmatter'"/>
     <xsl:with-param name="content">
      <section epub:type="chapter" role="doc-chapter">
       <div class="collec"><xsl:apply-templates/></div>
      </section>
     </xsl:with-param>
    </xsl:call-template>
   </xsl:result-document>
  </xsl:for-each>
 </xsl:template>
 
 <xsl:template name="document-structure">
  <xsl:param name="title"/>
  <xsl:param name="body-type"/>
  <xsl:param name="content"/>
  <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html&gt;&#10;</xsl:text>
  <xsl:text disable-output-escaping="yes">&lt;html xmlns="http://www.w3.org/1999/xhtml" xmlns:epub="http://www.idpf.org/2007/ops" xmlns:xml="http://www.w3.org/XML/1998/namespace" lang="fr-FR" xml:lang="fr-FR"&gt;&#10;</xsl:text>
  <xsl:text disable-output-escaping="yes">&lt;head&gt;&#10;</xsl:text>
  <xsl:text disable-output-escaping="yes">&lt;title&gt;</xsl:text>
  <xsl:value-of select="$title"/>
  <xsl:text disable-output-escaping="yes">&lt;/title&gt;&#10;</xsl:text>
  <xsl:text disable-output-escaping="yes">&lt;link href="../Styles/styles.css" rel="stylesheet" type="text/css"/&gt;&#10;</xsl:text>
  <xsl:text disable-output-escaping="yes">&lt;/head&gt;&#10;</xsl:text>
  <xsl:text disable-output-escaping="yes">&lt;body epub:type="</xsl:text>
  <xsl:value-of select="$body-type"/>
  <xsl:text disable-output-escaping="yes">"&gt;&#10;</xsl:text>
  <xsl:sequence select="$content"/>
  <xsl:text disable-output-escaping="yes">&lt;/body&gt;&#10;</xsl:text>
  <xsl:text disable-output-escaping="yes">&lt;/html&gt;</xsl:text>
 </xsl:template>
 
 <xsl:template match="p">
  <p>
   <xsl:variable name="cls" select="normalize-space(concat(if(@align) then concat('align-', @align) else '', ' ', if(@retrait) then concat('retrait-', @retrait) else ''))"/>
   <xsl:if test="$cls != ''">
    <xsl:attribute name="class" select="$cls"/>
   </xsl:if>
   <xsl:apply-templates/>
  </p>
 </xsl:template>
 
 <xsl:template match="*">
  <xsl:element name="{local-name()}" namespace="http://www.w3.org/1999/xhtml">
   <xsl:apply-templates select="@*|node()"/>
  </xsl:element>
 </xsl:template>
 
 <xsl:template match="@*">
  <xsl:attribute name="{name()}"><xsl:value-of select="."/></xsl:attribute>
 </xsl:template>
 
 <xsl:template match="@epub:*">
  <xsl:attribute name="epub:{local-name()}" namespace="http://www.idpf.org/2007/ops">
   <xsl:value-of select="."/>
  </xsl:attribute>
 </xsl:template>
 
 <xsl:template match="ident/tit"><h1><xsl:apply-templates/></h1></xsl:template>
 <xsl:template match="collec/tit"><h1><xsl:apply-templates/></h1></xsl:template>
 <xsl:template match="collec/cint"><h2><xsl:apply-templates/></h2></xsl:template>
 <xsl:template match="appen/tit"><h1><xsl:apply-templates/></h1></xsl:template>
 <xsl:template match="auteur"><p class="author"><xsl:apply-templates/></p></xsl:template>
 <xsl:template match="pc"><span class="pc"><xsl:apply-templates/></span></xsl:template>
 <xsl:template match="i"><i><xsl:apply-templates/></i></xsl:template>
 <xsl:template match="b"><b><xsl:apply-templates/></b></xsl:template>
 <xsl:template match="sup"><sup><xsl:apply-templates/></sup></xsl:template>
 <xsl:template match="sub"><sub><xsl:apply-templates/></sub></xsl:template>
 <xsl:template match="inf"><sub><xsl:apply-templates/></sub></xsl:template>
 <xsl:template match="sl"><span class="Underline"><xsl:apply-templates/></span></xsl:template>
 <xsl:template match="url">
  <a href="{@cible}">
   <xsl:apply-templates/>
  </a>
 </xsl:template>
 <xsl:template match="br"><br/></xsl:template>
 
 <xsl:template match="bl">
  <div class="space-v{@v}" aria-hidden="true">&#160;</div>
 </xsl:template>
 
 <xsl:template match="dev">
  <div><xsl:apply-templates/></div>
 </xsl:template>
 <xsl:template match="info">
  <p class="info"><xsl:apply-templates/></p>
 </xsl:template>
 <xsl:template match="edit">
  <p class="edit"><xsl:apply-templates/></p>
 </xsl:template>
 <xsl:template match="copy">
  <p class="copy"><xsl:apply-templates/></p>
 </xsl:template>
 <xsl:template match="ean">
  <p class="ean"><xsl:apply-templates/></p>
 </xsl:template>
 <xsl:template match="coned">
  <p class="coned"><xsl:apply-templates/></p>
 </xsl:template>
 <xsl:template match="rp">
  <span id="page{@folio}" epub:type="pagebreak" role="doc-pagebreak" title="{@folio}"></span>
 </xsl:template>
 
 <xsl:template match="text()">
  <xsl:value-of select="."/>
 </xsl:template>
 
</xsl:stylesheet>