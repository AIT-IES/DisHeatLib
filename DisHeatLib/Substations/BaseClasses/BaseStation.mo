within DisHeatLib.Substations.BaseClasses;
partial model BaseStation
  extends IBPSA.Fluid.Interfaces.PartialFourPortInterface(
    redeclare package Medium1 = Medium,
    redeclare package Medium2 = Medium,
    m1_flow_nominal=Q_flow_nominal/((TemSup1_nominal-TemRet1_nominal)*cp_default),
    m2_flow_nominal=Q_flow_nominal/((TemSup2_nominal-TemRet2_nominal)*cp_default));

  replaceable package Medium =
    Modelica.Media.Interfaces.PartialMedium "Medium in the component"
      annotation (choices(
        choice(redeclare package Medium = IBPSA.Media.Water "Water")));

  parameter Modelica.SIunits.Power Q_flow_nominal
    "Nominal heat flow rate"
    annotation(Evaluate=true, Dialog(group="Nominal condition"));

  parameter Boolean from_dp = false
    "= true, use m_flow = f(dp) else dp = f(m_flow)"
    annotation (Evaluate=true, Dialog(enable = FlowType==DisHeatLib.Substations.BaseClasses.BaseStationFlowType.Valve,
                tab="Flow resistance", group="Primary side"));

  parameter Boolean linearizeFlowResistance = false
    "= true, use linear relation between m_flow and dp for any flow rate"
    annotation(Dialog(enable = FlowType==DisHeatLib.Substations.BaseClasses.BaseStationFlowType.Valve,
               tab="Flow resistance", group="Primary side"));

  //Primary side parameters
  parameter BaseClasses.BaseStationFlowType FlowType = DisHeatLib.Substations.BaseClasses.BaseStationFlowType.Pump "Flow type at primary side"
    annotation(Dialog(group = "Primary side"));
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
          extent={{-70,80},{70,-80}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-38,64},{-100,56}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-38,-56},{-100,-64}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{100,64},{38,56}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{100,-56},{38,-64}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid)}),                      Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end BaseStation;
