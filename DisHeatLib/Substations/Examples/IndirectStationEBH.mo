within DisHeatLib.Substations.Examples;
model IndirectStationEBH
  extends Modelica.Icons.Example;
  BaseStations.IndirectStationEBH indirectStationEBH(
    show_T=true,
    redeclare package Medium = Medium,
    Q1_flow_nominal=100000,
    dp1_nominal(displayUnit="bar") = 100000,
    OutsideDependent=false,
    electricBoosterHeater(Q_flow_nominal(displayUnit="kW") = 10000,
        TemSup_nominal=343.15))
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  package Medium = IBPSA.Media.Water;

  IBPSA.Fluid.Sources.Boundary_pT bou_RL_p(
    redeclare package Medium = Medium,
    use_T_in=false,
    p=100000,
    T=313.15,
    nPorts=1) annotation (Placement(transformation(extent={{54,24},{34,44}})));
  IBPSA.Fluid.Sources.Boundary_pT bou_SL_p(
    redeclare package Medium = Medium,
    use_p_in=false,
    use_T_in=true,
    p=600000,
    T=353.15,
    nPorts=1)
    annotation (Placement(transformation(extent={{-56,24},{-36,44}})));
  IBPSA.Fluid.HeatExchangers.SensibleCooler_T cooler(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    dp_nominal(displayUnit="bar") = 300000)
    annotation (Placement(transformation(extent={{-30,-50},{-10,-30}})));
  Modelica.Blocks.Sources.RealExpression TConst(y=30.0 + 273.15)                      annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-54,-32})));
  Modelica.Blocks.Sources.Ramp T(
    height=80,
    offset=273.15 + 10.0,
    startTime(displayUnit="h") = 3600,
    duration(displayUnit="h") = 21600)
    annotation (Placement(transformation(extent={{-90,28},{-70,48}})));
  IBPSA.Fluid.Movers.FlowControlled_m_flow pump(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=1,
    inputType=IBPSA.Fluid.Types.InputType.Constant,
    addPowerToMedium=false,
    riseTime(displayUnit="min"),
    nominalValuesDefineDefaultPressureCurve=true,
    dp_nominal=1,
    constantMassFlowRate=0.1)
    annotation (Placement(transformation(extent={{10,-50},{30,-30}})));
equation
  connect(cooler.TSet, TConst.y)
    annotation (Line(points={{-32,-32},{-43,-32}},
                                                 color={0,0,127}));
  connect(bou_SL_p.T_in, T.y)
    annotation (Line(points={{-58,38},{-69,38}},   color={0,0,127}));

  connect(pump.port_a, cooler.port_b)
    annotation (Line(points={{10,-40},{-10,-40}},
                                                color={0,127,255}));
  connect(pump.port_b, indirectStationEBH.port_a2) annotation (Line(points={{30,
          -40},{38,-40},{38,-4.54545},{10,-4.54545}}, color={0,127,255}));
  connect(cooler.port_a, indirectStationEBH.port_b2) annotation (Line(points={{-30,
          -40},{-36,-40},{-36,-4.54545},{-10,-4.54545}}, color={0,127,255}));
  connect(bou_SL_p.ports[1], indirectStationEBH.port_a1) annotation (Line(
        points={{-36,34},{-18,34},{-18,6.36364},{-10,6.36364}}, color={0,127,255}));
  connect(indirectStationEBH.port_b1, bou_RL_p.ports[1]) annotation (Line(
        points={{10,6.36364},{14,6.36364},{14,34},{34,34}}, color={0,127,255}));
  annotation (__Dymola_Commands(file="modelica://DisHeatLib/Resources/Scripts/Dymola/Substations/Examples/IndirectStationEBH.mos"
        "Simulate and plot"),
        Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(revisions="<html>
<ul>
<li>Feburary 27, 2019, by Benedikt Leitner:<br>Implementation and added User&apos;s guide. </li>
</ul>
</html>"));
end IndirectStationEBH;
