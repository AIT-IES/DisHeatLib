within DisHeatLib.Demand.Examples;
model Demand
  extends Modelica.Icons.Example;
  package Medium = IBPSA.Media.Water;
  Modelica.Fluid.Sources.FixedBoundary boundaryRL(          redeclare package
      Medium = Medium, nPorts=1)
    annotation (Placement(transformation(extent={{40,-10},{20,10}})));
  Modelica.Fluid.Sources.MassFlowSource_T
                                     boundarySL(
    redeclare package Medium = Medium,
    use_T_in=true,
    m_flow=1,
    T=343.15,
    nPorts=1)
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Modelica.Blocks.Sources.Ramp T(
    height=80,
    offset=273.15 + 10.0,
    duration(displayUnit="d") = 864000,
    startTime(displayUnit="d") = 86400)
    annotation (Placement(transformation(extent={{-74,-6},{-54,14}})));

  BaseDemands.Radiator radiator(redeclare package Medium = Medium,
      Q_flow_nominal(displayUnit="kW") = 10000)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
equation
  connect(T.y, boundarySL.T_in)
    annotation (Line(points={{-53,4},{-42,4}},   color={0,0,127}));
  connect(boundaryRL.ports[1], radiator.port_b)
    annotation (Line(points={{20,0},{10,0}}, color={0,127,255}));
  connect(boundarySL.ports[1], radiator.port_a)
    annotation (Line(points={{-20,0},{-10,0}}, color={0,127,255}));
  annotation (__Dymola_Commands(file=
          "Resources/Scripts/Dymola/Demand/Examples/Demand1.mos"
        "Simulate and plot"),
        Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(revisions="<html>
<ul>
<li>Feburary 27, 2019, by Benedikt Leitner:<br>Implementation and added User&apos;s guide. </li>
</ul>
</html>", info="<html>
<p><span style=\"font-family: Arial,sans-serif;\">This example demonstrates how this model transfers heat from a medium depending on the room temperature. If the temperature of the medium is above the room temperature the medium looses heat, if it is below it gains heat. The absorbed heat is measured and can be accesed through the output node. If the medium looses heat the value of the heat flow is negative.</span></p>
<p><br><span style=\"font-family: Arial,sans-serif;\">The plot shows that the medium in the radiator gains heat while below the room temperature and later looses heat while above the room temperature, approximately proportional to the difference in temperature.</span></p>
<p><span style=\"font-family: Arial,sans-serif;\">Available commands: Simulate and plot: simulates the example and plots the results so that the example can be better understood.</span></p>
</html>"),
    experiment(StopTime=864000));
end Demand;
