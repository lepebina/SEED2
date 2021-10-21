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
                          
let $key_words := ("0010","0016","0018","004","006","008","0087","009","01","0122","0135","016","026","0284","0286","043","0444","05",
"0548","0644","06460","074","092","10","1010","108","110","114","120","123","123456","149","150","17","2014","2018","2020","240",
"244","3232","34","38408216","4261","4440000000000000","509","598","624","6866","7608","852","888","9","90","908","9107","9191","937","99",
"99300","abc","access","account","acte","action","add","address","alexander","another","atlantis","automatic","automation",
"available","back","backfriday","backwards","banner","basica","blackfriday","boleto","bone","bota","br","brand","brasil","browse","bruce",
"buy","calculate","cami","camisa","camiseta","capri","card","cart","cellphone","cep","change","check","choose","chose","chuteira","cocacola",
"code","com","comment","company","complete","connect","conta","contact","contain","control","controls","copa","corinthian","correct","create",
"cupom","cvv","da","date","dbmrulecartridge","delete","delivery","detail","diadora","different","discount","display","done","email","empty",
"everlast","every","example","exercicio","exist","expect","facebook","fadiga","fantasia","female","fifa","filter","filtrate","finalize",
"finish","finished","first","fitness","flamengo","florentina","following","forward","frame","free","friday","futebol","futsal","gear","gender","gmail","go","gonew","googleplu","have","holder","hotmail","ic","icon","impetus","information","internet","invalid","item","joao","jogo",
"kick","last","lid","like","linkedin","list","loaded","log","login","logout","look","low","lthr","make","maria","maximum","message","method",
"minha","miro","missing","mizuno","mobile","modify","moletom","msn","multiplu","mundo","name","navigate","netshoe","netshoes","new","nike",
"nome","november","ns","number","oakley","one","open","operation","ops","option","order","orders","outracoisa","page","part","particulars",
"passcode","password","passwort","path","pay","payment","pf","phone","pitbull","pj","policy","polo","power","ppc","previous","price","primal",
"product","producturl","produto","provide","ps","purchase","put","putt","qa","qanetshoes","qualquercoisa","random","razao","rc","re","receive",
"redirect","register","registerofertasdesconto","relative","remove","reset","respectively","result","review","rio","robert","rolo","safsdfsd",
"scroll","sdafsdfsd","search","second","section","security","select","set","shades","shape","ship","shipping","shoe","shop","shopping",
"should","show","shown","sign","silva","site","size","sku","skull","social","society","softbox","softboxpf","sports","stelo","steps","stock",
"store","sub","subscribe","success","successful","suggestion","summer","surname","table","team","telephone","teni","testador","teste","tiempo",
"top","trampolim","trincado","twitter","type","umbro","update","update'razao","use","user","useremail","username","userpassword","valid",
"validity","value","verify","via","video","visa","visit","walker","warning","wave","web","wish","wishlist","word","yes",
"click", "http", "invalid_url", "sub_page","sub_url"
 )


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
      (
        <suggestion>
          <delete-scenario-with>{$steps_scenario1/@title}</delete-scenario-with>
          <in>{$steps_scenario1/@feature}</in>
          <keyword-count>{count($keyword_counts1)}</keyword-count>
          <keywords>{$keyword_counts1}</keywords>
          <or/>
          <delete-scenario-with> {$steps_scenario2/@title} </delete-scenario-with>
          <in> {$steps_scenario2/@feature}</in>
          <keyword-count>{count($keyword_counts2)}</keyword-count>
          <keywords>{$keyword_counts2}</keywords>
        </suggestion>, '&#xa;'
       )
       else if(count($keyword_counts2) > count($keyword_counts1)) then
       (
       <suggestion>
          <delete-scenario-with> {$steps_scenario1/@title}</delete-scenario-with>
          <in>{$steps_scenario1/@feature}</in>
          <keyword-count>{count($keyword_counts1)}</keyword-count>
          <keywords>{$keyword_counts1}</keywords>
          <and/>
          <keep-scenario-with>{$steps_scenario2/@title}</keep-scenario-with>
          <in> {$steps_scenario2/@feature}</in>
          <keyword-count>{count($keyword_counts2)}</keyword-count>
          <keywords>{$keyword_counts2}</keywords>
       </suggestion>, '&#xa;'
       )
       else (
       <suggestion>
          <delete-scenario-with>{$steps_scenario2/@title}</delete-scenario-with>
          <in>{$steps_scenario2/@feature}</in>
          <keyword-count>{count($keyword_counts2)}</keyword-count>
          <keywords>{$keyword_counts2}</keywords>
          <and/>
          <keep-scenario-with> {$steps_scenario1/@title} </keep-scenario-with>
          <in> {$steps_scenario1/@feature}</in>
          <keyword-count>{count($keyword_counts1)} </keyword-count>
          <keywords>{$keyword_counts1}</keywords>
       </suggestion>, '&#xa;'
       )     


 }
</suggestions>