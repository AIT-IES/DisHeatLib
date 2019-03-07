within DisHeatLib.Substations.BaseClasses;
model IndirectBaseStation
  extends BaseStation(
    Q_flow_nominal=m2_flow_small*(TemSup2_nominal-TemRet2_nominal)*cp_default,
    m1_flow_nominal=Q_flow_nominal/hex_efficiency/((TemSup1_nominal-TemRet1_nominal)*cp_default),
    m2_flow_nominal=Q_flow_nominal/((TemSup2_nominal-TemRet2_nominal)*cp_default));

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
    dpFixed_nominal=dp_hex_nominal) if FlowType == DisHeatLib.Substations.BaseClasses.BaseStationFlowType.Valve
    annotation (Placement(transformation(extent={{-42,70},{-22,50}})));
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
    annotation (Placement(transformation(extent={{-22,-44},{-42,-24}})));
  IBPSA.Fluid.Sensors.MassFlowRate senMasFlo(redeclare package Medium = Medium,
      allowFlowReversal=allowFlowReversal2)
    annotation (Placement(transformation(extent={{-54,-44},{-74,-24}})));
public
  Controls.TemSup_control TemSup_controller(
    TemSup_min=TemSup2_min,
    TemSup_max=TemSup2_max,
    TemOut_min=TemOut_min,
    TemOut_max=TemOut_max) if OutsideDependent
    "outside temperature dependent supply temperature set-point"
    annotation (Placement(transformation(extent={{-38,-78},{-58,-58}})));
public
  Modelica.Blocks.Sources.RealExpression TConst(y=TemSup2_nominal) if
                                                                 not OutsideDependent annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-48,-90})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor
    outsideTemperatureSensor if OutsideDependent annotation (Placement(
        transformation(extent={{-8,-78},{-28,-58}})));
public
  Controls.flow_control valve_control(
    min_y=min_y,
    use_T_in=true,
    use_m_flow_in=true,
    m_flow_nominal=m2_flow_nominal,
    k=k,
    Ti=Ti)
    annotation (Placement(transformation(extent={{-56,-14},{-36,6}})));
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
    dp_nominal=dp1_nominal) if      FlowType == DisHeatLib.Substations.BaseClasses.BaseStationFlowType.Pump
    annotation (Placement(transformation(extent={{-28,40},{-8,20}})));
  Modelica.Blocks.Math.Gain gain(k=m1_flow_nominal) if
                                                      FlowType == DisHeatLib.Substations.BaseClasses.BaseStationFlowType.Pump
                                                   annotation (Placement(
        transformation(
        extent={{4,-4},{-4,4}},
        rotation=-90,
        origin={-18,8})));
equation
  connect(TemSup_controller.TemOut, outsideTemperatureSensor.T)
    annotation (Line(points={{-36,-68},{-28,-68}},
                                                 color={0,0,127}));
  connect(valve_control.m_flow_measurement, senMasFlo.m_flow) annotation (Line(
        points={{-58,1},{-64,1},{-64,-23}},                      color={0,0,127}));
  connect(valve_control.T_set, TemSup_controller.y) annotation (Line(points={{-58,-4},
          {-78,-4},{-78,-68},{-59,-68}},     color={0,0,127}));
  connect(TConst.y, valve_control.T_set) annotation (Line(points={{-59,-90},{-78,
          -90},{-78,-4},{-58,-4}},  color={0,0,127}));
  connect(valve_control.y, valve.y)
    annotation (Line(points={{-35,-4},{-32,-4},{-32,48}},    color={0,0,127}));
  connect(senTem.T, valve_control.T_measurement) annotation (Line(points={{-32,-23},
          {-32,-18},{-60,-18},{-60,-9},{-58,-9}}, color={0,0,127}));
  connect(gain.u, valve_control.y) annotation (Line(points={{-18,3.2},{-18,-4},{
          -35,-4}},   color={0,0,127}));
  connect(gain.y, pump.m_flow_in)
    annotation (Line(points={{-18,12.4},{-18,18}},   color={0,0,127}));
  connect(port_a2, exp.port_a)
    annotation (Line(points={{100,-60},{68,-60},{68,-44}}, color={0,127,255}));
  connect(port_a2, hex.port_a2)
    annotation (Line(points={{100,-60},{32,-60},{32,-4}}, color={0,127,255}));
  connect(pump.port_b, hex.port_a1)
    annotation (Line(points={{-8,30},{12,30},{12,8}}, color={0,127,255}));
  connect(valve.port_b, hex.port_a1)
    annotation (Line(points={{-22,60},{12,60},{12,8}}, color={0,127,255}));
  connect(port_a1, valve.port_a)
    annotation (Line(points={{-100,60},{-42,60}}, color={0,127,255}));
  connect(port_a1, pump.port_a) annotation (Line(points={{-100,60},{-60,60},{-60,
          30},{-28,30}}, color={0,127,255}));
  connect(hex.port_b1, port_b1)
    annotation (Line(points={{32,8},{32,60},{100,60}}, color={0,127,255}));
  connect(senTem.port_a, hex.port_b2)
    annotation (Line(points={{-22,-34},{12,-34},{12,-4}}, color={0,127,255}));
  connect(outsideTemperatureSensor.port, port_ht)
    annotation (Line(points={{-8,-68},{0,-68},{0,-100}}, color={191,0,0}));
  connect(senMasFlo.port_b, port_b2) annotation (Line(points={{-74,-34},{-84,-34},
          {-84,-60},{-100,-60}}, color={0,127,255}));
  connect(senMasFlo.port_a, senTem.port_b)
    annotation (Line(points={{-54,-34},{-42,-34}}, color={0,127,255}));
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
