within DisHeatLib.Substations.BaseClasses;
model StorageTankHex
  extends BaseStation(
  final OutsideDependent=false);

  parameter Modelica.SIunits.Volume VTan "Tank volume"
    annotation(Dialog(group="Storage tank"));
  parameter Modelica.SIunits.Length hTan
    "Height of tank (without insulation)"
    annotation(Dialog(group="Storage tank"));
  parameter Modelica.SIunits.Length dIns=0.2 "Thickness of insulation"
    annotation(Dialog(group="Storage tank"));
  parameter Modelica.SIunits.ThermalConductivity kIns=0.04
    "Specific heat conductivity of insulation"
    annotation(Dialog(group="Storage tank"));
  parameter Integer nSeg=4 "Number of volume segments"
    annotation(Dialog(group="Storage tank"));
  parameter Modelica.SIunits.Temperature TemRoom=20.0 + 273.15
    "Constant temperature surrounding the storage tank"
    annotation(Dialog(group="Storage tank"));
  parameter Integer nInit=0
    "Number of volume segments initialized with TemSup2_nominal"
    annotation(Dialog(group="Storage tank"));
  parameter Modelica.SIunits.Height hHex_a=storageTankHex.hTan/2
    "Height of portHex_a of the heat exchanger, measured from tank bottom"
    annotation(Dialog(group="Storage tank"));
  parameter Modelica.SIunits.Height hHex_b=0
    "Height of portHex_b of the heat exchanger, measured from tank bottom"
    annotation(Dialog(group="Storage tank"));
  parameter Integer hexSegMult=2
    "Number of heat exchanger segments in each tank segment"
    annotation(Dialog(group="Storage tank"));
  parameter Modelica.SIunits.Diameter dExtHex=0.025
    "Exterior diameter of the heat exchanger pipe"
    annotation(Dialog(group="Storage tank"));
  parameter Real r_nominal=0.5
    "Ratio between coil inside and outside convective heat transfer at nominal heat transfer conditions"
    annotation(Dialog(group="Storage tank"));

  parameter Real y_max=1.0 "Maximum set-point value for valve/pump"
    annotation(Dialog(group="Storage tank control"));
  parameter Real y_min=0.0 "Minimum set-point value for valve/pump"
    annotation(Dialog(group="Storage tank control"));
  parameter Real u_min=TemSup2_nominal "Minimum input value for charging activation"
    annotation(Dialog(group="Storage tank control"));
  parameter Real u_bandwidth=5.0 "bandwidth for charging de-/activation"
    annotation(Dialog(group="Storage tank control"));
  parameter Integer nSegMeasure=1 "Measurement taken from this tank segment (1: Top)"
    annotation(Dialog(group="Storage tank control"));


  Storage.StorageTankHex storageTankHex(
    allowFlowReversal1=allowFlowReversal1,
    allowFlowReversal2=allowFlowReversal2,
    m1_flow_nominal=m1_flow_nominal,
    m2_flow_nominal=m2_flow_nominal,
    m1_flow_small=m1_flow_small,
    m2_flow_small=m2_flow_small,
    redeclare package Medium = Medium,
    from_dp=from_dp,
    linearizeFlowResistance=linearizeFlowResistance,
    Q1_flow_nominal=Q1_flow_nominal,
    TemSup1_nominal=TemSup1_nominal,
    TemRet1_nominal=TemRet1_nominal,
    Q2_flow_nominal=Q2_flow_nominal,
    TemSup2_nominal=TemSup2_nominal,
    TemRet2_nominal=TemRet2_nominal,
    VTan=VTan,
    hTan=hTan,
    dIns=dIns,
    kIns=kIns,
    nSeg=nSeg,
    TemRoom=TemRoom,
    nInit=nInit,
    hHex_a=hHex_a,
    hHex_b=hHex_b,
    hexSegMult=hexSegMult,
    dExtHex=dExtHex,
    r_nominal=r_nominal)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Controls.twopoint_control storage_control(
    y_max=y_max,
    y_min=y_min,
    u_min=u_min,
    u_bandwidth=u_bandwidth)
    annotation (Placement(transformation(extent={{-32,76},{-52,96}})));
public
  IBPSA.Fluid.Actuators.Valves.TwoWayEqualPercentage     valve(
    redeclare package Medium = Medium,
    dpValve_nominal=dp1_nominal,
    m_flow_nominal=m1_flow_nominal,
    allowFlowReversal=allowFlowReversal1,
    riseTime(displayUnit="min"),
    linearized=linearizeFlowResistance,
    from_dp=from_dp) if FlowType == DisHeatLib.BaseClasses.FlowType.Valve
    annotation (Placement(transformation(extent={{-86,50},{-66,70}})));
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
    annotation (Placement(transformation(extent={{-66,18},{-46,38}})));
  Modelica.Blocks.Math.Gain gain(k=m1_flow_nominal) if FlowType == DisHeatLib.BaseClasses.FlowType.Pump
                                                   annotation (Placement(
        transformation(
        extent={{-4,-4},{4,4}},
        rotation=-90,
        origin={-56,50})));
