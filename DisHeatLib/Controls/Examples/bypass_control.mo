within DisHeatLib.Controls.Examples;
model bypass_control
  import DisHeatLib;
  extends Modelica.Icons.Example;
  DisHeatLib.Controls.bypass_control control(T_bandwidth=3, T_min=328.15)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.Sine Tem_measure(
    startTime(displayUnit="s") = 100,
    amplitude=10,
    freqHz=1/86400,
    offset=60.0 + 273.15,
    phase=3.6651914291881)
    annotation (Placement(transformation(extent={{-66,-10},{-46,10}})));
equation
  connect(Tem_measure.y, control.T_measurement) annotation (Line(points={{-45,0},
          {-12,0}},                       color={0,0,127}));
  annotation (__Dymola_Commands(file="modelica://DisHeatLib/Resources/Scripts/Dymola/Controls/Examples/bypass_control.mos"
        "Simulate and plot"),
        Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(revisions="<html>
<ul>
<li>Feburary 27, 2019, by Benedikt Leitner:<br>Implementation and added User&apos;s guide. </li>
</ul>
</html>"));
end bypass_control;
