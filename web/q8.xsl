<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:template match="/">
    <html style="height:100%; width: 100%">
      <head>
        <title>q8</title>
        <style>
          .header td { border: 1px solid black; }

          td { border-bottom: 1px dotted grey;  text-align: center;}

          tr:last-child td { border-bottom: 0; }
        </style>
      </head>
      <body style="height: 100%; width: 100%; margin: 0; padding:0; border: 0">
        <div style="width:100%">
          <h2 align="center">department max employee salary rising</h2>
        </div>
        <table style="height:100%; width:100%;" cellspacing="0">
          <tr class="header">
            <td>
              <strong>Department</strong>
            </td>
            <td>
              <strong>Longest Period</strong>
            </td>
          </tr>
          <xsl:for-each select="//department">
            <tr>
              <td>
                <xsl:value-of select="@deptno"/>
              </td>
              <td>
                <xsl:value-of select="rising/@from"/> to <xsl:value-of select="rising/@to"/>
              </td>
            </tr>
          </xsl:for-each>
        </table>
      </body>
    </html>
  </xsl:template>
</xsl:stylesheet>