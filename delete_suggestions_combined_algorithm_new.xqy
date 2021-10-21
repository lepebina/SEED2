declare namespace functx = "http://www.functx.com";
declare function functx:escape-for-regex
  ( $arg as xs:string? )  as xs:string {

   replace($arg,
           '(\.|\[|\]|\\|\||\-|\^|\$|\?|\*|\+|\{|\}|\(|\))','\\$1')
 } ;


declare function functx:contains-word
  ( $arg as xs:string? ,
    $word as xs:string )  as xs:boolean {

   matches(upper-case($arg),
           concat('^(.*\W)?',
                     upper-case(functx:escape-for-regex($word)),
                     '(\W.*)?$'))
 } ;


<suggestions>
{
for $duplicate_pair in doc("duplicates-system3.xml")//duplicate
let $scenario1 := $duplicate_pair/hit/@scenario
let $scenario2 := $duplicate_pair/hitd/@scenario

let $steps_scenario1 := doc("scenarios.xml")/scenarios/scenario[@title = $scenario1]                
                                              
let $steps_scenario2 := doc("scenarios.xml")/scenarios/scenario[@title = $scenario2] 

(:the immediate block of 11 lines are specifically for conservation of proper abstraction:)
let $steps_scenario11 := doc("trace.xml")/traces/trace[@scenario = $scenario1]    
let $steps_scenario22 := doc("trace.xml")/traces/trace[@scenario = $scenario2] 
let $for_sc1_steps := doc("scenarios.xml")/scenarios/scenario[@title = $scenario1] 
let $for_sc2_steps := doc("scenarios.xml")/scenarios/scenario[@title = $scenario2]
let $all_steps_count := count(doc("scenarios.xml")//step)
let $all_glue_stmts_count := count(doc("trace.xml")//statement)
let $avg_stmts_per_step := $all_glue_stmts_count div $all_steps_count
let $sc1_avg_glue_stmts_per_step := count($steps_scenario11//statement) div count($for_sc1_steps//step)
let $sc2_avg_glue_stmts_per_step := count($steps_scenario22//statement) div count($for_sc2_steps//step)
let $sc1_abstraction_distance := abs($avg_stmts_per_step - $sc1_avg_glue_stmts_per_step)
let $sc2_abstraction_distance := abs($avg_stmts_per_step - $sc2_avg_glue_stmts_per_step)                      
                 
let $first_given_wording := $steps_scenario1/Given/step
let $first_when_wording := $steps_scenario1/When/step
let $first_then_wording := $steps_scenario1/Then/step

let $second_given_wording := $steps_scenario2/Given/step
let $second_when_wording := $steps_scenario2/When/step
let $second_then_wording := $steps_scenario2/Then/step

let $all_steps := doc("scenarios.xml")//step
let $all_keywords := doc("scenarios.xml")//step-keywords

let $total_redundancy := deep-equal($first_given_wording, $second_given_wording) and
                   deep-equal($first_when_wording, $second_when_wording) and
                   deep-equal($first_then_wording, $second_then_wording)
 let $total_redundancy_message := 'Exactly the same'
 
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
                   
 let $tech_words := ("cache", "refresh", "button", "click", "database", "link", "links", "http", "invalid_url",
 "sub_page", "sub_url", "admin", "api", "autocomplete", "baseurl", "bdd",  "configure", "cookie",
  "crlf_injection.xml", "httpon", "insecure_methods.xml", "log", "os", "os_injection.xml",
   "padding_oracle.xml", "page", "passive.xml", "redirect", "redirect.xml", "sfi.xml", "shell_shock.xml",
    "site", "sql_injection.xml", "ss_code_injection.xml", "ssi.xml", "source_disclosure.xml", "url",
     "www.continuumsecurity.net", "xml", "xpath", "xpath_injection.xml", "xss.xml", "xxe.xml", "assert",
      "box", "checkbox", "dropdown", "import", "java", "mouse", "tab", "textbox", "uncheck",
       "url", "website", "bar", "sidebar", "side bar", "menu", "icon", "link", "os", "portrait", "drop down", "select list",
        "text box", "radio button", "check box", "window", "pop up", "pop-up", "screen","DB"
        )
        
        let $key_words := ("game", "generate", "get", "grant", "greeting", "group","handle", "helloandofftbarboutsala",
"help","id", "identification", "inactive", "info", "input", "invalid", "invitation", "january", "kalli", "key", "keyword",
"lang", "langcode","language","launch", "list","mano", "mark","mary", "member", "message", "messages", "mo", "msidn",
 "msisdn", "msisdntest","navigation", "new", "nick", "no", "note", "number", "obtained","offset","ok","optin","ordered",
"original","personality", "personalityquizendofsession","personalityquizpool","personalitysubscription","personalitysubscriptionwelcome",
"personaltysubcription","phone","play","point","pre","previous","process","profile","quit","receive","received","refresshe","register",
"remove","replace","reply","request","respond","response","scenario","scheme","score","send","sent","service","set","shorcode", "short",
"shortcode","smart","sms","someone","sophie","sq","start","status","stop","string","stupid","subday","subdaytest","subid","submit","subscibe",
"subscribe","subscripion","subscription","subscrition","subsribe","success", "summary","sunscribe","system","teaser","telecom",
"telekomcamapign","text", "time","today", "today","todaytest","todo","totalcharge","trigger","twice","type","unprofiled","unsubscribe",
"unsubscribed","update","use","user","userinfo","valid","value","wait","wants","week","welcome","without","word","words","yes","yet"
        )

        
return
if($total_redundancy) then (
       <suggestion>
          <delete-scenario-with> {$steps_scenario1/@title} </delete-scenario-with>
          <in>{$steps_scenario1/@feature}</in>
          <or/>
          <delete-scenario-with> {$steps_scenario2/@title} </delete-scenario-with>
          <in> {$steps_scenario2/@feature}</in>
          <remark>{$total_redundancy_message}</remark>
       </suggestion>, '&#xa;'    
 )
else if($given_diff) then (
let $sc1 := $steps_scenario1/Given//step
let $sc2 := $steps_scenario2/Given//step

let $step_counts1 := for $step1 in distinct-values($sc1)
                    return count($all_steps[. = $step1])          
   
let $step_counts2 := for $step2 in distinct-values($sc2)
                    return count($all_steps[. = $step2])       
return
     if(sum($step_counts1) = sum($step_counts2)) then
      (
       let $sc1 := $steps_scenario1/Given//step union $steps_scenario1/When//step union $steps_scenario1/Then//step
       let $sc2 := $steps_scenario2/Given//step union $steps_scenario2/When//step union $steps_scenario2/Then//step

       let $keyword_counts1 := for $step1 in distinct-values($sc1), $kw1 in $key_words     
                                where functx:contains-word($step1, $kw1)
                               return $kw1
          
        let $keyword_counts2 := for $step2 in distinct-values($sc2), $kw2 in $key_words     
                                where functx:contains-word($step2, $kw2)
                               return $kw2      
     return
      if(count($keyword_counts1) = count($keyword_counts2)) then
      (:invoke the tech elimination principle:)
      (
        let $sc1 := $steps_scenario1/Given//step union $steps_scenario1/When//step union $steps_scenario1/Then//step
        let $sc2 := $steps_scenario2/Given//step union $steps_scenario2/When//step union $steps_scenario2/Then//step

          let $tech_counts1 := for $step1 in distinct-values($sc1), $tw1 in $tech_words     
                                where functx:contains-word($step1, $tw1)
                               return $tw1
          
          let $tech_counts2 := for $step2 in distinct-values($sc2), $tw2 in $tech_words     
                                where functx:contains-word($step2, $tw2)
                               return $tw2
    return
     if(count($tech_counts1) = count($tech_counts2)) then
     (:invoke the principle of conservation of abstraction:)
      (         
   
     if($sc1_abstraction_distance = $sc2_abstraction_distance) then
      (
        <suggestion>
          <delete-scenario-with>{$steps_scenario1/@title}</delete-scenario-with>
          <in>{$steps_scenario1/@feature}</in>
          <abstraction-distance>{$sc1_abstraction_distance}</abstraction-distance>
          <all-glue-statements-count>{$all_glue_stmts_count}</all-glue-statements-count>
          <average-statements-per-step>{$avg_stmts_per_step}</average-statements-per-step>
          <scenario1-avg-glue-statements-per-step>{$sc1_avg_glue_stmts_per_step}</scenario1-avg-glue-statements-per-step>
          <scenario2-avg-glue-statements-per-step>{$sc2_avg_glue_stmts_per_step}</scenario2-avg-glue-statements-per-step>
          <or/>
          <delete-scenario-with> {$steps_scenario2/@title}</delete-scenario-with>
          <in> {$steps_scenario2/@feature}</in>
          <abstraction-distance>{$sc2_abstraction_distance}</abstraction-distance>
        </suggestion>, '&#xa;'
       )
       else if($sc1_abstraction_distance > $sc2_abstraction_distance) then
       (
       <suggestion>
          <delete-scenario-with> {$steps_scenario1/@title}</delete-scenario-with>
          <in>{$steps_scenario1/@feature}</in>
          <abstraction-distance>{$sc1_abstraction_distance}</abstraction-distance>
          <and/>
          <keep-scenario-with>{$steps_scenario2/@title}</keep-scenario-with>
          <in> {$steps_scenario2/@feature}</in>
          <abstraction-distance>{$sc2_abstraction_distance}</abstraction-distance>
       </suggestion>, '&#xa;'
       )
       else (
       <suggestion>
          <delete-scenario-with>{$steps_scenario2/@title}</delete-scenario-with>
          <in>{$steps_scenario2/@feature}</in>
         <abstraction-distance>{$sc2_abstraction_distance}</abstraction-distance>
          <and/>
          <keep-scenario-with> {$steps_scenario1/@title} </keep-scenario-with>
          <in> {$steps_scenario1/@feature}</in>
          <abstraction-distance>{$sc1_abstraction_distance}</abstraction-distance>
       </suggestion>, '&#xa;'
       )     
     )
       else if(count($tech_counts2) > count($tech_counts1)) then
       (
       <suggestion>
          <delete-scenario-with> {$steps_scenario2/@title}</delete-scenario-with>
          <in>{$steps_scenario2/@feature}</in>
          <tech-word-count>{count($tech_counts2)}</tech-word-count>
          <tech-words>{$tech_counts2}</tech-words>
          <and/>
          <keep-scenario-with>{$steps_scenario1/@title}</keep-scenario-with>
          <in> {$steps_scenario1/@feature}</in>
          <tech-word-count>{count($tech_counts1)}</tech-word-count>
          <tech-words>{$tech_counts1}</tech-words>
       </suggestion>, '&#xa;'
       )
       else (
       <suggestion>
          <delete-scenario-with>{$steps_scenario1/@title}</delete-scenario-with>
          <in>{$steps_scenario1/@feature}</in>
          <tech-word-count>{count($tech_counts1)}</tech-word-count>
          <tech-words>{$tech_counts1}</tech-words>
          <and/>
          <keep-scenario-with> {$steps_scenario2/@title} </keep-scenario-with>
          <in> {$steps_scenario2/@feature}</in>
          <tech-word-count>{count($tech_counts2)} </tech-word-count>
          <tech-words>{$tech_counts2}</tech-words>
       </suggestion>, '&#xa;'
       )     
      )
       else if(count($keyword_counts1) > count($keyword_counts2)) then
       (
       <suggestion>
          <delete-scenario-with> {$steps_scenario2/@title}</delete-scenario-with>
          <in>{$steps_scenario2/@feature}</in>
          <diff-given-keywords-usage-aggregate>{count($keyword_counts2)}</diff-given-keywords-usage-aggregate>
          <and/>
          <keep-scenario-with>{$steps_scenario1/@title}</keep-scenario-with>
          <in> {$steps_scenario1/@feature}</in>
          <diff-given-keywords-usage-aggregate>{count($keyword_counts1)} </diff-given-keywords-usage-aggregate>
       </suggestion>, '&#xa;'
       )
       else (
       <suggestion>
          <delete-scenario-with>{$steps_scenario1/@title}</delete-scenario-with>
          <in>{$steps_scenario1/@feature}</in>
          <diff-given-keywords-usage-aggregate>{count($keyword_counts1)}</diff-given-keywords-usage-aggregate>
          <and/>
          <keep-scenario-with> {$steps_scenario2/@title} </keep-scenario-with>
          <in> {$steps_scenario2/@feature}</in>
          <diff-given-keywords-usage-aggregate>{count($keyword_counts2)} </diff-given-keywords-usage-aggregate>
       </suggestion>, '&#xa;'
       )     

       )
       else if(sum($step_counts1) > sum($step_counts2)) then
       (
       <suggestion>
          <delete-scenario-with> {$steps_scenario2/@title}</delete-scenario-with>
          <in>{$steps_scenario2/@feature}</in>
          <diff-given-steps-usage-aggregate>{sum($step_counts2)}</diff-given-steps-usage-aggregate>
          <and/>
          <keep-scenario-with>{$steps_scenario1/@title}</keep-scenario-with>
          <in> {$steps_scenario1/@feature}</in>
          <diff-given-steps-usage-aggregate>{sum($step_counts1)} </diff-given-steps-usage-aggregate>
       </suggestion>, '&#xa;'
       )
       else (
       <suggestion>
          <delete-scenario-with>{$steps_scenario1/@title}</delete-scenario-with>
          <in>{$steps_scenario1/@feature}</in>
          <diff-given-steps-usage-aggregate>{sum($step_counts1)}</diff-given-steps-usage-aggregate>
          <and/>
          <keep-scenario-with> {$steps_scenario2/@title} </keep-scenario-with>
          <in> {$steps_scenario2/@feature}</in>
          <diff-given-steps-usage-aggregate>{sum($step_counts2)} </diff-given-steps-usage-aggregate>
       </suggestion>, '&#xa;'
       )     
)
else if($when_diff) then (
let $sc1 := $steps_scenario1/When//step
let $sc2 := $steps_scenario2/When//step

let $step_counts1 := for $step1 in distinct-values($sc1)
                    return count($all_steps[. = $step1])          
   
let $step_counts2 := for $step2 in distinct-values($sc2)
                    return count($all_steps[. = $step2])      
return
     if(sum($step_counts1) = sum($step_counts2)) then
      (
       let $sc1 := $steps_scenario1/Given//step union $steps_scenario1/When//step union $steps_scenario1/Then//step
       let $sc2 := $steps_scenario2/Given//step union $steps_scenario2/When//step union $steps_scenario2/Then//step

       let $keyword_counts1 := for $step1 in distinct-values($sc1), $kw1 in $key_words     
                                where functx:contains-word($step1, $kw1)
                               return $kw1
          
        let $keyword_counts2 := for $step2 in distinct-values($sc2), $kw2 in $key_words     
                                where functx:contains-word($step2, $kw2)
                               return $kw2         
  return
     if(count($keyword_counts1) = count($keyword_counts2)) then
     (:invoke the tech elimination principle:)
      (
        let $sc1 := $steps_scenario1/Given//step union $steps_scenario1/When//step union $steps_scenario1/Then//step
        let $sc2 := $steps_scenario2/Given//step union $steps_scenario2/When//step union $steps_scenario2/Then//step

          let $tech_counts1 := for $step1 in distinct-values($sc1), $tw1 in $tech_words     
                                where functx:contains-word($step1, $tw1)
                               return $tw1
          
          let $tech_counts2 := for $step2 in distinct-values($sc2), $tw2 in $tech_words     
                                where functx:contains-word($step2, $tw2)
                               return $tw2
    return
     if(count($tech_counts1) = count($tech_counts2)) then
     (:invoke the principle of conservation of abstraction:)
      (        
        if($sc1_abstraction_distance = $sc2_abstraction_distance) then
      (
        <suggestion>
          <delete-scenario-with>{$steps_scenario1/@title}</delete-scenario-with>
          <in>{$steps_scenario1/@feature}</in>
          <abstraction-distance>{$sc1_abstraction_distance}</abstraction-distance>
          <all-glue-statements-count>{$all_glue_stmts_count}</all-glue-statements-count>
          <average-statements-per-step>{$avg_stmts_per_step}</average-statements-per-step>
          <scenario1-avg-glue-statements-per-step>{$sc1_avg_glue_stmts_per_step}</scenario1-avg-glue-statements-per-step>
          <scenario2-avg-glue-statements-per-step>{$sc2_avg_glue_stmts_per_step}</scenario2-avg-glue-statements-per-step>
          <or/>
          <delete-scenario-with> {$steps_scenario2/@title}</delete-scenario-with>
          <in> {$steps_scenario2/@feature}</in>
          <abstraction-distance>{$sc2_abstraction_distance}</abstraction-distance>
        </suggestion>, '&#xa;'
       )
       else if($sc1_abstraction_distance > $sc2_abstraction_distance) then
       (
       <suggestion>
          <delete-scenario-with> {$steps_scenario1/@title}</delete-scenario-with>
          <in>{$steps_scenario1/@feature}</in>
          <abstraction-distance>{$sc1_abstraction_distance}</abstraction-distance>
          <and/>
          <keep-scenario-with>{$steps_scenario2/@title}</keep-scenario-with>
          <in> {$steps_scenario2/@feature}</in>
          <abstraction-distance>{$sc2_abstraction_distance}</abstraction-distance>
       </suggestion>, '&#xa;'
       )
       else (
       <suggestion>
          <delete-scenario-with>{$steps_scenario2/@title}</delete-scenario-with>
          <in>{$steps_scenario2/@feature}</in>
         <abstraction-distance>{$sc2_abstraction_distance}</abstraction-distance>
          <and/>
          <keep-scenario-with> {$steps_scenario1/@title} </keep-scenario-with>
          <in> {$steps_scenario1/@feature}</in>
          <abstraction-distance>{$sc1_abstraction_distance}</abstraction-distance>
       </suggestion>, '&#xa;'
       )     
     )
       else if(count($tech_counts2) > count($tech_counts1)) then
       (
       <suggestion>
          <delete-scenario-with> {$steps_scenario2/@title}</delete-scenario-with>
          <in>{$steps_scenario2/@feature}</in>
          <tech-word-count>{count($tech_counts2)}</tech-word-count>
          <tech-words>{$tech_counts2}</tech-words>
          <and/>
          <keep-scenario-with>{$steps_scenario1/@title}</keep-scenario-with>
          <in> {$steps_scenario1/@feature}</in>
          <tech-word-count>{count($tech_counts1)}</tech-word-count>
          <tech-words>{$tech_counts1}</tech-words>
       </suggestion>, '&#xa;'
       )
       else (
       <suggestion>
          <delete-scenario-with>{$steps_scenario1/@title}</delete-scenario-with>
          <in>{$steps_scenario1/@feature}</in>
          <tech-word-count>{count($tech_counts1)}</tech-word-count>
          <tech-words>{$tech_counts1}</tech-words>
          <and/>
          <keep-scenario-with> {$steps_scenario2/@title} </keep-scenario-with>
          <in> {$steps_scenario2/@feature}</in>
          <tech-word-count>{count($tech_counts2)} </tech-word-count>
          <tech-words>{$tech_counts2}</tech-words>
       </suggestion>, '&#xa;'
       )     
       )
       else if(count($keyword_counts1) > count($keyword_counts2)) then
       (
       <suggestion>
          <delete-scenario-with> {$steps_scenario2/@title}</delete-scenario-with>
          <in>{$steps_scenario2/@feature}</in>
          <diff-when-keywords-usage-aggregate>{count($keyword_counts2)}</diff-when-keywords-usage-aggregate>
          <and/>
          <keep-scenario-with>{$steps_scenario1/@title}</keep-scenario-with>
          <in> {$steps_scenario1/@feature}</in>
          <diff-when-keywords-usage-aggregate>{count($keyword_counts1)} </diff-when-keywords-usage-aggregate>
       </suggestion>, '&#xa;'
       )
       else (
       <suggestion>
          <delete-scenario-with>{$steps_scenario1/@title}</delete-scenario-with>
          <in>{$steps_scenario1/@feature}</in>
          <diff-when-keywords-usage-aggregate>{count($keyword_counts1)}</diff-when-keywords-usage-aggregate>
          <and/>
          <keep-scenario-with> {$steps_scenario2/@title} </keep-scenario-with>
          <in> {$steps_scenario2/@feature}</in>
          <diff-when-keywords-usage-aggregate>{count($keyword_counts2)}</diff-when-keywords-usage-aggregate>
       </suggestion>, '&#xa;'
       )
       )
       else if(sum($step_counts1) > sum($step_counts2)) then
       (
       <suggestion>
          <delete-scenario-with> {$steps_scenario2/@title}</delete-scenario-with>
          <in>{$steps_scenario2/@feature}</in>
          <diff-when-steps-usage-aggregate>{sum($step_counts2)}</diff-when-steps-usage-aggregate>
          <and/>
          <keep-scenario-with>{$steps_scenario1/@title}</keep-scenario-with>
          <in> {$steps_scenario1/@feature}</in>
          <diff-when-steps-usage-aggregate>{sum($step_counts1)} </diff-when-steps-usage-aggregate>
       </suggestion>, '&#xa;'
       )
       else (
       <suggestion>
          <delete-scenario-with>{$steps_scenario1/@title}</delete-scenario-with>
          <in>{$steps_scenario1/@feature}</in>
          <diff-when-steps-usage-aggregate>{sum($step_counts1)}</diff-when-steps-usage-aggregate>
          <and/>
          <keep-scenario-with> {$steps_scenario2/@title} </keep-scenario-with>
          <in> {$steps_scenario2/@feature}</in>
          <diff-when-steps-usage-aggregate>{sum($step_counts2)}</diff-when-steps-usage-aggregate>
       </suggestion>, '&#xa;'
       )
) else if($then_diff) then (
let $sc1 := $steps_scenario1/Then//step
let $sc2 := $steps_scenario2/Then//step

let $step_counts1 := for $step1 in distinct-values($sc1)
                    return count($all_steps[. = $step1])          
   
let $step_counts2 := for $step2 in distinct-values($sc2)
                    return count($all_steps[. = $step2])       
return
     if(sum($step_counts1) = sum($step_counts2)) then
      (
        let $sc1 := $steps_scenario1/Given//step union $steps_scenario1/When//step union $steps_scenario1/Then//step
       let $sc2 := $steps_scenario2/Given//step union $steps_scenario2/When//step union $steps_scenario2/Then//step

       let $keyword_counts1 := for $step1 in distinct-values($sc1), $kw1 in $key_words     
                                where functx:contains-word($step1, $kw1)
                               return $kw1
          
        let $keyword_counts2 := for $step2 in distinct-values($sc2), $kw2 in $key_words     
                                where functx:contains-word($step2, $kw2)
                               return $kw2         
   return
     if(count($keyword_counts1) = count($keyword_counts2)) then
     (:invoke the tech elimination principle:)
      (
        let $sc1 := $steps_scenario1/Given//step union $steps_scenario1/When//step union $steps_scenario1/Then//step
        let $sc2 := $steps_scenario2/Given//step union $steps_scenario2/When//step union $steps_scenario2/Then//step

          let $tech_counts1 := for $step1 in distinct-values($sc1), $tw1 in $tech_words     
                                where functx:contains-word($step1, $tw1)
                               return $tw1
          
          let $tech_counts2 := for $step2 in distinct-values($sc2), $tw2 in $tech_words     
                                where functx:contains-word($step2, $tw2)
                               return $tw2
    return
     if(count($tech_counts1) = count($tech_counts2)) then
     (:invoke the principle of conservation of abstraction:)
      (
        
       if($sc1_abstraction_distance = $sc2_abstraction_distance) then
      (
        <suggestion>
          <delete-scenario-with>{$steps_scenario1/@title}</delete-scenario-with>
          <in>{$steps_scenario1/@feature}</in>
          <abstraction-distance>{$sc1_abstraction_distance}</abstraction-distance>
          <all-glue-statements-count>{$all_glue_stmts_count}</all-glue-statements-count>
          <average-statements-per-step>{$avg_stmts_per_step}</average-statements-per-step>
          <scenario1-avg-glue-statements-per-step>{$sc1_avg_glue_stmts_per_step}</scenario1-avg-glue-statements-per-step>
          <scenario2-avg-glue-statements-per-step>{$sc2_avg_glue_stmts_per_step}</scenario2-avg-glue-statements-per-step>
          <or/>
          <delete-scenario-with> {$steps_scenario2/@title}</delete-scenario-with>
          <in> {$steps_scenario2/@feature}</in>
          <abstraction-distance>{$sc2_abstraction_distance}</abstraction-distance>
        </suggestion>, '&#xa;'
       )
       else if($sc1_abstraction_distance > $sc2_abstraction_distance) then
       (
       <suggestion>
          <delete-scenario-with> {$steps_scenario1/@title}</delete-scenario-with>
          <in>{$steps_scenario1/@feature}</in>
          <abstraction-distance>{$sc1_abstraction_distance}</abstraction-distance>
          <and/>
          <keep-scenario-with>{$steps_scenario2/@title}</keep-scenario-with>
          <in> {$steps_scenario2/@feature}</in>
          <abstraction-distance>{$sc2_abstraction_distance}</abstraction-distance>
       </suggestion>, '&#xa;'
       )
       else (
       <suggestion>
          <delete-scenario-with>{$steps_scenario2/@title}</delete-scenario-with>
          <in>{$steps_scenario2/@feature}</in>
         <abstraction-distance>{$sc2_abstraction_distance}</abstraction-distance>
          <and/>
          <keep-scenario-with> {$steps_scenario1/@title} </keep-scenario-with>
          <in> {$steps_scenario1/@feature}</in>
          <abstraction-distance>{$sc1_abstraction_distance}</abstraction-distance>
       </suggestion>, '&#xa;'
       )     
     )
       else if(count($tech_counts2) > count($tech_counts1)) then
       (
       <suggestion>
          <delete-scenario-with> {$steps_scenario2/@title}</delete-scenario-with>
          <in>{$steps_scenario2/@feature}</in>
          <tech-word-count>{count($tech_counts2)}</tech-word-count>
          <tech-words>{$tech_counts2}</tech-words>
          <and/>
          <keep-scenario-with>{$steps_scenario1/@title}</keep-scenario-with>
          <in> {$steps_scenario1/@feature}</in>
          <tech-word-count>{count($tech_counts1)}</tech-word-count>
          <tech-words>{$tech_counts1}</tech-words>
       </suggestion>, '&#xa;'
       )
       else (
       <suggestion>
          <delete-scenario-with>{$steps_scenario1/@title}</delete-scenario-with>
          <in>{$steps_scenario1/@feature}</in>
          <tech-word-count>{count($tech_counts1)}</tech-word-count>
          <tech-words>{$tech_counts1}</tech-words>
          <and/>
          <keep-scenario-with> {$steps_scenario2/@title} </keep-scenario-with>
          <in> {$steps_scenario2/@feature}</in>
          <tech-word-count>{count($tech_counts2)} </tech-word-count>
          <tech-words>{$tech_counts2}</tech-words>
       </suggestion>, '&#xa;'
       )     
       )
       else if(count($keyword_counts1) > count($keyword_counts2)) then
       (
       <suggestion>
          <delete-scenario-with> {$steps_scenario2/@title}</delete-scenario-with>
          <in>{$steps_scenario2/@feature}</in>
          <diff-then-keywords-usage-aggregate>{count($keyword_counts2)}</diff-then-keywords-usage-aggregate>
          <and/>
          <keep-scenario-with>{$steps_scenario1/@title}</keep-scenario-with>
          <in> {$steps_scenario1/@feature}</in>
          <diff-then-keywords-usage-aggregate>{count($keyword_counts1)} </diff-then-keywords-usage-aggregate>
       </suggestion>, '&#xa;'
       )
       else (
       <suggestion>
          <delete-scenario-with>{$steps_scenario1/@title}</delete-scenario-with>
          <in>{$steps_scenario1/@feature}</in>
          <diff-then-keywords-usage-aggregate>{count($keyword_counts1)}</diff-then-keywords-usage-aggregate>
          <and/>
          <keep-scenario-with> {$steps_scenario2/@title} </keep-scenario-with>
          <in> {$steps_scenario2/@feature}</in>
          <diff-then-keywords-usage-aggregate>{count($keyword_counts2)} </diff-then-keywords-usage-aggregate>
       </suggestion>, '&#xa;'
       )
       )
       else if(sum($step_counts1) > sum($step_counts2)) then
       (
       <suggestion>
          <delete-scenario-with> {$steps_scenario2/@title}</delete-scenario-with>
          <in>{$steps_scenario2/@feature}</in>
          <diff-then-steps-usage-aggregate>{sum($step_counts2)}</diff-then-steps-usage-aggregate>
          <and/>
          <keep-scenario-with>{$steps_scenario1/@title}</keep-scenario-with>
          <in> {$steps_scenario1/@feature}</in>
          <diff-then-steps-usage-aggregate>{sum($step_counts1)} </diff-then-steps-usage-aggregate>
       </suggestion>, '&#xa;'
       )
       else (
       <suggestion>
          <delete-scenario-with>{$steps_scenario1/@title}</delete-scenario-with>
          <in>{$steps_scenario1/@feature}</in>
          <diff-then-steps-usage-aggregate>{sum($step_counts1)}</diff-then-steps-usage-aggregate>
          <and/>
          <keep-scenario-with> {$steps_scenario2/@title} </keep-scenario-with>
          <in> {$steps_scenario2/@feature}</in>
          <diff-then-steps-usage-aggregate>{sum($step_counts2)} </diff-then-steps-usage-aggregate>
       </suggestion>, '&#xa;'
       )
)else if($when_then_diff) then (
let $sc1 := $steps_scenario1/When//step union $steps_scenario1/Then//step
let $sc2 := $steps_scenario2/When//step union $steps_scenario2/Then//step

let $step_counts1 := for $step1 in distinct-values($sc1)
                    return count($all_steps[. = $step1])          
   
let $step_counts2 := for $step2 in distinct-values($sc2)
                    return count($all_steps[. = $step2])       
return
     if(sum($step_counts1) = sum($step_counts2)) then
      (
       let $sc1 := $steps_scenario1/Given//step union $steps_scenario1/When//step union $steps_scenario1/Then//step
       let $sc2 := $steps_scenario2/Given//step union $steps_scenario2/When//step union $steps_scenario2/Then//step

       let $keyword_counts1 := for $step1 in distinct-values($sc1), $kw1 in $key_words     
                                where functx:contains-word($step1, $kw1)
                               return $kw1
          
        let $keyword_counts2 := for $step2 in distinct-values($sc2), $kw2 in $key_words     
                                where functx:contains-word($step2, $kw2)
                               return $kw2         
    return
     if(count($keyword_counts1) = count($keyword_counts2)) then
     (:invoke the tech elimination principle:)
      (
       let $sc1 := $steps_scenario1/Given//step union $steps_scenario1/When//step union $steps_scenario1/Then//step
        let $sc2 := $steps_scenario2/Given//step union $steps_scenario2/When//step union $steps_scenario2/Then//step

          let $tech_counts1 := for $step1 in distinct-values($sc1), $tw1 in $tech_words     
                                where functx:contains-word($step1, $tw1)
                               return $tw1
          
          let $tech_counts2 := for $step2 in distinct-values($sc2), $tw2 in $tech_words     
                                where functx:contains-word($step2, $tw2)
                               return $tw2
    return
     if(count($tech_counts1) = count($tech_counts2)) then
     (:invoke the principle of conservation of abstraction:)
      (       

       if($sc1_abstraction_distance = $sc2_abstraction_distance) then
      (
        <suggestion>
          <delete-scenario-with>{$steps_scenario1/@title}</delete-scenario-with>
          <in>{$steps_scenario1/@feature}</in>
          <abstraction-distance>{$sc1_abstraction_distance}</abstraction-distance>
          <all-glue-statements-count>{$all_glue_stmts_count}</all-glue-statements-count>
          <average-statements-per-step>{$avg_stmts_per_step}</average-statements-per-step>
          <scenario1-avg-glue-statements-per-step>{$sc1_avg_glue_stmts_per_step}</scenario1-avg-glue-statements-per-step>
          <scenario2-avg-glue-statements-per-step>{$sc2_avg_glue_stmts_per_step}</scenario2-avg-glue-statements-per-step>
          <or/>
          <delete-scenario-with> {$steps_scenario2/@title}</delete-scenario-with>
          <in> {$steps_scenario2/@feature}</in>
          <abstraction-distance>{$sc2_abstraction_distance}</abstraction-distance>
        </suggestion>, '&#xa;'
       )
       else if($sc1_abstraction_distance > $sc2_abstraction_distance) then
       (
       <suggestion>
          <delete-scenario-with> {$steps_scenario1/@title}</delete-scenario-with>
          <in>{$steps_scenario1/@feature}</in>
          <abstraction-distance>{$sc1_abstraction_distance}</abstraction-distance>
          <and/>
          <keep-scenario-with>{$steps_scenario2/@title}</keep-scenario-with>
          <in> {$steps_scenario2/@feature}</in>
          <abstraction-distance>{$sc2_abstraction_distance}</abstraction-distance>
       </suggestion>, '&#xa;'
       )
       else (
       <suggestion>
          <delete-scenario-with>{$steps_scenario2/@title}</delete-scenario-with>
          <in>{$steps_scenario2/@feature}</in>
         <abstraction-distance>{$sc2_abstraction_distance}</abstraction-distance>
          <and/>
          <keep-scenario-with> {$steps_scenario1/@title} </keep-scenario-with>
          <in> {$steps_scenario1/@feature}</in>
          <abstraction-distance>{$sc1_abstraction_distance}</abstraction-distance>
       </suggestion>, '&#xa;'
       )     
     )
       else if(count($tech_counts2) > count($tech_counts1)) then
       (
       <suggestion>
          <delete-scenario-with> {$steps_scenario2/@title}</delete-scenario-with>
          <in>{$steps_scenario2/@feature}</in>
          <tech-word-count>{count($tech_counts2)}</tech-word-count>
          <tech-words>{$tech_counts2}</tech-words>
          <and/>
          <keep-scenario-with>{$steps_scenario1/@title}</keep-scenario-with>
          <in> {$steps_scenario1/@feature}</in>
          <tech-word-count>{count($tech_counts1)}</tech-word-count>
          <tech-words>{$tech_counts1}</tech-words>
       </suggestion>, '&#xa;'
       )
       else (
       <suggestion>
          <delete-scenario-with>{$steps_scenario1/@title}</delete-scenario-with>
          <in>{$steps_scenario1/@feature}</in>
          <tech-word-count>{count($tech_counts1)}</tech-word-count>
          <tech-words>{$tech_counts1}</tech-words>
          <and/>
          <keep-scenario-with> {$steps_scenario2/@title} </keep-scenario-with>
          <in> {$steps_scenario2/@feature}</in>
          <tech-word-count>{count($tech_counts2)} </tech-word-count>
          <tech-words>{$tech_counts2}</tech-words>
       </suggestion>, '&#xa;'
       )     
       )
       else if(count($keyword_counts1) > count($keyword_counts2)) then
       (
       <suggestion>
          <delete-scenario-with> {$steps_scenario2/@title}</delete-scenario-with>
          <in>{$steps_scenario2/@feature}</in>
          <diff-when-then-keywords-usage-aggregate>{count($keyword_counts2)}</diff-when-then-keywords-usage-aggregate>
          <and/>
          <keep-scenario-with>{$steps_scenario1/@title}</keep-scenario-with>
          <in> {$steps_scenario1/@feature}</in>
          <diff-when-then-keywords-usage-aggregate>{count($keyword_counts1)} </diff-when-then-keywords-usage-aggregate>
       </suggestion>, '&#xa;'
       )
       else (
       <suggestion>
          <delete-scenario-with>{$steps_scenario1/@title}</delete-scenario-with>
          <in>{$steps_scenario1/@feature}</in>
          <diff-when-then-keywords-usage-aggregate>{count($keyword_counts1)}</diff-when-then-keywords-usage-aggregate>
          <and/>
          <keep-scenario-with> {$steps_scenario2/@title} </keep-scenario-with>
          <in> {$steps_scenario2/@feature}</in>
          <diff-when-then-keywords-usage-aggregate>{count($keyword_counts2)} </diff-when-then-keywords-usage-aggregate>
       </suggestion>, '&#xa;'
       )
       )
       else if(sum($step_counts1) > sum($step_counts2)) then
       (
       <suggestion>
          <delete-scenario-with> {$steps_scenario2/@title}</delete-scenario-with>
          <in>{$steps_scenario2/@feature}</in>
          <diff-when-then-steps-usage-aggregate>{sum($step_counts2)}</diff-when-then-steps-usage-aggregate>
          <and/>
          <keep-scenario-with>{$steps_scenario1/@title}</keep-scenario-with>
          <in> {$steps_scenario1/@feature}</in>
          <diff-when-then-steps-usage-aggregate>{sum($step_counts1)} </diff-when-then-steps-usage-aggregate>
       </suggestion>, '&#xa;'
       )
       else (
       <suggestion>
          <delete-scenario-with>{$steps_scenario1/@title}</delete-scenario-with>
          <in>{$steps_scenario1/@feature}</in>
          <diff-when-then-steps-usage-aggregate>{sum($step_counts1)}</diff-when-then-steps-usage-aggregate>
          <and/>
          <keep-scenario-with> {$steps_scenario2/@title} </keep-scenario-with>
          <in> {$steps_scenario2/@feature}</in>
          <diff-when-then-steps-usage-aggregate>{sum($step_counts2)} </diff-when-then-steps-usage-aggregate>
       </suggestion>, '&#xa;'
       )
)
else if($given_then_diff) then (
let $sc1 := $steps_scenario1/Given//step union $steps_scenario1/Then//step
let $sc2 := $steps_scenario2/Given//step union $steps_scenario2/Then//step

let $step_counts1 := for $step1 in distinct-values($sc1)
                    return count($all_steps[. = $step1])          
   
let $step_counts2 := for $step2 in distinct-values($sc2)
                    return count($all_steps[. = $step2])     
return
     if(sum($step_counts1) = sum($step_counts2)) then
      (
       let $sc1 := $steps_scenario1/Given//step union $steps_scenario1/When//step union $steps_scenario1/Then//step
       let $sc2 := $steps_scenario2/Given//step union $steps_scenario2/When//step union $steps_scenario2/Then//step

       let $keyword_counts1 := for $step1 in distinct-values($sc1), $kw1 in $key_words     
                                where functx:contains-word($step1, $kw1)
                               return $kw1
          
        let $keyword_counts2 := for $step2 in distinct-values($sc2), $kw2 in $key_words     
                                where functx:contains-word($step2, $kw2)
                               return $kw2         
    return
     if(count($keyword_counts1) = count($keyword_counts2)) then
     (:invoke the tech elimination principle:)
      (
        let $sc1 := $steps_scenario1/Given//step union $steps_scenario1/When//step union $steps_scenario1/Then//step
        let $sc2 := $steps_scenario2/Given//step union $steps_scenario2/When//step union $steps_scenario2/Then//step

          let $tech_counts1 := for $step1 in distinct-values($sc1), $tw1 in $tech_words     
                                where functx:contains-word($step1, $tw1)
                               return $tw1
          
          let $tech_counts2 := for $step2 in distinct-values($sc2), $tw2 in $tech_words     
                                where functx:contains-word($step2, $tw2)
                               return $tw2
    return
     if(count($tech_counts1) = count($tech_counts2)) then
     (:invoke the principle of conservation of abstraction:)
      (
        
      if($sc1_abstraction_distance = $sc2_abstraction_distance) then
      (
        <suggestion>
          <delete-scenario-with>{$steps_scenario1/@title}</delete-scenario-with>
          <in>{$steps_scenario1/@feature}</in>
          <abstraction-distance>{$sc1_abstraction_distance}</abstraction-distance>
          <all-glue-statements-count>{$all_glue_stmts_count}</all-glue-statements-count>
          <average-statements-per-step>{$avg_stmts_per_step}</average-statements-per-step>
          <scenario1-avg-glue-statements-per-step>{$sc1_avg_glue_stmts_per_step}</scenario1-avg-glue-statements-per-step>
          <scenario2-avg-glue-statements-per-step>{$sc2_avg_glue_stmts_per_step}</scenario2-avg-glue-statements-per-step>
          <or/>
          <delete-scenario-with> {$steps_scenario2/@title}</delete-scenario-with>
          <in> {$steps_scenario2/@feature}</in>
          <abstraction-distance>{$sc2_abstraction_distance}</abstraction-distance>
        </suggestion>, '&#xa;'
       )
       else if($sc1_abstraction_distance > $sc2_abstraction_distance) then
       (
       <suggestion>
          <delete-scenario-with> {$steps_scenario1/@title}</delete-scenario-with>
          <in>{$steps_scenario1/@feature}</in>
          <abstraction-distance>{$sc1_abstraction_distance}</abstraction-distance>
          <and/>
          <keep-scenario-with>{$steps_scenario2/@title}</keep-scenario-with>
          <in> {$steps_scenario2/@feature}</in>
          <abstraction-distance>{$sc2_abstraction_distance}</abstraction-distance>
       </suggestion>, '&#xa;'
       )
       else (
       <suggestion>
          <delete-scenario-with>{$steps_scenario2/@title}</delete-scenario-with>
          <in>{$steps_scenario2/@feature}</in>
         <abstraction-distance>{$sc2_abstraction_distance}</abstraction-distance>
          <and/>
          <keep-scenario-with> {$steps_scenario1/@title} </keep-scenario-with>
          <in> {$steps_scenario1/@feature}</in>
          <abstraction-distance>{$sc1_abstraction_distance}</abstraction-distance>
       </suggestion>, '&#xa;'
       )     
     )
       else if(count($tech_counts2) > count($tech_counts1)) then
       (
       <suggestion>
          <delete-scenario-with> {$steps_scenario2/@title}</delete-scenario-with>
          <in>{$steps_scenario2/@feature}</in>
          <tech-word-count>{count($tech_counts2)}</tech-word-count>
          <tech-words>{$tech_counts2}</tech-words>
          <and/>
          <keep-scenario-with>{$steps_scenario1/@title}</keep-scenario-with>
          <in> {$steps_scenario1/@feature}</in>
          <tech-word-count>{count($tech_counts1)}</tech-word-count>
          <tech-words>{$tech_counts1}</tech-words>
       </suggestion>, '&#xa;'
       )
       else (
       <suggestion>
          <delete-scenario-with>{$steps_scenario1/@title}</delete-scenario-with>
          <in>{$steps_scenario1/@feature}</in>
          <tech-word-count>{count($tech_counts1)}</tech-word-count>
          <tech-words>{$tech_counts1}</tech-words>
          <and/>
          <keep-scenario-with> {$steps_scenario2/@title} </keep-scenario-with>
          <in> {$steps_scenario2/@feature}</in>
          <tech-word-count>{count($tech_counts2)} </tech-word-count>
          <tech-words>{$tech_counts2}</tech-words>
       </suggestion>, '&#xa;'
       )     
       )
       else if(count($keyword_counts1) > count($keyword_counts2)) then
       (
       <suggestion>
          <delete-scenario-with> {$steps_scenario2/@title}</delete-scenario-with>
          <in>{$steps_scenario2/@feature}</in>
          <diff-given-then-keywords-usage-aggregate>{count($keyword_counts2)}</diff-given-then-keywords-usage-aggregate>
          <and/>
          <keep-scenario-with>{$steps_scenario1/@title}</keep-scenario-with>
          <in> {$steps_scenario1/@feature}</in>
          <diff-given-then-keywords-usage-aggregate>{count($keyword_counts1)} </diff-given-then-keywords-usage-aggregate>
       </suggestion>, '&#xa;'
       )
       else (
       <suggestion>
          <delete-scenario-with>{$steps_scenario1/@title}</delete-scenario-with>
          <in>{$steps_scenario1/@feature}</in>
          <diff-given-then-keywords-usage-aggregate>{count($keyword_counts1)}</diff-given-then-keywords-usage-aggregate>
          <and/>
          <keep-scenario-with> {$steps_scenario2/@title} </keep-scenario-with>
          <in> {$steps_scenario2/@feature}</in>
          <diff-given-then-keywords-usage-aggregate>{count($keyword_counts2)} </diff-given-then-keywords-usage-aggregate>
       </suggestion>, '&#xa;'
       )
       )
       else if(sum($step_counts1) > sum($step_counts2)) then
       (
       <suggestion>
          <delete-scenario-with> {$steps_scenario2/@title}</delete-scenario-with>
          <in>{$steps_scenario2/@feature}</in>
          <diff-given-then-steps-usage-aggregate>{sum($step_counts2)}</diff-given-then-steps-usage-aggregate>
          <and/>
          <keep-scenario-with>{$steps_scenario1/@title}</keep-scenario-with>
          <in> {$steps_scenario1/@feature}</in>
          <diff-given-then-steps-usage-aggregate>{sum($step_counts1)} </diff-given-then-steps-usage-aggregate>
       </suggestion>, '&#xa;'
       )
       else (
       <suggestion>
          <delete-scenario-with>{$steps_scenario1/@title}</delete-scenario-with>
          <in>{$steps_scenario1/@feature}</in>
          <diff-given-then-steps-usage-aggregate>{sum($step_counts1)}</diff-given-then-steps-usage-aggregate>
          <and/>
          <keep-scenario-with> {$steps_scenario2/@title} </keep-scenario-with>
          <in> {$steps_scenario2/@feature}</in>
          <diff-given-then-steps-usage-aggregate>{sum($step_counts2)} </diff-given-then-steps-usage-aggregate>
       </suggestion>, '&#xa;'
       )
)
else if($given_when_diff) then (
let $sc1 := $steps_scenario1/Given//step union $steps_scenario1/When//step
let $sc2 := $steps_scenario2/Given//step union $steps_scenario2/When//step

let $step_counts1 := for $step1 in distinct-values($sc1)
                    return count($all_steps[. = $step1])          
   
let $step_counts2 := for $step2 in distinct-values($sc2)
                    return count($all_steps[. = $step2])      
return
     if(sum($step_counts1) = sum($step_counts2)) then
      (
       let $sc1 := $steps_scenario1/Given//step union $steps_scenario1/When//step union $steps_scenario1/Then//step
       let $sc2 := $steps_scenario2/Given//step union $steps_scenario2/When//step union $steps_scenario2/Then//step

       let $keyword_counts1 := for $step1 in distinct-values($sc1), $kw1 in $key_words     
                                where functx:contains-word($step1, $kw1)
                               return $kw1
          
        let $keyword_counts2 := for $step2 in distinct-values($sc2), $kw2 in $key_words     
                                where functx:contains-word($step2, $kw2)
                               return $kw2       
  return
     if(count($keyword_counts1) = count($keyword_counts2)) then
     (:invoke the tech elimination principle:)
      (
        let $sc1 := $steps_scenario1/Given//step union $steps_scenario1/When//step union $steps_scenario1/Then//step
        let $sc2 := $steps_scenario2/Given//step union $steps_scenario2/When//step union $steps_scenario2/Then//step

          let $tech_counts1 := for $step1 in distinct-values($sc1), $tw1 in $tech_words     
                                where functx:contains-word($step1, $tw1)
                               return $tw1
          
          let $tech_counts2 := for $step2 in distinct-values($sc2), $tw2 in $tech_words     
                                where functx:contains-word($step2, $tw2)
                               return $tw2
    return
     if(count($tech_counts1) = count($tech_counts2)) then
     (:invoke the principle of conservation of abstraction:)
      (
        
      if($sc1_abstraction_distance = $sc2_abstraction_distance) then
      (
        <suggestion>
          <delete-scenario-with>{$steps_scenario1/@title}</delete-scenario-with>
          <in>{$steps_scenario1/@feature}</in>
          <abstraction-distance>{$sc1_abstraction_distance}</abstraction-distance>
          <all-glue-statements-count>{$all_glue_stmts_count}</all-glue-statements-count>
          <average-statements-per-step>{$avg_stmts_per_step}</average-statements-per-step>
          <scenario1-avg-glue-statements-per-step>{$sc1_avg_glue_stmts_per_step}</scenario1-avg-glue-statements-per-step>
          <scenario2-avg-glue-statements-per-step>{$sc2_avg_glue_stmts_per_step}</scenario2-avg-glue-statements-per-step>
          <or/>
          <delete-scenario-with> {$steps_scenario2/@title}</delete-scenario-with>
          <in> {$steps_scenario2/@feature}</in>
          <abstraction-distance>{$sc2_abstraction_distance}</abstraction-distance>
        </suggestion>, '&#xa;'
       )
       else if($sc1_abstraction_distance > $sc2_abstraction_distance) then
       (
       <suggestion>
          <delete-scenario-with> {$steps_scenario1/@title}</delete-scenario-with>
          <in>{$steps_scenario1/@feature}</in>
          <abstraction-distance>{$sc1_abstraction_distance}</abstraction-distance>
          <and/>
          <keep-scenario-with>{$steps_scenario2/@title}</keep-scenario-with>
          <in> {$steps_scenario2/@feature}</in>
          <abstraction-distance>{$sc2_abstraction_distance}</abstraction-distance>
       </suggestion>, '&#xa;'
       )
       else (
       <suggestion>
          <delete-scenario-with>{$steps_scenario2/@title}</delete-scenario-with>
          <in>{$steps_scenario2/@feature}</in>
         <abstraction-distance>{$sc2_abstraction_distance}</abstraction-distance>
          <and/>
          <keep-scenario-with> {$steps_scenario1/@title} </keep-scenario-with>
          <in> {$steps_scenario1/@feature}</in>
          <abstraction-distance>{$sc1_abstraction_distance}</abstraction-distance>
       </suggestion>, '&#xa;'
       )     
     )
       else if(count($tech_counts2) > count($tech_counts1)) then
       (
       <suggestion>
          <delete-scenario-with> {$steps_scenario2/@title}</delete-scenario-with>
          <in>{$steps_scenario2/@feature}</in>
          <tech-word-count>{count($tech_counts2)}</tech-word-count>
          <tech-words>{$tech_counts2}</tech-words>
          <and/>
          <keep-scenario-with>{$steps_scenario1/@title}</keep-scenario-with>
          <in> {$steps_scenario1/@feature}</in>
          <tech-word-count>{count($tech_counts1)}</tech-word-count>
          <tech-words>{$tech_counts1}</tech-words>
       </suggestion>, '&#xa;'
       )
       else (
       <suggestion>
          <delete-scenario-with>{$steps_scenario1/@title}</delete-scenario-with>
          <in>{$steps_scenario1/@feature}</in>
          <tech-word-count>{count($tech_counts1)}</tech-word-count>
          <tech-words>{$tech_counts1}</tech-words>
          <and/>
          <keep-scenario-with> {$steps_scenario2/@title} </keep-scenario-with>
          <in> {$steps_scenario2/@feature}</in>
          <tech-word-count>{count($tech_counts2)} </tech-word-count>
          <tech-words>{$tech_counts2}</tech-words>
       </suggestion>, '&#xa;'
       )     
       )
       else if(count($keyword_counts1) > count($keyword_counts2)) then
       (
       <suggestion>
          <delete-scenario-with> {$steps_scenario2/@title}</delete-scenario-with>
          <in>{$steps_scenario2/@feature}</in>
          <diff-given-when-keywords-usage-aggregate>{count($keyword_counts2)}</diff-given-when-keywords-usage-aggregate>
          <and/>
          <keep-scenario-with>{$steps_scenario1/@title}</keep-scenario-with>
          <in> {$steps_scenario1/@feature}</in>
          <diff-given-when-keywords-usage-aggregate>{count($keyword_counts1)} </diff-given-when-keywords-usage-aggregate>
       </suggestion>, '&#xa;'
       )
       else (
       <suggestion>
          <delete-scenario-with>{$steps_scenario1/@title}</delete-scenario-with>
          <in>{$steps_scenario1/@feature}</in>
          <diff-given-when-keywords-usage-aggregate>{count($keyword_counts1)}</diff-given-when-keywords-usage-aggregate>
          <and/>
          <keep-scenario-with> {$steps_scenario2/@title} </keep-scenario-with>
          <in> {$steps_scenario2/@feature}</in>
          <diff-given-when-keywords-usage-aggregate>{count($keyword_counts2)} </diff-given-when-keywords-usage-aggregate>
       </suggestion>, '&#xa;'
       )
       )
       else if(sum($step_counts1) > sum($step_counts2)) then
       (
       <suggestion>
          <delete-scenario-with> {$steps_scenario2/@title}</delete-scenario-with>
          <in>{$steps_scenario2/@feature}</in>
          <diff-given-when-steps-usage-aggregate>{sum($step_counts2)}</diff-given-when-steps-usage-aggregate>
          <and/>
          <keep-scenario-with>{$steps_scenario1/@title}</keep-scenario-with>
          <in> {$steps_scenario1/@feature}</in>
          <diff-given-when-steps-usage-aggregate>{sum($step_counts1)} </diff-given-when-steps-usage-aggregate>
       </suggestion>, '&#xa;'
       )
       else (
       <suggestion>
          <delete-scenario-with>{$steps_scenario1/@title}</delete-scenario-with>
          <in>{$steps_scenario1/@feature}</in>
          <diff-given-when-steps-usage-aggregate>{sum($step_counts1)}</diff-given-when-steps-usage-aggregate>
          <and/>
          <keep-scenario-with> {$steps_scenario2/@title} </keep-scenario-with>
          <in> {$steps_scenario2/@feature}</in>
          <diff-given-when-steps-usage-aggregate>{sum($step_counts2)} </diff-given-when-steps-usage-aggregate>
       </suggestion>, '&#xa;'
       )
)
else if($given_when_then_diff) then (
let $sc1 := $steps_scenario1/Given//step union $steps_scenario1/When//step union $steps_scenario1/Then//step
let $sc2 := $steps_scenario2/Given//step union $steps_scenario2/When//step union $steps_scenario2/Then//step

let $step_counts1 := for $step1 in distinct-values($sc1)
                    return count($all_steps[. = $step1])          
   
let $step_counts2 := for $step2 in distinct-values($sc2)
                    return count($all_steps[. = $step2])       
return
     if(sum($step_counts1) = sum($step_counts2)) then
      (
       let $sc1 := $steps_scenario1/Given//step union $steps_scenario1/When//step union $steps_scenario1/Then//step
       let $sc2 := $steps_scenario2/Given//step union $steps_scenario2/When//step union $steps_scenario2/Then//step

       let $keyword_counts1 := for $step1 in distinct-values($sc1), $kw1 in $key_words     
                                where functx:contains-word($step1, $kw1)
                               return $kw1
          
        let $keyword_counts2 := for $step2 in distinct-values($sc2), $kw2 in $key_words     
                                where functx:contains-word($step2, $kw2)
                               return $kw2        
    return
     if(count($keyword_counts1) = count($keyword_counts2)) then
     (:invoke the tech elimination principle:)
      (
        let $sc1 := $steps_scenario1/Given//step union $steps_scenario1/When//step union $steps_scenario1/Then//step
        let $sc2 := $steps_scenario2/Given//step union $steps_scenario2/When//step union $steps_scenario2/Then//step

          let $tech_counts1 := for $step1 in distinct-values($sc1), $tw1 in $tech_words     
                                where functx:contains-word($step1, $tw1)
                               return $tw1
          
          let $tech_counts2 := for $step2 in distinct-values($sc2), $tw2 in $tech_words     
                                where functx:contains-word($step2, $tw2)
                               return $tw2
    return
     if(count($tech_counts1) = count($tech_counts2)) then
     (:invoke the principle of conservation of abstraction:)
      (
        
       if($sc1_abstraction_distance = $sc2_abstraction_distance) then
      (
        <suggestion>
          <delete-scenario-with>{$steps_scenario1/@title}</delete-scenario-with>
          <in>{$steps_scenario1/@feature}</in>
          <abstraction-distance>{$sc1_abstraction_distance}</abstraction-distance>
          <all-glue-statements-count>{$all_glue_stmts_count}</all-glue-statements-count>
          <average-statements-per-step>{$avg_stmts_per_step}</average-statements-per-step>
          <scenario1-avg-glue-statements-per-step>{$sc1_avg_glue_stmts_per_step}</scenario1-avg-glue-statements-per-step>
          <scenario2-avg-glue-statements-per-step>{$sc2_avg_glue_stmts_per_step}</scenario2-avg-glue-statements-per-step>
          <or/>
          <delete-scenario-with> {$steps_scenario2/@title}</delete-scenario-with>
          <in> {$steps_scenario2/@feature}</in>
          <abstraction-distance>{$sc2_abstraction_distance}</abstraction-distance>
        </suggestion>, '&#xa;'
       )
       else if($sc1_abstraction_distance > $sc2_abstraction_distance) then
       (
       <suggestion>
          <delete-scenario-with> {$steps_scenario1/@title}</delete-scenario-with>
          <in>{$steps_scenario1/@feature}</in>
          <abstraction-distance>{$sc1_abstraction_distance}</abstraction-distance>
          <and/>
          <keep-scenario-with>{$steps_scenario2/@title}</keep-scenario-with>
          <in> {$steps_scenario2/@feature}</in>
          <abstraction-distance>{$sc2_abstraction_distance}</abstraction-distance>
       </suggestion>, '&#xa;'
       )
       else (
       <suggestion>
          <delete-scenario-with>{$steps_scenario2/@title}</delete-scenario-with>
          <in>{$steps_scenario2/@feature}</in>
         <abstraction-distance>{$sc2_abstraction_distance}</abstraction-distance>
          <and/>
          <keep-scenario-with> {$steps_scenario1/@title} </keep-scenario-with>
          <in> {$steps_scenario1/@feature}</in>
          <abstraction-distance>{$sc1_abstraction_distance}</abstraction-distance>
       </suggestion>, '&#xa;'
       )     
     )
       else if(count($tech_counts2) > count($tech_counts1)) then
       (
       <suggestion>
          <delete-scenario-with> {$steps_scenario2/@title}</delete-scenario-with>
          <in>{$steps_scenario2/@feature}</in>
          <tech-word-count>{count($tech_counts2)}</tech-word-count>
          <tech-words>{$tech_counts2}</tech-words>
          <and/>
          <keep-scenario-with>{$steps_scenario1/@title}</keep-scenario-with>
          <in> {$steps_scenario1/@feature}</in>
          <tech-word-count>{count($tech_counts1)}</tech-word-count>
          <tech-words>{$tech_counts1}</tech-words>
       </suggestion>, '&#xa;'
       )
       else (
       <suggestion>
          <delete-scenario-with>{$steps_scenario1/@title}</delete-scenario-with>
          <in>{$steps_scenario1/@feature}</in>
          <tech-word-count>{count($tech_counts1)}</tech-word-count>
          <tech-words>{$tech_counts1}</tech-words>
          <and/>
          <keep-scenario-with> {$steps_scenario2/@title} </keep-scenario-with>
          <in> {$steps_scenario2/@feature}</in>
          <tech-word-count>{count($tech_counts2)} </tech-word-count>
          <tech-words>{$tech_counts2}</tech-words>
       </suggestion>, '&#xa;'
       )     
       )
       else if(count($keyword_counts1) > count($keyword_counts2)) then
       (
       <suggestion>
          <delete-scenario-with> {$steps_scenario2/@title}</delete-scenario-with>
          <in>{$steps_scenario2/@feature}</in>
          <diff-given-when-then-keywords-usage-aggregate>{count($keyword_counts2)}</diff-given-when-then-keywords-usage-aggregate>
          <and/>
          <keep-scenario-with>{$steps_scenario1/@title}</keep-scenario-with>
          <in> {$steps_scenario1/@feature}</in>
          <diff-given-when-then-keywords-usage-aggregate>{count($keyword_counts1)} </diff-given-when-then-keywords-usage-aggregate>
       </suggestion>, '&#xa;'
       )
       else (
       <suggestion>
          <delete-scenario-with>{$steps_scenario1/@title}</delete-scenario-with>
          <in>{$steps_scenario1/@feature}</in>
          <diff-given-when-then-keywords-usage-aggregate>{count($keyword_counts1)}</diff-given-when-then-keywords-usage-aggregate>
          <and/>
          <keep-scenario-with> {$steps_scenario2/@title} </keep-scenario-with>
          <in> {$steps_scenario2/@feature}</in>
          <diff-given-when-then-keywords-usage-aggregate>{count($keyword_counts2)} </diff-given-when-then-keywords-usage-aggregate>
       </suggestion>, '&#xa;'
       )
       )
       else if(sum($step_counts1) > sum($step_counts2)) then
       (
       <suggestion>
          <delete-scenario-with> {$steps_scenario2/@title}</delete-scenario-with>
          <in>{$steps_scenario2/@feature}</in>
          <diff-given-when-then-steps-usage-aggregate>{sum($step_counts2)}</diff-given-when-then-steps-usage-aggregate>
          <and/>
          <keep-scenario-with>{$steps_scenario1/@title}</keep-scenario-with>
          <in> {$steps_scenario1/@feature}</in>
          <diff-given-when-then-steps-usage-aggregate>{sum($step_counts1)} </diff-given-when-then-steps-usage-aggregate>
       </suggestion>, '&#xa;'
       )
       else (
       <suggestion>
          <delete-scenario-with>{$steps_scenario1/@title}</delete-scenario-with>
          <in>{$steps_scenario1/@feature}</in>
          <diff-given-when-then-steps-usage-aggregate>{sum($step_counts1)}</diff-given-when-then-steps-usage-aggregate>
          <and/>
          <keep-scenario-with> {$steps_scenario2/@title} </keep-scenario-with>
          <in> {$steps_scenario2/@feature}</in>
          <diff-given-when-then-steps-usage-aggregate>{sum($step_counts2)} </diff-given-when-then-steps-usage-aggregate>
       </suggestion>, '&#xa;'
       )
)    
     else (
     
     )
}
</suggestions>