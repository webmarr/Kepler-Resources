<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:epub="http://www.idpf.org/2007/ops"
 exclude-result-prefixes="xs" version="2.0">
	<xsl:output method="xhtml" indent="no"/>

	<!--COPY ALL TAGS FROM INITIAL XML = INDENTITY TRANSFORM-->
	<xsl:template match="node()|@*" name="identity">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>
 <xsl:param name="arrayRenvlnk" select="//rp/@folio"/>
 <xsl:param name="idRenv" select="//renv/@id"/>
 <xsl:template match="renv">
  <xsl:for-each select=".">
   <xsl:variable name="idRenv_utilizat" select="./@id"/>
   <xsl:variable name="htmlFile" select="//rp[@folio = $idRenv_utilizat]/ancestor::*/@id"/>
   <a href="../Text/{$htmlFile}.xhtml#{$idRenv_utilizat}"><xsl:value-of select="."/></a> 
  </xsl:for-each>
 </xsl:template>
	<xsl:template match="//processing-instruction('epub')">
		<xsl:variable name="Page_number" select="replace(.,'page=','')"></xsl:variable>
		<xsl:variable name="Page_number" select="translate($Page_number,'&#34;','')"></xsl:variable>
		<a id="p{$Page_number}"/>
	</xsl:template>
 <xsl:variable name="bookTitle" select="LIVRE/INFO/TITRE"/>
<!-- <xsl:variable name="fullTitle" select="concat(normalize-space(//NUMERO), ' ', normalize-space(//TITRE))"/>-->
	<!--IGNORE SPECIFIC TAGS-->
	<xsl:template match="tableau/table/tgroup/tbody">
		<xsl:apply-templates/>
	</xsl:template>
 <xsl:template match="DEV">
  <xsl:apply-templates/>
 </xsl:template>
	<xsl:template match="livre/corps/part/chap">
	</xsl:template>
	<xsl:template match="livre/corps/part/chap/schap">
	</xsl:template>
	<xsl:template match="tableau/table/tgroup/tbody/@valign">
	</xsl:template>
	<xsl:template match="tableau/table/tgroup/colspec">
