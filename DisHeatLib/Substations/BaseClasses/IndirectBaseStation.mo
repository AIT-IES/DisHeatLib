within DisHeatLib.Substations.BaseClasses;
model IndirectBaseStation
  extends BaseStation(
    Q_flow_nominal=m_flow_nominal_sec*(TemSup_nominal_sec-TemRet_nominal_sec)*cp_default,
    m_flow_nominal=Q_flow_nominal/hex_efficiency/((TemSup_nominal_sec-TemRet_nominal_sec)*cp_default),
    m_flow_nominal_sec=Q_flow_nominal/((TemSup_nominal_sec-TemRet_nominal_sec)*cp_default));

  //Secondary side supply temperature
  parameter Modelica.SIunits.Temperature TemOut_max(displayUnit="degC")=15.0+273.15
    "Outdoor temperature where minimum secondary supply temperature is needed"
    annotation (Dialog(enable = OutsideDependent, group="Temperature control secondary side"));
  parameter Modelica.SIunits.Temperature TemOut_min(displayUnit="degC")=-5.0+273.15
    "Outdoor temperature where maximum secondary supply temperature is needed"
    annotation (Dialog(enable = OutsideDependent, group="Temperature control secondary side"));
  parameter Modelica.SIunits.Temperature TemSup_sec_min(displayUnit="degC")=50.0+273.15
    "Secondary supply temperature where maximum outdoor temperature is reached"
    annotation(Dialog(enable = OutsideDependent, group = "Temperature control secondary side"));
  parameter Modelica.SIunits.Temperature TemSup_sec_max(displayUnit="degC")=60.0+273.15
    "Secondary supply temperature where minimum outdoor temperature is reached"
    annotation(Dialog(enable = OutsideDependent, group = "Temperature control secondary side"));

  //Heat exchanger parameter
  parameter Modelica.SIunits.Efficiency hex_efficiency(max=1)=0.90
    "Constant efficiency of the heat exchanger"
    annotation(Dialog(group = "Heat exchanger and flow"));
  parameter Modelica.SIunits.PressureDifference dp_nominal_hex=50000
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

 // Assumptions
  parameter Boolean allowFlowReversal = true
    "= false to simplify equations, assuming, but not enforcing, no flow reversal for primary side"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);
  parameter Boolean allowFlowReversal_sec = true
    "= false to simplify equations, assuming, but not enforcing, no flow reversal for secondary side"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);

  // Advanced
  parameter Boolean linearized = false
    "= true, use linear relation between m_flow and dp for any flow rate"
    annotation(Evaluate=true, Dialog(tab="Advanced"));
  parameter Boolean from_dp = false
    "= true, use linear relation between m_flow and dp for any flow rate"
    annotation(Evaluate=true, Dialog(tab = "Advanced"));

protected
      final parameter Modelica.SIunits.SpecificHeatCapacity cp_default=
        Medium.cp_const
        "Specific heat capacity of the fluid"
        annotation(Evaluate=true);
public
  IBPSA.Fluid.Actuators.Valves.TwoWayEqualPercentage     valve(
    redeclare package Medium = Medium,
    dpValve_nominal=dp_nominal - dp_nominal_hex,
    m_flow_nominal=m_flow_nominal,
    allowFlowReversal=allowFlowReversal,
    riseTime(displayUnit="min"),
    linearized=linearized,
    from_dp=from_dp,
    dpFixed_nominal=dp_nominal_hex) if FlowType == DisHeatLib.Substations.BaseClasses.BaseStationFlowType.Valve
    annotation (Placement(transformation(extent={{-42,-46},{-22,-26}})));
public
  IBPSA.Fluid.HeatExchangers.ConstantEffectiveness hex(redeclare package
      Medium1 = Medium, redeclare package Medium2 = Medium,
    eps=hex_efficiency,
    m1_flow_nominal=m_flow_nominal,
    m2_flow_nominal=m_flow_nominal_sec,
    allowFlowReversal1=allowFlowReversal,
    allowFlowReversal2=allowFlowReversal_sec,
    dp2_nominal(displayUnit="kPa") = 0,
    linearizeFlowResistance1=linearized,
    linearizeFlowResistance2=linearized,
    dp1_nominal=0,
    from_dp1=from_dp)
    annotation (Placement(transformation(extent={{12,12},{32,-8}})));
public
  IBPSA.Fluid.Storage.ExpansionVessel exp(redeclare package Medium = Medium,
    V_start=m_flow_nominal_sec*0.1)
    annotation (Placement(transformation(extent={{36,66},{56,86}})));
public
  IBPSA.Fluid.Sensors.TemperatureTwoPort senTem(
    redeclare package Medium = Medium,
    transferHeat=false,
    T(displayUnit="degC"),
    T_start=TemSup_nominal_sec,
    m_flow_nominal=m_flow_nominal_sec,
    allowFlowReversal=allowFlowReversal_sec,
    tau=30,
    initType=Modelica.Blocks.Types.Init.InitialOutput,
    m_flow_small=1E-3*abs(m_flow_nominal_sec))
    annotation (Placement(transformation(extent={{-8,16},{-28,36}})));
  IBPSA.Fluid.Sensors.MassFlowRate senMasFlo(redeclare package Medium = Medium,
      allowFlowReversal=allowFlowReversal_sec)
    annotation (Placement(transformation(extent={{-44,16},{-64,36}})));
public
  Controls.TemSup_control TemSup_controller(
    TemSup_min=TemSup_sec_min,
    TemSup_max=TemSup_sec_max,
    TemOut_min=TemOut_min,
    TemOut_max=TemOut_max) if OutsideDependent
    "SH supply temperature to buildings is dependent on outside temperature"
    annotation (Placement(transformation(extent={{-38,66},{-58,86}})));
