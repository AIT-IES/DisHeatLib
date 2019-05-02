within DisHeatLib.Demand;
package BaseClasses
  extends Modelica.Icons.BasesPackage;

  type InputTypeDemand = enumeration(
    ConstantQ   "Use heat parameter",
    FileQ   "Use heat input from file",
    InputQ   "Use heat input connector",
    ConstantM   "Use flow parameter",
    FileM   "Use flow input from file",
    InputM   "Use flow input connector")
    "Input options for demands" annotation (Documentation(revisions="<html>
<ul>
<li>Feburary 27, 2019, by Benedikt Leitner:<br>Implementation and added User&apos;s guide. </li>
</ul>
</html>"));

annotation (Documentation(revisions="<html>
<ul>
<li>Feburary 27, 2019, by Benedikt Leitner:<br>Implementation and added User&apos;s guide. </li>
</ul>
</html>"));
end BaseClasses;