</xsl:template>
	<xsl:template match="tableau/table/tgroup/thead">
		<xsl:apply-templates/>
	</xsl:template>
	<xsl:template match="/">
		<xsl:apply-templates/>
	</xsl:template>
	<xsl:template match="LIVRE">
		<xsl:apply-templates/>
	</xsl:template>
	<xsl:template match="INFO">
	</xsl:template>
	
	<!--TREAT IDENT FROM XML-->
	<!--<xsl:template match="ident">
		<div class="ident" id="{@id}">
			<xsl:apply-templates/>
		</div>
	</xsl:template>
	<xsl:template match="ident/tit">
		<h1 class="ident_titre">
			<xsl:apply-templates/>
		</h1>
	</xsl:template>
	<xsl:template match="ident/edit">
			<xsl:apply-templates/>
	</xsl:template>
	<xsl:template match="ident/auteur">
		<h1 class="ident_auteur">
			<xsl:apply-templates/>
		</h1>
	</xsl:template>-->
	
	<!--TREAT PART/CHAP FROM XML-->
	<xsl:template match="part">
		<div class="part" id="{@id}">
			<xsl:apply-templates/>
		</div>
	</xsl:template>
	<xsl:template match="part/n">
		<h1 class="part_num">
			<xsl:apply-templates/>
		</h1>
	</xsl:template>
	<xsl:template match="part/tit">
		<h1 class="part_titre">
			<xsl:apply-templates/>
		</h1>
	</xsl:template>
	<xsl:template match="part/dev">
		<div class="dev_part">
			<xsl:apply-templates/>
		</div>
	</xsl:template>
	<xsl:template match="part/dev/p">
		<p class="para_part">
			<xsl:apply-templates/>
		</p>
	</xsl:template>
	<xsl:template match="LIVRE/CORPS/CHAPITRE">
					<div class="chap" id="{@id}">
						<xsl:apply-templates/>
					</div>
	</xsl:template>
 <xsl:template match="NUMERO">
  <h1>
   <span class="chapterNumber">
    <xsl:value-of select="normalize-space(text())"/>
   </span>
   <br/>
   <span class="chaterTitle">
    <xsl:apply-templates select="following-sibling::TITRE[1]/node()"/>
   </span>
  </h1>
 </xsl:template>
 
 <xsl:template match="TITRE"/>
 <xsl:template match="INTERTITRE">
  <xsl:element name="h{@niveau + 1}">
   <xsl:attribute name="id">
    <xsl:value-of select="@id"/>
   </xsl:attribute>
   
   <xsl:apply-templates select="node()"/>
  </xsl:element>
 </xsl:template>
	<xsl:template match="chap/stit">
		<h1 class="chap_stitre">
			<xsl:apply-templates/>
		</h1>
	</xsl:template>
	<xsl:template match="//pbib">
		<p class="biblio">
			<xsl:apply-templates/>
		</p>
	</xsl:template>
	<xsl:template match="schap">
		<div class="schap" id="{@id}">
			<xsl:apply-templates/>
		</div>
	</xsl:template>
	<xsl:template match="schap/n" name="schapterNumber">
		<h1 class="schap_num">
			<xsl:apply-templates/>
		</h1>
	</xsl:template>
	<xsl:template match="schap/tit">
		<h1 class="schap_titre">
			<xsl:apply-templates/>
		</h1>
	</xsl:template>
	<xsl:template match="schap/stit">
		<h1 class="schap_stitre">
			<xsl:apply-templates/>
		</h1>
	</xsl:template>
	<!--TREAT PRE FROM XML-->
	<xsl:template match="pre">
		<div class="pre" id="{@id}">
			<xsl:apply-templates/>
		</div>
	</xsl:template>
	<xsl:template match="pre/n" name="preNumber">
		<h1 class="chap_num">
			<xsl:apply-templates/>
		</h1>
	</xsl:template>
	<xsl:template match="pre/tit">
		<h1 class="chap_titre">
			<xsl:apply-templates/>
		</h1>
	</xsl:template>
	<xsl:template match="pre/stit">
		<h1 class="chap_stitre">
			<xsl:apply-templates/>
		</h1>
	</xsl:template>
	<xsl:template match="pre/dev">
		<div class="pre-interieur">
			<xsl:apply-templates/>
		</div>
	</xsl:template>
	<xsl:template match="pre/dev/p">
		<p class="para">
			<xsl:apply-templates/>
		</p>
	</xsl:template>
	<xsl:template match="list[@type='autre']">
		<div class="autre">
			<xsl:apply-templates/>
		</div>
	</xsl:template>
	<xsl:template match="list[@type='none']">
		<div class="listnone">
			<xsl:apply-templates/>
		</div>
	</xsl:template>
	<xsl:template match="list/item/p">
		<p class="para"><xsl:apply-templates/></p>
	</xsl:template>
	<xsl:template match="list/item"><xsl:apply-templates/></xsl:template>
	<xsl:template match="list[@type='puce']">
		<div class="listpuce">
			<xsl:apply-templates/>
		</div>
	</xsl:template>
	<xsl:template match="list/item/p">
		<p class="para"><xsl:apply-templates/></p>
	</xsl:template>
	<xsl:template match="list/item"><xsl:apply-templates/></xsl:template>	
	<xsl:template match="list[@type='tiret']">
		<div class="listtiret">
			<xsl:apply-templates/>
		</div>
	</xsl:template>
	<xsl:template match="list/item/p">
		<p class="para"><xsl:apply-templates/></p>
	</xsl:template>
	<xsl:template match="list/item"><xsl:apply-templates/></xsl:template>
	<!--TREAT APPENDIX FROM XML-->
	<xsl:template match="appen">
		<div class="appendix" id="{@id}">
			<xsl:apply-templates/>
		</div>
	</xsl:template>
	<xsl:template match="appen/n" name="appenNumber">
		<h1 class="chap_num">
			<xsl:apply-templates/>
		</h1>
	</xsl:template>
	<xsl:template match="appen/tit">
		<h1 class="chap_titre">
			<xsl:apply-templates/>
		</h1>
	</xsl:template>
	<xsl:template match="appen/stit">
		<h1 class="chap_stitre">
			<xsl:apply-templates/>
		</h1>
	</xsl:template>
	<xsl:template match="appen/dev">
		<div class="appen">
			<xsl:apply-templates/>
		</div>
	</xsl:template>
	<xsl:template match="appen/dev/p">
		<p class="appen">
			<xsl:apply-templates/>
		</p>
	</xsl:template>
	<xsl:template match="appen[@type='conclusion']">
		<div class="conclusion" id="{@id}">
			<xsl:apply-templates/>
		</div>
	</xsl:template>
	<xsl:template match="appen[@type='conclusion']/n" name="conclusionNumber">
		<h1 class="chap_num">
			<xsl:apply-templates/>
		</h1>
	</xsl:template>
	<xsl:template match="appen[@type='conclusion']/tit">
		<h1 class="chap_titre">
			<xsl:apply-templates/>
		</h1>
	</xsl:template>
	<xsl:template match="appen[@type='conclusion']/stit">
		<h1 class="chap_stitre">
			<xsl:apply-templates/>
		</h1>
	</xsl:template>
	<xsl:template match="appen[@type='conclusion']/dev">
		<div class="appen">
			<xsl:apply-templates/>
		</div>
	</xsl:template>
	<xsl:template match="appen[@type='conclusion']/dev/p">
		<p class="para">
			<xsl:apply-templates/>
		</p>
	</xsl:template>
	<xsl:template match="appen[@type='postface']">
		<div class="postface" id="{@id}">
			<xsl:apply-templates/>
		</div>
	</xsl:template>
	<xsl:template match="appen[@type='postface']/n" name="postfaceNumber">
		<h1 class="chap_num">
			<xsl:apply-templates/>
		</h1>
	</xsl:template>
	<xsl:template match="appen[@type='postface']/tit">
		<h1 class="chap_titre">
			<xsl:apply-templates/>
		</h1>
	</xsl:template>
	<xsl:template match="appen[@type='postface']/stit">
		<h1 class="chap_stitre">
			<xsl:apply-templates/>
		</h1>
	</xsl:template>
	<xsl:template match="appen[@type='postface']/stit">
		<h2 class="chap_stitre">
			<xsl:apply-templates/>
		</h2>
	</xsl:template>
	<xsl:template match="appen[@type='postface']/dev">
		<div class="appen">
			<xsl:apply-templates/>
		</div>
	</xsl:template>
	<xsl:template match="appen[@type='postface']/dev/p">
		<p class="para">
			<xsl:apply-templates/>
		</p>
	</xsl:template>
	<xsl:template match="appen[@type='biblio']">
		<div class="biblio" id="{@id}">
			<xsl:apply-templates/>
		</div>
	</xsl:template>
	<xsl:template match="appen[@type='biblio']/n" name="biblioNumber">
		<h1 class="chap_num">
			<xsl:apply-templates/>
		</h1>
	</xsl:template>
	<xsl:template match="appen[@type='biblio']/tit">
		<h1 class="chap_titre">
			<xsl:apply-templates/>
		</h1>
	</xsl:template>
	<xsl:template match="appen[@type='biblio']/stit">
		<h1 class="chap_stitre">
			<xsl:apply-templates/>
		</h1>
	</xsl:template>
	<xsl:template match="appen[@type='biblio']/dev">
		<div class="appen">
			<xsl:apply-templates/>
		</div>
	</xsl:template>
	<xsl:template match="appen[@type='biblio']/dev/pbib">
		<p class="biblio">
			<xsl:apply-templates/>
		</p>
	</xsl:template>
	<xsl:template match="appen[@type='remer']">
		<div class="remer" id="{@id}">
			<xsl:apply-templates/>
		</div>
	</xsl:template>
	<xsl:template match="appen[@type='remer']/n" name="remerNumber">
		<h1 class="chap_num">
			<xsl:apply-templates/>
		</h1>
	</xsl:template>
	<xsl:template match="appen[@type='remer']/tit">
		<h1 class="chap_titre">
			<xsl:apply-templates/>
		</h1>
	</xsl:template>
	<xsl:template match="appen[@type='remer']/stit">
		<h1 class="chap_stitre">
			<xsl:apply-templates/>
		</h1>
	</xsl:template>
	<xsl:template match="appen[@type='remer']/dev">
		<div class="appen">
			<xsl:apply-templates/>
		</div>
	</xsl:template>
	<xsl:template match="appen[@type='remer']/dev/p">
		<p class="remer">
			<xsl:apply-templates/>
		</p>
	</xsl:template>
	<xsl:template match="enc">
		<xsl:choose>
			<xsl:when test="@type">
				<xsl:variable name="typeEncadre" select="./@type"/>
				<div class="{$typeEncadre}">
					<xsl:apply-templates/>
				</div>
			</xsl:when>
			<xsl:otherwise>
				<div class="enc">
					<xsl:apply-templates/>
				</div>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="enc/dev">
		<div class="dev">
			<xsl:apply-templates/>
		</div>
	</xsl:template>
	<xsl:template match="enc/tit">
		<h3 class="encadre">
			<xsl:apply-templates/>
		</h3>
	</xsl:template>
	<xsl:template match="exer">
		<div class="exergue">
			<xsl:apply-templates/>
		</div>
	</xsl:template>
	<xsl:template match="exer/p">
		<p class="p_exergue">
			<xsl:apply-templates/>
		</p>
	</xsl:template>
	<xsl:template match="exer/source">
		<p class="p_source_exergue">
			<xsl:apply-templates/>
		</p>
	</xsl:template>
	<xsl:template match="exer/auteur">
		<p class="p_auteur_exergue">
			<xsl:apply-templates/>
		</p>
	</xsl:template>
	<xsl:template match="tableau/source">
		<p class="para source">
			<xsl:apply-templates/>
		</p>
	</xsl:template>
	<!--TREAT CURRENT TEXT FROM XML-->
	<xsl:template match="br">
		<br/>
		<xsl:apply-templates/>
	</xsl:template>
	<xsl:template match="chap/dev">
		<div class="dev">
		<xsl:apply-templates/>
		</div>
	</xsl:template>
	<xsl:template match="chap/dev/p">
		<p class="para">
			<xsl:apply-templates/>
		</p>
	</xsl:template>
	<xsl:template match="schap/dev">
		<div class="dev">
			<xsl:apply-templates/>
		</div>
	</xsl:template>
	<xsl:template match="schap/dev/p">
		<p class="para">
			<xsl:apply-templates/>
		</p>
	</xsl:template>
	<xsl:template match="P">
		<p>
			<xsl:apply-templates/>
		</p>
	</xsl:template>
	<xsl:template match="ITAL" name="makeItalic">
		<i>
			<xsl:apply-templates/>
		</i>
	</xsl:template>
 <xsl:template match="SOUL" name="makeunderline">
		<span class="underline">
			<xsl:apply-templates/>
		</span>
	</xsl:template>
 <xsl:template match="GRAS" name="makeBold">
		<b>
			<xsl:apply-templates/>
		</b>
	</xsl:template>
 <xsl:template match="IND" name="makeSub">
		<sub>
			<xsl:apply-templates/>
		</sub>
	</xsl:template>
	<xsl:template match="inf" name="makeInf">
		<sub>
			<xsl:apply-templates/>
		</sub>
	</xsl:template>
 <xsl:template match="EXP" name="makeSup">
		<sup>
			<xsl:apply-templates/>
		</sup>
	</xsl:template>
 <xsl:template match="PCAP">
  <span class="smallcaps">
   <xsl:value-of select="."/>
		</span>
	</xsl:template>
	<xsl:template match="rp" name="makeRP">
		<a id="{@folio}">
			<xsl:apply-templates/>
		</a>
	</xsl:template>
	<!--<xsl:template match="renvlnk" name="makeRenv">
		<a href="{@id}">
			<xsl:apply-templates/>
			<xsl:call-template name="makeRP"></xsl:call-template>
		</a>
	</xsl:template>-->
 <xsl:template match="CITATION">
		<div class="citation">
				<xsl:apply-templates/>
		</div>
	</xsl:template>
 <xsl:template match="RP">
  <span id="page_{@folio}" 
   class="page" 
   title="{@folio}" 
   epub:type="pagebreak" 
   role="doc-pagebreak">
  </span>
 </xsl:template>
 <xsl:template match="INDEX">
  <a class="sigil_index_marker">
   <xsl:attribute name="title">
    <xsl:value-of select="@niv1"/>
   </xsl:attribute>
   
   <xsl:attribute name="id">
    <xsl:value-of select="concat('sigil_index_id_', generate-id(.))"/>
   </xsl:attribute>
   
   <xsl:value-of select="@niv1"/>
  </a>
 </xsl:template>
 <xsl:template match="APPNOTEB">
  <xsl:variable name="noteNum" select="count(preceding::APPNOTEB) + 1"/>
  
  <xsl:variable name="formattedNum" select="format-number($noteNum, '000')"/>
  
  <span class="apnb">
   <span>
    <a id="footnote-{$formattedNum}-backlink" 
     class="_idFootnoteLink _idGenColorInherit" 
     role="doc-noteref" 
     epub:type="noteref" 
     href="#footnote-{$formattedNum}">
     <xsl:value-of select="$noteNum"/>
    </a>
   </span>
  </span>
 </xsl:template>
 <xsl:template match="APPNOTEB" mode="footnote-area">
  <xsl:variable name="noteNum" select="count(preceding::APPNOTEB) + 1"/>
  <xsl:variable name="formattedNum" select="format-number($noteNum, '000')"/>
  
  <aside id="footnote-{$formattedNum}" epub:type="footnote">
   <p class="footnote-text">
    <a href="#footnote-{$formattedNum}-backlink"><xsl:value-of select="$noteNum"/>.</a>
    <xsl:text>&#160;</xsl:text>
    <xsl:apply-templates select="P/node()"/>
   </p>
  </aside>
 </xsl:template>
	<xsl:template match="apnf">
		<a class="_idFootnoteLink antsp" epub:type="noteref" href="#note{@id}" id="{@id}"><sup><span class="note"><xsl:value-of select="translate(@id,'N','')"/></span></sup></a>
		<xsl:apply-templates/>
	</xsl:template>
	<xsl:template match="defnotes">
		<div class="defnotes">
			<p class="hr_note">&#160;</p>
			<div class="clear"></div>
			<xsl:apply-templates/>
		</div>
	</xsl:template>
	
	<xsl:template match="defnotes/ntb">
		<xsl:variable name="refNote" select="@id" />
		<aside id="note{$refNote}" class="_idFootnote" epub:type="footnote">
		<p class="ntb"><a href="#{$refNote}"><span class="note"><xsl:value-of select="translate($refNote,'N','')"/>.</span></a>&#160;<xsl:copy-of select="defnotes/ntb/p"></xsl:copy-of>
			<xsl:apply-templates/>
		</p>
		</aside>
	</xsl:template>
	<xsl:template match="defnotes/ntf">
		<xsl:variable name="refNote" select="@id" />
		<aside id="note{$refNote}" class="_idFootnote" epub:type="footnote">
		<p class="ntf"><a href="#{$refNote}"><span class="note"><xsl:value-of select="translate($refNote,'N','')"/>.</span></a>&#160;<xsl:copy-of select="defnotes/ntf/p"></xsl:copy-of>
			<xsl:apply-templates/>
		</p>
		</aside>
	</xsl:template>
	<xsl:template match="niv1">
		<div class="niv1">
			<xsl:apply-templates/>
		</div>
	</xsl:template>
	<xsl:template match="niv1/p">
		<p class="para">
			<xsl:apply-templates/>
		</p>
	</xsl:template>
	<xsl:template match="niv2">
		<div class="niv2">
			<xsl:apply-templates/>
		</div>
	</xsl:template>
	<xsl:template match="niv2/p">
		<p class="para">
			<xsl:apply-templates/>
		</p>
	</xsl:template>
	<xsl:template match="niv3">
		<div class="niv3">
			<xsl:apply-templates/>
		</div>
	</xsl:template>
	<xsl:template match="niv3/p">
		<p class="para">
			<xsl:apply-templates/>
		</p>
	</xsl:template>
	<xsl:template match="niv4">
		<div class="niv4">
			<xsl:apply-templates/>
		</div>
	</xsl:template>
	<xsl:template match="niv4/p">
		<p class="para">
			<xsl:apply-templates/>
		</p>
	</xsl:template>
	<xsl:template match="niv1/int">
		<h2>
			<xsl:apply-templates/>
		</h2>
	</xsl:template>
	<xsl:template match="niv2/int">
		<h3>
			<xsl:apply-templates/>
		</h3>
	</xsl:template>
	<xsl:template match="niv3/int">
		<h4>
			<xsl:apply-templates/>
		</h4>
	</xsl:template>
	<xsl:template match="niv4/int">
		<h5>
			<xsl:apply-templates/>
		</h5>
	</xsl:template>
	<xsl:template match="sep[@type='etoile']">
		<p class="sep_etoile">&#160;<xsl:apply-templates/></p>
	</xsl:template>
	
	<!--Tables-->
	<xsl:template match="tableau">
		<div class="tableau" id="{@id}"><xsl:apply-templates/></div>
	</xsl:template>
	<!--<xsl:template match="tableau">
		<div class="tableau" id="{@id}"><xsl:apply-templates/></div>
	</xsl:template>-->
