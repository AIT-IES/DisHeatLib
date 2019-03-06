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
    redeclare package Medium = Medium,
    redeclare DisHeatLib.Pipes.Library.Isoplus.Isoplus_Std_DN50 pipeType,
    L=1000,
    T_sl_init=283.15,
    T_rl_init=283.15,
    nPorts_sl=1,
    nPorts_rl=1)
            annotation (Placement(transformation(extent={{4,-22},{24,-2}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature Temp(T=293.15)
    annotation (Placement(transformation(extent={{-26,30},{-6,50}})));
public
  IBPSA.Fluid.Sensors.TemperatureTwoPort senTem1(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    T(displayUnit="degC"))
    annotation (Placement(transformation(extent={{38,-16},{58,4}})));
public
  IBPSA.Fluid.Sensors.TemperatureTwoPort senTem2(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    T(displayUnit="degC"))
    annotation (Placement(transformation(extent={{-6,-34},{-26,-14}})));
public
  IBPSA.Fluid.Sensors.TemperatureTwoPort senTem(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    T(displayUnit="degC"))
    annotation (Placement(transformation(extent={{-26,-10},{-6,10}})));
equation
  connect(T.y, boundarySL.T_in)
    annotation (Line(points={{-77,4},{-66,4}},   color={0,0,127}));
  connect(Temp.port, dualPipe.port_ht)
    annotation (Line(points={{-6,40},{14,40},{14,-2}},color={191,0,0}));
  connect(dualPipe.port_sl_b[1], senTem1.port_a)
    annotation (Line(points={{24,-6},{38,-6}}, color={0,127,255}));
  connect(senTem1.port_b, dualPipe.port_rl_a) annotation (Line(points={{58,-6},
          {66,-6},{66,-18},{24,-18}}, color={0,127,255}));
  connect(dualPipe.port_rl_b[1], senTem2.port_a) annotation (Line(points={{4,
          -18},{-2,-18},{-2,-24},{-6,-24}}, color={0,127,255}));
  connect(senTem2.port_b, boundaryRL.ports[1])
    annotation (Line(points={{-26,-24},{-44,-24}}, color={0,127,255}));
  connect(boundarySL.ports[1], senTem.port_a)
    annotation (Line(points={{-44,0},{-26,0}}, color={0,127,255}));
  connect(senTem.port_b, dualPipe.port_sl_a) annotation (Line(points={{-6,0},
          {-4,0},{-4,-6},{4,-6}}, color={0,127,255}));
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
