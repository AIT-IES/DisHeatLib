within DisHeatLib.Substations.Examples;
model Substation
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
    annotation (Placement(transformation(extent={{-64,22},{-44,42}})));
  Modelica.Blocks.Sources.RealExpression TConst(y=10.0 + 273.15)                      annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-86,40})));
  Modelica.Blocks.Sources.Ramp T(
    height=80,
    offset=273.15 + 10.0,
    startTime(displayUnit="h") = 3600,
    duration(displayUnit="h") = 21600)
    annotation (Placement(transformation(extent={{-90,-26},{-70,-6}})));
  DisHeatLib.Substations.Substation substation(
    dp_nominal=100000,
    show_T=true,
    TemSup_nominal=363.15,
    use_bypass=false,
    redeclare DisHeatLib.Substations.BaseClasses.IndirectStation baseStationSH(
      Q1_flow_nominal=10000,
      TemRet1_nominal=308.15,
      TemSup2_nominal=323.15,
      TemRet2_nominal=303.15,
      OutsideDependent=false),
    redeclare DisHeatLib.Substations.BaseClasses.IndirectStation baseStationDHW(
      Q1_flow_nominal=10000,
      TemRet1_nominal=288.15,
      TemSup2_nominal=333.15,
      TemRet2_nominal=283.15,
      OutsideDependent=false),
    redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-10,-12},{10,8}})));
  IBPSA.Fluid.HeatExchangers.SensibleCooler_T cooler1(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    dp_nominal(displayUnit="bar") = 300000,
    T_start=303.15)
    annotation (Placement(transformation(extent={{44,22},{64,42}})));
  Modelica.Blocks.Sources.RealExpression TConst1(
                                                y=30.0 + 273.15)                      annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={24,40})));
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
    annotation (Placement(transformation(extent={{-40,22},{-20,42}})));
  IBPSA.Fluid.Movers.FlowControlled_m_flow pump1(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=1,
    inputType=IBPSA.Fluid.Types.InputType.Constant,
    addPowerToMedium=false,
    riseTime(displayUnit="min"),
    nominalValuesDefineDefaultPressureCurve=true,
    dp_nominal=1,
    constantMassFlowRate=0.1)
    annotation (Placement(transformation(extent={{68,22},{88,42}})));
equation
  connect(cooler.TSet, TConst.y)
    annotation (Line(points={{-66,40},{-75,40}}, color={0,0,127}));
  connect(bou_SL_p.T_in, T.y)
    annotation (Line(points={{-62,-16},{-69,-16}}, color={0,0,127}));

  connect(TConst1.y, cooler1.TSet)
    annotation (Line(points={{35,40},{42,40}}, color={0,0,127}));
  connect(cooler.port_b, pump.port_a)
    annotation (Line(points={{-44,32},{-40,32}}, color={0,127,255}));
  connect(cooler1.port_b, pump1.port_a)
    annotation (Line(points={{64,32},{68,32}}, color={0,127,255}));
  connect(bou_RL_p.ports[1], substation.port_b) annotation (Line(points={{40,
          -20},{20,-20},{20,-6.54545},{10,-6.54545}}, color={0,127,255}));
  connect(bou_SL_p.ports[1], substation.port_a) annotation (Line(points={{-40,
          -20},{-20,-20},{-20,-6.54545},{-10,-6.54545}}, color={0,127,255}));
  connect(substation.port_b_DHW, cooler.port_a) annotation (Line(points={{-10,
          4.36364},{-76,4.36364},{-76,32},{-64,32}}, color={0,127,255}));
  connect(pump.port_b, substation.port_a_DHW) annotation (Line(points={{-20,32},
          {-16,32},{-16,0.727273},{-10,0.727273}}, color={0,127,255}));
  connect(substation.port_b_SH, cooler1.port_a) annotation (Line(points={{10,
          4.36364},{30,4.36364},{30,32},{44,32}}, color={0,127,255}));
  connect(pump1.port_b, substation.port_a_SH) annotation (Line(points={{88,32},
          {92,32},{92,0.727273},{10,0.727273}}, color={0,127,255}));
  annotation (__Dymola_Commands(file="modelica://DisHeatLib/Resources/Scripts/Dymola/Substations/Examples/Substation.mos"
        "Simulate and plot"),
        Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(revisions="<html>
<ul>
<li>Feburary 27, 2019, by Benedikt Leitner:<br>Implementation and added User&apos;s guide. </li>
</ul>
</html>"));
end Substation;
