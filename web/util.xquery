module namespace util = "http://cs.ucla.edu/~juwood03/util";

declare function util:datePairs($dates as element()*) as xs:anyAtomicType*
{
	for 	$d
	in 		$dates
	return 	if (index-of(data($dates), data($d)) > 1) 
			then 
				(concat(data($dates)[index-of(data($dates), data($d))-1], ',', data($d))) 
			else 
				()
};

declare function util:dates($e as element()*) as element()*
{
	for 	$d
	in 		distinct-values($e/title/@tend | 
							$e/deptno/@tend | 
							doc("v-depts.xml")//department[deptno=data($e/deptno/@tend)]/deptname/@tend |
							$e/title/@tstart | 
							$e/deptno/@tstart |
							doc("v-depts.xml")//department[deptno=data($e/deptno/@tstart)]/deptname/@tstart)
	order by xs:date($d)
	return 	<dates>{$d}</dates>
};

declare function util:empDates($e as element()*) as element()*
{
	for 	$d
	in 		distinct-values(doc("v-emps.xml")//employee[deptno=data($e/deptno)]/deptno/@tend |
							doc("v-emps.xml")//employee[deptno=data($e/deptno)]/deptno/@tstart)
	order by xs:date($d)
	return 	<dates>{$d}</dates>
};

declare function util:riseDates($e as element()*) as element()*
{
	for 	$d
	in 		distinct-values( $e//@from | $e//@to )
	order by xs:date($d)
	return 	<dates>{$d}</dates>
};

declare function util:emps($e as element()*) as element()*
{
	for 	$d
	in 		distinct-values($e//@empid)
	return 	<emps>{$d}</emps>
};

declare function util:rise($emps as element()*, $sals as element()*) as element()*
{
	for 	$d
	in 		$emps
	let		$r := 	(
						for		$s
						in			$sals//a[@empid = data($d)]
						return	$s//salary
					)
	let		$f :=	(
						for		$c
						in		$r
						return	<salary from="{$c/@tstart}" to="{$c/@tend}" key="{concat($c/@tstart, ",", $c/@tend, ",", data($c))}">
									{data($c)}
								</salary>
					)
	let		$u :=	(
						for	$ru
						in	distinct-values($f//@key)
						let	$di := $f[@key = $ru][1]
						return <salary from="{$di/@from}" to="{$di/@to}" key="{$di/@key}">{data($di)}</salary>
					)
	let		$wi :=	(
						for	$cu
						in	$u
						let	$ind := index-of($u/@key, $cu/@key)
						return <salary from="{$cu/@from}" to="{$cu/@to}" index="{$ind}">{data($cu)}</salary>
					)
	let		$wr :=	(
						for	$cs
						in	$wi
						let	$ci := 	(
										if (xs:integer($cs/@index) = 1)
										then
										(
											1
										)
										else
										(
											if (xs:integer(data($cs)) >= xs:integer(data($wi[xs:integer(@index) = (xs:integer($cs/@index) - 1)])))
											then
											(
												1
											)
											else
											(
												0
											)
										)
									)
						return <salary from="{$cs/@from}" to="{$cs/@to}">{$ci}</salary>
					)
	return 	<rise empno="{data($d)}">{$wr}</rise>
};

declare function util:getDeptRisHistory($dep as element()*) as element()*
{
	for 	$d
	in 		$dep
	let 	$ed := util:empDates($d)
	let		$p := distinct-values(util:datePairs($ed))
	let		$u := util:extract($p)	
	let		$c := util:alls($d, $u)
	let 	$em := util:emps($c)
	let		$ris := util:rise($em, $c)	
	let 	$rd := util:riseDates($ris)
	let		$rp := distinct-values(util:datePairs($rd))
	let		$ru := util:extract($rp)
	let		$cr := util:rises($ris, $ru)
	let		$co := util:colid($cr)
	let		$unco := util:uncolid($co)
	let		$un := distinct-values($unco/@unid)
	let		$his := util:getDeptHistoryInner($un, $unco)
	let		$ones := (for $or in $his where xs:integer(data($or)) = 1 return $or)
	let		$dur := ( 
						<root>
						{
							for $nr 
							in $ones 
							return 	<history from="{$nr/@from}" to="{$nr/@to}" span="{util:min(xs:date($nr/@to),util:now()) - xs:date($nr/@from)}">
										</history>
						}
						</root>
					)
	let		$clean := 	(
							for 	$cru
							in		$dur/history[xs:dayTimeDuration(@span) = max($dur/history/xs:dayTimeDuration(@span)) ][1]
							return <rising from="{$cru/@from}" to="{$cru/@to}"></rising>
						)
	return $clean
};

declare function util:getDeptSalHistoryLeg($dep as element()*) as element()*
{
	for 	$d
	in 		$dep
	let 	$ed := util:empDates($d)
	let		$p := distinct-values(util:datePairs($ed))
	let		$u := util:extract($p)	
	let		$c := util:maxs($d, $u)
	let		$co := util:colid($c)
	let		$unco := util:uncolidleg($co)
	let		$un := distinct-values($unco/@unid)
	return	util:getDeptHistoryInner($un, $unco)
};

declare function util:getDeptSalHistory($dep as element()*) as element()*
{
	for 	$d
	in 		$dep
	let 	$ed := util:empDates($d)
	let		$p := distinct-values(util:datePairs($ed))
	let		$u := util:extract($p)	
	let		$c := util:maxs($d, $u)
	let		$co := util:colid($c)
	let		$unco := util:uncolid($co)
	let		$un := distinct-values($unco/@unid)
	return	util:getDeptHistoryInner($un, $unco)
};

declare function util:getDeptHistory($dep as element()*) as element()*
{
	for $d
	in 	$dep
	let $ed := util:empDates($d)
	let	$p := distinct-values(util:datePairs($ed))
	let	$u := util:extract($p)	
	let	$c := util:counts($d, $u)
	let	$co := util:colid($c)
	let	$unco := util:uncolid($co)
	let	$un := distinct-values($unco/@unid)
	return 	util:getDeptHistoryInner($un, $unco)
};

declare function util:getDeptHistoryInner($un as xs:anyAtomicType*, $unco as element()*)  as element()*
{
	for 	$u
	in 		$un
	let		$min := min($unco[ xs:integer($u) = xs:integer(@unid)]/xs:date(@from))
	let		$max := max($unco[ xs:integer($u) = xs:integer(@unid)]/xs:date(@to))
	let		$any := distinct-values((data($unco[ xs:integer($u) = xs:integer(@unid)])))
	return	<history from="{$min}" to="{$max}">
				{$any}
			</history>
};

declare function util:check($start as xs:integer, $end as xs:integer, $counts as element()*)  as xs:integer
{
	if (count(distinct-values(data($counts[xs:integer(@colid) >= $start and xs:integer(@colid) <= $end]))) = 1)
	then  ( 1 ) else ( 0 )
};

declare function util:uncolidInner($halfv as xs:integer, $cur as xs:integer, $halfe as element()*, $i as xs:integer, $counts as element()*, $left as xs:integer, $right as xs:integer, $hold as xs:integer, $holdi)  as xs:integer
{

	if ($i = 1) 
	then
	( 
		if ($halfv = $hold ) then ( 1 ) else ( 2 ) 
	)
	else 
	(
		if ($halfv = $hold and util:check($i, $holdi, $counts) = 1)
		then
		(
			if ( ($left + (($i - $left) idiv 2)) < 1 or ($left + (($i - $left) idiv 2)) > $holdi )
			then
			(
				1
			) 
			else
			(
				util:uncolidInner(
					xs:integer(data($counts[ xs:integer(@colid) = ($left + (($i - $left) idiv 2)) ])), 
					xs:integer(data($counts[xs:integer(@colid) = ($left + ((($i - $left) idiv 2)+1))])),
					$counts[xs:integer(@colid) = ($left + (($i - $left) idiv 2))],
					$left + (($i - $left) idiv 2),
					$counts,
					$left,
					$i,
					$hold, $holdi)
			)
		)
		else
		( 
			if ($cur = $hold and util:check($i+1, $holdi, $counts) = 1 )
			then
			(
				xs:integer($halfe/@colid) + 1
			)
			else
			(
				if ( ($left + (($right - $i) idiv 2)) < 1 or ($left + (($right - $i) idiv 2)) > $holdi )
				then
				(
					1
				) 
				else
				(
					util:uncolidInner(
						xs:integer(data($counts[xs:integer(@colid) = ($i + (($right - $i) idiv 2))])),
						xs:integer(data($counts[xs:integer(@colid) = ($i+ ((($right - $i) idiv 2)+1))])),
						$counts[xs:integer(@colid) = ($i + (($right - $i) idiv 2) )],
						$i + (($right - $i) idiv 2),
						$counts,
						$i, $right, $hold, $holdi)
				)
			)
		)
	)
};

declare function util:uncolidlegInner($prevv as xs:integer, $cur as xs:integer, $prev as element()*, $i as xs:integer, $counts as element()*)  as xs:integer
{
	if ($i = 1) 
	then
	( 
		1 
	)
	else 
	(
		if ($prevv = $cur)
		then
		(
			if ($i = 2)
			then
			(
				1
			)
			else
			(
				util:uncolidlegInner(xs:integer(data($counts[xs:integer(@colid) = ($i - 2)])), $prevv, $counts[xs:integer(@colid) = ($i - 2)], $i - 1, $counts)
			)
		)
		else
		( 
			xs:integer($prev/@colid) + 1
		)
	)
};

declare function util:uncolidleg($counts as element()*) as element()*
{
	for 		$c
	in 		$counts
	let		$i := xs:integer($c/@colid)
	let		$x := 1
	let		$un := 	if ($i = 1) 
					then 
						( 1 ) 
					else 
						(
							let $prev := $counts[xs:integer(@colid) = ($i - 1)]
							let $prevv := xs:integer(data($prev))
							let $cur := xs:integer(data($c))
							return util:uncolidlegInner($cur, $prevv, $prev, $i, $counts)
						)
	return 	<count from="{$c/@from}" to="{$c/@to}" colid="{$c/@colid}" unid="{$un}">
				{data($c)}
			</count>
};

declare function util:uncolid($counts as element()*) as element()*
{
	for 	$c
	in 		$counts
	let		$i := xs:integer($c/@colid)
	let		$x := 1
	let		$un := 	if ($i = 1) 
					then 
						( 1 ) 
					else 
						(
							if ( $i = 2)
							then
							(
								if ( xs:integer(data($counts[xs:integer(@colid) = 1])) = xs:integer(data($c)) )
								then ( 1 ) else ( 2 )
							)
							else
							(
								let $imo := $i - 1
								let $imdt := 1 + $imo idiv 2
								let $halfe:= $counts[xs:integer(@colid) = ($imdt)] (:$counts[xs:integer(@colid) = xs:integer(($i - 1)/2)] :)
								let $halfv := xs:integer(data($halfe))
								let $cur := xs:integer(data($counts[xs:integer(@colid) = $imdt +1]))
								let $hold := xs:integer(data($c))									
								return util:uncolidInner($halfv, $cur, $halfe, $imdt, $counts, 1, $i, $hold, $i)
							)
						)
	return 	<count from="{$c/@from}" to="{$c/@to}" colid="{$c/@colid}" unid="{$un}">
				{data($c)}
			</count>
};

declare function util:colid($counts as element()*) as element()*
{
	for 	$c
	in 		$counts
	let		$f := $counts/@from
	return 	<count from="{$c/@from}" to="{$c/@to}" colid="{index-of($f, $c/@from)}">
				{data($c)}
			</count>
};

declare function util:rises($dep as element()*, $dates as element()*) as element()*
{
	for 	$d 
	in 		$dates
	return 	<count from="{$d/@from}" to="{$d/@to}">
			{
				let $f := $dep//salary[	xs:date($d/@from) >= xs:date(@from) and
																		xs:date($d/@to) <= xs:date(@to) ]
				return if ( count(distinct-values(data($f))) = 1) then 1 else 0
			}
			</count>
};


declare function util:counts($dep as element()*, $dates as element()*) as element()*
{
	for 	$d 
	in 		$dates
	return 	<count from="{$d/@from}" to="{$d/@to}">
			{
				let $f := doc("v-emps.xml")//employee[	deptno=data($dep/deptno)]/deptno[	xs:date($d/@from) >= xs:date(@tstart) and
														xs:date($d/@to) <= xs:date(@tend) ]
				return count($f)
			}
			</count>
};

declare function util:alls($dep as element()*, $dates as element()*) as element()*
{
	for 	$d 
	in 		$dates
	return 	<count from="{$d/@from}" to="{$d/@to}">
			{
				let $f := doc("v-emps.xml")//employee[deptno=data($dep/deptno)]
				return 	
				(
					for 	$a
					in 		$f
					where 	count($a/salary[ not (	xs:date(@tstart) > xs:date($d/@to) or xs:date(@tend) < xs:date($d/@from) ) ]) > 0
					return 	<a empid="{data($a/empno)}">
							{
								$a/salary[ not (	xs:date(@tstart) > xs:date($d/@to) or xs:date(@tend) < xs:date($d/@from) ) ]
							}
							</a>
				)
							
			}
			</count>
};

declare function util:maxs($dep as element()*, $dates as element()*) as element()*
{
	for 	$d 
	in 		$dates
	return 	<count from="{$d/@from}" to="{$d/@to}">
			{
				let $f := doc("v-emps.xml")//employee[deptno=data(	$dep/deptno)]/salary[ not (	xs:date(@tstart) > xs:date($d/@to) or
																	xs:date(@tend) < xs:date($d/@from) ) ]																														
				return 	max(data($f))
			}
			</count>
};


declare function util:getHistory($emp as element()*) as element()*
{
	for $e 
	in 	$emp
	let $d := util:dates($e)
	let	$p := distinct-values(util:datePairs($d))
	let	$u := util:extract($p)
	return 	util:getHistoryInner($emp, $u)
};

declare function util:getHistoryInner($emp as element()*, $dates as element()*) as element()*
{
	for 	$d 
	in 		$dates
	return 	<history from="{$d/@from}" to="{$d/@to}">
				<title>
					{data($emp/title[xs:date($d/@from) >= xs:date(@tstart) and xs:date($d/@to) <= xs:date(@tend)])}
				</title>
				<deptno>
					{data($emp/deptno[xs:date($d/@from) >= xs:date(@tstart) and xs:date($d/@to) <= xs:date(@tend)])}
				</deptno>
				<department>
				{
					let $c := data($emp/deptno[xs:date($d/@from) >= xs:date(@tstart) and xs:date($d/@to) <= xs:date(@tend)])
					return data((doc("v-depts.xml")//department[deptno=$c]/deptname))
				}
				</department>
			</history>
};

declare function util:extract($p as xs:anyAtomicType*) as element()*
{
	for 	$i
	in		$p
	let	$s := tokenize($i, '\s')
	return <pair from="{tokenize($i, ',')[1]}" to="{tokenize($i, ',')[2]}"></pair>
};


declare function util:now( ) as xs:date
{
	fn:adjust-date-to-timezone(current-date(),())
};

declare function util:getMaxDurationSalary($durations as element()*, $max as xs:dayTimeDuration) as element()
{
	for 	$d
	in 		$durations[xs:dayTimeDuration(span) = $max][1]
	return 	<salary from="{xs:date(data($d/from))}" to="{xs:date(data($d/to))}">
				{data($d/salary)}
			</salary>
};

declare function util:durations( $empl as element()* ) as element()*
{
	for 	$s
	in 		$empl/salary
	return 	<duration>
				<from>{xs:date($s/@tstart)}</from>
				<to>{util:min(xs:date($s/@tend),util:now())}</to>
				<span>
					{util:min(xs:date($s/@tend),util:now()) - xs:date($s/@tstart)}
				</span>
				<salary>{data($s)}</salary>
			</duration>
};

declare function util:min( $d1 as xs:date, $d2 as xs:date ) as xs:date
{
	if($d1 > $d2) then $d2	else $d1
};

declare function util:maxInt( $d1 as xs:integer, $d2 as xs:integer ) as xs:integer
{
    if( $d1 > $d2 ) then $d1 else $d2
};

declare function util:max( $d1 as xs:date, $d2 as xs:date ) as xs:date
{
    if( $d1>$d2 ) then $d1 else $d2
};

declare function util:getDeptName($deptnos as element()*) as element()*
{
	for 	$d 
	in 		$deptnos
	return 	<department deptno="{$d}">
				<name>
					{data((doc("v-depts.xml")//department[deptno=$d]/deptname))}
				</name>
			</department>	
};

declare function util:getManagersHistory($mgrnos as element()*, $from as xs:date, $to as xs:date) as element()*
{
	for 	$m 
	in 		$mgrnos
	return 	<manager from="{util:max(xs:date($m/@tstart), $from)}" to="{util:min(xs:date($m/@tend), $to)}" mgrno="{$m}">
				<mgno>{data($m)}</mgno>
			</manager>
};

declare function util:getDept($deptnos as element()*) as element()*
{
	for 	$d 
	in 		$deptnos
	return 	<department deptno="{$d}">
				<name>
					{data((doc("v-depts.xml")//department[deptno=$d]/deptname))}
				</name>
				<start>
					{data((doc("v-depts.xml")//department[deptno=$d]/deptno/@tstart))}
				</start>
				<end>
					{data((doc("v-depts.xml")//department[deptno=$d]/deptno/@tend))}
				</end>
			</department>	
};