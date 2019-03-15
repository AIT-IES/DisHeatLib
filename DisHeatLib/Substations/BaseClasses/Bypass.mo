within DisHeatLib.Substations.BaseClasses;
model Bypass
  extends IBPSA.Fluid.Interfaces.PartialTwoPortInterface;
  extends IBPSA.Fluid.Interfaces.TwoPortFlowResistanceParameters(
    final computeFlowResistance=(abs(dp_nominal) > Modelica.Constants.eps),
    final deltaM=0.1);

  parameter DisHeatLib.BaseClasses.FlowType FlowType=DisHeatLib.BaseClasses.FlowType.Pump
    "Flow type at primary side";

  // Control
  parameter Boolean use_thermostat = false "Use a thermostat to control the bypass valve, otherwise always opened"
    annotation(Dialog(group = "Control"), HideResult=true, choices(checkBox=true));
  parameter Modelica.SIunits.Temperature TemSupMinBypass(displayUnit="degC")=50.0+273.15
    "Minimum supply temperature before bypass valve is opened"
    annotation(Dialog(group = "Control", enable=use_thermostat));
  parameter Modelica.SIunits.TemperatureDifference TemBandwidthBypass(displayUnit="degC")=3.0
    "Temperature bandwidth for bypass activation"
    annotation(Dialog(group = "Control", enable=use_thermostat));

public
  Controls.bypass_control bypass_control(
    use_thermostat=use_thermostat,
    T_min=TemSupMinBypass,
    T_bandwidth=TemBandwidthBypass)
    annotation (Placement(transformation(extent={{-30,60},{-10,80}})));
  IBPSA.Fluid.Movers.FlowControlled_m_flow pump(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    allowFlowReversal=allowFlowReversal,
    m_flow_small=m_flow_small,
    riseTime(displayUnit="min"),
    nominalValuesDefineDefaultPressureCurve=true,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=dp_nominal,
    addPowerToMedium=false) if FlowType == DisHeatLib.BaseClasses.FlowType.Pump
    annotation (Placement(transformation(extent={{-10,-50},{10,-30}})));
protected
  Modelica.Blocks.Math.Gain gain(k=m_flow_nominal) if FlowType == DisHeatLib.BaseClasses.FlowType.Pump
                                                   annotation (Placement(
        transformation(
        extent={{-4,-4},{4,4}},
        rotation=-90,
        origin={18,0})));
public
  Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium =
        Medium) "Supply fluid port"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium =
        Medium) "Return fluid port"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  Modelica.Blocks.Interfaces.RealInput T_measurement(unit="K", displayUnit="degC") if
    use_thermostat "Supply temperature measurement"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={0,120})));
protected
  IBPSA.Fluid.Actuators.Valves.TwoWayEqualPercentage     valve(
    redeclare package Medium = Medium,
    allowFlowReversal=allowFlowReversal,
    dpValve_nominal(displayUnit="bar") = dp_nominal,
    m_flow_nominal=m_flow_nominal,
    linearized=linearizeFlowResistance,
    from_dp=from_dp) if FlowType == DisHeatLib.BaseClasses.FlowType.Valve
    annotation (Placement(transformation(extent={{-10,30},{10,50}})));
equation
  connect(bypass_control.y, valve.y)
    annotation (Line(points={{-9,70},{0,70},{0,52}}, color={0,0,127}));
  connect(bypass_control.y, gain.u)
    annotation (Line(points={{-9,70},{18,70},{18,4.8}}, color={0,0,127}));
  connect(gain.y,pump. m_flow_in)
    annotation (Line(points={{18,-4.4},{18,-28},{0,-28}},   color={0,0,127}));
  connect(port_a, valve.port_a) annotation (Line(points={{-100,0},{-40,0},{-40,40},
          {-10,40}}, color={0,127,255}));
  connect(valve.port_b, port_b) annotation (Line(points={{10,40},{40,40},{40,0},
          {100,0}}, color={0,127,255}));
  connect(port_a, pump.port_a) annotation (Line(points={{-100,0},{-40,0},{-40,-40},
          {-10,-40}}, color={0,127,255}));
  connect(pump.port_b, port_b) annotation (Line(points={{10,-40},{40,-40},{40,0},
          {100,0}}, color={0,127,255}));
  connect(bypass_control.T_measurement, T_measurement) annotation (Line(points={{-32,70},
          {-38,70},{-38,92},{0,92},{0,120}},          color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          lineColor={200,200,200},
          fillColor={248,248,248},
          fillPattern=FillPattern.HorizontalCylinder,
          extent={{-100,-100},{100,100}},
          radius=25.0),
        Rectangle(
          lineColor={128,128,128},
          extent={{-100,-100},{100,100}},
          radius=25.0),
        Line(
          points={{-8,28},{20,0}},
          color={244,125,35},
          thickness=1),
        Line(
          points={{20,0},{-8,-28}},
          color={244,125,35},
          thickness=1),
        Line(
          points={{-100,0},{100,0}},
          color={244,125,35},
          thickness=1)}),                                        Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>This is a model for a generic by-pass that can be used, e.g., in a district heating substation. By-passes are used to avoid waiting times in heat supply and to avoid freezing of return lines in the district heating network. However, their use increases the return temperature and, thus, the losses of the network. The by-pass can be controlled by a thermostat or it can allow a constant flow.</p>
</html>",
        revisions="<html>
<ul>
<li>Feburary 27, 2019, by Benedikt Leitner:<br>Implementation and added User&apos;s guide. </li>
</ul>
</html>"));
end Bypass;
