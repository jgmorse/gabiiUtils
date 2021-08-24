<!-- Assumes an XML export formatted like Native SQLite Manager, e.g.
<foo>
  <bar>
    <RECORD>
      <FIELD1/>
      <FIELD2/>
    </RECORD>
  </bar>
<foo>
 -->
<?xml version="1.0" encoding="utf-8"?>
<xsl:transform xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:date="http://exslt.org/dates-and-times" xmlns:doc="http://exslt.org/common" version="1.0" extension-element-prefixes="date doc">
  <xsl:output method="xml" encoding="utf-8" omit-xml-declaration="yes" indent="yes"/>
  <xsl:strip-space elements="*"/>

<xsl:template match="/">

<doi_batch xmlns="http://www.crossref.org/schema/4.3.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="4.3.0" xsi:schemaLocation="http://www.crossref.org/schema/4.3.0 http://www.crossref.org/schema/deposit/crossref4.3.0.xsd">
  <head >
    <doi_batch_id>umpre-backlist-<xsl:value-of select="date:date-time()"/>-submission</doi_batch_id>
    <timestamp><xsl:value-of select="date:year()"/><xsl:value-of select="date:month-in-year()"/><xsl:value-of select="date:day-in-month()"/><xsl:value-of select="date:hour-in-day()"/><xsl:value-of select="date:minute-in-hour()"/><xsl:value-of select="date:second-in-minute()"/></timestamp>
    <depositor>
      <name>scpo</name>
      <email_address>mpub.xref@gmail.com</email_address>
    </depositor>
    <registrant>MPublishing</registrant>
  </head>
  <body>
    <database>
      <database_metadata language="en">
        <contributors>
          <person_name contributor_role="editor" sequence="first">
            <given_name>Rachel</given_name>
            <surname>Opitz</surname>
            <affiliation>University of South Florida</affiliation>
          </person_name>
          <person_name contributor_role="editor" sequence="additional">
            <given_name>Marcello</given_name>
            <surname>Mogetta</surname>
            <affiliation>University of Missouri</affiliation>
          </person_name>
          <person_name contributor_role="editor" sequence="additional">
            <given_name>Nicola</given_name>
            <surname>Terrenato</surname>
            <affiliation>University of Michigan</affiliation>
          </person_name>
        </contributors>
        <titles>
          <title>A Mid-Republican House from Gabii - Database</title>
        </titles>
        <description language="en">The database accompanying the digital work A Mid-Republican House from Gabii, DOI: https://doi.org/10.3998/mpub.9231782. Includes complete data for Areas A and B of the Gabii Project, as well as data from all other areas as available at time of publication. The database will be updated as each successive volume of the series is published.</description>
        <database_date>
            <publication_date>
              <month>12</month>
              <year>2016</year>
            </publication_date>
        </database_date>
        <publisher>
          <publisher_name>University of Michigan Press</publisher_name>
          <publisher_place>Ann Arbor, MI</publisher_place>
        </publisher>
        <doi_data>
            <doi>10.3998/gabii.1</doi>
            <resource>https://quod.lib.umich.edu/g/gabii_1_data/</resource>
        </doi_data>
      </database_metadata>
      <xsl:apply-templates select="//RECORD"/>
    </database>
  </body>
</doi_batch>
</xsl:template>

<xsl:template match="//RECORD">
  <dataset xmlns="http://www.crossref.org/schema/4.3.0" dataset_type="record">
    <xsl:variable name="type">
        <xsl:choose>
            <xsl:when test="STRUCT_DESCRIPTION"><xsl:text>SU</xsl:text></xsl:when>
            <xsl:when test="SF_DESCRIPTION"><xsl:text>SF</xsl:text></xsl:when>
            <xsl:otherwise><xsl:text>SD</xsl:text></xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
      <titles><title>
	<xsl:choose>
          <xsl:when test="$type='SU'">Stratigraphic Unit </xsl:when>
          <xsl:when test="$type='SF'">Special Find </xsl:when>
          <xsl:when test="$type='SD'">Spot Date </xsl:when>
        </xsl:choose>
	<xsl:value-of select="ID"/>
      </title></titles>
    <publisher_item>
      <xsl:element name="item_number">
        <xsl:attribute name="item_number_type">
          <xsl:choose>
            <xsl:when test="$type='SU'">stratigraphic_unit</xsl:when>
            <xsl:when test="$type='SF'">special_find</xsl:when>
            <xsl:when test="$type='SD'">spot_date</xsl:when>
          </xsl:choose>
        </xsl:attribute>
        <xsl:value-of select="ID"/>
      </xsl:element>
    </publisher_item>
    <xsl:if test="$type='SU' and not(DEFINITION='')">
      <description language="en">
        Definition: <xsl:value-of select="DEFINITION"/>
        <xsl:if test="STRUCT_DESCRIPTION and not(STRUCT_DESCRIPTION='')">
          Description: <xsl:value-of select="STRUCT_DESCRIPTION"/>
        </xsl:if>
        <xsl:if test="OBSERVATIONS and not(OBSERVATIONS='')">
          Observations: <xsl:value-of select="OBSERVATIONS"/>
        </xsl:if>
      </description>
    </xsl:if>
    <xsl:if test="$type='SF' and not(SF_DESCRIPTION='')">
      <description language="en">
        <xsl:value-of select="SF_DESCRIPTION"/>
        <!-- Seems like too much detail
        <xsl:if test="SF_NOTES and not(SF_NOTES='')">
          Notes: <xsl:value-of select="SF_NOTES"/>
        </xsl:if>
        <xsl:if test="SF_OBJECT_TYPE and not(SF_OBJECT_TYPE='')">
          Object Type: <xsl:value-of select="SF_OBJECT_TYPE"/>
        </xsl:if> -->
      </description>
    </xsl:if>
    <xsl:if test="$type='SD' and not(SD_START='')">
      <description language="en">
        Spot Date Range: <xsl:value-of select="SD_START"/> <xsl:value-of select="SD_START_SUFFIX"/> - <xsl:value-of select="SD_END"/> <xsl:value-of select="SD_END_SUFFIX"/>
        <xsl:if test="SD_CERAM_CLASS and not(SD_CERAM_CLASS='')">
          Ceramics Class: <xsl:value-of select="SD_CERAM_CLASS"/>
        </xsl:if>
      </description>
    </xsl:if>
    <doi_data>
        <doi>
          <xsl:text>10.3998/gabii.1.</xsl:text>
          <xsl:if test="$type='SF' or $type='SD'"><xsl:value-of select="$type"/></xsl:if>
          <xsl:value-of select="ID"/>
        </doi>
        <resource>
          <xsl:text>https://quod.lib.umich.edu/g/gabii_1_data/</xsl:text>
          <xsl:choose>
            <xsl:when test="$type='SU'">stratigraphic_units</xsl:when>
            <xsl:when test="$type='SF'">special_finds</xsl:when>
            <xsl:when test="$type='SD'">spot_dates</xsl:when>
          </xsl:choose>
        <xsl:text>/</xsl:text>
        <xsl:value-of select="ID"/>
      </resource>
    </doi_data>
  </dataset>
</xsl:template>

</xsl:transform>
