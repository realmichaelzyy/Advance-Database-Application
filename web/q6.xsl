<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:template match="/">
<html style="height:100%; width: 100%">
  <head>
    <title>q6</title>
    <style>
      /* set the CSS */

      body { font: 12px Arial;}

      path {
      stroke: steelblue;
      stroke-width: 2;
      fill: none;
      }

      .legend rect {
      fill:white;
      stroke:black;
      opacity:0.8;}

      .axis path,
      .axis line {
      fill: none;
      stroke: grey;
      stroke-width: 1;
      shape-rendering: crispEdges;
      }

    </style>
    
    <script src="d3.js">//</script>
    <script src="d3.legend.js">//</script>
    <script src="moment.js">//</script>
    <script src="jquery-2.1.1.js">//</script>
    <script type="text/javascript">
      $(function() {

      var data = [];

      var first = true;
      var minDate = new Date();
      var maxDate = new Date();

      var maxCount = -1;

      var colorc = d3.scale.category20c();

      var didx = 0;
      var dephash = {};

      <xsl:for-each select="//department">

        var depno = '<xsl:value-of select="@deptno"/>';
        dephash[depno] = didx;
        didx++;

        var dateParse = d3.time.format("%Y-%m-%d").parse;

        <xsl:for-each select="history">
          var d = {};
          d.start = dateParse('<xsl:value-of select="@from"/>');
          d.end = dateParse('<xsl:value-of select="@to"/>');
          d.count = <xsl:value-of select="."/>
          if (moment(d.end).year() == 9999) { d.end = moment().toDate(); }

          if (d.count > maxCount) { maxCount = d.count; }

          if (first) {
            minDate = d.start;
            maxDate = d.end;
          }

          first = false;

          if (d.start &lt; minDate) { minDate = d.start; }
          if (d.end &gt; maxDate) { maxDate = d.end; }

          var item = {};
          item.date = d.start;
          item.value = d.count;
          item.depno = depno;
          data.push(item);
          item.date = d.end;
          item.value = d.count;
          item.depno = depno;
          data.push(item);
        </xsl:for-each>

      </xsl:for-each>
        
        var html = '&lt;div style="display:table-row"&gt;';
        html += '&lt;div class="cell" style="height: 100%; width: 100%; margin: 0; padding:0; border: 0; display:table-cell; padding-left:20px; padding-top:20px">&lt;/div&gt;';
        html += '&lt;/div&gt;'

      var div = $(html);
      $(".table").append(div);
      div = $(".table").find(".cell").last();

      var width = div.width() - 20;
      var height = div.height() - 20;

      var x = d3.time.scale().range([0, width]);
      var y = d3.scale.linear().range([height-30, 0]);

      var paddingr = moment(maxDate).add(600, 'days');
      var paddingl = moment(minDate).subtract(300, 'days');

      x.domain([paddingl.toDate(), paddingr.toDate()]);
      y.domain([0, maxCount + 5]);

      var svg = d3.select(div[0]).append("svg")
      .attr("width", width)
      .attr("height", height);



      var contentGroup = svg.append("g")
      .attr("transform", "translate(10,10)");



      var xAxis = d3.svg.axis().scale(x)
      .orient("bottom").ticks(10);

      var yAxis = d3.svg.axis().scale(y)
      .orient("left").ticks(10);

      // Define the line
      var lineValues = d3.svg.line()
      .x(function(d) { return x(d.date); })
      .y(function(d) { return y(d.value); })
      .interpolate("linear");

      var nest = d3.nest().key(function (d) { return d.depno; }).entries(data);
      nest.forEach(function (d) {
      contentGroup.append("path")
      .datum(d.values)
      .attr("class", "line")
      .attr("transform", "translate(20, 0)")
      .attr("data-legend" , function () { return d.key; })
      .attr("data-legend-color", function () { return colorc(d.key); })
      .style("stroke", function () { return colorc(d.key); })
      .transition()
      .attr("d", lineValues);
      });


      contentGroup.append("g")
      .attr("class", "x axis")
      .attr("transform", "translate(20," + (height-30) + ")")
      .call(xAxis);

      // Add the Y Axis
      contentGroup.append("g")
      .attr("class", "y axis")
      .attr("transform", "translate(20, 0)")
      .call(yAxis);

      legend = contentGroup.append("g")
      .attr("class","legend")
      .attr("transform","translate(50,30)")
      .style("font-size","12px")
      .call(d3.legend)

      });
    </script>
    
  </head>
  <body style="height: 100%; width: 100%; margin: 0; padding:0; border: 0">

    <br />
    <br />
    <div class="table" style="height: 100%; width: 100%; margin: 0; padding:0; border: 0; display:table">
      <div style="display:table-row">
        <h2 align="center">department history count</h2>    
      </div>
      
    </div>
  </body>
</html>
</xsl:template>
</xsl:stylesheet>
