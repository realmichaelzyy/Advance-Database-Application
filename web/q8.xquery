import module namespace util = "http://cs.ucla.edu/~juwood03/util" at "util.xquery";

<q8>
{
    for     $d
    in      doc("v-depts.xml")//department
    return  <department deptno="{data($d/deptno)}">
            {
                util:getDeptRisHistory($d)
            }
            </department>
}
</q8>