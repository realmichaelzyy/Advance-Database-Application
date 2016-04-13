import module namespace util = "http://cs.ucla.edu/~juwood03/util" at "util.xquery";

<q4>
{
    for     $e
    in      doc("v-emps.xml")//employee
    let     $d := util:durations($e)
    return  <employee empno="{$e/empno}">
                <name>{data($e/firstname)}{' '}{data($e/lastname)}</name>
                {
                    util:getMaxDurationSalary($d, max($d/xs:dayTimeDuration(span)))
                }
            </employee>
}
</q4>