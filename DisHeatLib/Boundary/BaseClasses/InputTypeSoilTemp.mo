within DisHeatLib.Boundary.BaseClasses;
type InputTypeSoilTemp = enumeration(
    Constant "Use parameter",
    Undisturbed "Use Kusuda equation") "Input options for temperature"
                                  annotation (Documentation(revisions="<html>
<ul>
<li>March 25, 2019, by Benedikt Leitner:<br>Implementation and added User&apos;s guide. </li>
</ul>
</html>",
        info="<html>
<p>Input types for OutsideTemperature model</p>
</html>"));
