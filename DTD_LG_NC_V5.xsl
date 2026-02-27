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
 xmlns:xs="http://www.w3.org/2001/XMLSchema" 
 xmlns:epub="http://www.idpf.org/2007/ops"
 xmlns="http://www.w3.org/1999/xhtml"
 exclude-result-prefixes="xs" version="3.0">
 
 <xsl:character-map name="spaces-only">
  <xsl:output-character character="&#160;"  string="&amp;#160;"/>
  <xsl:output-character character="&#8201;" string="&amp;#x2009;"/>
 </xsl:character-map>
 
 <xsl:output method="xhtml" indent="yes" use-character-maps="spaces-only" include-content-type="no"/>
 
 <xsl:variable name="bookTitle" select="/livre/ident/tit"/>
 
 <xsl:template match="/livre">
  <xsl:result-document href="cover.xhtml">
   <xsl:call-template name="document-structure">
    <xsl:with-param name="title-value" select="'Couverture'"/><xsl:with-param name="body-type" select="'cover'"/>
    <xsl:with-param name="content">
     <section epub:type="cover" class="sectionpp"><img src="../Images/cover.jpg" alt="Couverture" class="imagepp"/></section>
    </xsl:with-param>
   </xsl:call-template>
  </xsl:result-document>
  
  <xsl:result-document href="chap_01_titlePage.xhtml">
   <xsl:call-template name="document-structure">
    <xsl:with-param name="title-value" select="'Page de titre'"/><xsl:with-param name="body-type" select="'frontmatter'"/>
    <xsl:with-param name="content">
     <section class="titlepage" epub:type="titlepage"><xsl:apply-templates select="ident/ftit | ident/auteur | ident/tit | ident/edit"/></section>
    </xsl:with-param>
   </xsl:call-template>
  </xsl:result-document>
  
  <xsl:result-document href="chap_02_copyright.xhtml">
   <xsl:call-template name="document-structure">
    <xsl:with-param name="title-value" select="'Copyright'"/><xsl:with-param name="body-type" select="'frontmatter'"/>
    <xsl:with-param name="content">
     <section class="copyright" epub:type="copyright-page" role="doc-chapter"><xsl:apply-templates select="ident/info | ident/copy | ident/ean | ident/coned"/></section>
    </xsl:with-param>
   </xsl:call-template>
  </xsl:result-document>
  
  <xsl:for-each select="ident/dedi">
   <xsl:result-document href="chap_03_dedi_{format-number(position(), '00')}.xhtml">
    <xsl:call-template name="document-structure">
     <xsl:with-param name="title-value" select="'Dedication'"/><xsl:with-param name="body-type" select="'frontmatter'"/>
     <xsl:with-param name="content"><section epub:type="dedication" role="doc-dedication"><div class="dedicace"><xsl:apply-templates select="."/></div></section></xsl:with-param>
    </xsl:call-template>
   </xsl:result-document>
  </xsl:for-each>
  
  <xsl:for-each select="ident/exer">
   <xsl:result-document href="chap_03_exer_{format-number(position(), '00')}.xhtml">
    <xsl:call-template name="document-structure">
     <xsl:with-param name="title-value" select="'Exergue'"/><xsl:with-param name="body-type" select="'frontmatter'"/>
     <xsl:with-param name="content"><section epub:type="epigraph" role="doc-epigraph"><div class="exergue"><xsl:apply-templates select="."/></div></section></xsl:with-param>
    </xsl:call-template>
   </xsl:result-document>
  </xsl:for-each>
  
  <xsl:for-each select="//part">
   <xsl:variable name="pPos" select="format-number(position(), '00')"/>
   <xsl:result-document href="chap_04_part_{$pPos}.xhtml">
    <xsl:call-template name="document-structure">
     <xsl:with-param name="title-value" select="tit"/><xsl:with-param name="body-type" select="'bodymatter'"/>
     <xsl:with-param name="content"><section class="part" role="doc-part"><h1><xsl:apply-templates select="tit/node()"/></h1></section></xsl:with-param>
    </xsl:call-template>
   </xsl:result-document>
   <xsl:for-each select="chap">
    <xsl:result-document href="chap_04_part_{$pPos}_chap_{format-number(position(), '00')}.xhtml">
     <xsl:call-template name="document-structure">
      <xsl:with-param name="title-value" select="if(n or tit) then (n | tit)[1] else $bookTitle"/><xsl:with-param name="body-type" select="'bodymatter'"/>
      <xsl:with-param name="content"><xsl:call-template name="render-chapter"/></xsl:with-param>
     </xsl:call-template>
    </xsl:result-document>
   </xsl:for-each>
  </xsl:for-each>
  
  <xsl:for-each select="//chap[not(ancestor::part)]">
   <xsl:result-document href="chap_04_part_c_{format-number(position(), '00')}.xhtml">
    <xsl:call-template name="document-structure">
     <xsl:with-param name="title-value" select="if(n or tit) then (n | tit)[1] else $bookTitle"/><xsl:with-param name="body-type" select="'bodymatter'"/>
     <xsl:with-param name="content"><xsl:call-template name="render-chapter"/></xsl:with-param>
    </xsl:call-template>
   </xsl:result-document>
  </xsl:for-each>
  
  <xsl:for-each select="//appen">
   <xsl:result-document href="chap_05_appen_{format-number(position(), '00')}.xhtml">
    <xsl:call-template name="document-structure">
     <xsl:with-param name="title-value" select="'Appendice'"/><xsl:with-param name="body-type" select="'backmatter'"/>
     <xsl:with-param name="content">
      <section class="appendix" role="doc-appendix">
       <xsl:choose>
        <xsl:when test="n and tit">
         <h1 class="appen_n"><xsl:apply-templates select="n/node()"/></h1>
         <h2 class="appen_tit"><xsl:apply-templates select="tit/node()"/></h2>
         <xsl:apply-templates select="node() except (n | tit | defnotes)"><xsl:with-param name="next-h-level" select="3"/></xsl:apply-templates>
        </xsl:when>
        <xsl:otherwise>
         <h1 class="appen_tit"><xsl:apply-templates select="(n | tit)/node()"/></h1>
         <xsl:apply-templates select="node() except (n | tit | defnotes)"><xsl:with-param name="next-h-level" select="2"/></xsl:apply-templates>
        </xsl:otherwise>
       </xsl:choose>
      </section>
      <xsl:apply-templates select="defnotes"/>
     </xsl:with-param>
    </xsl:call-template>
   </xsl:result-document>
  </xsl:for-each>
  
  <xsl:for-each select="//collec">
   <xsl:result-document href="chap_06_collec_{format-number(position(), '00')}.xhtml">
    <xsl:call-template name="document-structure">
     <xsl:with-param name="title-value" select="'Collection'"/><xsl:with-param name="body-type" select="'backmatter'"/>
     <xsl:with-param name="content">
      <section class="collec" epub:type="colloquium" role="doc-bibliography">
       <xsl:if test="tit"><h1 class="collec"><xsl:apply-templates select="tit/node()"/></h1></xsl:if>
       <xsl:apply-templates select="node() except tit"/>
      </section>
     </xsl:with-param>
    </xsl:call-template>
   </xsl:result-document>
  </xsl:for-each>
 </xsl:template>
 
 <xsl:template name="render-chapter">
  <section class="chapter" role="doc-chapter" id="{@id}">
   <xsl:choose>
    <xsl:when test="n and tit">
     <h1 class="chap_n"><xsl:apply-templates select="n/node()"/></h1>
     <h2 class="chap_tit"><xsl:apply-templates select="tit/node()"/></h2>
     <xsl:apply-templates select="node() except (n | tit | defnotes)"><xsl:with-param name="next-h-level" select="3"/></xsl:apply-templates>
    </xsl:when>
    <xsl:when test="n or tit">
     <h1 class="{if(n) then 'chap_n' else 'chap_tit'}"><xsl:apply-templates select="(n | tit)/node()"/></h1>
     <xsl:apply-templates select="node() except (n | tit | defnotes)"><xsl:with-param name="next-h-level" select="2"/></xsl:apply-templates>
    </xsl:when>
    <xsl:otherwise>
     <div class="chap_sanstitre">
      <xsl:apply-templates select="node() except defnotes"><xsl:with-param name="next-h-level" select="1"/></xsl:apply-templates>
     </div>
    </xsl:otherwise>
   </xsl:choose>
  </section>
  <xsl:apply-templates select="defnotes"/>
 </xsl:template>
 
 <xsl:template match="dev | dedi | exer">
  <xsl:param name="next-h-level" select="1"/>
  <xsl:apply-templates><xsl:with-param name="next-h-level" select="$next-h-level"/></xsl:apply-templates>
 </xsl:template>
 
 <xsl:template match="niv1 | niv2 | niv3 | niv4">
  <xsl:param name="next-h-level" select="1"/>
  <div class="{local-name()}" id="{@id}">
   <xsl:apply-templates><xsl:with-param name="next-h-level" select="$next-h-level"/></xsl:apply-templates>
  </div>
 </xsl:template>
 
 <xsl:template match="niv1/niv2 | niv2/niv3 | niv3/niv4" priority="2">
  <xsl:param name="next-h-level" select="1"/>
  <div class="{local-name()}" id="{@id}">
   <xsl:apply-templates><xsl:with-param name="next-h-level" select="$next-h-level + 1"/></xsl:apply-templates>
  </div>
 </xsl:template>
 
 <xsl:template match="int">
  <xsl:param name="next-h-level" select="1"/>
  <xsl:element name="h{$next-h-level}">
   <xsl:attribute name="class">intertitre</xsl:attribute>
   <xsl:apply-templates/>
  </xsl:element>
 </xsl:template>
 
 <xsl:template match="pc"><span class="pc"><xsl:apply-templates/></span></xsl:template>
 <xsl:template match="i"><i><xsl:apply-templates/></i></xsl:template>
 <xsl:template match="b"><b><xsl:apply-templates/></b></xsl:template>
 <xsl:template match="sup"><sup><xsl:apply-templates/></sup></xsl:template>
 <xsl:template match="sub | inf"><sub><xsl:apply-templates/></sub></xsl:template>
 <xsl:template match="br"><br/></xsl:template>
 <xsl:template match="text()"><xsl:value-of select="."/></xsl:template>
 
 <xsl:template match="p">
  <p><xsl:variable name="cls" select="normalize-space(concat(if(@align) then concat('align-', @align) else '', ' ', if(@retrait) then concat('retrait-', @retrait) else ''))"/>
   <xsl:if test="$cls != ''"><xsl:attribute name="class" select="$cls"/></xsl:if><xsl:apply-templates/></p>
 </xsl:template>
 
 <xsl:template match="stroplg"><div class="stroplg"><xsl:apply-templates/></div></xsl:template>
 <xsl:template match="verslg"><p class="verslg"><xsl:apply-templates/></p></xsl:template>
 <xsl:template match="bl"><div class="space-v{@v}" aria-hidden="true">&#160;</div></xsl:template>
 <xsl:template match="rp"><span epub:type="pagebreak" role="doc-pagebreak" id="page{@folio}" title="{@folio}"></span></xsl:template>
 
 <xsl:template match="apnb">
  <sup class="noteref"><a epub:type="noteref" role="doc-noteref" href="#{@id}" id="back-{@id}"><xsl:value-of select="count(preceding::apnb) + 1"/></a></sup>
 </xsl:template>
 <xsl:template match="ntb">
  <aside epub:type="footnote" role="doc-footnote" id="{@id}"><div class="footnote-content"><xsl:apply-templates select="p"/></div></aside>
 </xsl:template>
 <xsl:template match="ntb/p">
  <p><a href="#back-{../@id}" class="footnote-number"><xsl:value-of select="count(../preceding::ntb) + 1"/></a>. <xsl:apply-templates/></p>
 </xsl:template>
 <xsl:template match="defnotes"><section epub:type="footnotes" role="doc-endnotes" class="footnotes"><xsl:apply-templates/></section></xsl:template>
 
 <xsl:template name="document-structure">
  <xsl:param name="title-value"/><xsl:param name="body-type"/><xsl:param name="content"/>
  <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html&gt;&#10;</xsl:text>
  <html xmlns="http://www.w3.org/1999/xhtml" xmlns:epub="http://www.idpf.org/2007/ops" xml:lang="fr-FR" lang="fr-FR">
   <head><title><xsl:value-of select="$title-value"/></title><link href="../Styles/styles.css" rel="stylesheet" type="text/css"/></head>
   <body epub:type="{$body-type}" class="body"><xsl:sequence select="$content"/></body>
  </html>
 </xsl:template>

