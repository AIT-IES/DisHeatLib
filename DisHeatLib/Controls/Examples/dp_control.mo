within DisHeatLib.Controls.Examples;
model dp_control
  extends Modelica.Icons.Example;
  DisHeatLib.Controls.dp_control     control(
    dp_setpoint=500000,
    dp_min=200000,
    dp_max=1000000)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.Pulse sine(
    startTime(displayUnit="s") = 100,
    period=800,
    amplitude=100000,
    offset=450000)
    annotation (Placement(transformation(extent={{-52,-10},{-32,10}})));
equation
  connect(sine.y, control.dp)
    annotation (Line(points={{-31,0},{-12,0}}, color={0,0,127}));
  annotation (__Dymola_Commands(file="modelica://DisHeatLib/Resources/Scripts/Dymola/Controls/Examples/dp_control.mos"
        "Simulate and plot"),
        Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(revisions="<html>
<ul>
<li>Feburary 27, 2019, by Benedikt Leitner:<br>Implementation and added User&apos;s guide. </li>
</ul>
</html>"));
end dp_control;