public
  Modelica.Blocks.Sources.RealExpression TConst(y=TemSup_nominal_sec) if
                                                                 not OutsideDependent annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-48,54})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor
    outsideTemperatureSensor if OutsideDependent annotation (Placement(
        transformation(extent={{-8,66},{-28,86}})));
public
  Controls.flow_control valve_control(
    min_y=min_y,
    use_T_in=true,
    use_m_flow_in=true,
    m_flow_nominal=m_flow_nominal_sec,
    k=k,
    Ti=Ti)
    annotation (Placement(transformation(extent={{-60,-16},{-40,4}})));
  IBPSA.Fluid.Movers.FlowControlled_m_flow pump(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    T_start=TemSup_nominal,
    m_flow_nominal=m_flow_nominal,
    allowFlowReversal=allowFlowReversal,
    riseTime(displayUnit="min"),
    nominalValuesDefineDefaultPressureCurve=true,
    dp_nominal=dp_nominal) if       FlowType == DisHeatLib.Substations.BaseClasses.BaseStationFlowType.Pump
    annotation (Placement(transformation(extent={{-22,-70},{-2,-50}})));
  Modelica.Blocks.Math.Gain gain(k=m_flow_nominal) if FlowType == DisHeatLib.Substations.BaseClasses.BaseStationFlowType.Pump
                                                   annotation (Placement(
        transformation(
        extent={{-4,-4},{4,4}},
        rotation=-90,
        origin={-12,-40})));
equation
  connect(senTem.port_b, senMasFlo.port_a)
    annotation (Line(points={{-28,26},{-44,26}},
                                               color={0,127,255}));
  connect(valve.port_b, hex.port_a1) annotation (Line(
        points={{-22,-36},{12,-36},{12,-4}},  color={0,127,
          255}));
  connect(TemSup_controller.TemOut, outsideTemperatureSensor.T)
    annotation (Line(points={{-36,76},{-28,76}}, color={0,0,127}));
  connect(valve_control.m_flow_measurement, senMasFlo.m_flow) annotation (Line(
        points={{-62,-1},{-70,-1},{-70,40},{-54,40},{-54,37}},   color={0,0,127}));
  connect(valve_control.T_set, TemSup_controller.y) annotation (Line(points={{-62,-6},
          {-74,-6},{-74,76},{-59,76}},       color={0,0,127}));
  connect(TConst.y, valve_control.T_set) annotation (Line(points={{-59,54},{-74,
          54},{-74,-6},{-62,-6}},   color={0,0,127}));
  connect(valve_control.y, valve.y)
    annotation (Line(points={{-39,-6},{-32,-6},{-32,-24}},   color={0,0,127}));
  connect(senTem.T, valve_control.T_measurement) annotation (Line(points={{-18,37},
          {-18,44},{-78,44},{-78,-11},{-62,-11}}, color={0,0,127}));
  connect(pump.port_b, hex.port_a1)
    annotation (Line(points={{-2,-60},{12,-60},{12,-4}},  color={0,127,255}));
  connect(gain.u, valve_control.y) annotation (Line(points={{-12,-35.2},{-12,-6},
          {-39,-6}},  color={0,0,127}));
  connect(gain.y, pump.m_flow_in)
    annotation (Line(points={{-12,-44.4},{-12,-48}}, color={0,0,127}));
  connect(hex.port_b2, senTem.port_a)
    annotation (Line(points={{12,8},{12,26},{-8,26}}, color={0,127,255}));
  connect(senMasFlo.port_b, port_sl_s) annotation (Line(points={{-64,26},{-88,26},
          {-88,60},{-100,60}}, color={0,127,255}));
  connect(hex.port_a2, port_rl_s) annotation (Line(points={{32,8},{32,26},{70,26},
          {70,60},{100,60}}, color={0,127,255}));
  connect(port_rl_s, exp.port_a)
    annotation (Line(points={{100,60},{46,60},{46,66}}, color={0,127,255}));
  connect(hex.port_b1, port_rl_p)
    annotation (Line(points={{32,-4},{32,-60},{100,-60}},  color={0,127,255}));
  connect(port_sl_p, valve.port_a)
    annotation (Line(points={{-100,-60},{-72,-60},{-72,-36},{-42,-36}},
                                                    color={0,127,255}));
  connect(port_sl_p, pump.port_a) annotation (Line(points={{-100,-60},{-22,-60}},
                                color={0,127,255}));
  connect(outsideTemperatureSensor.port, port_ht)
    annotation (Line(points={{-8,76},{0,76},{0,100}}, color={191,0,0}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-120},
            {100,100}}),                                        graphics={
        Rectangle(
          extent={{-102,65},{99,55}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-104,-55},{97,-65}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),Rectangle(
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
          points={{0,-60},{30,0},{60,-60},{70,-60}},
          color={28,108,200},
          thickness=1),
        Line(
          points={{0,-60},{-30,0},{-60,-60},{-70,-60}},
          color={238,46,47},
          thickness=1),
        Line(
          points={{-100,60},{-60,60},{-60,-14},{-30,46},{0,-14}},
          color={238,46,47},
          thickness=1),
        Line(
          points={{0,-14},{30,46},{60,-14},{60,60},{100,60}},
          color={28,108,200},
          thickness=1)}), Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),
    Documentation(info="<html>
<p>This is a model for an indirect district heating substation. Its main components are a heat exchanger, a flow regulating valve, a pump to deliver heat to the customers, an expansion vessel and controller that maintains the temperature at the secondary side by setting the position of the flow regulating valve/pump. The supply temperature setpoint at the secondary side can thereby be set to a constant or can be changed depending on the outside temperature.</p>
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
end IndirectBaseStation;
