within DisHeatLib.Pipes.Examples;
model DualPipe
  import DisHeatLib;
  extends Modelica.Icons.Example;
  package Medium = IBPSA.Media.Water;
  Modelica.Fluid.Sources.FixedBoundary boundaryRL(          redeclare package
      Medium = Medium, nPorts=1)
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-54,-24})));
  Modelica.Fluid.Sources.Boundary_pT boundarySL(
    redeclare package Medium = Medium,
    use_p_in=false,
    use_T_in=true,
    p=500000,
    T=343.15,
    nPorts=1)
    annotation (Placement(transformation(extent={{-64,-10},{-44,10}})));
  Modelica.Blocks.Sources.Ramp T(
    height=80,
    offset=273.15 + 10.0,
    duration(displayUnit="h") = 18000,
    startTime(displayUnit="h") = 3600)
    annotation (Placement(transformation(extent={{-98,-6},{-78,14}})));

  DisHeatLib.Pipes.DualPipe dualPipe(
    show_T=true,
    redeclare package Medium = Medium,
    redeclare DisHeatLib.Pipes.Library.Isoplus.Isoplus_Std_DN50 pipeType,
    L=2000,
    T_sl_init=283.15,
    T_rl_init=283.15,
    nPorts2=1,
    nPorts1=1)
            annotation (Placement(transformation(extent={{4,-22},{24,-2}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature Temp(T=293.15)
    annotation (Placement(transformation(extent={{-26,30},{-6,50}})));
equation
  connect(T.y, boundarySL.T_in)
    annotation (Line(points={{-77,4},{-66,4}},   color={0,0,127}));
  connect(Temp.port, dualPipe.port_ht)
    annotation (Line(points={{-6,40},{14,40},{14,-2}},color={191,0,0}));
  connect(dualPipe.ports_b2[1], boundaryRL.ports[1]) annotation (Line(points={{
          4,-18},{-14,-18},{-14,-24},{-44,-24}}, color={0,127,255}));
  connect(boundarySL.ports[1], dualPipe.port_a1) annotation (Line(points={{-44,
          0},{-14,0},{-14,-6},{4,-6}}, color={0,127,255}));
  connect(dualPipe.ports_b1[1], dualPipe.port_a2) annotation (Line(points={{24,
          -6},{36,-6},{36,-18},{24,-18}}, color={0,127,255}));
  annotation (__Dymola_Commands(file="modelica://DisHeatLib/Resources/Scripts/Dymola/Pipes/Examples/DualPipe.mos"
        "Simulate and plot"),
        Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(revisions="<html>
<ul>
<li>Feburary 27, 2019, by Benedikt Leitner:<br>Implementation and added User&apos;s guide. </li>
</ul>
</html>"));
end DualPipe;
