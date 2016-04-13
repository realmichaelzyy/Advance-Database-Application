<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:template match="/">
<html style="height:100%; width: 100%">
  <head>
    <title>q5</title>
    <style type="text/css">

      .sk-spinner-circle.sk-spinner {
      margin: 0 auto;
      width: 100px;
      height: 100px;
      position: relative;
      }
      .sk-spinner-circle .sk-circle {
      width: 100%;
      height: 100%;
      position: absolute;
      left: 0;
      top: 0; }
      .sk-spinner-circle .sk-circle:before {
      content: '';
      display: block;
      margin: 0 auto;
      width: 20%;
      height: 20%;
      background-color: #009ED6;
      border-radius: 100%;
      -webkit-animation: sk-circleBounceDelay 1.2s infinite ease-in-out;
      animation: sk-circleBounceDelay 1.2s infinite ease-in-out;
      /* Prevent first frame from flickering when animation starts */
      -webkit-animation-fill-mode: both;
      animation-fill-mode: both; }
      .sk-spinner-circle .sk-circle2 {
      -webkit-transform: rotate(30deg);
      -ms-transform: rotate(30deg);
      transform: rotate(30deg); }
      .sk-spinner-circle .sk-circle3 {
      -webkit-transform: rotate(60deg);
      -ms-transform: rotate(60deg);
      transform: rotate(60deg); }
      .sk-spinner-circle .sk-circle4 {
      -webkit-transform: rotate(90deg);
      -ms-transform: rotate(90deg);
      transform: rotate(90deg); }
      .sk-spinner-circle .sk-circle5 {
      -webkit-transform: rotate(120deg);
      -ms-transform: rotate(120deg);
      transform: rotate(120deg); }
      .sk-spinner-circle .sk-circle6 {
      -webkit-transform: rotate(150deg);
      -ms-transform: rotate(150deg);
      transform: rotate(150deg); }
      .sk-spinner-circle .sk-circle7 {
      -webkit-transform: rotate(180deg);
      -ms-transform: rotate(180deg);
      transform: rotate(180deg); }
      .sk-spinner-circle .sk-circle8 {
      -webkit-transform: rotate(210deg);
      -ms-transform: rotate(210deg);
      transform: rotate(210deg); }
      .sk-spinner-circle .sk-circle9 {
      -webkit-transform: rotate(240deg);
      -ms-transform: rotate(240deg);
      transform: rotate(240deg); }
      .sk-spinner-circle .sk-circle10 {
      -webkit-transform: rotate(270deg);
      -ms-transform: rotate(270deg);
      transform: rotate(270deg); }
      .sk-spinner-circle .sk-circle11 {
      -webkit-transform: rotate(300deg);
      -ms-transform: rotate(300deg);
      transform: rotate(300deg); }
      .sk-spinner-circle .sk-circle12 {
      -webkit-transform: rotate(330deg);
      -ms-transform: rotate(330deg);
      transform: rotate(330deg); }
      .sk-spinner-circle .sk-circle2:before {
      -webkit-animation-delay: -1.1s;
      animation-delay: -1.1s; }
      .sk-spinner-circle .sk-circle3:before {
      -webkit-animation-delay: -1s;
      animation-delay: -1s; }
      .sk-spinner-circle .sk-circle4:before {
      -webkit-animation-delay: -0.9s;
      animation-delay: -0.9s; }
      .sk-spinner-circle .sk-circle5:before {
      -webkit-animation-delay: -0.8s;
      animation-delay: -0.8s; }
      .sk-spinner-circle .sk-circle6:before {
      -webkit-animation-delay: -0.7s;
      animation-delay: -0.7s; }
      .sk-spinner-circle .sk-circle7:before {
      -webkit-animation-delay: -0.6s;
      animation-delay: -0.6s; }
      .sk-spinner-circle .sk-circle8:before {
      -webkit-animation-delay: -0.5s;
      animation-delay: -0.5s; }
      .sk-spinner-circle .sk-circle9:before {
      -webkit-animation-delay: -0.4s;
      animation-delay: -0.4s; }
      .sk-spinner-circle .sk-circle10:before {
      -webkit-animation-delay: -0.3s;
      animation-delay: -0.3s; }
      .sk-spinner-circle .sk-circle11:before {
      -webkit-animation-delay: -0.2s;
      animation-delay: -0.2s; }
      .sk-spinner-circle .sk-circle12:before {
      -webkit-animation-delay: -0.1s;
      animation-delay: -0.1s; }

      @-webkit-keyframes sk-circleBounceDelay {
      0%, 80%, 100% {
      -webkit-transform: scale(0);
      transform: scale(0); }

      40% {
      -webkit-transform: scale(1);
      transform: scale(1); } }

      @keyframes sk-circleBounceDelay {
      0%, 80%, 100% {
      -webkit-transform: scale(0);
      transform: scale(0); }

      40% {
      -webkit-transform: scale(1);
      transform: scale(1); } }

    </style>
    <script src="d3.js">//</script>
    <script src="moment.js">//</script>
    <script src="jquery-2.1.1.js">//</script>
    <script type="text/javascript">
      $(function() {
      var idx = 0;

      var run = function(firstRun, empnoState) {
      var startTime = Date.now();
      var runIt = false;
      <xsl:for-each select="//employee">

        var empno = '<xsl:value-of select="@empno"/>';

        if (firstRun || runIt) {

        var dateParse = d3.time.format("%Y-%m-%d").parse;

        var data = [];
        

        var first = true;
        var minDate = new Date();
        var maxDate = new Date();

        <xsl:for-each select="history">
          var d = {};
          d.start = dateParse('<xsl:value-of select="@from"/>');
          d.end = dateParse('<xsl:value-of select="@to"/>');
          if (moment(d.end).year() == 9999) { d.end = moment().toDate(); }
          d.title = '<xsl:value-of select="title"/>';
          d.deptno = '<xsl:value-of select="deptno"/>';
          d.department = '<xsl:value-of select="department"/>';

          if (first) {
            minDate = d.start;
            maxDate = d.end;
          }

          first = false;

          if (d.start &lt; minDate) { minDate = d.start; }
          if (d.end &gt; maxDate) { maxDate = d.end; }
          
          data.push(d);
        </xsl:for-each>

        var html =  '&lt;div style="display:table-row"&gt;'
        html +=   '&lt;h3 align="center">' + empno + '&lt;/h3&gt;';
        html +=     '&lt;/div&gt;';
        
        var div = $(html);
        $(".table").append(div);

        for (var j=0; j &lt; 2; j++) {

        var header = j == 0 ? "title" : "department";

        var html =  '&lt;div style="display:table-row"&gt;';
        html +=   '&lt;h5 align="center">' + header + '&lt;/h5&gt;';
        html +=     '&lt;/div&gt;';
        html += '&lt;div style="display:table-row"&gt;';
        html += '&lt;div class="cell" style="height: 100%; width: 100%; margin: 0; padding:0; border: 0; display:table-cell; padding-left:20px; padding-top:20px">&lt;/div&gt;';
        html += '&lt;/div&gt;'

        var div = $(html);
        $(".table").append(div);
        div = $(".table").find(".cell").last();

        var width = div.width() - 20;
        var height = 200;

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
        .text(data[i][header])
        .call(function (text) { var box = text[0][0].getBBox(); text.attr("x", mid - (0.5 * box.width)); });

        high = high ? false : true;

        }
        }

        }

        if (!firstRun) { if (empno == empnoState) { runIt = true; } }

        if (Date.now() - startTime > 30){
          setTimeout(function() { run(false, empno); }, 50);
          return;
        }

      </xsl:for-each>
      
      $(".sk-spinner").remove();
      $("br").remove();
      
      }
      
      run(true);
      
      });
    </script>
    
  </head>
  <body style="height: 100%; width: 100%; margin: 0; padding:0; border: 0">

    <br />
    <br />

    <div class="sk-spinner sk-spinner-circle">
      <div class="sk-circle1 sk-circle"></div>
      <div class="sk-circle2 sk-circle"></div>
      <div class="sk-circle3 sk-circle"></div>
      <div class="sk-circle4 sk-circle"></div>
      <div class="sk-circle5 sk-circle"></div>
      <div class="sk-circle6 sk-circle"></div>
      <div class="sk-circle7 sk-circle"></div>
      <div class="sk-circle8 sk-circle"></div>
      <div class="sk-circle9 sk-circle"></div>
      <div class="sk-circle10 sk-circle"></div>
      <div class="sk-circle11 sk-circle"></div>
      <div class="sk-circle12 sk-circle"></div>
    </div>

    <br />
    <br />
    <br />
    <br />

    <div class="table" style="height: 100%; width: 100%; margin: 0; padding:0; border: 0; display:table">
      <div style="display:table-row">
        <h2 align="center">employee title/department history</h2>    
      </div>
      
    </div>
  </body>
</html>
</xsl:template>
</xsl:stylesheet>
