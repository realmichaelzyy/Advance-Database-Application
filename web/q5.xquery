import module namespace util = "http://cs.ucla.edu/~juwood03/util" at "util.xquery";

<q5>
{
    for     $e
    in      doc("v-emps.xml")//employee
    return  <employee empno="{data($e/empno)}">
            {
                util:getHistory($e)
            }
            </employee>
}
</q5>
