<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:template match="/">
<html style="height:100%; width: 100%">
  <head>
    <title>q1</title>
    <script src="d3.js">//</script>
    <script src="moment.js">//</script>
    <script src="jquery-2.1.1.js">//</script>
    <script type="text/javascript">
      $(function() {
      var width = $("#chart").width() - 20;
      var height = $("#chart").height() - 20;

      var dateParse = d3.time.format("%Y-%m-%d").parse;

      var deps = [];
      var datar = [];
      var first = true;
      var minDate = new Date();
      var maxDate = new Date();
      <xsl:for-each select="//department">
          deps.push('<xsl:value-of select="name"/>');
          var d = {};
          d.start = dateParse('<xsl:value-of select="start"/>');
          d.end = dateParse('<xsl:value-of select="end"/>');
          if (moment(d.end).year() == 9999) { d.end = moment().toDate(); }
          if (first) {
            minDate = d.start;
            maxDate = d.end;
          }
          first  = false;
          
          if (d.start &lt; minDate) { minDate = d.start; }
          if (d.end &gt; maxDate) { maxDate = d.end; }


        datar.push(d);
      </xsl:for-each>

      var div = $("#chart");

      var x = d3.time.scale().range([0, width]);
      var y = d3.scale.linear().range([height, 0]);

      console.log(minDate);
      console.log(maxDate);

      var paddingr = moment(maxDate).add(600, 'days');
      var paddingl = moment(minDate).subtract(300, 'days');


      x.domain([paddingl.toDate(), paddingr.toDate()]);
      y.domain([0, deps.length+2]);


      var svg = d3.select(div[0]).append("svg")
      .attr("width", width)
      .attr("height", height);

      var contentGroup = svg.append("g")
      .attr("transform", "translate(10,10)");

      for (var i=0; i &lt; datar.length; i++) {

      var p1x = x(datar[i].start);
      console.log(p1x);
      var p2x = x(datar[i].end);
      console.log(p2x);
      var py = y(i+1);

      contentGroup.append("line").attr("x1", p1x).attr("y1", py-25).attr("x2", p1x)
      .attr("y2", py+25)
      .attr("stroke-width", 5)
      .attr("stroke", "#009ED6");

      contentGroup.append("text")
      .attr("x", p1x)
      .attr("y", py+25+10)
      .attr("dy", ".35em")
      .attr("fill", "black")
      .style("font-size","1em")
      .text(moment(datar[i].start).format("MM/DD/YYYY"))
      .call(function (text) { var box = text[0][0].getBBox(); text.attr("x", p1x - (0.5 * box.width)); });

      contentGroup.append("line").attr("x1", p1x).attr("y1", py).attr("x2", p2x)
      .attr("y2", py)
      .attr("stroke-width", 5)
      .attr("stroke", "#009ED6");

      contentGroup.append("line").attr("x1", p2x).attr("y1", py-25).attr("x2", p2x)
      .attr("y2", py+25)
      .attr("stroke-width", 5)
      .attr("stroke", "#009ED6");

      contentGroup.append("text")
      .attr("x", p2x)
      .attr("y", py+25+10)
      .attr("dy", ".35em")
      .attr("fill", "black")
      .style("font-size","1em")
      .text(moment(datar[i].end).format("MM/DD/YYYY"))
      .call(function (text) { var box = text[0][0].getBBox(); text.attr("x", p2x - (0.5 * box.width)); });

      var mid = p1x + (p2x-p1x)/2;
      contentGroup.append("text")
      .attr("x", mid)
      .attr("y", py-10)
      .attr("dy", ".35em")
      .attr("fill", "black")
      .style("font-size","1em")
      .text(deps[i])
      .call(function (text) { var box = text[0][0].getBBox(); text.attr("x", mid - (0.5 * box.width)); });

      }

      });
    </script>
    
  </head>
  <body style="height: 100%; width: 100%; margin: 0; padding:0; border: 0">
    
    <div style="height: 100%; width: 100%; margin: 0; padding:0; border: 0; display:table">
      <div style="display:table-row">
        <h2 align="center">employment history for Kyoichi Maliniak</h2>    
      </div>
      <div style="display:table-row">
        <div id="chart" style="height: 100%; width: 100%; margin: 0; padding:0; border: 0; display:table-cell; padding-left:20px; padding-top:20px"></div>
      </div>
    </div>
  </body>
</html>
</xsl:template>
</xsl:stylesheet>
