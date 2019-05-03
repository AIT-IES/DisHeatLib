within DisHeatLib.Substations.BaseClasses.Examples;
model Bypass
  extends Modelica.Icons.Example;
  BaseClasses.Bypass bypass(
    redeclare package Medium = Medium,
    dp_nominal(displayUnit="bar") = 100000,
    m_flow_nominal=1,
    use_thermostat=true)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  package Medium = IBPSA.Media.Water;

  IBPSA.Fluid.Sources.Boundary_pT bou_RL_p(
    redeclare package Medium = Medium,
    use_T_in=false,
    nPorts=1,
    p=100000,
    T=313.15) annotation (Placement(transformation(extent={{50,-10},{30,10}})));
  IBPSA.Fluid.Sources.Boundary_pT bou_SL_p(
    redeclare package Medium = Medium,
    use_p_in=false,
    nPorts=1,
    use_T_in=true,
    p=600000,
    T=353.15)
    annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));
  Modelica.Blocks.Sources.Ramp T(
    height=80,
    offset=273.15 + 10.0,
    startTime(displayUnit="h") = 3600,
    duration(displayUnit="h") = 21600)
    annotation (Placement(transformation(extent={{-88,-6},{-68,14}})));
equation
  connect(bou_SL_p.T_in, T.y)
    annotation (Line(points={{-52,4},{-67,4}},     color={0,0,127}));

  connect(T.y, bypass.T_measurement) annotation (Line(points={{-67,4},{-60,4},{-60,
          22},{0,22},{0,12}}, color={0,0,127}));
  connect(bou_SL_p.ports[1], bypass.port_a)
    annotation (Line(points={{-30,0},{-10,0}}, color={0,127,255}));
  connect(bypass.port_b, bou_RL_p.ports[1])
    annotation (Line(points={{10,0},{30,0}}, color={0,127,255}));
  annotation (__Dymola_Commands(file="modelica://DisHeatLib/Resources/Scripts/Dymola/Substations/BaseClasses/Examples/Bypass.mos"
        "Simulate and plot"),
        Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(revisions="<html>
<ul>
<li>Feburary 27, 2019, by Benedikt Leitner:<br>Implementation and added User&apos;s guide. </li>
</ul>
</html>"));
end Bypass;
