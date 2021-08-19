within DisHeatLib.Examples.Cascade;
model varyingReturnTemperature
  extends Modelica.Icons.Example;
  package Medium = IBPSA.Media.Water;
  DisHeatLib.Boundary.SoilTemperature soilTemperature(T_const=278.15)
    annotation (Placement(transformation(extent={{-20,60},{0,40}})));
  DisHeatLib.Pipes.DualPipe dualPipe1(
    show_T=true,
    redeclare package Medium = Medium,
    redeclare DisHeatLib.Pipes.Library.Isoplus.Isoplus_2IMP_DN80 pipeType,
    L(displayUnit="km") = 500,
    T_sl_init=supply_pT.TemSup_nominal,
    T_rl_init=supply_pT.TemRet_nominal,
    nPorts1=2,
    nPorts2=1)
    annotation (Placement(transformation(extent={{-46,-18},{-26,2}})));
  DisHeatLib.Pipes.DualPipe dualPipe2(
    show_T=true,
    redeclare package Medium = Medium,
    redeclare DisHeatLib.Pipes.Library.Isoplus.Isoplus_2IMP_DN80 pipeType,
    L(displayUnit="m") = 500,
    T_sl_init=supply_pT.TemSup_nominal,
    T_rl_init=supply_pT.TemRet_nominal,
    nPorts2=3,
    nPorts1=1)
    annotation (Placement(transformation(extent={{6,-18},{26,2}})));
  DisHeatLib.Demand.Demand demand2(
    redeclare package Medium = Medium,
    dp_nominal(displayUnit="bar") = 100000,
    Q_flow_nominal(displayUnit="kW") = 100000,
    TemSup_nominal=333.15,
    TemRet_nominal=303.15,
    heatLoad=DisHeatLib.Demand.BaseClasses.InputTypeDemand.InputQ,
    Q_constant(displayUnit="kW") = 100000,
    redeclare DisHeatLib.Demand.BaseDemands.FixedReturn demandType)
    annotation (Placement(transformation(extent={{-22,-80},{-2,-100}})));
  IBPSA.Fluid.HeatExchangers.SensibleCooler_T cooler(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    dp_nominal(displayUnit="Pa") = 0,
    T_start=303.15)
    annotation (Placement(transformation(extent={{44,-12},{64,8}})));
  IBPSA.Fluid.Movers.FlowControlled_m_flow pump(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=1,
    inputType=IBPSA.Fluid.Types.InputType.Continuous,
    addPowerToMedium=false,
    riseTime(displayUnit="min"),
    nominalValuesDefineDefaultPressureCurve=true,
    dp_nominal(displayUnit="bar") = 100000,
    constantMassFlowRate=1)
    annotation (Placement(transformation(extent={{72,-12},{92,8}})));
  DisHeatLib.Substations.SubstationCascade substationCascade(
    allowFlowReversal1=true,
    show_T=true,
    redeclare package Medium = Medium,
    Q1_flow_nominal(displayUnit="kW") = 100000,
    Q1_flow_nominal_supply(displayUnit="kW") = 200000,
    TemSup1_nominal=363.15,
    TemRet1_supply_nominal=343.15,
    TemRet1_nominal=308.15,
    dp1_nominal(displayUnit="bar") = 50000,
    dp1_nominal_supply(displayUnit="bar") = 100000,
    Q2_flow_nominal(displayUnit="kW") = 100000,
    TemSup2_nominal=333.15,
    TemRet2_nominal=303.15,
    dp_hex_nominal=0,
    Ti=10) annotation (Placement(transformation(extent={{-22,-64},{-2,-44}})));
  IBPSA.Fluid.Sensors.TemperatureTwoPort senTem_a1(redeclare package Medium =
        Medium, m_flow_nominal=1)
    annotation (Placement(transformation(extent={{-46,-58},{-26,-38}})));
  IBPSA.Fluid.Sensors.TemperatureTwoPort senTem_b1(redeclare package Medium =
        Medium, m_flow_nominal=1)
    annotation (Placement(transformation(extent={{4,-58},{24,-38}})));
  IBPSA.Fluid.Sensors.TemperatureTwoPort senTem_c1(redeclare package Medium =
        Medium, m_flow_nominal=1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-12,-28})));
  IBPSA.Fluid.Sensors.TemperatureTwoPort senTem_a2(redeclare package Medium =
        Medium, m_flow_nominal=1)
    annotation (Placement(transformation(extent={{6,-100},{26,-80}})));
  IBPSA.Fluid.Sensors.TemperatureTwoPort senTem_b2(redeclare package Medium =
        Medium, m_flow_nominal=1)
    annotation (Placement(transformation(extent={{-48,-100},{-28,-80}})));
  IBPSA.Fluid.Sensors.MassFlowRate senMasFlo_a1(redeclare package Medium =
        Medium)
    annotation (Placement(transformation(extent={{-74,-58},{-54,-38}})));
  IBPSA.Fluid.Sensors.MassFlowRate senMasFlo_c1(redeclare package Medium =
        Medium) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-12,-4})));
  IBPSA.Fluid.Sensors.TemperatureTwoPort senTem_sl(redeclare package Medium =
        Medium, m_flow_nominal=1)
    annotation (Placement(transformation(extent={{-112,-8},{-92,12}})));
  IBPSA.Fluid.Sensors.TemperatureTwoPort senTem_rl(redeclare package Medium =
        Medium, m_flow_nominal=1)
    annotation (Placement(transformation(extent={{-92,-34},{-112,-14}})));
  DisHeatLib.Supply.Supply_pT supply_pT(
    redeclare package Medium = Medium,
    Q_flow_nominal(displayUnit="MW") = 5000000,
    TemSup_nominal=363.15,
    TemRet_nominal=323.15,
    powerCha(Q_flow={0}, P={0}),
    dp_nominal=500000,
    SupplyTemperature=DisHeatLib.Supply.BaseClasses.InputTypeSupplyTemp.Constant,
    dp_controller=false,
    dp_min=100000,
    dp_set=100000,
    dp_max=100000,
    nPorts=1)
    annotation (Placement(transformation(extent={{-140,-6},{-120,14}})));

  Modelica.Blocks.Sources.Trapezoid TRetInput(
    amplitude=30,
    rising(displayUnit="h") = 18000,
    width(displayUnit="h") = 18000,
    falling(displayUnit="h") = 18000,
    period(displayUnit="h") = 72000,
    offset=55 + 273.15,
    startTime(displayUnit="h") = 14400)
    annotation (Placement(transformation(extent={{12,26},{32,46}})));
  Modelica.Blocks.Sources.Constant massFlowInput(k=5)
    annotation (Placement(transformation(extent={{54,24},{74,44}})));
  Modelica.Blocks.Sources.Constant heatDemandInput(k=100000)
    annotation (Placement(transformation(extent={{84,-264},{64,-244}})));
  Modelica.Blocks.Sources.Constant heatDemandInput1(k=100000)
    annotation (Placement(transformation(extent={{26,-134},{6,-114}})));
