<traces>
{
for $trace1 in doc("et_run1_vs_run2.xml")//trace,
$trace2 in doc("et_run1_vs_run3.xml")//trace,
$trace3 in doc("et_run1_vs_run4.xml")//trace,
$trace4 in doc("et_run1_vs_run5.xml")//trace

let $et1 := for $a in $trace1/statement
return data($a)
let $et2 := for $b in $trace2/statement
return data($b)
let $et3 := for $c in $trace3/statement
return data($c)
let $et4 := for $d in $trace4/statement
return data($d)

where (string-join($et1,'') eq string-join($et2,'')) and (string-join($et2,'') eq string-join($et3,'')) and
(string-join($et3,'') eq string-join($et4,''))
 
return <trace scenario="{$trace1/@scenario}" feature="{$trace1/@feature}">
          <statement>{$et1}</statement>          
       </trace>
       }
</traces>