within DisHeatLib.Storage;
model StorageTank
  extends IBPSA.Fluid.Interfaces.PartialFourPortInterface(
    redeclare package Medium1 = Medium,
    redeclare package Medium2 = Medium,
    final m1_flow_nominal = m_flow_nominal,
    final m2_flow_nominal = m_flow_nominal,
    final allowFlowReversal1 = allowFlowReversal,
    final allowFlowReversal2 = allowFlowReversal,
    final m1_flow_small = m_flow_small,
    final m2_flow_small = m_flow_small);

  replaceable package Medium =
    Modelica.Media.Interfaces.PartialMedium "Medium in the component"
      annotation (choices(
        choice(redeclare package Medium = IBPSA.Media.Water "Water")));

  parameter Modelica.SIunits.Volume VTan "Tank volume"
    annotation(Evaluate=false, Dialog(group = "Storage tank"));
  parameter Modelica.SIunits.Length hTan = 1 "Height of tank (without insulation)"
    annotation(Evaluate=true, Dialog(group = "Storage tank"));
  parameter Modelica.SIunits.Length dIns = 0.2 "Thickness of insulation"
    annotation(Evaluate=true, Dialog(group = "Storage tank"));
  parameter Modelica.SIunits.ThermalConductivity kIns = 0.04
    "Specific heat conductivity of insulation"
    annotation(Evaluate=true, Dialog(group = "Storage tank"));
  parameter Integer nSeg(min=4) = 4 "Number of volume segments"
    annotation(Evaluate=true, Dialog(group = "Storage tank"));
  parameter Modelica.SIunits.Temperature TemInit
    "Initial temperature of the storage tank"
    annotation(Evaluate=true, Dialog(group = "Storage tank"));
  parameter Modelica.SIunits.Temperature TemRoom = 20.0 + 273.15
    "Constant temperature surrounding the storage tank"
    annotation(Evaluate=true, Dialog(group = "Storage tank"));

  parameter Modelica.SIunits.MassFlowRate m_flow_nominal
    "Nominal mass flow rate"
    annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.SIunits.MassFlowRate m_flow_small(min=0) = 1E-4*abs(m_flow_nominal)
    "Small mass flow rate for regularization of zero flow"
    annotation(Dialog(tab = "Advanced"));
  parameter Boolean allowFlowReversal = true
    "= false to simplify equations, assuming, but not enforcing, no flow reversal for medium 1"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);

public
  IBPSA.Fluid.Storage.StratifiedEnhanced tan(
    allowFlowReversal=allowFlowReversal,
    m_flow_small=m_flow_small,
    VTan=VTan,
    hTan=hTan,
    dIns=dIns,
    kIns=kIns,
    nSeg=nSeg,
    m_flow_nominal=m_flow_nominal,
    redeclare package Medium = Medium,
    T_start=TemInit)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature
                                                  FixedTemRoom(T=TemRoom)
    annotation (Placement(transformation(
        extent={{6,6},{-6,-6}},
        rotation=90,
        origin={0,30})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heaPorVol[nSeg]
    "Heat port that connects to the control volumes of the tank"
    annotation (Placement(transformation(extent={{-6,94},{6,106}})));
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
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor SenTemTank[nSeg]
    "Temperature tank" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,-50})));
protected
  IBPSA.Fluid.FixedResistances.Junction jun(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    dp_nominal={0,0,0},
    m_flow_nominal={m_flow_nominal,m_flow_nominal,m_flow_nominal})
    annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=270,
        origin={60,0})));
  IBPSA.Fluid.FixedResistances.Junction jun1(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    T_start=TemInit,
    dp_nominal={0,0,0},
    m_flow_nominal={m_flow_nominal,m_flow_nominal,m_flow_nominal})
    annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=90,
        origin={-70,0})));
equation
  connect(FixedTemRoom.port, tan.heaPorTop)
    annotation (Line(points={{0,24},{0,7.4},{2,7.4}}, color={191,0,0}));
  connect(FixedTemRoom.port, tan.heaPorSid)
    annotation (Line(points={{0,24},{0,0},{5.6,0}}, color={191,0,0}));
  connect(FixedTemRoom.port, tan.heaPorBot)
    annotation (Line(points={{0,24},{0,-7.4},{2,-7.4}}, color={191,0,0}));
  connect(heaPorVol, tan.heaPorVol) annotation (Line(points={{0,100},{0,88},
          {-40,88},{-40,0},{0,0}},
                              color={191,0,0}));
  connect(jun1.port_2, port_a1) annotation (Line(points={{-70,6},{-70,60},{
          -100,60}}, color={0,127,255}));
  connect(port_b2, jun1.port_1) annotation (Line(points={{-100,-60},{-70,-60},
          {-70,-6}}, color={0,127,255}));
  connect(jun1.port_3, tan.port_a)
    annotation (Line(points={{-64,0},{-10,0}}, color={0,127,255}));
  connect(tan.port_b, jun.port_3)
    annotation (Line(points={{10,0},{54,0}}, color={0,127,255}));
  connect(jun.port_1, port_b1) annotation (Line(points={{60,6},{60,60},{100,
          60}}, color={0,127,255}));
  connect(jun.port_2, port_a2) annotation (Line(points={{60,-6},{60,-60},{100,
          -60}}, color={0,127,255}));
  connect(tan.heaPorVol, SenTemTank.port)
    annotation (Line(points={{0,0},{0,-40}}, color={191,0,0}));
  connect(SenTemTank.T, TemTank)
    annotation (Line(points={{0,-60},{0,-110}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Ellipse(
          extent={{-50,80},{50,54}},
          fillColor={238,46,47},
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
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid,
          lineThickness=1,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Rectangle(
          extent={{50,28},{-50,-60}},
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
        Line(
          points={{-32,60},{-100,60}},
          color={238,46,47},
          thickness=1),
        Line(
          points={{40,-58}},
          color={238,46,47},
          thickness=1),
        Line(
          points={{38,-60},{70,-60},{70,60},{98,60}},
          color={0,0,127},
          thickness=1),
        Line(
          points={{70,-60},{102,-60}},
          color={0,0,127},
          thickness=1),
        Line(
          points={{-70,60},{-70,36},{-70,-60},{-100,-60}},
          color={238,46,47},
          thickness=1)}),                                        Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(
      StopTime=36000,
      Interval=60,
      __Dymola_Algorithm="Cvode"),
    Documentation(revisions="<html>
<ul>
<li>Feburary 27, 2019, by Benedikt Leitner:<br>Implementation and added User&apos;s guide. </li>
</ul>
</html>",
        info="<html>
<p>This is a model of a stratified thermal storage tank. It is basically a convenience wrapper around the model <a href=\"modelica://IBPSA.Fluid.Storage.StratifiedEnhanced\">IBPSA.Fluid.Storage.StratifiedEnhanced</a>. It adds distinct ports for supply and demand as well as a constant ambient temperature to take losses into account.</p>
</html>"));
end StorageTank;
