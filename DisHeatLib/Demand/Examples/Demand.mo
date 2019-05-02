within DisHeatLib.Demand.Examples;
model Demand
  extends Modelica.Icons.Example;
  package Medium = IBPSA.Media.Water;
  Modelica.Fluid.Sources.FixedBoundary boundaryRL(          redeclare package
      Medium = Medium, nPorts=1)
    annotation (Placement(transformation(extent={{40,38},{20,58}})));
  Modelica.Fluid.Sources.Boundary_pT boundarySL(
    redeclare package Medium = Medium,
    use_p_in=false,
    use_T_in=true,
    p=500000,
    T=343.15,
    nPorts=1)
    annotation (Placement(transformation(extent={{-40,38},{-20,58}})));
  Modelica.Blocks.Sources.Ramp T(
    height=80,
    offset=273.15 + 10.0,
    duration(displayUnit="d") = 864000,
    startTime(displayUnit="d") = 86400)
    annotation (Placement(transformation(extent={{-74,42},{-54,62}})));
  Modelica.Blocks.Sources.Trapezoid Q(
    startTime(displayUnit="d") = 86400,
    rising(displayUnit="h") = 18000,
    falling(displayUnit="h") = 14400,
    period(displayUnit="h") = 86400,
    amplitude=1300,
    offset=0,
    width(displayUnit="h") = 28800)
    annotation (Placement(transformation(extent={{-30,74},{-10,94}})));

  Modelica.Fluid.Sources.FixedBoundary boundaryRL1(         redeclare package
      Medium = Medium, nPorts=1)
    annotation (Placement(transformation(extent={{40,-10},{20,10}})));
  Modelica.Fluid.Sources.Boundary_pT boundarySL1(
    redeclare package Medium = Medium,
    use_p_in=false,
    use_T_in=true,
    p=500000,
    T=343.15,
    nPorts=1)
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Modelica.Blocks.Sources.Ramp T1(
    height=80,
    offset=273.15 + 10.0,
    duration(displayUnit="d") = 864000,
    startTime(displayUnit="d") = 86400)
    annotation (Placement(transformation(extent={{-74,-6},{-54,14}})));
  Modelica.Fluid.Sources.FixedBoundary boundaryRL2(         redeclare package
      Medium = Medium, nPorts=1)
    annotation (Placement(transformation(extent={{40,-78},{20,-58}})));
  Modelica.Fluid.Sources.Boundary_pT boundarySL2(
    redeclare package Medium = Medium,
    use_p_in=false,
    use_T_in=true,
    p=500000,
    T=343.15,
    nPorts=1)
    annotation (Placement(transformation(extent={{-40,-78},{-20,-58}})));
  Modelica.Blocks.Sources.Ramp T2(
    height=80,
    offset=273.15 + 10.0,
    duration(displayUnit="d") = 864000,
    startTime(displayUnit="d") = 86400)
    annotation (Placement(transformation(extent={{-74,-74},{-54,-54}})));
  DisHeatLib.Demand.Demand demand(
    redeclare package Medium = Medium,
    Q_flow_nominal=1000,
    dp_nominal(displayUnit="bar") = 100000,
    heatLoad=DisHeatLib.Demand.BaseClasses.InputTypeDemand.InputQ,
    redeclare BaseClasses.FixedReturn demandType)
    annotation (Placement(transformation(extent={{-10,38},{10,58}})));
  DisHeatLib.Demand.Demand demand1(
    redeclare package Medium = Medium,
    Q_flow_nominal=1000,
    dp_nominal=100000,
    heatLoad=DisHeatLib.Demand.BaseClasses.InputTypeDemand.ConstantQ,
    Q_constant=1000,
    redeclare BaseClasses.FixedReturn demandType)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  DisHeatLib.Demand.Demand demand2(
    redeclare package Medium = Medium,
    Q_flow_nominal=10000,
    dp_nominal=100000,
    heatLoad=DisHeatLib.Demand.BaseClasses.InputTypeDemand.FileQ,
    tableName="SHprofile",
    fileName="modelica://DisHeatLib/Resources/Data/SHprofile.txt",
    redeclare BaseClasses.Radiator demandType)
    annotation (Placement(transformation(extent={{-10,-78},{10,-58}})));
equation
  connect(T2.y, boundarySL2.T_in)
    annotation (Line(points={{-53,-64},{-42,-64}}, color={0,0,127}));
  connect(T1.y, boundarySL1.T_in)
    annotation (Line(points={{-53,4},{-42,4}}, color={0,0,127}));
  connect(boundarySL1.ports[1], demand1.port_a)
    annotation (Line(points={{-20,0},{-10,0}}, color={0,127,255}));
  connect(demand1.port_b, boundaryRL1.ports[1])
    annotation (Line(points={{10,0},{20,0}}, color={0,127,255}));
  connect(boundarySL2.ports[1], demand2.port_a)
    annotation (Line(points={{-20,-68},{-10,-68}}, color={0,127,255}));
  connect(demand2.port_b, boundaryRL2.ports[1])
    annotation (Line(points={{10,-68},{20,-68}}, color={0,127,255}));
  connect(T.y, boundarySL.T_in)
    annotation (Line(points={{-53,52},{-42,52}}, color={0,0,127}));
  connect(boundarySL.ports[1], demand.port_a)
    annotation (Line(points={{-20,48},{-10,48}}, color={0,127,255}));
  connect(demand.port_b, boundaryRL.ports[1])
    annotation (Line(points={{10,48},{20,48}}, color={0,127,255}));
  connect(Q.y, demand.u)
    annotation (Line(points={{-9,84},{0,84},{0,60}}, color={0,0,127}));
  annotation (__Dymola_Commands(file="modelica://DisHeatLib/Resources/Scripts/Dymola/Demand/Examples/Demand.mos"
        "Simulate and plot"),
        Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(revisions="<html>
<ul>
<li>Feburary 27, 2019, by Benedikt Leitner:<br>Implementation and added User&apos;s guide. </li>
</ul>
</html>"));
end Demand;
