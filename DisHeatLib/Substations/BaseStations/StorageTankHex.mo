within DisHeatLib.Substations.BaseStations;
model StorageTankHex
  extends BaseClasses.BaseStation(
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
  parameter Integer nInit=nSeg
    "Number of volume segments initialized with TemSup2_nominal"
    annotation(Dialog(group="Storage tank"));
  parameter Modelica.SIunits.PressureDifference dp_hex_nominal=0
    "Nominal pressure difference at the heat exchanger at primary side"
    annotation(Dialog(group = "Storage tank"));
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

  // Controller
  parameter Modelica.SIunits.Temperature T_const=TemSup2_nominal
    "Constant temperature setpoint"
    annotation(Dialog(group="Flow controller"));
  parameter Modelica.SIunits.Time Ti=120 "Time constant of Integrator block"
    annotation(Dialog(group="Flow controller"));
  parameter Real k=0.01 "Gain of controller"
    annotation(Dialog(group="Flow controller"));
 parameter Integer nSegMeasure=1 "Volume segment to take temperature from"
    annotation(Dialog(group="Flow controller"));

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
  DisHeatLib.Controls.flow_control storage_control(
    k=k,
    Ti=Ti,
    T_const=T_const)
    annotation (Placement(transformation(extent={{-30,76},{-50,96}})));
protected
  IBPSA.Fluid.Storage.ExpansionVessel exp(
    redeclare package Medium = Medium,
    T_start=TemSup2_nominal,
    V_start=m2_flow_nominal*0.1)
    annotation (Placement(transformation(extent={{58,-44},{78,-24}})));

public
  replaceable DisHeatLib.BaseClasses.FlowUnit flowUnit(
    redeclare final package Medium = Medium,
    final allowFlowReversal=allowFlowReversal1,
    final m_flow_nominal=m1_flow_nominal,
    final m_flow_small=m1_flow_small,
    final dp_nominal=dp1_nominal,
    final dpFixed_nominal=dp_hex_nominal,
    final from_dp=from_dp,
    final linearizeFlowResistance=linearizeFlowResistance)
    annotation (Dialog(group="Parameters"), Placement(transformation(extent={{-82,50},{-62,70}})));

  Storage.BaseClasses.ThermostatMixer thermostatMixer(
    redeclare package Medium = Medium,
    FlowType=DisHeatLib.BaseClasses.FlowType.Valve,
    m_flow_nominal=m2_flow_nominal,
    dp_nominal=100000,
    Tem_set=TemSup2_nominal)
    annotation (Placement(transformation(extent={{-60,-70},{-80,-50}})));
equation
  connect(storageTankHex.port_b1, port_b1) annotation (Line(points={{10,6},{40,
          6},{40,60},{100,60}}, color={0,127,255}));
  connect(storageTankHex.port_a2, port_a2) annotation (Line(points={{10,-6},{
          40,-6},{40,-60},{100,-60}}, color={0,127,255}));
  connect(exp.port_a, port_a2) annotation (Line(points={{68,-44},{68,-60},{100,
          -60}}, color={0,127,255}));
  connect(storageTankHex.TemTank[nSegMeasure], storage_control.T_measurement) annotation (Line(
        points={{0,-11},{0,-22},{20,-22},{20,81},{-28,81}}, color={0,0,127}));
  connect(port_a1, flowUnit.port_a)
    annotation (Line(points={{-100,60},{-82,60}}, color={0,127,255}));
  connect(flowUnit.port_b, storageTankHex.port_a1) annotation (Line(points={{
          -62,60},{-40,60},{-40,6},{-10,6}}, color={0,127,255}));
  connect(storage_control.y, flowUnit.y)
    annotation (Line(points={{-51,86},{-72,86},{-72,72}}, color={0,0,127}));
  connect(port_b2, thermostatMixer.port_2)
    annotation (Line(points={{-100,-60},{-80,-60}}, color={0,127,255}));
  connect(thermostatMixer.port_3, storageTankHex.port_a2) annotation (Line(
        points={{-70,-70},{-70,-80},{10,-80},{10,-6}}, color={0,127,255}));
  connect(storageTankHex.port_b2, thermostatMixer.port_1) annotation (Line(
        points={{-10,-6},{-40,-6},{-40,-60},{-60,-60}}, color={0,127,255}));
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
