within DisHeatLib.Substations.BaseClasses;
model Bypass
  extends IBPSA.Fluid.Interfaces.PartialTwoPortInterface;
  extends IBPSA.Fluid.Interfaces.TwoPortFlowResistanceParameters(
    final computeFlowResistance=(abs(dp_nominal) > Modelica.Constants.eps),
    final deltaM=0.1);

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
  replaceable DisHeatLib.BaseClasses.FlowUnit flowUnit(
    redeclare final package Medium = Medium,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=m_flow_nominal,
    final m_flow_small=m_flow_small,
    final dp_nominal=dp_nominal,
    final dpFixed_nominal=0,
    final from_dp=from_dp,
    final linearizeFlowResistance=linearizeFlowResistance)
    annotation (Dialog(group="Parameters"), Placement(transformation(extent={{-10,-10},{10,10}})));
equation
  connect(bypass_control.T_measurement, T_measurement) annotation (Line(points={{-32,70},
          {-38,70},{-38,92},{0,92},{0,120}},          color={0,0,127}));
  connect(port_a, flowUnit.port_a)
    annotation (Line(points={{-100,0},{-10,0}}, color={0,127,255}));
  connect(flowUnit.port_b, port_b)
    annotation (Line(points={{10,0},{100,0}}, color={0,127,255}));
  connect(bypass_control.y, flowUnit.y)
    annotation (Line(points={{-9,70},{0,70},{0,12}}, color={0,0,127}));
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
