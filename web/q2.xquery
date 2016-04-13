import module namespace util = "http://cs.ucla.edu/~juwood03/util" at "util.xquery";

declare variable $d := xs:date('1991-01-06');

<q2>
{
    for     $e 
    in      doc("v-emps.xml")//employee[xs:date(@tstart) <= $d and $d <= xs:date(@tend)]
    let     $s := $e/salary[xs:date(@tstart) <= $d and $d <= xs:date(@tend)],
            $dept := $e/deptno[xs:date(@tstart) <= $d and $d <= xs:date(@tend)]
    where   $s and $dept and $s < 52000
    return  <employee>
                <name>{data($e/firstname)}{' '}{data($e/lastname)}</name>
                <salary>{data($s)}</salary>
                {
                    util:getDeptName($dept)
                }
            </employee>
}
</q2>