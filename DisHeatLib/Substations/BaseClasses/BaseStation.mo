within DisHeatLib.Substations.BaseClasses;
partial model BaseStation
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
    "Nominal heat flow rate at primary side"
    annotation(Evaluate=true, Dialog(group="Primary side"));
  parameter Modelica.SIunits.Temperature TemSup1_nominal(displayUnit="degC")=80.0+273.15
    "Nominal supply temperature"
    annotation(Dialog(group = "Primary side"));
  parameter Modelica.SIunits.Temperature TemRet1_nominal(displayUnit="degC")=45.0+273.15
    "Nominal return temperature"
    annotation(Dialog(group = "Primary side"));
  parameter Modelica.SIunits.PressureDifference dp1_nominal(min=0,
                                                           displayUnit="Pa")
    "Nominal pressure difference"
    annotation(Dialog(group = "Primary side"));

  //Secondary side parameters
  parameter Modelica.SIunits.Power Q2_flow_nominal
    "Nominal heat flow rate at primary side"
    annotation(Evaluate=true, Dialog(group="Secondary side"));
  parameter Modelica.SIunits.Temperature TemSup2_nominal(displayUnit="degC")=60.0+273.15
    "Nominal supply temperature"
    annotation(Dialog(group = "Secondary side"));
  parameter Modelica.SIunits.Temperature TemRet2_nominal(displayUnit="degC")=35.0+273.15
    "Nominal return temperature"
    annotation(Dialog(group = "Secondary side"));
  parameter Boolean OutsideDependent = true
    "Outside temperature dependent secondary supply temperature"
    annotation(Evaluate=true, HideResult=true, choices(checkBox=true), Dialog(group="Secondary side"));

protected
      final parameter Modelica.SIunits.SpecificHeatCapacity cp_default=
        Medium.cp_const
        "Specific heat capacity of the fluid"
        annotation(Evaluate=true);

public
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_ht if
    OutsideDependent
    "Outside temperature port"
    annotation (Placement(transformation(extent={{-10,-90},{10,-110}})));
public
  Modelica.Blocks.Interfaces.RealOutput P(
    final quantity="Power",
    final unit="W",
    displayUnit="W") "Electric power" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={110,0})));
  Modelica.Blocks.Sources.RealExpression total_power
    "sum of all power consumption/generation in component"
    annotation (Placement(transformation(extent={{66,-10},{86,10}})));
equation
  connect(total_power.y, P)
    annotation (Line(points={{87,0},{110,0}}, color={0,0,127}));
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
          radius=25.0),                  Rectangle(
          extent={{-80,80},{80,-80}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-100,60},{-80,60}},
          color={238,46,47},
          thickness=1),
        Line(
          points={{-100,-60},{-80,-60}},
          color={238,46,47},
          thickness=1),
        Line(
          points={{102,-60},{80,-60}},
          color={28,108,200},
          thickness=1),
        Line(
          points={{100,60},{80,60}},
          color={28,108,200},
          thickness=1)}),                                        Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end BaseStation;
