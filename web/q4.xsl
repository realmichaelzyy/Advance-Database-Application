<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:template match="/">
<html style="height:100%; width: 100%">
  <head>
    <title>q4</title>
    <style>
      .header td { border: 1px solid black; }

      td { border-bottom: 1px dotted grey;  text-align: center;}

      td:first-child { text-align: left; }

      tr:last-child td { border-bottom: 0; }
    </style>
  </head>
  <body style="height: 100%; width: 100%; margin: 0; padding:0; border: 0">
    <div style="width:100%">
      <h2 align="center">longest employee stagnation (constant salary)</h2>
    </div>
    <table style="height:100%; width:100%;" cellspacing="0">
      <tr class="header">
        <td>
          <strong>Name</strong>
        </td>
        <td>
          <strong>Salary</strong>
        </td>
        <td>
          <strong>Longest Period</strong>
        </td>
      </tr>
      <xsl:for-each select="//employee">
        <tr>
          <td>
            <xsl:value-of select="name"/>
          </td>
          <td>
            <xsl:value-of select="salary"/>
          </td>
          <td>
            <xsl:value-of select="salary/@from"/> to <xsl:value-of select="salary/@to"/>
          </td>
        </tr>
      </xsl:for-each>
    </table>  
  </body>
</html>
</xsl:template>
</xsl:stylesheet>