equation
  connect(soilTemperature.port, dualPipe1.port_ht) annotation (Line(points={{-10,40},
          {-10,8},{-36,8},{-36,2}},       color={191,0,0}));
  connect(dualPipe1.ports_b1[1], dualPipe2.port_a1) annotation (Line(points={{-26,-4},
          {-8,-4},{-8,-2},{6,-2}},         color={0,127,255}));
  connect(dualPipe2.ports_b2[1], dualPipe1.port_a2) annotation (Line(points={{6,
          -16.6667},{-8,-16.6667},{-8,-14},{-26,-14}},   color={0,127,255}));
  connect(soilTemperature.port, dualPipe2.port_ht) annotation (Line(points={{-10,40},
          {-10,8},{16,8},{16,2}},           color={191,0,0}));
  connect(cooler.port_b, pump.port_a)
    annotation (Line(points={{64,-2},{72,-2}}, color={0,127,255}));
  connect(pump.port_b, dualPipe2.port_a2) annotation (Line(points={{92,-2},{98,-2},
          {98,-14},{26,-14}}, color={0,127,255}));
  connect(cooler.port_a, dualPipe2.ports_b1[1])
    annotation (Line(points={{44,-2},{26,-2}}, color={0,127,255}));
  connect(substationCascade.port_a1, senTem_a1.port_b)
    annotation (Line(points={{-22,-48},{-26,-48}}, color={0,127,255}));
  connect(substationCascade.port_b1, senTem_b1.port_a)
    annotation (Line(points={{-2,-48},{4,-48}}, color={0,127,255}));
  connect(senTem_b1.port_b, dualPipe2.ports_b2[2]) annotation (Line(points={{24,
          -48},{24,-34},{4,-34},{4,-14},{6,-14}}, color={0,127,255}));
  connect(substationCascade.port_c1, senTem_c1.port_b)
    annotation (Line(points={{-12,-44},{-12,-38}}, color={0,127,255}));
  connect(demand2.port_b, senTem_a2.port_a)
    annotation (Line(points={{-2,-90},{6,-90}}, color={0,127,255}));
  connect(senTem_a2.port_b, substationCascade.port_a2) annotation (Line(points=
          {{26,-90},{26,-72},{-2,-72},{-2,-60}}, color={0,127,255}));
  connect(demand2.port_a, senTem_b2.port_b)
    annotation (Line(points={{-22,-90},{-28,-90}}, color={0,127,255}));
  connect(senTem_b2.port_a, substationCascade.port_b2) annotation (Line(points=
          {{-48,-90},{-48,-66},{-22,-66},{-22,-60}}, color={0,127,255}));
  connect(senTem_a1.port_a, senMasFlo_a1.port_b)
    annotation (Line(points={{-46,-48},{-54,-48}}, color={0,127,255}));
  connect(senMasFlo_a1.port_a, dualPipe2.ports_b2[3]) annotation (Line(points={{-74,-48},
          {-74,-11.3333},{6,-11.3333}},           color={0,127,255}));
  connect(senTem_c1.port_a, senMasFlo_c1.port_b)
    annotation (Line(points={{-12,-18},{-12,-14}}, color={0,127,255}));
  connect(senMasFlo_c1.port_a, dualPipe1.ports_b1[2])
    annotation (Line(points={{-12,6},{-26,6},{-26,0}}, color={0,127,255}));
  connect(senTem_sl.port_b, dualPipe1.port_a1) annotation (Line(points={{-92,2},
          {-78,2},{-78,-2},{-46,-2}}, color={0,127,255}));
  connect(senTem_rl.port_a, dualPipe1.ports_b2[1]) annotation (Line(points={{
          -92,-24},{-80,-24},{-80,-26},{-58,-26},{-58,-14},{-46,-14}}, color={0,
          127,255}));
  connect(senTem_sl.port_a, supply_pT.ports_b[1]) annotation (Line(points={{
          -112,2},{-112,20},{-120,20},{-120,4}}, color={0,127,255}));
  connect(supply_pT.port_a, senTem_rl.port_b) annotation (Line(points={{-140,4},
          {-150,4},{-150,-24},{-112,-24}}, color={0,127,255}));
  connect(TRetInput.y, cooler.TSet)
    annotation (Line(points={{33,36},{42,36},{42,6}}, color={0,0,127}));
  connect(massFlowInput.y, pump.m_flow_in)
    annotation (Line(points={{75,34},{82,34},{82,10}}, color={0,0,127}));
  connect(heatDemandInput1.y, demand2.u) annotation (Line(points={{5,-124},{-12,
          -124},{-12,-102}}, color={0,0,127}));
  annotation (__Dymola_Commands(file="modelica://DisHeatLib/Resources/Scripts/Dymola/Examples/Cascade/varyingReturnTemperature/varyingReturnTemperature.mos"
        "Simulate and plot"),
        Icon(coordinateSystem(preserveAspectRatio=false, extent={{-160,-140},{
            120,100}})),                                   Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-160,-140},{120,
            100}})),
    experiment(
      StopTime=259200,
      Interval=900.003,
      Tolerance=1e-06,
      __Dymola_Algorithm="Dassl"),
    Documentation(info="<html>
<p>This scenario studies the behavior of the cascading substation in the presence of fluctuating return temperatures in the main network. This can affect the ability to supply the connected sub-network in case the return temperature goes below the necessary supply temperature of the sub-network. In such a case, the supply line connection will be activated as a backup to guarantee supply. </p>
<p>In the concrete example the return temperature is varied using a trapezoid signal. Thus, the return temperature at the cascading connection varies +- 15&deg;C around the nominal/design return temperature of 70&deg;C. The mass flow at the connection point and the heat load of the sub-network are not varied. </p>
<p><b>Available commands: Simulate and plot: simulates the example and plots the results so that the example can be better understood.</b></p>
</html>"));
end varyingReturnTemperature;
