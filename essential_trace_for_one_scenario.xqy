<traces>
{
for $nd in collection("file:/home/leonard/eclipse-workspace/SEED2/etraces?select=*.xml")/traces 
let $focus := $nd/*
where data($focus) !="any"
return $focus
}
</traces>