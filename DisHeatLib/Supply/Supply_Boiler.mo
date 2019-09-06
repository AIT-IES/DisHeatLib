within DisHeatLib.Supply;
model Supply_Boiler
  extends DisHeatLib.Supply.BaseClasses.BaseSupply(nPorts=1);

  parameter Modelica.SIunits.Temperature TesTemSup_nominal "Nominal supply temperature of tank"
    annotation(Evaluate=false, Dialog(group = "Storage tank"));
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

  parameter BaseClasses.BasePowerCharacteristic powerCha
    "Characteristic for heat and power units";

  parameter Modelica.SIunits.MassFlowRate m_flow_small(min=0) = 1E-4*abs(m_flow_nominal)
    "Small mass flow rate for regularization of zero flow"
    annotation(Dialog(tab = "Advanced"));
  parameter Boolean allowFlowReversal = true
    "= false to simplify equations, assuming, but not enforcing, no flow reversal for medium 1"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);

  DisHeatLib.Supply.Supply_QT supply_QT(redeclare package Medium = Medium,
    allowFlowReversal=allowFlowReversal,
    m_flow_nominal=2*supply_QT.Q_flow_nominal/((supply_QT.TemSup_nominal -
        supply_QT.TemRet_nominal)*cp_default),
    Q_flow_nominal=Q_flow_nominal,
    TemSup_nominal=TemSup_nominal,
    TemRet_nominal=TemRet_nominal,
    powerCha=powerCha,
    m_flow_small=m_flow_small,
    dp_nominal=100000,                  use_Q_in=true,
    nPorts=1)
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  DisHeatLib.Storage.StorageTank storageTank(redeclare package Medium = Medium,
    VTan=VTan,
    hTan=hTan,
    dIns=dIns,
    kIns=kIns,
    nSeg=nSeg,
    TemInit=TemInit,
    TemRoom=TemRoom,
    m_flow_nominal=m_flow_nominal,
    m_flow_small=m_flow_small,
    allowFlowReversal=allowFlowReversal)
    annotation (Placement(transformation(extent={{-10,-4},{10,16}})));
  DisHeatLib.BaseClasses.FlowUnit flowUnit(redeclare package Medium = Medium,
    m_flow_nominal=2*m_flow_nominal,
      FlowType=DisHeatLib.BaseClasses.FlowType.Pump,
    dp_nominal(displayUnit="bar") = 100000)
    annotation (Placement(transformation(extent={{44,-10},{64,10}})));
public
  Modelica.Blocks.Interfaces.RealInput PSet             annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={-60,120})));
public
  Modelica.Blocks.Interfaces.RealInput QSet annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={60,120})));
  DisHeatLib.Controls.Q_flow_control
                          q_flow_control(
    Q_flow_nominal=Q_flow_nominal,
    m_flow_nominal=m_flow_nominal,
    limit_m_flow=true,
    normalize_y=true,
    Ti=60) annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={60,70})));
public
  Modelica.Blocks.Interfaces.RealInput m_flow_limit annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={0,120})));
  IBPSA.Fluid.Sensors.EnthalpyFlowRate senEntFlo(redeclare package Medium =
        Medium, m_flow_nominal=m_flow_nominal)
    annotation (Placement(transformation(extent={{-94,-10},{-74,10}})));
  IBPSA.Fluid.Sensors.EnthalpyFlowRate senEntFlo1(redeclare package Medium =
        Medium, m_flow_nominal=m_flow_nominal)
    annotation (Placement(transformation(extent={{70,-10},{90,10}})));
  Modelica.Blocks.Math.Add add1(k1=-1)
    annotation (Placement(transformation(extent={{16,60},{36,80}})));
  Controls.twopoint_control twopoint_control(
    y_max=0,
    y_min=1,
    u_min=TesTemSup_nominal + twopoint_control.u_bandwidth/2,
    u_bandwidth=5,
    pre_y_start=false)
    annotation (Placement(transformation(extent={{28,24},{48,44}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temperatureSensor
    annotation (Placement(transformation(extent={{0,24},{20,44}})));
  Modelica.Blocks.Math.Product product
    annotation (Placement(transformation(extent={{100,60},{80,80}})));
  Storage.BaseClasses.ThermostatMixer thermostatMixer(
    redeclare package Medium = Medium,
    FlowType=DisHeatLib.BaseClasses.FlowType.Valve,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=100000,
    Tem_set=TesTemSup_nominal)
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
public
  Modelica.Blocks.Interfaces.RealOutput TemTank[nSeg](
    quantity="Temperature",
    unit="K",
    displayUnit="degC") "Temperature of layers in thermal storage tank"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={60,-110}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={60,-110})));
public
  Modelica.Blocks.Interfaces.RealOutput P(unit="W")
    "Active power consumption (positive)/generation(negative)"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,-110})));