public
  IBPSA.Fluid.Storage.ExpansionVessel exp(
    redeclare package Medium = Medium,
    T_start=TemSup2_nominal,
    V_start=m2_flow_nominal*0.1)
    annotation (Placement(transformation(extent={{58,-44},{78,-24}})));

equation
  connect(port_a1, valve.port_a)
    annotation (Line(points={{-100,60},{-86,60}}, color={0,127,255}));
  connect(port_a1, pump.port_a) annotation (Line(points={{-100,60},{-92,60},{-92,
          28},{-66,28}}, color={0,127,255}));
  connect(valve.port_b, storageTankHex.port_a1) annotation (Line(points={{-66,60},
          {-40,60},{-40,6},{-10,6}}, color={0,127,255}));
  connect(pump.port_b, storageTankHex.port_a1) annotation (Line(points={{-46,28},
          {-40,28},{-40,6},{-10,6}}, color={0,127,255}));
  connect(gain.y, pump.m_flow_in)
    annotation (Line(points={{-56,45.6},{-56,40}}, color={0,0,127}));
  connect(storage_control.y, gain.u)
    annotation (Line(points={{-53,86},{-56,86},{-56,54.8}}, color={0,0,127}));
  connect(storageTankHex.port_b2, port_b2) annotation (Line(points={{-10,-6},
          {-40,-6},{-40,-60},{-100,-60}},
                                     color={0,127,255}));
  connect(storageTankHex.port_b1, port_b1) annotation (Line(points={{10,6},{40,
          6},{40,60},{100,60}}, color={0,127,255}));
  connect(storageTankHex.port_a2, port_a2) annotation (Line(points={{10,-6},{
          40,-6},{40,-60},{100,-60}}, color={0,127,255}));
  connect(exp.port_a, port_a2) annotation (Line(points={{68,-44},{68,-60},{100,
          -60}}, color={0,127,255}));
  connect(storageTankHex.TemTank[nSegMeasure], storage_control.u) annotation (Line(
        points={{4,-11},{4,-22},{20,-22},{20,86},{-30,86}}, color={0,0,127}));
  connect(storage_control.y, valve.y)
    annotation (Line(points={{-53,86},{-76,86},{-76,72}}, color={0,0,127}));
  annotation (Icon(graphics={
        Ellipse(
          extent={{-46,68},{46,42}},
          fillColor={255,85,85},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0},
          lineThickness=1),
        Ellipse(
          extent={{-46,-44},{46,-70}},
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0},
          lineThickness=1),
        Rectangle(
          extent={{-46,56},{46,20}},
          fillColor={255,85,85},
          fillPattern=FillPattern.Solid,
          lineThickness=1,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Rectangle(
          extent={{46,20},{-46,-56}},
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid,
          lineThickness=1,
          pattern=LinePattern.None),
        Line(
          points={{-46,56},{-46,-56}},
          color={0,0,0},
          thickness=1),
        Line(
          points={{46,56},{46,-56}},
          color={0,0,0},
          thickness=1),
        Line(
          points={{-100,60},{-84,60},{-74,60},{-74,0},{32,0},{-32,-12},{32,-22}},
          color={255,0,0},
          thickness=1),
        Line(
          points={{66,60},{66,-44},{32,-44},{-32,-34},{32,-22}},
          color={28,108,200},
          thickness=1),
        Line(
          points={{-100,-60},{-66,-60},{-60,-60},{-60,54},{-44,54}},
          color={255,85,85},
          thickness=1),
        Line(
          points={{40,-60},{100,-60}},
          color={0,0,127},
          thickness=1),
        Line(
          points={{66,60},{100,60}},
          color={28,108,200},
          thickness=1)}), Documentation(info="<html>
<p>This is a model for a district heating substation storage tank with an internal heat exchanger. Its main components are the storage tank with internal heat exchanger, a flow regulating valve/pump, an expansion vessel and a controller that maintains the temperature in the selected tank layer by setting the position of the flow regulating valve/pump to open or closed.</p>
<p>A mismatch between the setpoint and the actual value of the secondary supply temperature can have different reasons:</p>
<ul>
<li>The differential pressure at the station is too low, resulting in a too low mass flow at the primary side even if the valve is completely open.</li>
<li>The nominal mass flow rate at the primary side is too low, leading to a too low secondary supply temperature even with a fully opend valve.</li>
<li>The supply temperature at the primary side is too low, i.e., lower than the tank temperature setpoint, leading to a fully opened valve</li>
</ul>
</html>"));
end StorageTankHex;
