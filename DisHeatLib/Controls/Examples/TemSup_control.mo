within DisHeatLib.Controls.Examples;
model TemSup_control
  extends Modelica.Icons.Example;
  DisHeatLib.Controls.TemSup_control control
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.Ramp sine(
    duration(displayUnit="d") = 69120,
    offset=273.15 - 10.0,
    startTime(displayUnit="d") = 8640,
    height=30)
    annotation (Placement(transformation(extent={{-52,-10},{-32,10}})));
equation
  connect(sine.y, control.TemOut)
    annotation (Line(points={{-31,0},{-12,0}}, color={0,0,127}));
  annotation (__Dymola_Commands(file="modelica://DisHeatLib/Resources/Scripts/Dymola/Controls/Examples/TemSup_control.mos"
        "Simulate and plot"),
        Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(revisions="<html>
<ul>
<li>Feburary 27, 2019, by Benedikt Leitner:<br>Implementation and added User&apos;s guide. </li>
</ul>
</html>"));
end TemSup_control;