public
  Modelica.Blocks.Interfaces.RealOutput Q_flow(unit="W")
    "Active power consumption (positive)/generation(negative)" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-60,-110})));

  Modelica.Blocks.Sources.RealExpression realExpression(y=senEntFlo1.H_flow -
        senEntFlo.H_flow)
    annotation (Placement(transformation(extent={{-88,-90},{-68,-70}})));
equation
  connect(supply_QT.ports_b[1], storageTank.port_b2)
    annotation (Line(points={{-20,0},{-10,0}}, color={0,127,255}));
  connect(QSet, q_flow_control.Q_flow_set)
    annotation (Line(points={{60,120},{60,82}}, color={0,0,127}));
  connect(PSet, supply_QT.QSet) annotation (Line(points={{-60,120},{-60,20},{-36,
          20},{-36,12}}, color={0,0,127}));
  connect(q_flow_control.y, flowUnit.y)
    annotation (Line(points={{60,59},{60,12},{54,12}}, color={0,0,127}));
  connect(port_a, senEntFlo.port_a)
    annotation (Line(points={{-100,0},{-94,0}}, color={0,127,255}));
  connect(senEntFlo1.port_b, ports_b[1])
    annotation (Line(points={{90,0},{100,0}}, color={0,127,255}));
  connect(senEntFlo1.port_a, flowUnit.port_b)
    annotation (Line(points={{70,0},{64,0}}, color={0,127,255}));
  connect(q_flow_control.Q_flow_measure, add1.y)
    annotation (Line(points={{48,70},{37,70}}, color={0,0,127}));
  connect(senEntFlo1.H_flow, add1.u2) annotation (Line(points={{80,11},{80,52},{
          2,52},{2,64},{14,64}}, color={0,0,127}));
  connect(senEntFlo.H_flow, add1.u1)
    annotation (Line(points={{-84,11},{-84,76},{14,76}}, color={0,0,127}));
  connect(storageTank.port_a2, supply_QT.port_a) annotation (Line(points={{10,0},{
          10,-20},{-52,-20},{-52,0},{-40,0}},  color={0,127,255}));
  connect(storageTank.port_b1, senEntFlo.port_b) annotation (Line(points={{10,12},
          {14,12},{14,-30},{-62,-30},{-62,0},{-74,0}}, color={0,127,255}));
  connect(temperatureSensor.T, twopoint_control.u)
    annotation (Line(points={{20,34},{26,34}}, color={0,0,127}));
  connect(temperatureSensor.port, storageTank.heaPorVol[1])
    annotation (Line(points={{0,34},{0,16}}, color={191,0,0}));
  connect(q_flow_control.m_flow_max, product.y)
    annotation (Line(points={{72,70},{79,70}}, color={0,0,127}));
  connect(twopoint_control.y, product.u2) annotation (Line(points={{49,34},{116,
          34},{116,64},{102,64}}, color={0,0,127}));
  connect(m_flow_limit, product.u1) annotation (Line(points={{0,120},{0,92},{116,
          92},{116,76},{102,76}}, color={0,0,127}));
  connect(flowUnit.port_a, thermostatMixer.port_2)
    annotation (Line(points={{44,0},{40,0}}, color={0,127,255}));
  connect(storageTank.port_a1, thermostatMixer.port_1) annotation (Line(points={
          {-10,12},{-12,12},{-12,22},{20,22},{20,0}}, color={0,127,255}));
  connect(storageTank.port_a2, thermostatMixer.port_3) annotation (Line(points={
          {10,0},{10,-20},{30,-20},{30,-10}}, color={0,127,255}));
  connect(supply_QT.P, P) annotation (Line(points={{-30,-11},{-30,-60},{0,-60},{
          0,-110}}, color={0,0,127}));
  connect(realExpression.y, Q_flow) annotation (Line(points={{-67,-80},{-60,-80},
          {-60,-110}}, color={0,0,127}));
  connect(storageTank.TemTank, TemTank) annotation (Line(points={{0,-5},{0,-40},
          {60,-40},{60,-110}}, color={0,0,127}));
end Supply_Boiler;
