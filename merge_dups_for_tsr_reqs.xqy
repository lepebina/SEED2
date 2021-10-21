 <scenarios-paths>
 {
 
 for $trace in doc("clean_trace.xml")//trace
 let $executionPath := concat(string-join($trace/class, ''), string-join($trace/method, ''),
     string-join($trace/param-types, ''), string-join($trace/return-type, '')) 
  
    return <scenario-group path = "{$executionPath}">
             <scenario name= "{$trace/@scenario}" feature = "{$trace/@feature}"></scenario>             
           </scenario-group>
}
 </scenarios-paths>