within DisHeatLib.Substations.BaseClasses;
model IndirectStationEBH
  extends BaseStation(
    Q2_flow_nominal=Q1_flow_nominal,
    m2_flow_nominal=Q2_flow_nominal/((electricBoosterHeater.TemSup_nominal-TemRet2_nominal)*cp_default),
    total_power(y=electricBoosterHeater.P));

  //Secondary side supply temperature
  parameter Modelica.SIunits.Temperature TemOut_max(displayUnit="degC")=15.0+273.15
    "Outdoor temperature where minimum secondary supply temperature is needed"
    annotation (Dialog(enable = OutsideDependent, group="Temperature control secondary side"));
  parameter Modelica.SIunits.Temperature TemOut_min(displayUnit="degC")=-5.0+273.15
    "Outdoor temperature where maximum secondary supply temperature is needed"
    annotation (Dialog(enable = OutsideDependent, group="Temperature control secondary side"));
  parameter Modelica.SIunits.Temperature TemSup2_min(displayUnit="degC")=50.0+273.15
    "Secondary supply temperature where maximum outdoor temperature is reached"
    annotation(Dialog(enable = OutsideDependent, group = "Temperature control secondary side"));
  parameter Modelica.SIunits.Temperature TemSup2_max(displayUnit="degC")=60.0+273.15
    "Secondary supply temperature where minimum outdoor temperature is reached"
    annotation(Dialog(enable = OutsideDependent, group = "Temperature control secondary side"));

  //Heat exchanger parameter
  parameter Modelica.SIunits.Efficiency hex_efficiency(max=1)=0.90
    "Constant efficiency of the heat exchanger"
    annotation(Dialog(group = "Heat exchanger and flow"));
  parameter Modelica.SIunits.PressureDifference dp_hex_nominal=0
    "Nominal pressure difference at the heat exchanger at primary side"
    annotation(Dialog(group = "Heat exchanger and flow"));
  parameter Real k(min=0, unit="1") = 0.01 "Gain of flow controller"
    annotation(Dialog(group = "Heat exchanger and flow"));
  parameter Modelica.SIunits.Time Ti(min=Modelica.Constants.small)=120
    "Time constant of Integrator block of flow controller"
    annotation(Dialog(group = "Heat exchanger and flow"));
  parameter Real min_y(max=1)=0.0
    "Minimum position of flow controller (e.g, to mimic bypass)"
    annotation(Dialog(group = "Heat exchanger and flow"));

protected
      final parameter Modelica.SIunits.SpecificHeatCapacity cp_default=
        Medium.cp_const
        "Specific heat capacity of the fluid"
        annotation(Evaluate=true);

public
  IBPSA.Fluid.Actuators.Valves.TwoWayEqualPercentage     valve(
    redeclare package Medium = Medium,
    dpValve_nominal=dp1_nominal - dp_hex_nominal,
    m_flow_nominal=m1_flow_nominal,
    allowFlowReversal=allowFlowReversal1,
    riseTime(displayUnit="min"),
    linearized=linearizeFlowResistance,
    from_dp=from_dp,
    dpFixed_nominal=dp_hex_nominal) if FlowType == DisHeatLib.BaseClasses.FlowType.Valve
    annotation (Placement(transformation(extent={{-26,70},{-6,50}})));
public
  IBPSA.Fluid.HeatExchangers.ConstantEffectiveness hex(redeclare package
      Medium1 = Medium, redeclare package Medium2 = Medium,
    allowFlowReversal1=allowFlowReversal1,
    allowFlowReversal2=allowFlowReversal2,
    m1_flow_small=m1_flow_small,
    m2_flow_small=m2_flow_small,
    eps=hex_efficiency,
    m1_flow_nominal=m1_flow_nominal,
    m2_flow_nominal=m2_flow_nominal,
    dp2_nominal(displayUnit="kPa") = 0,
    dp1_nominal=0)
    annotation (Placement(transformation(extent={{12,-8},{32,12}})));
public
  IBPSA.Fluid.Storage.ExpansionVessel exp(redeclare package Medium = Medium,
    T_start=TemSup2_nominal,
    V_start=m2_flow_nominal*0.1)
    annotation (Placement(transformation(extent={{58,-44},{78,-24}})));
