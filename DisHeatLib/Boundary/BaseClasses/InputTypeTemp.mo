within DisHeatLib.Boundary.BaseClasses;
type InputTypeTemp = enumeration(
    Constant "Use parameter",
    File "Use input from file",
    Input "Use input connector")
  "Input options for temperature" annotation (Documentation(revisions="<html>
<ul>
<li>Feburary 27, 2019, by Benedikt Leitner:<br>Implementation and added User&apos;s guide. </li>
</ul>
</html>",
        info="<html>
<p>Input types for OutsideTemperature model</p>
</html>"));
