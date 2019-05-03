within DisHeatLib.Storage;
model StorageTankHex
  extends IBPSA.Fluid.Interfaces.PartialFourPortInterface(
    redeclare package Medium1 = Medium,
    redeclare package Medium2 = Medium,
    m1_flow_nominal=Q1_flow_nominal/((TemSup1_nominal-TemRet1_nominal)*cp_default),
    m2_flow_nominal=Q2_flow_nominal/((TemSup2_nominal-TemRet2_nominal)*cp_default));

  replaceable package Medium =
    Modelica.Media.Interfaces.PartialMedium "Medium in the component"
      annotation (choices(
        choice(redeclare package Medium = IBPSA.Media.Water "Water")));


  parameter Boolean from_dp = false
    "= true, use m_flow = f(dp) else dp = f(m_flow)"
    annotation (Evaluate=true, Dialog(enable=FlowType == DisHeatLib.BaseClasses.FlowType.Valve,
                tab="Flow resistance", group="Primary side"));

  parameter Boolean linearizeFlowResistance = false
    "= true, use linear relation between m_flow and dp for any flow rate"
    annotation(Dialog(enable=FlowType == DisHeatLib.BaseClasses.FlowType.Valve,
               tab="Flow resistance", group="Primary side"));

  //Primary side parameters
  parameter Modelica.SIunits.Power Q1_flow_nominal
    "Nominal heat flow rate"
    annotation(Evaluate=true, Dialog(group="Primary side"));
  parameter Modelica.SIunits.Temperature TemSup1_nominal(displayUnit="degC", start=80.0 + 273.15)
    "Nominal supply temperature"
    annotation(Dialog(group = "Primary side"));
  parameter Modelica.SIunits.Temperature TemRet1_nominal(displayUnit="degC", start=40.0 + 273.15)
    "Nominal return temperature"
    annotation(Dialog(group = "Primary side"));


  //Secondary side parameters
  parameter Modelica.SIunits.Power Q2_flow_nominal
    "Nominal heat flow rate"
    annotation(Evaluate=true, Dialog(group="Secondary side"));
  parameter Modelica.SIunits.Temperature TemSup2_nominal(displayUnit="degC", start=60.0 + 273.15)
    "Nominal supply temperature"
    annotation(Dialog(group = "Secondary side"));
  parameter Modelica.SIunits.Temperature TemRet2_nominal(displayUnit="degC", start=10.0 + 273.15)
    "Nominal return temperature"
    annotation(Dialog(group = "Secondary side"));

  //Storage tank parameters
  parameter Modelica.SIunits.Volume VTan "Tank volume"
    annotation(Evaluate=true, Dialog(group = "Storage tank"));
  parameter Modelica.SIunits.Length hTan(start=1) "Height of tank (without insulation)"
    annotation(Evaluate=true, Dialog(group = "Storage tank"));
  parameter Modelica.SIunits.Length dIns = 0.2 "Thickness of insulation"
    annotation(Evaluate=true, Dialog(group = "Storage tank"));
  parameter Modelica.SIunits.ThermalConductivity kIns = 0.04
    "Specific heat conductivity of insulation"
    annotation(Evaluate=true, Dialog(group = "Storage tank"));
  parameter Integer nSeg(min=4) = 4 "Number of volume segments"
    annotation(Evaluate=true, Dialog(group = "Storage tank"));
  parameter Modelica.SIunits.Temperature TemRoom = 20.0 + 273.15
    "Constant temperature surrounding the storage tank"
    annotation(Evaluate=true, Dialog(group = "Storage tank"));
  parameter Integer nInit(min=0) = 0 "Number of volume segments initialized with TemSup2_nominal"
    annotation(Evaluate=true, Dialog(group = "Storage tank"));

  //Heat exchanger parameters - TAB: Heat exchanger
  parameter Modelica.SIunits.Height hHex_a = hTan/2
    "Height of portHex_a of the heat exchanger, measured from tank bottom"
    annotation(Dialog(group="Heat exchanger"));

  parameter Modelica.SIunits.Height hHex_b = 0
    "Height of portHex_b of the heat exchanger, measured from tank bottom"
    annotation(Dialog(group="Heat exchanger"));

  parameter Integer hexSegMult(min=1) = 2
    "Number of heat exchanger segments in each tank segment"
    annotation(Dialog(group="Heat exchanger"));

  parameter Modelica.SIunits.Diameter dExtHex = 0.025
    "Exterior diameter of the heat exchanger pipe"
    annotation(Dialog(group="Heat exchanger"));

  parameter Real r_nominal(min=0, max=1)=0.5
    "Ratio between coil inside and outside convective heat transfer at nominal heat transfer conditions"
    annotation(Dialog(group="Heat exchanger"));

protected
      final parameter Modelica.SIunits.SpecificHeatCapacity cp_default=
        Medium.cp_const
        "Specific heat capacity of the fluid"
        annotation(Evaluate=true);

