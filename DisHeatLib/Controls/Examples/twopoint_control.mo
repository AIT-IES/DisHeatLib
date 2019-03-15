within DisHeatLib.Controls.Examples;
model twopoint_control
  import DisHeatLib;
  extends Modelica.Icons.Example;
  DisHeatLib.Controls.twopoint_control
                                     control(u_min=0.2, u_bandwidth=0.1)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.Sine Tem_measure(
    startTime(displayUnit="s") = 100,
    amplitude=1,
    freqHz=1/900,
    offset=0,
    phase=0)
    annotation (Placement(transformation(extent={{-66,-10},{-46,10}})));
equation
  connect(Tem_measure.y, control.u)
    annotation (Line(points={{-45,0},{-12,0}}, color={0,0,127}));
  annotation (__Dymola_Commands(file="modelica://DisHeatLib/Resources/Scripts/Dymola/Controls/Examples/twopoint_control.mos"
        "Simulate and plot"),
        Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(revisions="<html>
<ul>
<li>Feburary 27, 2019, by Benedikt Leitner:<br>Implementation and added User&apos;s guide. </li>
</ul>
</html>"));
end twopoint_control;
