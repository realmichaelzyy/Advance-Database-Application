import module namespace util = "http://cs.ucla.edu/~juwood03/util" at "util.xquery";

<q1>
{
    for     $e
    in      doc("v-emps.xml")//employee
    where   $e/firstname="Kyoichi" and
            $e/lastname="Maliniak"
    return  <history for="{$e/firstname} {$e/lastname}">
            {
                util:getDept($e/deptno)
            }
            </history>
}
</q1>