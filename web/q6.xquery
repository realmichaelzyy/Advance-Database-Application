import module namespace util = "http://cs.ucla.edu/~juwood03/util" at "util.xquery";

<q6>
{
    for     $d
    in      doc("v-depts.xml")//department
    return  <department deptno="{data($d/deptno)}">
            {
                util:getDeptHistory($d)
            }
            </department>
}
</q6>