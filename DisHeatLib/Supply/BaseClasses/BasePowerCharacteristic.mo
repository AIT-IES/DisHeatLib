within DisHeatLib.Supply.BaseClasses;
record BasePowerCharacteristic
  "Record for electrical power parameters"
  extends Modelica.Icons.Record;
  parameter Modelica.SIunits.HeatFlowRate Q_flow[:](each min=0)
    "Heat flow rate at selected operating points";
  parameter Modelica.SIunits.Power P[size(Q_flow,1)]
    "Electrical power generation/consumption at these flow rates";
  annotation (Documentation(info="<html>
<p>
Data record for performance data that describe heat flow versus
electric power flow.
Electric power flow can be positive(=consumption) or negative(=generation).
The heat generation <code>Q_flow</code> must be increasing, i.e.,
<code>Q_flow[i] &lt; Q_flow[i+1]</code>.
Both vectors, <code>Q_flow</code> and <code>P</code>
must have the same size.
</p>
</html>",
revisions="<html>
<ul>
<li>Feburary 27, 2019, by Benedikt Leitner:<br>Implementation and added User&apos;s guide. </li>
</ul>
</html>"));
end BasePowerCharacteristic;