<xsl:template match="table[title]">
	<xsl:apply-templates select="title"></xsl:apply-templates>
	<xsl:copy>
<xsl:apply-templates select="node()[not(self::title)]"></xsl:apply-templates>
</xsl:copy>
</xsl:template>
	<xsl:template match="title">
		<p class="title_table"><xsl:apply-templates/></p>
	</xsl:template>
	
	<!--<xsl:template match="table[@colsep]">
		<table><xsl:apply-templates/></table>
	</xsl:template>
	<xsl:template match="table[@rowsep]">
		<table><xsl:apply-templates/></table>
	</xsl:template>
	<xsl:template match="table[@frame]">
		<table><xsl:apply-templates/></table>
	</xsl:template>-->
	
	
	<!--TABLES FROM XML-->
	<xsl:template match="table">
		<table><xsl:apply-templates/></table>
	</xsl:template>
	<xsl:template match="tgroup">
		<tbody><xsl:apply-templates/></tbody>
	</xsl:template>
	<xsl:template match="row">
		<tr><xsl:apply-templates/></tr>
	</xsl:template>
	<xsl:template match="entry[@nameend]">
		<xsl:variable name="colspan1" select="replace(@namest,'col','')"/>
		<xsl:variable name="colspan2" select="replace(@nameend,'col','')"/>
		<xsl:variable name="colspan" select="number($colspan2)-number($colspan1)+1"/>
		<!--<xsl:variable name="tableColsep" select="table[@colsep]/ancestor::entry"/>
		<xsl:variable name="tableRowsep" select="table[@colsep]/ancestor::entry"/>-->
			<!--<xsl:if test="$tableColsep='1'and $tableRowsep='1'">-->
		<td style="border-top:1px solid;border-right:1px solid;border-bottom:1px solid;border-left:1px solid" colspan="{$colspan}"><xsl:apply-templates/></td>
			<!--</xsl:if>-->
	<!--	<xsl:if test="$tableColsep='1'and $tableRowsep='0'">
			<td style="border-top:0px solid;border-right:1px solid;border-bottom:0px solid;border-left:1px solid"><xsl:apply-templates/></td>
		</xsl:if>-->
	</xsl:template>
	<xsl:template match="entry[@morerows]">
		<xsl:variable name="rowspan" select="number(@morerows)+1"/>
		<td style="border-top:1px solid;border-right:1px solid;border-bottom:1px solid;border-left:1px solid" rowspan="{$rowspan}"><xsl:apply-templates/></td>
	</xsl:template>
	<xsl:template match="entry">
		<td style="border-top:1px solid;border-right:1px solid;border-bottom:1px solid;border-left:1px solid"><xsl:apply-templates/></td>
	</xsl:template>
