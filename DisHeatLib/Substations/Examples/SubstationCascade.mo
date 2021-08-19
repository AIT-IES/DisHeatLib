within DisHeatLib.Substations.Examples;
model SubstationCascade
  package Medium = IBPSA.Media.Water;
  extends Modelica.Icons.Example;

  DisHeatLib.Substations.SubstationCascade substationCascade(
    allowFlowReversal1=true,
    m1_flow_nominal=1,
    m2_flow_nominal=1,
    show_T=true,
    redeclare package Medium = Medium,
    m1_flow_nominal_supply=1,
    dp1_nominal(displayUnit="bar"),
    dp1_nominal_supply(displayUnit="bar") = 500000,
    dp_hex_nominal=100000,
    Ti=10) annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  IBPSA.Fluid.Sources.Boundary_pT bou_SL_p(
    redeclare package Medium = Medium,
    use_p_in=false,
    p=600000,
    T=353.15,
    nPorts=1)
    annotation (Placement(transformation(extent={{-32,38},{-12,58}})));
  IBPSA.Fluid.Sources.Boundary_pT bou_RL_p1(
    redeclare package Medium = Medium,
    use_p_in=false,
    p=100000,
    T=323.15,
    nPorts=1)
    annotation (Placement(transformation(extent={{48,-4},{28,16}})));
  IBPSA.Fluid.Sources.Boundary_pT bou_RL_p2(
    redeclare package Medium = Medium,
    use_p_in=false,
    p=100000,
    use_T_in=true,
    T=323.15,
    nPorts=1)
    annotation (Placement(transformation(extent={{-56,-4},{-36,16}})));
  IBPSA.Fluid.HeatExchangers.SensibleCooler_T cooler(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    dp_nominal(displayUnit="Pa") = 0,
    T_start=303.15)
    annotation (Placement(transformation(extent={{-20,-52},{0,-32}})));
  Modelica.Blocks.Sources.RealExpression TConst(y=35.0 + 273.15)                      annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-42,-34})));
  IBPSA.Fluid.Movers.FlowControlled_m_flow pump(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=1,
    inputType=IBPSA.Fluid.Types.InputType.Constant,
    addPowerToMedium=false,
    riseTime(displayUnit="min"),
    nominalValuesDefineDefaultPressureCurve=true,
    dp_nominal(displayUnit="bar") = 100000,
    constantMassFlowRate=1)
    annotation (Placement(transformation(extent={{4,-52},{24,-32}})));
  Modelica.Blocks.Sources.Trapezoid trapezoid(
    amplitude=20,
    rising(displayUnit="h") = 3600,
    width(displayUnit="h") = 3600,
    falling(displayUnit="h") = 3600,
    period(displayUnit="h") = 14400,
    offset=50 + 273.15,
    startTime(displayUnit="h") = 3600)
    annotation (Placement(transformation(extent={{-90,0},{-70,20}})));
equation
  connect(bou_SL_p.ports[1], substationCascade.port_c1)
    annotation (Line(points={{-12,48},{0,48},{0,10}}, color={0,127,255}));
  connect(cooler.TSet,TConst. y)
    annotation (Line(points={{-22,-34},{-31,-34}},
                                                 color={0,0,127}));
  connect(cooler.port_b,pump. port_a)
    annotation (Line(points={{0,-42},{4,-42}},   color={0,127,255}));
  connect(bou_RL_p2.ports[1], substationCascade.port_a1)
    annotation (Line(points={{-36,6},{-10,6}}, color={0,127,255}));
  connect(substationCascade.port_b1, bou_RL_p1.ports[1])
    annotation (Line(points={{10,6},{28,6}}, color={0,127,255}));
  connect(cooler.port_a, substationCascade.port_b2) annotation (Line(points={{-20,
          -42},{-26,-42},{-26,-6},{-10,-6}}, color={0,127,255}));
  connect(pump.port_b, substationCascade.port_a2) annotation (Line(points={{24,-42},
          {30,-42},{30,-6},{10,-6}}, color={0,127,255}));
  connect(trapezoid.y, bou_RL_p2.T_in)
    annotation (Line(points={{-69,10},{-58,10}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(
      StopTime=36000,
      Interval=60,
      __Dymola_Algorithm="Dassl"));
end SubstationCascade;
