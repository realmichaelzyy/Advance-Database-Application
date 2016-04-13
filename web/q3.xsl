<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:template match="/">
<html style="height:100%; width: 100%">
  <head>
    <title>q3</title>
    <script src="d3.js">//</script>
    <script src="moment.js">//</script>
    <script src="jquery-2.1.1.js">//</script>
    <script type="text/javascript">
      $(function() {

      var dateParse = d3.time.format("%Y-%m-%d").parse;

      var deps = [];
      var deptnos = [];
      var datar = [];

      <xsl:for-each select="//department">
        deps.push('<xsl:value-of select="name"/>');
        deptnos.push('<xsl:value-of select="@deptno"/>');
        var d = {};
        d.start = dateParse('<xsl:value-of select="@from"/>');
        d.end = dateParse('<xsl:value-of select="@to"/>');
        d.managers = [];
        <xsl:for-each select="managers/manager">
          var manager = {};
          manager.mgrno = '<xsl:value-of select="@mgrno"/>';
          manager.from = dateParse('<xsl:value-of select="@from"/>');
          manager.to = dateParse('<xsl:value-of select="@to"/>');
          if (moment(manager.to).year() == 9999) { manager.to = moment().toDate(); }
          d.managers.push(manager);
        </xsl:for-each>
        
        if (moment(d.end).year() == 9999) { d.end = moment().toDate(); }
        datar.push(d);
      </xsl:for-each>

      var create = function(deptno, k, deptname) {

      var html =  '&lt;div style="display:table-row"&gt;'
        html +=   '&lt;h3 align="center">' + deptname + '&lt;/h3&gt;'
      html +=     '&lt;/div&gt;'
          html += '&lt;div style="display:table-row"&gt;';
          html += '&lt;div class="cell" style="height: 100%; width: 100%; margin: 0; padding:0; border: 0; display:table-cell; padding-left:20px; padding-top:20px">&lt;/div&gt;';
          html += '&lt;/div&gt;'
  

      var div = $(html);
      $(".table").append(div);
      div = $(".table").find(".cell").last();

      var width = div.width() - 20;
      var height = 200;

      var data = [];
      var obj = {};

      var first = true;
      var minDate = new Date();
      var maxDate = new Date();

      obj = datar[k];

      for (var k=0; k &lt; obj.managers.length; k++) {
      var d = {};
      d.start = obj.managers[k].from;
      d.end = obj.managers[k].to;
      d.mgrno = obj.managers[k].mgrno;
      if (first) {
      minDate = d.start;
      maxDate = d.end;
      }

      first = false;

      if (d.start &lt; minDate) { minDate = d.start; }
        if (d.end &gt; maxDate) { maxDate = d.end; }
        data.push(d);
      }

      var x = d3.time.scale().range([0, width]);
      var y = d3.scale.linear().range([height, 0]);

      var paddingr = moment(maxDate).add(600, 'days');
      var paddingl = moment(minDate).subtract(300, 'days');


      x.domain([paddingl.toDate(), paddingr.toDate()]);
      y.domain([0, 3]);


      var svg = d3.select(div[0]).append("svg")
      .attr("width", width)
      .attr("height", height);

      var contentGroup = svg.append("g")
      .attr("transform", "translate(10,10)");

      var high = false;

      for (var i=0; i &lt; data.length; i++) {

      var p1x = x(data[i].start);
      console.log(p1x);
      var p2x = x(data[i].end);
      console.log(p2x);
      var py = high ? y(2) : y(1);

      var color = high ? "#FFE800" : "#009ED6";

      contentGroup.append("line").attr("x1", p1x).attr("y1", py-25).attr("x2", p1x)
      .attr("y2", py+25)
      .attr("stroke-width", 5)
      .attr("stroke", color);

      contentGroup.append("text")
      .attr("x", p1x)
      .attr("y", py+25+10)
      .attr("dy", ".35em")
      .attr("fill", "black")
      .style("font-size","1em")
      .text(moment(data[i].start).format("MM/DD/YYYY"))
      .call(function (text) { var box = text[0][0].getBBox(); text.attr("x", p1x - (0.5 * box.width)); });

      contentGroup.append("line").attr("x1", p1x).attr("y1", py).attr("x2", p2x)
      .attr("y2", py)
      .attr("stroke-width", 5)
      .attr("stroke", color);

      contentGroup.append("line").attr("x1", p2x).attr("y1", py-25).attr("x2", p2x)
      .attr("y2", py+25)
      .attr("stroke-width", 5)
      .attr("stroke", color);

      contentGroup.append("text")
      .attr("x", p2x)
      .attr("y", py+25+10)
      .attr("dy", ".35em")
      .attr("fill", "black")
      .style("font-size","1em")
      .text(moment(data[i].end).format("MM/DD/YYYY"))
      .call(function (text) { var box = text[0][0].getBBox(); text.attr("x", p2x - (0.5 * box.width)); });

      var mid = p1x + (p2x-p1x)/2;
      contentGroup.append("text")
      .attr("x", mid)
      .attr("y", py-10)
      .attr("dy", ".35em")
      .attr("fill", "black")
      .style("font-size","1em")
      .text(data[i].mgrno)
      .call(function (text) { var box = text[0][0].getBBox(); text.attr("x", mid - (0.5 * box.width)); });

      high = high ? false : true;

      }
      };

      for (var j=0; j &lt; datar.length; j++){
        create(deptnos[j], j, deps[j]);
      }
      
      });
    </script>
    
  </head>
  <body style="height: 100%; width: 100%; margin: 0; padding:0; border: 0">
    
    <div class="table" style="height: 100%; width: 100%; margin: 0; padding:0; border: 0; display:table">
      <div style="display:table-row">
        <h2 align="center">all departments history between 1988-05-01 and 1998-05-06</h2>    
      </div>
      
    </div>
  </body>
</html>
</xsl:template>
</xsl:stylesheet>