public
  IBPSA.Fluid.Sensors.TemperatureTwoPort senTem(
    redeclare package Medium = Medium,
    transferHeat=false,
    T(displayUnit="degC"),
    T_start=TemSup2_nominal,
    m_flow_nominal=m2_flow_nominal,
    allowFlowReversal=allowFlowReversal2,
    tau=30,
    initType=Modelica.Blocks.Types.Init.InitialOutput,
    m_flow_small=m2_flow_small)
    annotation (Placement(transformation(extent={{12,-44},{-8,-24}})));
  IBPSA.Fluid.Sensors.MassFlowRate senMasFlo(redeclare package Medium = Medium,
      allowFlowReversal=allowFlowReversal2)
    annotation (Placement(transformation(extent={{-12,-44},{-32,-24}})));
public
  Controls.TemSup_control TemSup_controller(
    TemSup_min=TemSup2_min,
    TemSup_max=TemSup2_max,
    TemOut_min=TemOut_min,
    TemOut_max=TemOut_max) if OutsideDependent
    "outside temperature dependent supply temperature set-point"
    annotation (Placement(transformation(extent={{-38,-84},{-58,-64}})));
public
  Modelica.Blocks.Sources.RealExpression TConst(y=TemSup2_nominal) if
                                                                 not OutsideDependent annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-48,-94})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor
    outsideTemperatureSensor if OutsideDependent annotation (Placement(
        transformation(extent={{-8,-84},{-28,-64}})));
public
  Controls.flow_control valve_control(
    min_y=min_y,
    use_T_in=true,
    use_m_flow_in=true,
    m_flow_nominal=m2_flow_nominal,
    k=k,
    Ti=Ti)
    annotation (Placement(transformation(extent={{-54,-4},{-34,16}})));
  IBPSA.Fluid.Movers.FlowControlled_m_flow pump(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    T_start=TemSup1_nominal,
    m_flow_nominal=m1_flow_nominal,
    allowFlowReversal=allowFlowReversal1,
    m_flow_small=m1_flow_small,
    addPowerToMedium=false,
    riseTime(displayUnit="min"),
    nominalValuesDefineDefaultPressureCurve=true,
    dp_nominal=dp1_nominal) if FlowType == DisHeatLib.BaseClasses.FlowType.Pump
    annotation (Placement(transformation(extent={{-14,40},{6,20}})));
  Modelica.Blocks.Math.Gain gain(k=m1_flow_nominal) if FlowType == DisHeatLib.BaseClasses.FlowType.Pump
                                                   annotation (Placement(
        transformation(
        extent={{4,-4},{-4,4}},
        rotation=-90,
        origin={-4,12})));
  replaceable Supply.Supply_T electricBoosterHeater(
    redeclare final package Medium = Medium,
    final allowFlowReversal=allowFlowReversal2,
    final m_flow_nominal=m2_flow_nominal,
    final TemRet_nominal=TemRet2_nominal,
    powerCha(Q_flow={0,1}, P={0,1}),
    final m_flow_small=m2_flow_small,
    nPorts=1) constrainedby Supply.Supply_T
    annotation (Dialog(group="Electric booster heater"), Placement(transformation(extent={{-40,-44},{-60,-24}})));
