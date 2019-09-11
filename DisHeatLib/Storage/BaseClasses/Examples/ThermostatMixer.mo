within DisHeatLib.Storage.BaseClasses.Examples;
model ThermostatMixer
  extends Modelica.Icons.Example;
  package Medium = IBPSA.Media.Water;

  DisHeatLib.Storage.StorageTank storageTank(
    show_T=true,
    redeclare package Medium = Medium,
    TemInit=343.15,
    VTan=5,
    hTan=2,
    nSeg=4,
    m_flow_nominal=1)
    annotation (Placement(transformation(extent={{-8,14},{12,34}})));
  IBPSA.Fluid.Sources.MassFlowSource_T
                                  boundary(
    redeclare package Medium = Medium,
    use_m_flow_in=true,
    m_flow=0.1,
    use_T_in=false,
    T=343.15,
    nPorts=1)
    annotation (Placement(transformation(extent={{-54,40},{-34,60}})));
  IBPSA.Fluid.Sources.Boundary_pT bou_RL_p(
    redeclare package Medium = Medium,
    use_T_in=false,
    p=100000,
    T=313.15,
    nPorts=1) annotation (Placement(transformation(extent={{86,40},{66,60}})));
  IBPSA.Fluid.HeatExchangers.SensibleCooler_T cooler(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    dp_nominal(displayUnit="bar") = 300000)
    annotation (Placement(transformation(extent={{-38,-60},{-18,-40}})));
  Modelica.Blocks.Sources.RealExpression TConst(y=10.0 + 273.15)                      annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-68,-42})));
  IBPSA.Fluid.Movers.FlowControlled_m_flow pump(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=1,
    inputType=IBPSA.Fluid.Types.InputType.Continuous,
    addPowerToMedium=false,
    riseTime(displayUnit="min"),
    nominalValuesDefineDefaultPressureCurve=true,
    dp_nominal=1,
    constantMassFlowRate=0.1)
    annotation (Placement(transformation(extent={{14,-40},{34,-60}})));
  Modelica.Blocks.Sources.Pulse pulse(
    amplitude=storageTank.m_flow_nominal/2,
    width=10,
    period(displayUnit="h") = 18000,
    startTime(displayUnit="h"))
    annotation (Placement(transformation(extent={{-10,-78},{10,-58}})));
  Controls.storage_control  storage_control(
    T_top_set=333.15,
    T_bot_set=328.15,
    T_top_bandwidth=10)
    annotation (Placement(transformation(extent={{-42,74},{-62,94}})));
  Modelica.Blocks.Math.Gain gain(k=storageTank.m_flow_nominal)  annotation (
      Placement(transformation(
        extent={{-4,-4},{4,4}},
        rotation=-90,
        origin={-72,76})));
  IBPSA.Fluid.FixedResistances.Junction jun(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal={1,1,1},
    dp_nominal={0,0,0}) annotation (Placement(transformation(
        extent={{6,-6},{-6,6}},
        rotation=-90,
        origin={56,0})));
  BaseClasses.ThermostatMixer thermostatMixer(
    redeclare package Medium = Medium,
    FlowType=DisHeatLib.BaseClasses.FlowType.Valve,
    m_flow_nominal=1,
    dp_nominal=100000,
    Tem_set=313.15) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-52,0})));
  IBPSA.Fluid.Sensors.TemperatureTwoPort senTem(redeclare package Medium =
        Medium, m_flow_nominal=1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-52,-26})));
equation
  connect(pump.port_a,cooler. port_b)
    annotation (Line(points={{14,-50},{-18,-50}},
                                                color={0,127,255}));
  connect(boundary.ports[1],storageTank. port_a1) annotation (Line(points={{-34,50},
          {-12,50},{-12,30},{-8,30}},      color={0,127,255}));
  connect(storageTank.port_b1,bou_RL_p. ports[1]) annotation (Line(points={{12,30},
          {24,30},{24,50},{66,50}},     color={0,127,255}));
  connect(pulse.y,pump. m_flow_in)
    annotation (Line(points={{11,-68},{24,-68},{24,-62}},color={0,0,127}));
  connect(storage_control.y,gain. u) annotation (Line(points={{-63,84},{-72,84},
          {-72,80.8}}, color={0,0,127}));
  connect(gain.y,boundary. m_flow_in) annotation (Line(points={{-72,71.6},{-72,58},
          {-56,58}},     color={0,0,127}));
  connect(storageTank.TemTank[1], storage_control.T_top) annotation (Line(
        points={{2,13.75},{2,6},{22,6},{22,89},{-40,89}},     color={0,0,127}));
  connect(storageTank.TemTank[4], storage_control.T_bot) annotation (Line(
        points={{2,12.25},{2,6},{22,6},{22,79},{-40,79}},     color={0,0,127}));
  connect(pump.port_b, jun.port_1)
    annotation (Line(points={{34,-50},{56,-50},{56,-6}}, color={0,127,255}));
  connect(thermostatMixer.port_3, jun.port_3)
    annotation (Line(points={{-42,0},{50,0}}, color={0,127,255}));
  connect(thermostatMixer.port_1, storageTank.port_b2)
    annotation (Line(points={{-52,10},{-52,18},{-8,18}}, color={0,127,255}));
  connect(storageTank.port_a2, jun.port_2)
    annotation (Line(points={{12,18},{56,18},{56,6}}, color={0,127,255}));
  connect(senTem.port_b, cooler.port_a) annotation (Line(points={{-52,-36},{-52,
          -50},{-38,-50}}, color={0,127,255}));
  connect(TConst.y, cooler.TSet)
    annotation (Line(points={{-57,-42},{-40,-42}}, color={0,0,127}));
  connect(thermostatMixer.port_2, senTem.port_a)
    annotation (Line(points={{-52,-10},{-52,-16}}, color={0,127,255}));
  annotation (__Dymola_Commands(file="modelica://DisHeatLib/Resources/Scripts/Dymola/Storage/BaseClasses/Examples/ThermostatMixer.mos"
        "Simulate and plot"),
        Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(
      StopTime=259200,
      Interval=1,
      __Dymola_Algorithm="Cvode"),
    Documentation(revisions="<html>
<ul>
<li>Feburary 27, 2019, by Benedikt Leitner:<br>Implementation and added User&apos;s guide. </li>
</ul>
</html>", info="<html>
<p><span style=\"font-family: Arial,sans-serif;\">This example extends the StorageTank example to show how the thermostat mixer keeps the temperature of the water that reaches the demand almost perfectly constant.</span></p>
</html>"));
end ThermostatMixer;
