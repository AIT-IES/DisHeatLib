within DisHeatLib.Substations.Examples;
model IndirectBaseStation
  extends Modelica.Icons.Example;
  BaseClasses.IndirectBaseStation indirectBaseStation(
    redeclare package Medium = Medium,
    OutsideDependent=false,
    FlowType=DisHeatLib.Substations.BaseClasses.BaseStationFlowType.Valve,
    m_flow_nominal_sec=1,
    Q_flow_nominal(displayUnit="kW") = 10000)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  package Medium = IBPSA.Media.Water;

  IBPSA.Fluid.Sources.Boundary_pT bou_RL_p(
    redeclare package Medium = Medium,
    use_T_in=false,
    nPorts=1,
    p=100000,
    T=313.15) annotation (Placement(transformation(extent={{58,-30},{38,-10}})));
  IBPSA.Fluid.Sources.Boundary_pT bou_SL_p(
    redeclare package Medium = Medium,
    use_p_in=false,
    nPorts=1,
    use_T_in=true,
    p=600000,
    T=353.15)
    annotation (Placement(transformation(extent={{-52,-30},{-32,-10}})));
  IBPSA.Fluid.HeatExchangers.SensibleCooler_T cooler(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    dp_nominal(displayUnit="bar") = 300000)
    annotation (Placement(transformation(extent={{-30,30},{-10,50}})));
  Modelica.Blocks.Sources.RealExpression TConst(y=30.0 + 273.15)                      annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-54,48})));
  Modelica.Blocks.Sources.Ramp T(
    height=80,
    offset=273.15 + 10.0,
    startTime(displayUnit="h") = 3600,
    duration(displayUnit="h") = 21600)
    annotation (Placement(transformation(extent={{-86,-26},{-66,-6}})));
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
    annotation (Placement(transformation(extent={{10,30},{30,50}})));
equation
  connect(bou_SL_p.ports[1], indirectBaseStation.port_sl_p) annotation (Line(
        points={{-32,-20},{-20,-20},{-20,-4.54545},{-10,-4.54545}}, color={0,127,
          255}));
  connect(indirectBaseStation.port_rl_p, bou_RL_p.ports[1]) annotation (Line(
        points={{10,-4.54545},{20,-4.54545},{20,-20},{38,-20}}, color={0,127,255}));
  connect(cooler.TSet, TConst.y)
    annotation (Line(points={{-32,48},{-43,48}}, color={0,0,127}));
  connect(bou_SL_p.T_in, T.y)
    annotation (Line(points={{-54,-16},{-65,-16}}, color={0,0,127}));

  connect(indirectBaseStation.port_sl_s, cooler.port_a) annotation (Line(points=
         {{-10,6.36364},{-22,6.36364},{-22,6},{-30,6},{-30,40}}, color={0,127,255}));
  connect(indirectBaseStation.port_rl_s, pump.port_b) annotation (Line(points={{
          10,6.36364},{18,6.36364},{18,6},{30,6},{30,40}}, color={0,127,255}));
  connect(pump.port_a, cooler.port_b)
    annotation (Line(points={{10,40},{-10,40}}, color={0,127,255}));
  annotation (__Dymola_Commands(file="modelica://DisHeatLib/Resources/Scripts/Dymola/Substations/Examples/IndirectBaseStation.mos"
        "Simulate and plot"),
        Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(revisions="<html>
<ul>
<li>Feburary 27, 2019, by Benedikt Leitner:<br>Implementation and added User&apos;s guide. </li>
</ul>
</html>"));
end IndirectBaseStation;