public
  IBPSA.Fluid.Storage.StratifiedEnhancedInternalHex tan(
    m_flow_small=m2_flow_small,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    Q_flow_nominal=Q1_flow_nominal,
    hHex_a=hHex_a,
    hHex_b=hHex_b,
    hexSegMult=hexSegMult,
    dExtHex=dExtHex,
    r_nominal=r_nominal,
    dpHex_nominal=0,
    TTan_nominal=TemRet2_nominal,
    THex_nominal=TemSup1_nominal,
    VTan=VTan,
    hTan=hTan,
    dIns=dIns,
    kIns=kIns,
    nSeg=nSeg,
    allowFlowReversal=allowFlowReversal1,
    computeFlowResistance=false,
    energyDynamicsHex=Modelica.Fluid.Types.Dynamics.FixedInitial,
    allowFlowReversalHex=allowFlowReversal2,
    redeclare package Medium = Medium,
    redeclare package MediumHex = Medium,
    m_flow_nominal=m2_flow_nominal,
    mHex_flow_nominal=m1_flow_nominal,
    vol(T_start=cat(
          1,
          fill(TemSup2_nominal, nInit),
          fill(TemRet2_nominal, nSeg - nInit))))
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
protected
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature
                                                  FixedTemRoom(T=TemRoom)
    annotation (Placement(transformation(
        extent={{6,6},{-6,-6}},
        rotation=90,
        origin={0,34})));

public
  Modelica.Blocks.Interfaces.RealOutput TemTank[nSeg](
    quantity="Temperature",
    unit="K",
    displayUnit="degC") "Temperature of layers in thermal storage tank"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,-110}),  iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,-110})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heaPorVol[nSeg]
    "Heat port that connects to the control volumes of the tank"
    annotation (Placement(transformation(extent={{-6,94},{6,106}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor SenTemTank[nSeg]
    "Temperature tank" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,-50})));
equation
  connect(port_a1, port_a1) annotation (Line(points={{-100,60},{-100,63},{-100,63},
          {-100,60}}, color={0,127,255}));
  connect(tan.port_b, port_a2) annotation (Line(points={{10,0},{48,0},{48,-60},{
          100,-60}}, color={0,127,255}));
  connect(tan.port_a, port_b2) annotation (Line(points={{-10,0},{-14,0},{-14,76},
          {20,76},{20,-60},{-100,-60}}, color={0,127,255}));
  connect(port_a1, tan.portHex_a) annotation (Line(points={{-100,60},{-30,60},{-30,
          -3.8},{-10,-3.8}}, color={0,127,255}));
  connect(tan.portHex_b, port_b1) annotation (Line(points={{-10,-8},{-14,-8},{-14,
          -16},{40,-16},{40,60},{100,60}}, color={0,127,255}));
  connect(FixedTemRoom.port, tan.heaPorTop)
    annotation (Line(points={{0,28},{0,7.4},{2,7.4}}, color={191,0,0}));
  connect(FixedTemRoom.port, tan.heaPorSid)
    annotation (Line(points={{0,28},{0,0},{5.6,0}}, color={191,0,0}));
  connect(FixedTemRoom.port, tan.heaPorBot)
    annotation (Line(points={{0,28},{0,-7.4},{2,-7.4}}, color={191,0,0}));
  connect(heaPorVol, tan.heaPorVol) annotation (Line(points={{0,100},{0,88},{-40,
          88},{-40,0},{0,0}}, color={191,0,0}));
  connect(tan.heaPorVol, SenTemTank.port)
    annotation (Line(points={{0,0},{0,-40}}, color={191,0,0}));
  connect(SenTemTank.T, TemTank)
    annotation (Line(points={{0,-60},{0,-110}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Ellipse(
          extent={{-50,80},{50,54}},
          fillColor={255,85,85},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0},
          lineThickness=1),
        Ellipse(
          extent={{-50,-48},{50,-74}},
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0},
          lineThickness=1),
        Rectangle(
          extent={{-50,68},{50,20}},
          fillColor={255,85,85},
          fillPattern=FillPattern.Solid,
          lineThickness=1,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Rectangle(
          extent={{50,20},{-50,-60}},
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid,
          lineThickness=1,
          pattern=LinePattern.None),
        Line(
          points={{-50,68},{-50,-60}},
          color={0,0,0},
          thickness=1),
        Line(
          points={{50,68},{50,-60}},
          color={0,0,0},
          thickness=1),
        Text(
          extent={{-149,-126},{151,-166}},
          lineColor={0,0,255},
          textString="%name"),
        Line(
          points={{-100,60},{-84,60},{-80,60},{-80,0},{32,0},{-32,-12},{32,-22}},
          color={255,0,0},
          thickness=1),
        Line(
          points={{66,56},{66,-44},{32,-44},{-32,-34},{32,-22}},
          color={28,108,200},
          thickness=1),
        Line(
          points={{66,56},{66,60},{98,60}},
          color={28,108,200},
          thickness=1),
        Line(
          points={{-100,-60},{-66,-60},{-60,-60},{-60,60},{-44,60}},
          color={255,85,85},
          thickness=1),
        Line(
          points={{46,-60},{100,-60}},
          color={0,0,127},
          thickness=1)}),                                        Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(revisions="<html>
<ul>
<li>Feburary 27, 2019, by Benedikt Leitner:<br>Implementation and added User&apos;s guide. </li>
</ul>
</html>",
        info="<html>
<p>This is a model of a stratified thermal storage tank with an internal heat exchanger. It is basically a convenience wrapper around the model <a href=\"modelica://IBPSA.Fluid.Storage.StratifiedEnhancedInternalHex\">IBPSA.Fluid.Storage.StratifiedEnhancedInternalHex</a>. It adds a constant ambient temperature to take losses into account.</p>
</html>"));
end StorageTankHex;
