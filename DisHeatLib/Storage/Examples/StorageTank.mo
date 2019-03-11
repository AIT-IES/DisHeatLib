within DisHeatLib.Storage.Examples;
model StorageTank
  extends Modelica.Icons.Example;
  package Medium = IBPSA.Media.Water;
  Modelica.Fluid.Sources.FixedBoundary boundaryRL(          redeclare package
      Medium = Medium, nPorts=1)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=180,
        origin={40,12})));
  Modelica.Fluid.Sources.MassFlowSource_T
                                     boundarySL(
    redeclare package Medium = Medium,
    m_flow=1,
    nPorts=1,
    use_m_flow_in=true,
    T=343.15)
    annotation (Placement(transformation(extent={{-52,2},{-32,22}})));

  DisHeatLib.Storage.StorageTank storageTank(
    m_flow_nominal=1,
    redeclare package Medium = Medium,
    TemSup_nominal=333.15,
    VTan=10,
    nSeg=10,
    TemInit=303.15)
    annotation (Placement(transformation(extent={{-10,2},{10,22}})));
  DisHeatLib.Boundary.OutsideTemperature outsideTemperature
    annotation (Placement(transformation(extent={{-34,44},{-14,64}})));
  Modelica.Blocks.Sources.Step step(
    height=-2,
    offset=1,
    startTime(displayUnit="h") = 28800)
    annotation (Placement(transformation(extent={{-84,10},{-64,30}})));
equation
  connect(boundaryRL.ports[1], storageTank.port_b) annotation (Line(points={{30,12},
          {10,12}},                          color={0,127,255}));
  connect(outsideTemperature.port, storageTank.port_ht)
    annotation (Line(points={{-24,64},{0,64},{0,22}},   color={191,0,0}));
  connect(boundarySL.ports[1], storageTank.port_a)
    annotation (Line(points={{-32,12},{-10,12}},       color={0,127,255}));
  connect(boundarySL.m_flow_in, step.y)
    annotation (Line(points={{-52,20},{-63,20}}, color={0,0,127}));
  annotation (__Dymola_Commands(file="modelica://DisHeatLib/Resources/Scripts/Dymola/Storage/Examples/StorageTank.mos"
        "Simulate and plot"),
        Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(
      StopTime=86400,
      Interval=900,
      __Dymola_Algorithm="Cvode"),
    Documentation(revisions="<html>
<ul>
<li>Feburary 27, 2019, by Benedikt Leitner:<br>Implementation and added User&apos;s guide. </li>
</ul>
</html>"));
end StorageTank;