equation
  connect(TemSup_controller.TemOut, outsideTemperatureSensor.T)
    annotation (Line(points={{-36,-74},{-28,-74}},
                                                 color={0,0,127}));
  connect(valve_control.T_set, TemSup_controller.y) annotation (Line(points={{-56,6},
          {-78,6},{-78,-74},{-59,-74}},      color={0,0,127}));
  connect(TConst.y, valve_control.T_set) annotation (Line(points={{-59,-94},{-78,
          -94},{-78,6},{-56,6}},    color={0,0,127}));
  connect(valve_control.y, valve.y)
    annotation (Line(points={{-33,6},{-16,6},{-16,48}},      color={0,0,127}));
  connect(senTem.T, valve_control.T_measurement) annotation (Line(points={{2,-23},
          {2,-6},{-60,-6},{-60,1},{-56,1}},       color={0,0,127}));
  connect(gain.u, valve_control.y) annotation (Line(points={{-4,7.2},{-4,6},{-33,
          6}},        color={0,0,127}));
  connect(port_a2, exp.port_a)
    annotation (Line(points={{100,-60},{68,-60},{68,-44}}, color={0,127,255}));
  connect(port_a2, hex.port_a2)
    annotation (Line(points={{100,-60},{32,-60},{32,-4}}, color={0,127,255}));
  connect(pump.port_b, hex.port_a1)
    annotation (Line(points={{6,30},{12,30},{12,8}},  color={0,127,255}));
  connect(valve.port_b, hex.port_a1)
    annotation (Line(points={{-6,60},{12,60},{12,8}},  color={0,127,255}));
  connect(port_a1, valve.port_a)
    annotation (Line(points={{-100,60},{-26,60}}, color={0,127,255}));
  connect(port_a1, pump.port_a) annotation (Line(points={{-100,60},{-34,60},{-34,
          30},{-14,30}}, color={0,127,255}));
  connect(hex.port_b1, port_b1)
    annotation (Line(points={{32,8},{32,60},{100,60}}, color={0,127,255}));
  connect(senTem.port_a, hex.port_b2)
    annotation (Line(points={{12,-34},{12,-4}},           color={0,127,255}));
  connect(outsideTemperatureSensor.port, port_ht)
    annotation (Line(points={{-8,-74},{0,-74},{0,-100}}, color={191,0,0}));
  connect(senMasFlo.port_a, senTem.port_b)
    annotation (Line(points={{-12,-34},{-8,-34}},  color={0,127,255}));
  connect(gain.y, pump.m_flow_in)
    annotation (Line(points={{-4,16.4},{-4,18}}, color={0,0,127}));
  connect(senMasFlo.m_flow, valve_control.m_flow_measurement) annotation (Line(
        points={{-22,-23},{-22,-8},{-62,-8},{-62,11},{-56,11}}, color={0,0,127}));
  connect(electricBoosterHeater.port_a, senMasFlo.port_b)
    annotation (Line(points={{-40,-34},{-32,-34}}, color={0,127,255}));
  connect(electricBoosterHeater.ports_b[1], port_b2) annotation (Line(points={{-60,
          -34},{-68,-34},{-68,-60},{-100,-60}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-120},
            {100,100}}),                                        graphics={
                                         Rectangle(
          extent={{-70,80},{70,-80}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-70,-62}},
          color={28,108,200},
          thickness=1),
        Line(
          points={{0,-60},{30,0},{60,-60},{82,-60}},
          color={28,108,200},
          thickness=1),
        Line(
          points={{0,-60},{-30,0},{-60,-60},{-80,-60}},
          color={238,46,47},
          thickness=1),
        Line(
          points={{-100,60},{-60,60},{-60,-14},{-30,46},{0,-14}},
          color={238,46,47},
          thickness=1),
        Line(
          points={{0,-14},{30,46},{60,-14},{60,60},{100,60}},
          color={28,108,200},
          thickness=1),
        Ellipse(
          extent={{-36,38},{36,-38}},
          lineColor={0,0,0},
          fillColor={247,247,247},
          fillPattern=FillPattern.Solid,
          lineThickness=0.5),
        Polygon(
          points={{-8,-28},{0,-2},{-14,-2},{4,30},{-2,4},{12,4},{-8,-28}},
          lineColor={0,0,0},
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid,
          lineThickness=0.5)}),
                          Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),
    Documentation(info="<html>
<p>This is a model for an indirect district heating substation. Its main components are a heat exchanger, a flow regulating valve/pump, an expansion vessel and controller that maintains the temperature at the secondary side by setting the position of the flow regulating valve/pump. The supply temperature setpoint at the secondary side can thereby be set to a constant or can be changed depending on the outside temperature.</p>
<p>A mismatch between the setpoint and the actual value of the secondary supply temperature can have different reasons:</p>
<ul>
<li>The differential pressure at the station is too low, resulting in a too low mass flow at the primary side even if the valve is completely open.</li>
<li>The nominal mass flow rate at the primary side is too low, leading to a too low secondary supply temperature even with a fully opend valve.</li>
<li>The supply temperature at the primary side is too low, i.e., lower than the secondary supply temperature setpoint, leading to a fully opened valve.</li>
</ul>
<p><br>Redimensioning the substation, e.g., by using a more efficient heat exchanger or a higher differential pressure at the primary side, might solve these issues.</p>
</html>",
        revisions="<html>
<ul>
<li>Feburary 27, 2019, by Benedikt Leitner:<br>Implementation and added User&apos;s guide. </li>
</ul>
</html>"));
end IndirectStationEBH;
