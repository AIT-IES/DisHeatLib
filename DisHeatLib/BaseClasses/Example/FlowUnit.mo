within DisHeatLib.BaseClasses.Example;
model FlowUnit
  extends Modelica.Icons.Example;
  package Medium = IBPSA.Media.Water;

  DisHeatLib.BaseClasses.FlowUnit flowUnit(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    FlowType=DisHeatLib.BaseClasses.FlowType.Pump,
    dp_nominal(displayUnit="bar") = 100000)
    annotation (Placement(transformation(extent={{-10,28},{10,48}})));
  IBPSA.Fluid.Sources.Boundary_pT bou_SL_p(
    redeclare package Medium = Medium,
    use_p_in=false,
    use_T_in=false,
    p=200000,
    T=353.15,
    nPorts=1)
    annotation (Placement(transformation(extent={{-56,28},{-36,48}})));
  IBPSA.Fluid.Sources.Boundary_pT bou_RL_p(
    redeclare package Medium = Medium,
    use_T_in=false,
    p=100000,
    T=313.15,
    nPorts=1) annotation (Placement(transformation(extent={{54,28},{34,48}})));
  Modelica.Blocks.Sources.Ramp T(
    height=1,
    offset=0,
    startTime(displayUnit="s") = 10,
    duration(displayUnit="s") = 100)
    annotation (Placement(transformation(extent={{-32,68},{-12,88}})));
  DisHeatLib.BaseClasses.FlowUnit flowUnit1(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    FlowType=DisHeatLib.BaseClasses.FlowType.Valve,
    dp_nominal(displayUnit="bar") = 100000,
    redeclare IBPSA.Fluid.Actuators.Valves.TwoWayLinear valve(riseTime=30,
        y_start=0))
    annotation (Placement(transformation(extent={{-10,-70},{10,-50}})));
  IBPSA.Fluid.Sources.Boundary_pT bou_SL_p1(
    redeclare package Medium = Medium,
    use_p_in=false,
    use_T_in=false,
    p=200000,
    T=353.15,
    nPorts=1)
    annotation (Placement(transformation(extent={{-56,-70},{-36,-50}})));
  IBPSA.Fluid.Sources.Boundary_pT bou_RL_p1(
    redeclare package Medium = Medium,
    use_T_in=false,
    p=100000,
    T=313.15,
    nPorts=1) annotation (Placement(transformation(extent={{54,-70},{34,-50}})));
  Modelica.Blocks.Sources.Ramp T1(
    height=1,
    offset=0,
    startTime(displayUnit="s") = 10,
    duration(displayUnit="s") = 100)
    annotation (Placement(transformation(extent={{-32,-30},{-12,-10}})));
equation
  connect(bou_SL_p.ports[1], flowUnit.port_a)
    annotation (Line(points={{-36,38},{-10,38}},
                                               color={0,127,255}));
  connect(flowUnit.port_b, bou_RL_p.ports[1])
    annotation (Line(points={{10,38},{34,38}},
                                             color={0,127,255}));
  connect(T.y, flowUnit.y)
    annotation (Line(points={{-11,78},{0,78},{0,50}}, color={0,0,127}));
  connect(bou_SL_p1.ports[1], flowUnit1.port_a)
    annotation (Line(points={{-36,-60},{-10,-60}}, color={0,127,255}));
  connect(flowUnit1.port_b, bou_RL_p1.ports[1])
    annotation (Line(points={{10,-60},{34,-60}}, color={0,127,255}));
  connect(T1.y, flowUnit1.y)
    annotation (Line(points={{-11,-20},{0,-20},{0,-48}}, color={0,0,127}));
  annotation (__Dymola_Commands(file="modelica://DisHeatLib/Resources/Scripts/Dymola/BaseClasses/Examples/FlowUnit.mos"
        "Simulate and plot"),
        experiment(
      StopTime=500,
      Interval=1,
      __Dymola_Algorithm="Cvode"),
    Documentation(info="<html>
<p><span style=\"font-family: Arial,sans-serif;\">Available commands: Simulate and plot: simulates the example and plots the results so that the example can be better understood.</span></p>
</html>"));
end FlowUnit;
