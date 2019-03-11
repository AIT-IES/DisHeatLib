within DisHeatLib.Substations.BaseClasses;
partial model SubstationInterface
  replaceable package Medium =
    Modelica.Media.Interfaces.PartialMedium "Medium in the component"
      annotation (choices(
        choice(redeclare package Medium = IBPSA.Media.Air "Moist air")));

  parameter Modelica.SIunits.MassFlowRate m_flow_nominal
    "Nominal mass flow rate"
    annotation (Evaluate=true);

  parameter BaseClasses.BaseStationFlowType FlowType = DisHeatLib.Substations.BaseClasses.BaseStationFlowType.Pump "Flow type"
    annotation(Dialog(group = "Nominal condition"));

  parameter Modelica.SIunits.PressureDifference dp_nominal
    "Nominal pressure difference"
    annotation(Dialog(group = "Nominal condition"));

  parameter Boolean from_dp = false
    "= true, use m_flow = f(dp) else dp = f(m_flow)"
    annotation (Evaluate=true, Dialog(enable = FlowType==DisHeatLib.Substations.BaseClasses.BaseStationFlowType.Valve,
                tab="Flow resistance", group="Primary side"));

  parameter Boolean linearizeFlowResistance = false
    "= true, use linear relation between m_flow and dp for any flow rate"
    annotation(Dialog(enable = FlowType==DisHeatLib.Substations.BaseClasses.BaseStationFlowType.Valve,
               tab="Flow resistance", group="Primary side"));

  parameter Boolean allowFlowReversal = true
    "= false to simplify equations, assuming, but not enforcing, no flow reversal"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);

  parameter Medium.MassFlowRate m_flow_small(min=0) = 1E-4*abs(m_flow_nominal)
    "Small mass flow rate for regularization of zero flow"
    annotation(Dialog(tab = "Advanced"));

  // Diagnostics
  parameter Boolean show_T = false
    "= true, if actual temperature at port is computed"
    annotation(Dialog(tab="Advanced", group="Diagnostics"));

  Medium.MassFlowRate m_flow = port_a.m_flow
    "Mass flow rate from port_a to port_b (m_flow > 0 is design flow direction)";

  Medium.ThermodynamicState sta_a=
      Medium.setState_phX(port_a.p,
                           noEvent(actualStream(port_a.h_outflow)),
                           noEvent(actualStream(port_a.Xi_outflow))) if
         show_T "Medium properties in port_a";

  Medium.ThermodynamicState sta_b=
      Medium.setState_phX(port_b.p,
                           noEvent(actualStream(port_b.h_outflow)),
                           noEvent(actualStream(port_b.Xi_outflow))) if
         show_T "Medium properties in port_b";

  Medium.MassFlowRate m_flow_DHW = port_a_DHW.m_flow
    "Mass flow rate from port_a_DHW to port_b_DHW (m_flow > 0 is design flow direction)";

  Modelica.SIunits.PressureDifference dp_DHW(displayUnit="Pa") = port_a_DHW.p - port_b_DHW.p
    "Pressure difference between port_a_DHW and port_b_DHW";

  Medium.ThermodynamicState sta_a_DHW=
      Medium.setState_phX(port_a_DHW.p,
                           noEvent(actualStream(port_a_DHW.h_outflow)),
                           noEvent(actualStream(port_a_DHW.Xi_outflow))) if
         show_T "Medium properties in port_a_DHW";

  Medium.ThermodynamicState sta_b_DHW=
      Medium.setState_phX(port_b_DHW.p,
                           noEvent(actualStream(port_b_DHW.h_outflow)),
                           noEvent(actualStream(port_b_DHW.Xi_outflow))) if
         show_T "Medium properties in port_b_DHW";

  Medium.MassFlowRate m_flow_SH = port_a_SH.m_flow
    "Mass flow rate from port_a_SH to port_b_SH (m_flow > 0 is design flow direction)";

  Modelica.SIunits.PressureDifference dp_SH(displayUnit="Pa") = port_a_SH.p - port_b_SH.p
    "Pressure difference between port_a_SH and port_b_SH";

  Medium.ThermodynamicState sta_a_SH=
      Medium.setState_phX(port_a_SH.p,
                           noEvent(actualStream(port_a_SH.h_outflow)),
                           noEvent(actualStream(port_a_SH.Xi_outflow))) if
         show_T "Medium properties in port_a_SH";

  Medium.ThermodynamicState sta_b_SH=
      Medium.setState_phX(port_b_SH.p,
                           noEvent(actualStream(port_b_SH.h_outflow)),
                           noEvent(actualStream(port_b_SH.Xi_outflow))) if
         show_T "Medium properties in port_b_SH";

public
  Modelica.Fluid.Interfaces.FluidPort_a port_a_DHW(redeclare package Medium =
        Medium)
    "Fluid connector a for domestic hot water (positive design flow direction is from port_a_DHW to port_b_DHW)"
    annotation (Placement(transformation(extent={{-110,10},{-90,30}}),
        iconTransformation(extent={{-110,10},{-90,30}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b_DHW(redeclare package Medium =
        Medium)
    "Fluid connector b for domestic hot water (positive design flow direction is from port_a_DHW to port_b_DHW)"
    annotation (Placement(transformation(extent={{-110,50},{-90,70}}),
        iconTransformation(extent={{-110,50},{-90,70}})));
public
  Modelica.Fluid.Interfaces.FluidPort_a port_a_SH(redeclare package Medium =
        Medium)
    "Fluid connector a for space heating (positive design flow direction is from port_a_SH to port_b_SH)"
    annotation (Placement(transformation(extent={{90,10},{110,30}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b_SH(redeclare package Medium =
        Medium)
    "Fluid connector b for space heating (positive design flow direction is from port_a_SH to port_b_SH)"
    annotation (Placement(transformation(extent={{90,50},{110,70}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium =
        Medium)
    "Fluid connector b at primary side for district heating network (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{90,-70},{110,-50}})));
public
  Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium =
        Medium)
    "Fluid connector a for district heating network (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{-110,-70},{-90,-50}})));
public
  IBPSA.Fluid.Sensors.RelativePressure sendp(redeclare package Medium = Medium)
    "differential pressure sensor"
    annotation (Placement(transformation(extent={{-10,-98},{10,-78}})));
public
  Modelica.Blocks.Interfaces.RealOutput dp "Differential pressure"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,-110})));
  Modelica.Blocks.Sources.RealExpression total_power
    "sum of all power consumption/generation in component"
    annotation (Placement(transformation(extent={{66,-10},{86,10}})));
public
  Modelica.Blocks.Interfaces.RealOutput P(
    final quantity="Power",
    final unit="W",
    displayUnit="W") "Electric power" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={110,0})));
equation
  connect(sendp.p_rel,dp)
    annotation (Line(points={{0,-97},{0,-110}},  color={0,0,127}));
  connect(total_power.y,P)
    annotation (Line(points={{87,0},{110,0}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end SubstationInterface;
