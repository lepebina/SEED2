<traces>
{
let $node:= doc("xdiff_output.xml")//*[not(string-join(contains(text(),''),'<?UPDATE FROM'))]
    

return $node
}
</traces>
