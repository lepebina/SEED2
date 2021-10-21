<traces>
{
for $node in doc("trace.xml")//trace
where $node/@scenario!=""
return $node
}
</traces>