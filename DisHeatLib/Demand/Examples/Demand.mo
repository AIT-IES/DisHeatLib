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

  DisHeatLib.Demand.Demand demand(heatLoad=DisHeatLib.Demand.BaseClasses.InputTypeDemand.InputQ)
    annotation (Placement(transformation(extent={{-12,-10},{8,10}})));
equation
  connect(T.y, boundarySL.T_in)
    annotation (Line(points={{-53,4},{-42,4}},   color={0,0,127}));
  connect(boundarySL.ports[1], demand.port_a)
    annotation (Line(points={{-20,0},{-12,0}}, color={0,127,255}));
  connect(demand.port_b, boundaryRL.ports[1])
    annotation (Line(points={{8,0},{20,0}}, color={0,127,255}));
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
