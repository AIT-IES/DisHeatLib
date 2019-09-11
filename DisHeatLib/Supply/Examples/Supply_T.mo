within DisHeatLib.Supply.Examples;
model Supply_T
  import DisHeatLib;
  extends Modelica.Icons.Example;
  package Medium = IBPSA.Media.Water;

  DisHeatLib.Supply.Supply_T  supply_T(
    redeclare package Medium = Medium,
    show_T=true,
    Q_flow_nominal(displayUnit="kW") = 5000,
    TemSup_nominal=343.15,
    TemRet_nominal=313.15,
    powerCha(Q_flow={0}, P={0}),
    use_T_in=true,
    nPorts=1)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  IBPSA.Fluid.Sources.MassFlowSource_T
                                    boundary(
    redeclare package Medium = Medium,
    m_flow=0.1,
    T=313.15,
    nPorts=1)
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Modelica.Blocks.Sources.Ramp T_set(
    height=80,
    offset=10 + 273.15,
    duration(displayUnit="h") = 72000,
    startTime(displayUnit="h") = 7200)
    annotation (Placement(transformation(extent={{-36,30},{-16,50}})));
  IBPSA.Fluid.Sources.Boundary_pT bou(redeclare package Medium = Medium, nPorts=
       1) annotation (Placement(transformation(extent={{40,-10},{20,10}})));
equation
  connect(boundary.ports[1], supply_T.port_a)
    annotation (Line(points={{-20,0},{-10,0}}, color={0,127,255}));
  connect(T_set.y, supply_T.TSet)
    annotation (Line(points={{-15,40},{0,40},{0,12}}, color={0,0,127}));
  connect(supply_T.ports_b[1], bou.ports[1])
    annotation (Line(points={{10,0},{20,0}}, color={0,127,255}));
  annotation (__Dymola_Commands(file="modelica://DisHeatLib/Resources/Scripts/Dymola/Supply/Examples/Supply_T.mos"
        "Simulate and plot"),
        Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(revisions="<html>
<ul>
<li>Feburary 27, 2019, by Benedikt Leitner:<br>Implementation and added User&apos;s guide. </li>
</ul>
</html>", info="<html>
<p><span style=\"font-family: Arial,sans-serif;\">This example shows how the Supply_T model fulfills the role of a heat supply with given supply temperature using a PI-controller, and fixed maximum heat flow generation.</span></p>
<p><span style=\"font-family: Arial,sans-serif;\">The plots shows that even thought the temperature is supposed to go up to a higher temperature, the heat generation is to weak to reach that and stops increaseing the temperature further after reaching its maximum heat flow generation.</span></p>
</html>"));
end Supply_T;
