import module namespace util = "http://cs.ucla.edu/~juwood03/util" at "util.xquery";

declare variable $tstart := xs:date('1988-05-01');
declare variable $tend   := xs:date('1998-05-06');

<q3>
{
    for     $d 
    in      doc("v-depts.xml")//department[not( xs:date(@tstart) > $tend or 
                                                xs:date(@tend) < $tstart)]
    return  <department from="{util:max(xs:date($d/@tstart), $tstart)}" 
                        to="{util:min(xs:date($d/@tend), $tend)}" 
                        deptno="{$d/deptno}">
                <name>{data($d/deptname)}</name>
                <managers>{util:getManagersHistory($d/mgrno, $tstart, $tend)}</managers>
            </department>
}
</q3>