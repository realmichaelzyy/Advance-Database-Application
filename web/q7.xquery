import module namespace util = "http://cs.ucla.edu/~juwood03/util" at "util.xquery";

<q7>
{
    for     $d
    in      doc("v-depts.xml")//department
    return  <department deptno="{data($d/deptno)}">
            {
                util:getDeptSalHistory($d)
            }
            </department>
}
</q7>