<!--	<xsl:template match="entry/p">
		<xsl:if test="entry[@align='center']">
			<p class="para" style="text-align:center"><xsl:apply-templates/></p>
			
		</xsl:if>
	</xsl:template>-->
	<xsl:template match="entry/p">
		<p class="para"><xsl:apply-templates/></p>
	</xsl:template>
	<xsl:template match="leg">
		<div class="leg"><xsl:apply-templates/></div>
	</xsl:template>
	<xsl:template match="leg/p">
		<p class="table_legend"><xsl:apply-templates/></p>
	</xsl:template>
	
	<!--TREAT CITATIONS FROM XML-->
	<xsl:template match="cita">
		<div class="citation"><xsl:apply-templates/></div>
	</xsl:template>
	<xsl:template match="cita/p">
		<p class="para"><xsl:apply-templates/></p>
	</xsl:template>
	
	<!--IMAGES-->
	<!--<xsl:variable name="vArray" select="tokenize(//apfi/@id, ' ')"/>-->
	<xsl:template match="apfi">
		<xsl:variable name="apfi" select="@id"/>
		<xsl:variable name="figapfi" select="//fig[@id = $apfi]/img/@src"/>
		<img class="width100" src="../Images/{$figapfi}" alt="{$apfi}"/>
	</xsl:template>
	<!--<xsl:template	match="fig">
		<xsl:if test="index-of($vArray, @id)!=0">
			<xsl:call-template name="identity"></xsl:call-template>
			<div class="fig" id="{@id}"><xsl:apply-templates/></div>
		</xsl:if>
	</xsl:template>-->
	<xsl:param name="testArray" select="//apfi/@id"/>
	<xsl:template match="fig[not(@id = $testArray)]">
		<div class="fig" id="{@id}"><xsl:apply-templates/></div>
	</xsl:template>

	<xsl:template match="fig[@id = $testArray]">
	</xsl:template>
		
	<xsl:template match="fig/img">
		
		<img class="width100" src="../Images/{@src}" alt="{@src}"><xsl:apply-templates/></img>
		
	</xsl:template>
	<xsl:template match="fig/tit">
		<p class="tit_fig">
			<xsl:apply-templates/>
		</p>
	</xsl:template>
	<!--<xsl:template match="renvlnk">
		<a id="{@id}"><xsl:value-of select="."/></a>
	</xsl:template>-->

 
	<!--<xsl:template match="renv">
		<a href="../Text/{@id}.xhtml"><xsl:apply-templates/></a>
	</xsl:template>-->
	<xsl:template match="let">
		<span class="lettrine">
			<xsl:apply-templates/>
		</span>
	</xsl:template>
	<!--<xsl:template match="renv[@id = $arrayRenvlnk]">
		<xsl:variable name="idRenv" select="./@id"/>
		<xsl:variable name="htmlFile" select="//renvlnk[@id=$idRenv]/ancestor::part/@id"/>
		<a href="../Text/{$htmlFile}.xhtml#{$idRenv}"><xsl:value-of select="."/></a>
	</xsl:template>
	<xsl:template match="renv[@id = $arrayRenvlnk]">
		<xsl:variable name="idRenv" select="./@id"/>
		<xsl:variable name="htmlFile" select="//renvlnk[@id=$idRenv]/ancestor::pre/@id"/>
		<a href="../Text/{$htmlFile}.xhtml#{$idRenv}"><xsl:value-of select="."/></a>
	</xsl:template>
	<xsl:template match="renv[@id = $arrayRenvlnk]">
		<xsl:variable name="idRenv" select="./@id"/>
		<xsl:variable name="htmlFile" select="//renvlnk[@id=$idRenv]/ancestor::appen/@id"/>
		<a href="../Text/{$htmlFile}.xhtml#{$idRenv}"><xsl:value-of select="."/></a>
	</xsl:template>-->
	<xsl:template match="ident/exer">
		<div class="exergue">
			<xsl:apply-templates/>
		</div>
	</xsl:template>
	<xsl:template match="ident/exer/p">
		<p class="p_exergue">
			<xsl:apply-templates/>
		</p>
	</xsl:template>
	<xsl:template match="ident/exer/auteur">
		<p class="p_auteur_exergue">
			<xsl:apply-templates/>
		</p>
	</xsl:template>
	<xsl:template match="ident/exer/source">
		<p class="p_source_exergue">
			<xsl:apply-templates/>
		</p>
	</xsl:template>
	<xsl:template match="ident/fig">
		<div class="fig_credits">
			<xsl:apply-templates/>
		</div>
	</xsl:template>
	<xsl:template match="ident/ref">
		<p class="p_ref">
			<xsl:apply-templates/>
		</p>
	</xsl:template>
	<xsl:template match="ident/modulus">
		<p class="p_modulus">
			<xsl:apply-templates/>
		</p>
	</xsl:template>
	<xsl:template match="sign">
		<p class="p_signature">
			<xsl:apply-templates/>
		</p>
	</xsl:template>
 <xsl:template match="COLLECTION">
  <div class="collection {@class}">
   <xsl:apply-templates/>
  </div>
 </xsl:template>
 
 <xsl:template match="DIRECTION">
  <div class="director">
   <xsl:apply-templates/>
  </div>
 </xsl:template>
 <xsl:template match="FXTITRE">
  <div class="fauxtitre">
   <p><xsl:apply-templates/></p>
  </div>
 </xsl:template>
 <xsl:template match="AUTEUR">
  <div class="auteur">
   <p><xsl:apply-templates/></p>
  </div>
 </xsl:template>
 <xsl:template match="EDITEUR">
  <div class="editeur">
   <p><xsl:apply-templates/></p>
  </div>
 </xsl:template>
 <xsl:template match="ISBN">
  <div class="ISBN">
   <p><xsl:apply-templates/></p>
  </div>
 </xsl:template>
 <xsl:template match="DEPOT">
  <div class="DEPOT">
   <p><xsl:apply-templates/></p>
  </div>
 </xsl:template>
 <xsl:template match="COPYRIGHT">
  <div class="COPYRIGHT">
   <p><xsl:apply-templates/></p>
  </div>
 </xsl:template>
 <xsl:template match="SOUL">
  <span class="underline"><xsl:apply-templates/></span>
 </xsl:template>
	<!--<xsl:template match="renv">
		<xsl:variable name="htmlFile" select="//renvlnk/ancestor::chap[@id]"/>
		<a href="{$htmlFile}"><xsl:value-of select="."/></a>
	</xsl:template>-->
	<xsl:template match="/"><xsl:result-document method="xml">
		<xsl:apply-templates/>
	</xsl:result-document></xsl:template>
 
 <xsl:template match="LIVRE">
			
			<xsl:for-each select="//INFO">
			 <xsl:result-document method="xhtml" href="chap_01_debut.xhtml" indent="no" doctype-public="-//W3C//DTD XHTML 1.1//EN">
			  <xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE html&gt;&lt;html xmlns="http://www.w3.org/1999/xhtml" lang="fr-FR" xml:lang="fr-FR" xmlns:epub="http://www.idpf.org/2007/ops"&gt;</xsl:text>
			  <head>
			   <link rel="stylesheet" type="text/css" href="../Styles/Styles.css"/>
			   <title>Épiméthée</title>
			  </head>
			   
			   <body class="body" epub:type="frontmatter">
			    <section class="collec" epub:type="seriespage">
			     
			     <xsl:apply-templates select="COLLECTION | DIRECTION | RP"/>
			    </section>
			    
			    <section class="titlepage" epub:type="titlepage">
			     <xsl:apply-templates select="*[not(self::COLLECTION or self::DIRECTION or self::RP)]"/>
			    </section>
			   </body>
			  <xsl:text disable-output-escaping='yes'>&lt;/html&gt;</xsl:text>
			 </xsl:result-document>
				
			</xsl:for-each>
		 <xsl:for-each select="//LIMINAIRE">
		  <xsl:result-document href="chap_02_liminaire_{format-number(position(), '00')}.xhtml">
				<xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE html&gt;&lt;html xmlns="http://www.w3.org/1999/xhtml" lang="fr-FR" xml:lang="fr-FR" xmlns:epub="http://www.idpf.org/2007/ops"&gt;</xsl:text>
				<head>
				 <link rel="stylesheet" type="text/css" href="../Styles/Styles.css"/>
				 <title><xsl:value-of select="concat(normalize-space(NUMERO), ' ', normalize-space(TITRE))"/></title>
				</head>
			 <body class="body" epub:type="frontmatter">
			  <section class="liminary" id="{@id}" epub:type="introduction" role="doc-introduction">
			   <xsl:apply-templates/>
			   
			   <xsl:if test=".//APPNOTEB">
			    <div class="_idFootnotes">
			     <xsl:apply-templates select=".//APPNOTEB" mode="footnote-area"/>
			    </div>
			   </xsl:if>
			  </section>
				</body>
				<xsl:text disable-output-escaping='yes'>&lt;/html&gt;</xsl:text>
			</xsl:result-document>
			
		</xsl:for-each>
			<xsl:for-each select="//part">
			 <xsl:result-document href="chap_03_part_{format-number(position(), '00')}.xhtml">
					<xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE html&gt;&lt;html xmlns="http://www.w3.org/1999/xhtml" lang="fr-FR" xml:lang="fr-FR" xmlns:epub="http://www.idpf.org/2007/ops"&gt;</xsl:text>
					<head>
						<link href="../Styles/Style.css" rel="stylesheet" type="text/css"/>
						<title><xsl:value-of select="normalize-space($bookTitle)"/></title>
					</head>
					<body>
					 <xsl:if test=".//APPNOTEB">
					  <div class="_idFootnotes">
					   <xsl:apply-templates select=".//APPNOTEB" mode="footnote-area"/>
					  </div>
					 </xsl:if>
						<xsl:apply-templates/>
					 
					</body>
					<xsl:text disable-output-escaping='yes'>&lt;/html&gt;</xsl:text>
					
				</xsl:result-document>
			</xsl:for-each>
  <xsl:for-each select="//CHAPITRE">
   <xsl:result-document href="chap_04_chapitre_{format-number(position(), '00')}.xhtml">
    <xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE html&gt;&lt;html xmlns="http://www.w3.org/1999/xhtml" lang="fr-FR" xml:lang="fr-FR" xmlns:epub="http://www.idpf.org/2007/ops"&gt;</xsl:text>
    <head>
     <link rel="stylesheet" type="text/css" href="../Styles/Styles.css"/>
     <title><xsl:value-of select="concat(normalize-space(NUMERO), ' ', normalize-space(TITRE))"/></title>
    </head>
    <body class="body" epub:type="bodymatter">
     
     <section class="chapter" id="{@id}" epub:type="chapter" role="doc-chapter">
      <xsl:apply-templates/>
     
     <xsl:if test=".//APPNOTEB">
      <div class="_idFootnotes">
       <xsl:apply-templates select=".//APPNOTEB" mode="footnote-area"/>
      </div>
     </xsl:if>
     </section>
    </body>
    <xsl:text disable-output-escaping='yes'>&lt;/html&gt;</xsl:text>
   </xsl:result-document>
  </xsl:for-each>
		<!--	<xsl:for-each select="//schap">
				<xsl:result-document method="xhtml" href="{@id}.xhtml" indent="no" doctype-public="-//W3C//DTD XHTML 1.1//EN">
					<xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE html&gt;&lt;html xmlns="http://www.w3.org/1999/xhtml" lang="fr-FR" xml:lang="fr-FR" xmlns:epub="http://www.idpf.org/2007/ops"&gt;</xsl:text>
					<head>
						<link href="../Styles/Style.css" rel="stylesheet" type="text/css"/>
						<title><xsl:value-of select="normalize-space($bookTitle)"/></title>
					</head>
					<body>
						<xsl:apply-templates/>
					</body>
					<xsl:text disable-output-escaping='yes'>&lt;/html&gt;</xsl:text>
					
				</xsl:result-document>
			</xsl:for-each>-->
  <xsl:for-each select="//APPENDICE">
		 <xsl:result-document href="chap_05_appen_{format-number(position(), '00')}.xhtml">
				
				<xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE html&gt;&lt;html xmlns="http://www.w3.org/1999/xhtml" lang="fr-FR" xml:lang="fr-FR" xmlns:epub="http://www.idpf.org/2007/ops"&gt;</xsl:text>
				<head>
					<link href="../Styles/Style.css" rel="stylesheet" type="text/css"/>
					<title><xsl:value-of select="normalize-space($bookTitle)"/></title>
				</head>
				<body>
					
					<xsl:apply-templates/>
				</body>
				<xsl:text disable-output-escaping='yes'>&lt;/html&gt;</xsl:text>
				
			</xsl:result-document>
		</xsl:for-each>
	</xsl:template>
	
 <xsl:template match="source">
  <p class="source">
   <xsl:apply-templates/>
  </p>
 </xsl:template>	
 <xsl:key name="titbib-parents" match="titbib" use="generate-id(parent::pbib[1])"/>
 <xsl:template match="pbib[key('titbib-parents', generate-id())]">
  <p class="titbib"><xsl:apply-templates/></p>
 </xsl:template>
 <xsl:template match="titbib"><xsl:apply-templates/></xsl:template>
 <xsl:template match="collec">
  <div class="collec"><xsl:apply-templates/></div>
 </xsl:template>
 <xsl:template match="collec/tit">
  <h1 class="collec_tit"><xsl:apply-templates/></h1>
 </xsl:template>
 <xsl:template match="ident">
  <div class="collec"><xsl:apply-templates/></div>
 </xsl:template>
 <xsl:template match="ident/tit">
  <h1 class="ident_tit"><xsl:apply-templates/></h1>
 </xsl:template>
 <xsl:template match="ident/auteur">
  <p class="auteur"><xsl:apply-templates/></p>
 </xsl:template>
 <xsl:template match="ident/edit">
  <p class="edit"><xsl:apply-templates/></p>
 </xsl:template>
 <xsl:template match="ident/copy">
  <p class="copy"><xsl:apply-templates/></p>
 </xsl:template>
 <xsl:template match="ident/isbn">
  <p class="isbn"><xsl:apply-templates/></p>
 </xsl:template>
 <xsl:template match="ident/pagetitre">
  <div class="pagetitre"><xsl:apply-templates/></div>
 </xsl:template>
 <xsl:template match="ident/ftit">
  <div class="ftit"><xsl:apply-templates/></div>
 </xsl:template>
 <xsl:template match="ident/fstit">
  <div class="fstit"><xsl:apply-templates/></div>
 </xsl:template>
 <xsl:template match="ident/info">
  <div class="info"><xsl:apply-templates/></div>
 </xsl:template>
 <xsl:template match="ident/stit">
  <div class="stit"><xsl:apply-templates/></div>
 </xsl:template>
</xsl:stylesheet>