<suggestions>
{
for $duplicate_pair in doc("duplicates-system3.xml")//duplicate
let $scenario1 := $duplicate_pair/hit/@scenario
let $scenario2 := $duplicate_pair/hitd/@scenario

let $steps_scenario1 := doc("scenarios.xml")/scenarios/scenario[@title = $scenario1]                
                                              
let $steps_scenario2 := doc("scenarios.xml")/scenarios/scenario[@title = $scenario2]                        
                          

let $first_given_wording := $steps_scenario1/Given/step
let $first_when_wording := $steps_scenario1/When/step
let $first_then_wording := $steps_scenario1/Then/step

let $second_given_wording := $steps_scenario2/Given/step
let $second_when_wording := $steps_scenario2/When/step
let $second_then_wording := $steps_scenario2/Then/step

let $all_keywords := doc("scenarios.xml")//step-keywords

let $given_diff := not(deep-equal($first_given_wording, $second_given_wording)) and
                   deep-equal($first_when_wording, $second_when_wording) and
                   deep-equal($first_then_wording, $second_then_wording)
                   
let $when_diff := deep-equal($first_given_wording, $second_given_wording) and
                  not(deep-equal($first_when_wording, $second_when_wording)) and
                  deep-equal($first_then_wording, $second_then_wording)
                  
let $then_diff := deep-equal($first_given_wording, $second_given_wording) and
                  deep-equal($first_when_wording, $second_when_wording) and
                  not(deep-equal($first_then_wording, $second_then_wording))
                  
let $when_then_diff := deep-equal($first_given_wording, $second_given_wording) and
                   not(deep-equal($first_when_wording, $second_when_wording)) and
                   not(deep-equal($first_then_wording, $second_then_wording))
                   
let $given_then_diff := not(deep-equal($first_given_wording, $second_given_wording)) and
                   deep-equal($first_when_wording, $second_when_wording) and
                   not(deep-equal($first_then_wording, $second_then_wording))
                   
let $given_when_diff := not(deep-equal($first_given_wording, $second_given_wording)) and
                   not(deep-equal($first_when_wording, $second_when_wording)) and
                   deep-equal($first_then_wording, $second_then_wording)
                   
let $given_when_then_diff := not(deep-equal($first_given_wording, $second_given_wording)) and
                   not(deep-equal($first_when_wording, $second_when_wording)) and
                   not(deep-equal($first_then_wording, $second_then_wording))

return
if($given_diff) then (
let $sc1 := $steps_scenario1/Given//step-keywords
let $sc2 := $steps_scenario2/Given//step-keywords

let $keyword_counts1 := for $keyword1 in distinct-values($sc1)
                    return count($all_keywords[. = $keyword1])          
   
let $keyword_counts2 := for $keyword2 in distinct-values($sc2)
                    return count($all_keywords[. = $keyword2])       
return
     if(sum($keyword_counts1) = sum($keyword_counts2)) then
      (
        <suggestion>
          <delete-scenario-with> {$steps_scenario1/@title} </delete-scenario-with>
          <in>{$steps_scenario1/@feature}</in>
          <diff-given-keywords-usage-aggregate>{sum($keyword_counts1)}</diff-given-keywords-usage-aggregate>
          <or/>
          <delete-scenario-with> {$steps_scenario2/@title} </delete-scenario-with>
          <in> {$steps_scenario2/@feature}</in>
          <diff-given-keywords-usage-aggregate>{sum($keyword_counts2)} </diff-given-keywords-usage-aggregate>
        </suggestion>, '&#xa;'
       )
       else if(sum($keyword_counts1) > sum($keyword_counts2)) then
       (
       <suggestion>
          <delete-scenario-with> {$steps_scenario2/@title}</delete-scenario-with>
          <in>{$steps_scenario2/@feature}</in>
          <diff-given-keywords-usage-aggregate>{sum($keyword_counts2)}</diff-given-keywords-usage-aggregate>
          <and/>
          <keep-scenario-with>{$steps_scenario1/@title}</keep-scenario-with>
          <in> {$steps_scenario1/@feature}</in>
          <diff-given-keywords-usage-aggregate>{sum($keyword_counts1)} </diff-given-keywords-usage-aggregate>
       </suggestion>, '&#xa;'
       )
       else (
       <suggestion>
          <delete-scenario-with>{$steps_scenario1/@title}</delete-scenario-with>
          <in>{$steps_scenario1/@feature}</in>
          <diff-given-keywords-usage-aggregate>{sum($keyword_counts1)}</diff-given-keywords-usage-aggregate>
          <and/>
          <keep-scenario-with> {$steps_scenario2/@title} </keep-scenario-with>
          <in> {$steps_scenario2/@feature}</in>
          <diff-given-keywords-usage-aggregate>{sum($keyword_counts2)} </diff-given-keywords-usage-aggregate>
       </suggestion>, '&#xa;'
       )     
)
else if($when_diff) then (
let $sc1 := $steps_scenario1/When//step-keywords
let $sc2 := $steps_scenario2/When//step-keywords

let $keyword_counts1 := for $keyword1 in distinct-values($sc1)
                    return count($all_keywords[. = $keyword1])          
   
let $keyword_counts2 := for $keyword2 in distinct-values($sc2)
                    return count($all_keywords[. = $keyword2])       
return
     if(sum($keyword_counts1) = sum($keyword_counts2)) then
      (
        <suggestion>
          <delete-scenario-with> {$steps_scenario1/@title} </delete-scenario-with>
          <in>{$steps_scenario1/@feature}</in>
          <diff-when-keywords-usage-aggregate>{sum($keyword_counts1)}</diff-when-keywords-usage-aggregate>
          <or/>
          <delete-scenario-with> {$steps_scenario2/@title} </delete-scenario-with>
          <in> {$steps_scenario2/@feature}</in>
          <diff-when-keywords-usage-aggregate>{sum($keyword_counts2)}</diff-when-keywords-usage-aggregate>
        </suggestion>, '&#xa;'
       )
       else if(sum($keyword_counts1) > sum($keyword_counts2)) then
       (
       <suggestion>
          <delete-scenario-with> {$steps_scenario2/@title}</delete-scenario-with>
          <in>{$steps_scenario2/@feature}</in>
          <diff-when-keywords-usage-aggregate>{sum($keyword_counts2)}</diff-when-keywords-usage-aggregate>
          <and/>
          <keep-scenario-with>{$steps_scenario1/@title}</keep-scenario-with>
          <in> {$steps_scenario1/@feature}</in>
          <diff-when-keywords-usage-aggregate>{sum($keyword_counts1)} </diff-when-keywords-usage-aggregate>
       </suggestion>, '&#xa;'
       )
       else (
       <suggestion>
          <delete-scenario-with>{$steps_scenario1/@title}</delete-scenario-with>
          <in>{$steps_scenario1/@feature}</in>
          <diff-when-keywords-usage-aggregate>{sum($keyword_counts1)}</diff-when-keywords-usage-aggregate>
          <and/>
          <keep-scenario-with> {$steps_scenario2/@title} </keep-scenario-with>
          <in> {$steps_scenario2/@feature}</in>
          <diff-when-keywords-usage-aggregate>{sum($keyword_counts2)}</diff-when-keywords-usage-aggregate>
       </suggestion>, '&#xa;'
       )
) else if($then_diff) then (
let $sc1 := $steps_scenario1/Then//step-keywords
let $sc2 := $steps_scenario2/Then//step-keywords

let $keyword_counts1 := for $keyword1 in distinct-values($sc1)
                    return count($all_keywords[. = $keyword1])          
   
let $keyword_counts2 := for $keyword2 in distinct-values($sc2)
                    return count($all_keywords[. = $keyword2])       
return
     if(sum($keyword_counts1) = sum($keyword_counts2)) then
      (
        <suggestion>
          <delete-scenario-with> {$steps_scenario1/@title} </delete-scenario-with>
          <in>{$steps_scenario1/@feature}</in>
          <diff-then-keywords-usage-aggregate>{sum($keyword_counts1)}</diff-then-keywords-usage-aggregate>
          <or/>
          <delete-scenario-with> {$steps_scenario2/@title} </delete-scenario-with>
          <in> {$steps_scenario2/@feature}</in>
          <diff-then-keywords-usage-aggregate>{sum($keyword_counts2)} </diff-then-keywords-usage-aggregate>
        </suggestion>, '&#xa;'
       )
       else if(sum($keyword_counts1) > sum($keyword_counts2)) then
       (
       <suggestion>
          <delete-scenario-with> {$steps_scenario2/@title}</delete-scenario-with>
          <in>{$steps_scenario2/@feature}</in>
          <diff-then-keywords-usage-aggregate>{sum($keyword_counts2)}</diff-then-keywords-usage-aggregate>
          <and/>
          <keep-scenario-with>{$steps_scenario1/@title}</keep-scenario-with>
          <in> {$steps_scenario1/@feature}</in>
          <diff-then-keywords-usage-aggregate>{sum($keyword_counts1)} </diff-then-keywords-usage-aggregate>
       </suggestion>, '&#xa;'
       )
       else (
       <suggestion>
          <delete-scenario-with>{$steps_scenario1/@title}</delete-scenario-with>
          <in>{$steps_scenario1/@feature}</in>
          <diff-then-keywords-usage-aggregate>{sum($keyword_counts1)}</diff-then-keywords-usage-aggregate>
          <and/>
          <keep-scenario-with> {$steps_scenario2/@title} </keep-scenario-with>
          <in> {$steps_scenario2/@feature}</in>
          <diff-then-keywords-usage-aggregate>{sum($keyword_counts2)} </diff-then-keywords-usage-aggregate>
       </suggestion>, '&#xa;'
       )
)else if($when_then_diff) then (
let $sc1 := $steps_scenario1/When//step-keywords union $steps_scenario1/Then//step-keywords
let $sc2 := $steps_scenario2/When//step-keywords union $steps_scenario2/Then//step-keywords

let $keyword_counts1 := for $keyword1 in distinct-values($sc1)
                    return count($all_keywords[. = $keyword1])          
   
let $keyword_counts2 := for $keyword2 in distinct-values($sc2)
                    return count($all_keywords[. = $keyword2])       
return
     if(sum($keyword_counts1) = sum($keyword_counts2)) then
      (
        <suggestion>
          <delete-scenario-with> {$steps_scenario1/@title} </delete-scenario-with>
          <in>{$steps_scenario1/@feature}</in>
          <diff-when-then-keywords-usage-aggregate>{sum($keyword_counts1)}</diff-when-then-keywords-usage-aggregate>
          <or/>
          <delete-scenario-with> {$steps_scenario2/@title} </delete-scenario-with>
          <in> {$steps_scenario2/@feature}</in>
          <diff-when-then-keywords-usage-aggregate>{sum($keyword_counts2)}</diff-when-then-keywords-usage-aggregate>
        </suggestion>, '&#xa;'
       )
       else if(sum($keyword_counts1) > sum($keyword_counts2)) then
       (
       <suggestion>
          <delete-scenario-with> {$steps_scenario2/@title}</delete-scenario-with>
          <in>{$steps_scenario2/@feature}</in>
          <diff-when-then-keywords-usage-aggregate>{sum($keyword_counts2)}</diff-when-then-keywords-usage-aggregate>
          <and/>
          <keep-scenario-with>{$steps_scenario1/@title}</keep-scenario-with>
          <in> {$steps_scenario1/@feature}</in>
          <diff-when-then-keywords-usage-aggregate>{sum($keyword_counts1)} </diff-when-then-keywords-usage-aggregate>
       </suggestion>, '&#xa;'
       )
       else (
       <suggestion>
          <delete-scenario-with>{$steps_scenario1/@title}</delete-scenario-with>
          <in>{$steps_scenario1/@feature}</in>
          <diff-when-then-keywords-usage-aggregate>{sum($keyword_counts1)}</diff-when-then-keywords-usage-aggregate>
          <and/>
          <keep-scenario-with> {$steps_scenario2/@title} </keep-scenario-with>
          <in> {$steps_scenario2/@feature}</in>
          <diff-when-then-keywords-usage-aggregate>{sum($keyword_counts2)} </diff-when-then-keywords-usage-aggregate>
       </suggestion>, '&#xa;'
       )
)
else if($given_then_diff) then (
let $sc1 := $steps_scenario1/Given//step-keywords union $steps_scenario1/Then//step-keywords
let $sc2 := $steps_scenario2/Given//step-keywords union $steps_scenario2/Then//step-keywords

let $keyword_counts1 := for $keyword1 in distinct-values($sc1)
                    return count($all_keywords[. = $keyword1])          
   
let $keyword_counts2 := for $keyword2 in distinct-values($sc2)
                    return count($all_keywords[. = $keyword2])       
return
     if(sum($keyword_counts1) = sum($keyword_counts2)) then
      (
        <suggestion>
          <delete-scenario-with> {$steps_scenario1/@title} </delete-scenario-with>
          <in>{$steps_scenario1/@feature}</in>
          <diff-given-then-keywords-usage-aggregate>{sum($keyword_counts1)}</diff-given-then-keywords-usage-aggregate>
          <or/>
          <delete-scenario-with> {$steps_scenario2/@title} </delete-scenario-with>
          <in> {$steps_scenario2/@feature}</in>
          <diff-given-then-keywords-usage-aggregate>{sum($keyword_counts2)} </diff-given-then-keywords-usage-aggregate>
        </suggestion>, '&#xa;'
       )
       else if(sum($keyword_counts1) > sum($keyword_counts2)) then
       (
       <suggestion>
          <delete-scenario-with> {$steps_scenario2/@title}</delete-scenario-with>
          <in>{$steps_scenario2/@feature}</in>
          <diff-given-then-keywords-usage-aggregate>{sum($keyword_counts2)}</diff-given-then-keywords-usage-aggregate>
          <and/>
          <keep-scenario-with>{$steps_scenario1/@title}</keep-scenario-with>
          <in> {$steps_scenario1/@feature}</in>
          <diff-given-then-keywords-usage-aggregate>{sum($keyword_counts1)} </diff-given-then-keywords-usage-aggregate>
       </suggestion>, '&#xa;'
       )
       else (
       <suggestion>
          <delete-scenario-with>{$steps_scenario1/@title}</delete-scenario-with>
          <in>{$steps_scenario1/@feature}</in>
          <diff-given-then-keywords-usage-aggregate>{sum($keyword_counts1)}</diff-given-then-keywords-usage-aggregate>
          <and/>
          <keep-scenario-with> {$steps_scenario2/@title} </keep-scenario-with>
          <in> {$steps_scenario2/@feature}</in>
          <diff-given-then-keywords-usage-aggregate>{sum($keyword_counts2)} </diff-given-then-keywords-usage-aggregate>
       </suggestion>, '&#xa;'
       )
)
else if($given_when_diff) then (
let $sc1 := $steps_scenario1/Given//step-keywords union $steps_scenario1/When//step-keywords
let $sc2 := $steps_scenario2/Given//step-keywords union $steps_scenario2/When//step-keywords

let $keyword_counts1 := for $keyword1 in distinct-values($sc1)
                    return count($all_keywords[. = $keyword1])          
   
let $keyword_counts2 := for $keyword2 in distinct-values($sc2)
                    return count($all_keywords[. = $keyword2])       
return
     if(sum($keyword_counts1) = sum($keyword_counts2)) then
      (
        <suggestion>
          <delete-scenario-with> {$steps_scenario1/@title} </delete-scenario-with>
          <in>{$steps_scenario1/@feature}</in>
          <diff-given-when-keywords-usage-aggregate>{sum($keyword_counts1)}</diff-given-when-keywords-usage-aggregate>
          <or/>
          <delete-scenario-with> {$steps_scenario2/@title} </delete-scenario-with>
          <in> {$steps_scenario2/@feature}</in>
          <diff-given-when-keywords-usage-aggregate>{sum($keyword_counts2)} </diff-given-when-keywords-usage-aggregate>
        </suggestion>, '&#xa;'
       )
       else if(sum($keyword_counts1) > sum($keyword_counts2)) then
       (
       <suggestion>
          <delete-scenario-with> {$steps_scenario2/@title}</delete-scenario-with>
          <in>{$steps_scenario2/@feature}</in>
          <diff-given-when-keywords-usage-aggregate>{sum($keyword_counts2)}</diff-given-when-keywords-usage-aggregate>
          <and/>
          <keep-scenario-with>{$steps_scenario1/@title}</keep-scenario-with>
          <in> {$steps_scenario1/@feature}</in>
          <diff-given-when-keywords-usage-aggregate>{sum($keyword_counts1)} </diff-given-when-keywords-usage-aggregate>
       </suggestion>, '&#xa;'
       )
       else (
       <suggestion>
          <delete-scenario-with>{$steps_scenario1/@title}</delete-scenario-with>
          <in>{$steps_scenario1/@feature}</in>
          <diff-given-when-keywords-usage-aggregate>{sum($keyword_counts1)}</diff-given-when-keywords-usage-aggregate>
          <and/>
          <keep-scenario-with> {$steps_scenario2/@title} </keep-scenario-with>
          <in> {$steps_scenario2/@feature}</in>
          <diff-given-when-keywords-usage-aggregate>{sum($keyword_counts2)} </diff-given-when-keywords-usage-aggregate>
       </suggestion>, '&#xa;'
       )
)
else if($given_when_then_diff) then (
let $sc1 := $steps_scenario1/Given//step-keywords union $steps_scenario1/When//step-keywords union $steps_scenario1/Then//step-keywords
let $sc2 := $steps_scenario2/Given//step-keywords union $steps_scenario2/When//step-keywords union $steps_scenario2/Then//step-keywords

let $keyword_counts1 := for $keyword1 in distinct-values($sc1)
                    return count($all_keywords[. = $keyword1])          
   
let $keyword_counts2 := for $keyword2 in distinct-values($sc2)
                    return count($all_keywords[. = $keyword2])       
return
     if(sum($keyword_counts1) = sum($keyword_counts2)) then
      (
        <suggestion>
          <delete-scenario-with> {$steps_scenario1/@title} </delete-scenario-with>
          <in>{$steps_scenario1/@feature}</in>
          <diff-given-when-then-keywords-usage-aggregate>{sum($keyword_counts1)}</diff-given-when-then-keywords-usage-aggregate>
          <or/>
          <delete-scenario-with> {$steps_scenario2/@title} </delete-scenario-with>
          <in> {$steps_scenario2/@feature}</in>
          <diff-given-when-then-keywords-usage-aggregate>{sum($keyword_counts2)} </diff-given-when-then-keywords-usage-aggregate>
        </suggestion>, '&#xa;'
       )
       else if(sum($keyword_counts1) > sum($keyword_counts2)) then
       (
       <suggestion>
          <delete-scenario-with> {$steps_scenario2/@title}</delete-scenario-with>
          <in>{$steps_scenario2/@feature}</in>
          <diff-given-when-then-keywords-usage-aggregate>{sum($keyword_counts2)}</diff-given-when-then-keywords-usage-aggregate>
          <and/>
          <keep-scenario-with>{$steps_scenario1/@title}</keep-scenario-with>
          <in> {$steps_scenario1/@feature}</in>
          <diff-given-when-then-keywords-usage-aggregate>{sum($keyword_counts1)} </diff-given-when-then-keywords-usage-aggregate>
       </suggestion>, '&#xa;'
       )
       else (
       <suggestion>
          <delete-scenario-with>{$steps_scenario1/@title}</delete-scenario-with>
          <in>{$steps_scenario1/@feature}</in>
          <diff-given-when-then-keywords-usage-aggregate>{sum($keyword_counts1)}</diff-given-when-then-keywords-usage-aggregate>
          <and/>
          <keep-scenario-with> {$steps_scenario2/@title} </keep-scenario-with>
          <in> {$steps_scenario2/@feature}</in>
          <diff-given-when-then-keywords-usage-aggregate>{sum($keyword_counts2)} </diff-given-when-then-keywords-usage-aggregate>
       </suggestion>, '&#xa;'
       )
)    
else (        
)

 }
</suggestions>