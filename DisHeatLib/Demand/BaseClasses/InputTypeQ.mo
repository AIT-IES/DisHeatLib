within DisHeatLib.Demand.BaseClasses;
type InputTypeQ = enumeration(
    Constant "Use parameter",
    File "Use input from file",
    Input "Use input connector")
  "Input options for demands" annotation (Documentation(revisions="<html>
<ul>
<li>Feburary 27, 2019, by Benedikt Leitner:<br>Implementation and added User&apos;s guide. </li>
</ul>
</html>"));
