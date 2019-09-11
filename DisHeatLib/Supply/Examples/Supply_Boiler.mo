within DisHeatLib.Supply.Examples;
model Supply_Boiler
  import DisHeatLib;
  extends Modelica.Icons.Example;
  package Medium = IBPSA.Media.Water;

  DisHeatLib.Supply.Supply_Boiler
                              supply_Boiler(
    redeclare package Medium = Medium,
    show_T=true,
    Q_flow_nominal=10000,
    TemSup_nominal=353.15,
    TemRet_nominal=313.15,
    powerCha(Q_flow={0,1}, P={0,1}),
    TesTemSup_nominal=343.15,
    VTan=5,
    hTan=2,
    nSeg=6,
    TemInit=353.15,
    nPorts=1)
    annotation (Placement(transformation(extent={{-12,-10},{8,10}})));
  Modelica.Blocks.Sources.Ramp Q_flow_set(
    height=5000,
    offset=0,
    duration(displayUnit="h") = 72000,
    startTime(displayUnit="h") = 7200)
    annotation (Placement(transformation(extent={{-24,62},{-4,82}})));
  Modelica.Blocks.Sources.Ramp m_flow_limit(
    height=-0.02,
    offset=0.03,
    duration(displayUnit="h") = 72000,
    startTime(displayUnit="h") = 7200)
    annotation (Placement(transformation(extent={{38,30},{18,50}})));
  IBPSA.Fluid.Sources.Boundary_pT bou1(
    redeclare package Medium = Medium,
    T=313.15,
    nPorts=1)
    annotation (Placement(transformation(extent={{-76,-10},{-56,10}})));
  IBPSA.Fluid.Sources.Boundary_pT bou(redeclare package Medium = Medium, nPorts=
       1) annotation (Placement(transformation(extent={{76,-10},{56,10}})));
  Modelica.Blocks.Sources.Pulse P_set(
    amplitude=1000,
    period(displayUnit="h") = 7200,
    offset=0,
    startTime(displayUnit="h") = 7200)
    annotation (Placement(transformation(extent={{-60,34},{-40,54}})));
equation
  connect(Q_flow_set.y, supply_Boiler.QSet)
    annotation (Line(points={{-3,72},{4,72},{4,12}}, color={0,0,127}));
  connect(bou1.ports[1], supply_Boiler.port_a)
    annotation (Line(points={{-56,0},{-12,0}}, color={0,127,255}));
  connect(supply_Boiler.ports_b[1], bou.ports[1])
    annotation (Line(points={{8,0},{56,0}}, color={0,127,255}));
  connect(m_flow_limit.y, supply_Boiler.m_flow_limit)
    annotation (Line(points={{17,40},{-2,40},{-2,12}}, color={0,0,127}));
  connect(P_set.y, supply_Boiler.PSet)
    annotation (Line(points={{-39,44},{-8,44},{-8,12}}, color={0,0,127}));
  annotation (__Dymola_Commands(file="modelica://DisHeatLib/Resources/Scripts/Dymola/Supply/Examples/Supply_QT.mos"
        "Simulate and plot"),
        Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(revisions="<html>
<ul>
<li>Feburary 27, 2019, by Benedikt Leitner:<br>Implementation and added User&apos;s guide. </li>
</ul>
</html>", info="<html>
<p>This example shows how the Supply_T model fulfills the role of a heat supply with given minimum supply temperature and a fixed maximum mass flow. The limited mass flow therefor limits the heat flow. This is possible due to an internal Supply_QT that heats the boiler&apos;s tank whenever the temperature is too low and a thermostat mixer that mixes hot water from the upper layers and cold water from the lower layers to provide the given mass flow and the heat demand.</p>
</html>"));
end Supply_Boiler;
