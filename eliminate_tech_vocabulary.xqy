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
for $duplicate_pair in doc("duplicates-system1.xml")//duplicate
let $scenario1 := $duplicate_pair/hit/@scenario
let $scenario2 := $duplicate_pair/hitd/@scenario

let $steps_scenario1 := doc("scenarios.xml")/scenarios/scenario[@title = $scenario1]                
                                              
let $steps_scenario2 := doc("scenarios.xml")/scenarios/scenario[@title = $scenario2]       
                          
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
      (
        <suggestion>
          <delete-scenario-with>{$steps_scenario1/@title}</delete-scenario-with>
          <in>{$steps_scenario1/@feature}</in>
          <tech-word-count>{count($tech_counts1)}</tech-word-count>
          <tech-words>{$tech_counts1}</tech-words>
          <or/>
          <delete-scenario-with> {$steps_scenario2/@title} </delete-scenario-with>
          <in> {$steps_scenario2/@feature}</in>
          <tech-word-count>{count($tech_counts2)}</tech-word-count>
          <tech-words>{$tech_counts2}</tech-words>
        </suggestion>, '&#xa;'
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


 }
</suggestions>