within DisHeatLib.Substations.Examples;
model SubstationSingle
  import DisHeatLib;
  extends Modelica.Icons.Example;
  package Medium = IBPSA.Media.Water;

  IBPSA.Fluid.Sources.Boundary_pT bou_RL_p(
    redeclare package Medium = Medium,
    use_T_in=false,
    p=100000,
    T=313.15,
    nPorts=1) annotation (Placement(transformation(extent={{60,-30},{40,-10}})));
  IBPSA.Fluid.Sources.Boundary_pT bou_SL_p(
    redeclare package Medium = Medium,
    use_p_in=false,
    use_T_in=true,
    p=700000,
    T=353.15,
    nPorts=1)
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));
  IBPSA.Fluid.HeatExchangers.SensibleCooler_T cooler(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    dp_nominal(displayUnit="bar") = 300000,
    T_start=303.15)
    annotation (Placement(transformation(extent={{-22,28},{-2,48}})));
  Modelica.Blocks.Sources.RealExpression TConst(y=10.0 + 273.15)                      annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-44,46})));
  Modelica.Blocks.Sources.Ramp T(
    height=80,
    offset=273.15 + 10.0,
    startTime(displayUnit="h") = 3600,
    duration(displayUnit="h") = 21600)
    annotation (Placement(transformation(extent={{-90,-26},{-70,-6}})));
  DisHeatLib.Substations.SubstationSingle substation(
    show_T=true,
    dp1_nominal=100000,
    TemSup_nominal=363.15,
    use_bypass=false,
    redeclare package Medium = Medium,
    redeclare DisHeatLib.Substations.BaseStations.IndirectStation baseStation(
        m1_flow_nominal=1))
    annotation (Placement(transformation(extent={{-10,8},{10,-12}})));
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
    annotation (Placement(transformation(extent={{2,28},{22,48}})));
equation
  connect(cooler.TSet, TConst.y)
    annotation (Line(points={{-24,46},{-33,46}}, color={0,0,127}));
  connect(bou_SL_p.T_in, T.y)
    annotation (Line(points={{-62,-16},{-69,-16}}, color={0,0,127}));

  connect(cooler.port_b, pump.port_a)
    annotation (Line(points={{-2,38},{2,38}},    color={0,127,255}));
  connect(bou_SL_p.ports[1], substation.port_a1) annotation (Line(points={{-40,-20},
          {-20,-20},{-20,-8},{-10,-8}}, color={0,127,255}));
  connect(substation.port_b1, bou_RL_p.ports[1]) annotation (Line(points={{10,-8},
          {16,-8},{16,-8},{20,-8},{20,-20},{40,-20}}, color={0,127,255}));
  connect(substation.port_a2, pump.port_b) annotation (Line(points={{10,4},{20,4},
          {20,2},{26,2},{26,38},{22,38}}, color={0,127,255}));
  connect(substation.port_b2, cooler.port_a) annotation (Line(points={{-10,4},{-18,
          4},{-18,2},{-26,2},{-26,38},{-22,38}}, color={0,127,255}));
  annotation (__Dymola_Commands(file="modelica://DisHeatLib/Resources/Scripts/Dymola/Substations/Examples/SubstationSingle.mos"
        "Simulate and plot"),
        Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(revisions="<html>
<ul>
<li>Feburary 27, 2019, by Benedikt Leitner:<br>Implementation and added User&apos;s guide. </li>
</ul>
</html>", info="<html>
<p><span style=\"font-family: Arial,sans-serif;\">This example shows how the substation delivers hot water to a consumer, such as the cooler here. The plot shows how the indirect substation is able to deliver the supply temperature in the demand loop, until the supply temperature is above the nominal demand temperature, where the temperature supplied to the loop stays at its nominal condition.</span></p>
<p><br><span style=\"font-family: Arial,sans-serif;\">Available commands: Simulate and plot: simulates the example and plots the results so that the example can be better understood.</span></p>
</html>"));
end SubstationSingle;
