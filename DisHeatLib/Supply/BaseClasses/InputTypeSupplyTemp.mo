within DisHeatLib.Supply.BaseClasses;
type InputTypeSupplyTemp = enumeration(
    Constant "Use parameter",
    Input "Use input connector",
    OutsideDependent "Outside dependent") "Input options for supply temperature"
                                  annotation (Documentation(revisions="<html>
<ul>
<li>March 29, 2019, by Benedikt Leitner:<br>Implementation and added User&apos;s guide. </li>
</ul>
</html>",
        info="<html>
<p>Input types for supply models</p>
</html>"));
