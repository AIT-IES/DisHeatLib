within DisHeatLib.Substations.BaseClasses;
partial model SubstationCascadeInterface
   extends IBPSA.Fluid.Interfaces.PartialFourPortInterface(
    redeclare package Medium1 = Medium,
    redeclare package Medium2 = Medium,
    m1_flow_nominal=Q1_flow_nominal/((TemRet1_supply_nominal-TemRet1_nominal)*cp_default),
    m2_flow_nominal=Q2_flow_nominal/((TemSup2_nominal-TemRet2_nominal)*cp_default));
  replaceable package Medium =
    Modelica.Media.Interfaces.PartialMedium "Medium in the component"
      annotation (choices(
        choice(redeclare package Medium = IBPSA.Media.Air "Moist air")));

  parameter Boolean from_dp = false
    "= true, use m_flow = f(dp) else dp = f(m_flow)"
    annotation (Evaluate=true, Dialog(enable=FlowType == DisHeatLib.BaseClasses.FlowType.Valve,
                tab="Flow resistance", group="Primary side"));

  parameter Boolean linearizeFlowResistance = false
    "= true, use linear relation between m_flow and dp for any flow rate"
    annotation(Dialog(enable=FlowType == DisHeatLib.BaseClasses.FlowType.Valve,
               tab="Flow resistance", group="Primary side"));

  parameter Modelica.SIunits.MassFlowRate m1_flow_nominal_supply=Q1_flow_nominal_supply/((TemSup1_nominal-TemRet1_nominal)*cp_default) "Nominal mass flow rate (port_c1)"
    annotation(Evaluate=true, Dialog(group="Nominal condition"));

  //Primary side parameters
  parameter Modelica.SIunits.Power Q1_flow_nominal=m1_flow_nominal*(TemRet1_supply_nominal-TemRet1_nominal)*cp_default
    "Nominal heat flow rate at primary side"
    annotation(Evaluate=true, Dialog(group="Primary side"));
  parameter Modelica.SIunits.Power Q1_flow_nominal_supply=m1_flow_nominal_supply*(TemSup1_nominal-TemRet1_nominal)*cp_default
    "Nominal heat flow rate at primary side taken from supply line"
    annotation(Evaluate=true, Dialog(group="Primary side"));
  parameter Modelica.SIunits.Temperature TemSup1_nominal(displayUnit="degC")=80.0+273.15
    "Nominal supply temperature"
    annotation(Dialog(group = "Primary side"));
  parameter Modelica.SIunits.Temperature TemRet1_supply_nominal(displayUnit="degC")=45.0+273.15
    "Nominal return temperature"
    annotation(Dialog(group = "Primary side"));
  parameter Modelica.SIunits.Temperature TemRet1_nominal(displayUnit="degC")=35.0+273.15
    "Nominal return temperature after cascading"
    annotation(Dialog(group = "Primary side"));
  parameter Modelica.SIunits.PressureDifference dp1_nominal(min=0,
                                                           displayUnit="Pa")=dp_hex_nominal+dpCheckValve_nominal
    "Nominal pressure difference of pump (port_a1 to port_b1)"
    annotation(Dialog(group = "Primary side"));

  parameter Modelica.SIunits.PressureDifference dp1_nominal_supply(min=0,
                                                           displayUnit="Pa")
    "Nominal pressure difference of valve (port_c1 to port_b1)"
    annotation(Dialog(group = "Primary side"));
  parameter Modelica.SIunits.PressureDifference dpCheckValve_nominal=5000
    "Nominal pressure drop of fully open check valve, used if CvData=IBPSA.Fluid.Types.CvTypes.OpPoint"
    annotation(Dialog(group = "Primary side"));
  parameter Modelica.SIunits.TemperatureDifference TemSupMargin(displayUnit="degC")=5.0 "Temperature difference of primary supply inlet and secondary supply setpoint"
    annotation(Dialog(group = "Primary side"));

  //Secondary side parameters
  parameter Modelica.SIunits.Power Q2_flow_nominal=m2_flow_nominal*(TemSup2_nominal-TemRet2_nominal)*cp_default
    "Nominal heat flow rate at primary side"
    annotation(Evaluate=true, Dialog(group="Secondary side"));
  parameter Modelica.SIunits.Temperature TemSup2_nominal(displayUnit="degC")=60.0+273.15
    "Nominal supply temperature"
    annotation(Dialog(group = "Secondary side"));
  parameter Modelica.SIunits.Temperature TemRet2_nominal(displayUnit="degC")=35.0+273.15
    "Nominal return temperature"
    annotation(Dialog(group = "Secondary side"));
  parameter Boolean OutsideDependent = false
    "Outside temperature dependent secondary supply temperature"
    annotation(Evaluate=true, HideResult=true, choices(checkBox=true), Dialog(group="Secondary side"));

  //Secondary side supply temperature
  parameter Modelica.SIunits.Temperature TemOut_max(displayUnit="degC")=15.0+273.15
    "Outdoor temperature where minimum secondary supply temperature is needed"
    annotation (Dialog(enable = OutsideDependent, group="Temperature control secondary side"));
  parameter Modelica.SIunits.Temperature TemOut_min(displayUnit="degC")=-5.0+273.15
    "Outdoor temperature where maximum secondary supply temperature is needed"
    annotation (Dialog(enable = OutsideDependent, group="Temperature control secondary side"));
  parameter Modelica.SIunits.Temperature TemSup2_min(displayUnit="degC")=50.0+273.15
    "Secondary supply temperature where maximum outdoor temperature is reached"
    annotation(Dialog(enable = OutsideDependent, group = "Temperature control secondary side"));
  parameter Modelica.SIunits.Temperature TemSup2_max(displayUnit="degC")=60.0+273.15
    "Secondary supply temperature where minimum outdoor temperature is reached"
    annotation(Dialog(enable = OutsideDependent, group = "Temperature control secondary side"));

  //Heat exchanger parameter
  parameter Modelica.SIunits.Efficiency hex_efficiency(max=1)=0.90
    "Constant efficiency of the heat exchanger"
    annotation(Dialog(group = "Heat exchanger"));
  parameter Modelica.SIunits.PressureDifference dp_hex_nominal=0
    "Nominal pressure difference at the heat exchanger at primary side"
    annotation(Dialog(group = "Heat exchanger"));
  parameter Real k(min=0, unit="1") = 0.01 "Gain of flow controller"
    annotation(Dialog(group = "Pump control"));
  parameter Modelica.SIunits.Time Ti(min=Modelica.Constants.small)=120
    "Time constant of Integrator block of flow controller"
    annotation(Dialog(group = "Pump control"));
  parameter Real k_valve=0.01 "Gain of controller"
    annotation(Dialog(group = "Valve control"));
  parameter Modelica.SIunits.Time Ti_valve=30
    "Time constant of Integrator block"
    annotation(Dialog(group = "Valve control"));

  Medium1.MassFlowRate m1_flow_supply = port_c1.m_flow
    "Mass flow rate from port_a1 to port_b1 (m1_flow > 0 is design flow direction)";
  Modelica.SIunits.PressureDifference dp1_supply(displayUnit="Pa") = port_c1.p - port_b1.p
    "Pressure difference between port_c1 and port_b1";
  Medium1.ThermodynamicState sta_c1=
      Medium1.setState_phX(port_c1.p,
                           noEvent(actualStream(port_c1.h_outflow)),
                           noEvent(actualStream(port_c1.Xi_outflow))) if
         show_T "Medium properties in port_c1";
protected
      final parameter Modelica.SIunits.SpecificHeatCapacity cp_default=
        Medium.cp_const
        "Specific heat capacity of the fluid"
        annotation(Evaluate=true);

public
  Modelica.Fluid.Interfaces.FluidPort_a port_c1(
    redeclare final package Medium = Medium1,
    m_flow(min=if allowFlowReversal1 then -Modelica.Constants.inf else 0),
    h_outflow(start=Medium1.h_default, nominal=Medium1.h_default))
    "Fluid connector c1 (positive design flow direction is from port_c1 to port_b1)"
    annotation (Placement(transformation(extent={{-10,90},{10,110}})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end SubstationCascadeInterface;
