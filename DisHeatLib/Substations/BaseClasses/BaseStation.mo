within DisHeatLib.Substations.BaseClasses;
partial model BaseStation
    replaceable package Medium =
    Modelica.Media.Water.ConstantPropertyLiquidWater;

    parameter Modelica.SIunits.Power Q_flow_nominal
    "Nominal heat flow rate through station at secondary side (i.e., demand side)"
    annotation(Evaluate=true, Dialog(group="Nominal parameters"));

  parameter Boolean OutsideDependent = true
  "Outside temperature dependent secondary supply temperature"
  annotation(Evaluate=true, HideResult=true, choices(checkBox=true), Dialog(group="Temperature control secondary side"));

  //Primary side parameters
  parameter BaseClasses.BaseStationFlowType FlowType = DisHeatLib.Substations.BaseClasses.BaseStationFlowType.Pump "Flow type at primary side"
    annotation(Dialog(group = "Primary side"));
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal
    "Nominal mass flow rate at the primary side"
    annotation(Evaluate=true, Dialog(group = "Primary side"));
  parameter Modelica.SIunits.PressureDifference dp_nominal=500000
    "Nominal pressure difference at the primary side"
    annotation(Dialog(group = "Primary side"));
  parameter Modelica.SIunits.Temperature TemSup_nominal(displayUnit="degC")=80.0+273.15
    "Nominal supply temperature at the primary side"
    annotation(Dialog(group = "Primary side"));
  parameter Modelica.SIunits.Temperature TemRet_nominal(displayUnit="degC")=45.0+273.15
    "Nominal return temperature at the primary side"
    annotation(Dialog(group = "Primary side"));

  //Secondary side parameters
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal_sec
    "Nominal mass flow rate at the secondary side"
    annotation(Evaluate=true, Dialog(group = "Secondary side"));
  parameter Modelica.SIunits.Temperature TemSup_nominal_sec(displayUnit="degC")=60.0+273.15
    "Nominal supply temperature at the secondary side"
    annotation(Dialog(group = "Secondary side"));
  parameter Modelica.SIunits.Temperature TemRet_nominal_sec(displayUnit="degC")=35.0+273.15
    "Nominal return temperature at the secondary side"
    annotation(Dialog(group = "Secondary side"));

  Modelica.Fluid.Interfaces.FluidPort_b port_sl_s(redeclare package Medium =
        Medium) "Supply fluid port at secondary side "
    annotation (Placement(transformation(extent={{-110,50},{-90,70}})));
public
  Modelica.Fluid.Interfaces.FluidPort_a port_rl_s(redeclare package Medium =
        Medium) "Return fluid port at secondary side "
    annotation (Placement(transformation(extent={{90,50},{110,70}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_rl_p(redeclare package Medium =
        Medium) "Return fluid port at primary side "
    annotation (Placement(transformation(extent={{90,-70},{110,-50}})));
public
  Modelica.Fluid.Interfaces.FluidPort_a port_sl_p(redeclare package Medium =
        Medium) "Supply fluid port at primary side "
    annotation (Placement(transformation(extent={{-110,-70},{-90,-50}})));
public
  IBPSA.Fluid.Sensors.RelativePressure sendp(redeclare package Medium = Medium)
    "differential pressure sensor"
    annotation (Placement(transformation(extent={{-10,-96},{10,-76}})));
  Modelica.Blocks.Interfaces.RealOutput dp "Connector of Real output signal"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=90,
        origin={0,-110}), iconTransformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={0,-110})));
public
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_ht if
    OutsideDependent
    "Outside temperature port"
    annotation (Placement(transformation(extent={{-10,90},{10,110}})));
equation
  connect(sendp.port_b, port_rl_p) annotation (Line(points={{10,-86},{92,-86},{92,
          -60},{100,-60}},     color={0,127,255}));
  connect(sendp.port_a, port_sl_p) annotation (Line(points={{-10,-86},{-92,-86},
          {-92,-60},{-100,-60}}, color={0,127,255}));
  connect(sendp.p_rel, dp)
    annotation (Line(points={{0,-95},{0,-110}},  color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          lineColor={200,200,200},
          fillColor={248,248,248},
          fillPattern=FillPattern.HorizontalCylinder,
          extent={{-100,-100},{100,100}},
          radius=25.0),          Text(
          extent={{-149,-109},{151,-149}},
          lineColor={0,0,255},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255},
          textString="%name"),
        Rectangle(
          lineColor={128,128,128},
          extent={{-100,-100},{100,100}},
          radius=25.0),                  Rectangle(
          extent={{-70,80},{70,-80}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid)}),                      Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end BaseStation;
