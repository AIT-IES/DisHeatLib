within DisHeatLib.Substations.BaseClasses;
partial model SubstationParallelInterface
  replaceable package Medium =
    Modelica.Media.Interfaces.PartialMedium "Medium in the component"
      annotation (choices(
        choice(redeclare package Medium = IBPSA.Media.Air "Moist air")));

  parameter Modelica.SIunits.MassFlowRate m1_flow_nominal(min=0)
    "Nominal mass flow rate";
  parameter Modelica.SIunits.MassFlowRate m2_flow_nominal(min=0)
    "Nominal mass flow rate";
  parameter Modelica.SIunits.MassFlowRate m3_flow_nominal(min=0)
    "Nominal mass flow rate";
  parameter Medium.MassFlowRate m1_flow_small(min=0) = 1E-4*abs(
    m1_flow_nominal) "Small mass flow rate for regularization of zero flow"
    annotation(Dialog(tab = "Advanced"));
  parameter Medium.MassFlowRate m2_flow_small(min=0) = 1E-4*abs(
    m2_flow_nominal) "Small mass flow rate for regularization of zero flow"
    annotation(Dialog(tab = "Advanced"));
  parameter Medium.MassFlowRate m3_flow_small(min=0) = 1E-4*abs(
    m3_flow_nominal) "Small mass flow rate for regularization of zero flow"
    annotation(Dialog(tab = "Advanced"));

  parameter Modelica.SIunits.PressureDifference dp1_nominal
    "Nominal pressure difference"
    annotation(Dialog(group = "Nominal condition"));

  parameter Boolean from_dp1 = false
    "= true, use m_flow = f(dp) else dp = f(m_flow)"
    annotation (Evaluate=true, Dialog(enable=FlowType == DisHeatLib.BaseClasses.FlowType.Valve,
                tab="Flow resistance", group="Primary side"));

  parameter Boolean linearizeFlowResistance1 = false
    "= true, use linear relation between m_flow and dp for any flow rate"
    annotation(Dialog(enable=FlowType == DisHeatLib.BaseClasses.FlowType.Valve,
               tab="Flow resistance", group="Primary side"));

  parameter Boolean allowFlowReversal1 = true
    "= false to simplify equations, assuming, but not enforcing, no flow reversal"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);

  parameter Boolean allowFlowReversal2 = true
    "= false to simplify equations, assuming, but not enforcing, no flow reversal"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);

  parameter Boolean allowFlowReversal3 = true
    "= false to simplify equations, assuming, but not enforcing, no flow reversal"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);

  // Diagnostics
  parameter Boolean show_T = false
    "= true, if actual temperature at port is computed"
    annotation(Dialog(tab="Advanced", group="Diagnostics"));

  Medium.MassFlowRate m1_flow=port_a1.m_flow
    "Mass flow rate from port_a to port_b (m_flow > 0 is design flow direction)";

  Modelica.SIunits.PressureDifference dp1(displayUnit="Pa") = port_a1.p -
    port_b1.p "Pressure difference between port_a and port_b";

  Medium.ThermodynamicState sta_a1=Medium.setState_phX(
      port_a1.p,
      noEvent(actualStream(port_a1.h_outflow)),
      noEvent(actualStream(port_a1.Xi_outflow))) if show_T
    "Medium properties in port_a";

  Medium.ThermodynamicState sta_b1=Medium.setState_phX(
      port_b1.p,
      noEvent(actualStream(port_b1.h_outflow)),
      noEvent(actualStream(port_b1.Xi_outflow))) if show_T
    "Medium properties in port_b";

  Medium.MassFlowRate m2_flow=port_a2.m_flow
    "Mass flow rate from port_a2 to port_b2 (m_flow > 0 is design flow direction)";

  Modelica.SIunits.PressureDifference dp2(displayUnit="Pa") = port_a2.p -
    port_b2.p "Pressure difference between port_a2 and port_b2";

  Medium.ThermodynamicState sta_a2=Medium.setState_phX(
      port_a2.p,
      noEvent(actualStream(port_a2.h_outflow)),
      noEvent(actualStream(port_a2.Xi_outflow))) if show_T
    "Medium properties in port_a2";

  Medium.ThermodynamicState sta_b2=Medium.setState_phX(
      port_b2.p,
      noEvent(actualStream(port_b2.h_outflow)),
      noEvent(actualStream(port_b2.Xi_outflow))) if show_T
    "Medium properties in port_b2";

  Medium.MassFlowRate m_flow3=port_a3.m_flow
    "Mass flow rate from port_a3 to port_b3 (m_flow > 0 is design flow direction)";

  Modelica.SIunits.PressureDifference dp3(displayUnit="Pa") = port_a3.p -
    port_b3.p "Pressure difference between port_a3 and port_b3";

  Medium.ThermodynamicState sta_a3=Medium.setState_phX(
      port_a3.p,
      noEvent(actualStream(port_a3.h_outflow)),
      noEvent(actualStream(port_a3.Xi_outflow))) if show_T
    "Medium properties in port_a3";

  Medium.ThermodynamicState sta_b3=Medium.setState_phX(
      port_b3.p,
      noEvent(actualStream(port_b3.h_outflow)),
      noEvent(actualStream(port_b3.Xi_outflow))) if show_T
    "Medium properties in port_b3";

public
  Modelica.Fluid.Interfaces.FluidPort_a port_a2(redeclare package Medium =
        Medium)
    "Fluid connector a for station1 (positive design flow direction is from port_a2 to port_b2)"
    annotation (Placement(transformation(extent={{-110,-50},{-90,-30}}),
        iconTransformation(extent={{-110,-50},{-90,-30}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b2(redeclare package Medium =
        Medium)
    "Fluid connector b for station1 (positive design flow direction is from port_a2 to port_b2)"
    annotation (Placement(transformation(extent={{-110,-90},{-90,-70}}),
        iconTransformation(extent={{-110,-90},{-90,-70}})));
public
  Modelica.Fluid.Interfaces.FluidPort_a port_a3(redeclare package Medium =
        Medium)
    "Fluid connector a for station2 (positive design flow direction is from port_a3 to port_b3)"
    annotation (Placement(transformation(extent={{90,-50},{110,-30}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b3(redeclare package Medium =
        Medium)
    "Fluid connector b for station2 (positive design flow direction is from port_a3 to port_b3)"
    annotation (Placement(transformation(extent={{90,-90},{110,-70}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b1(redeclare package Medium =
        Medium)
    "Fluid connector b at primary side for district heating network (positive design flow direction is from port_a1 to port_b1)"
    annotation (Placement(transformation(extent={{90,50},{110,70}})));
public
  Modelica.Fluid.Interfaces.FluidPort_a port_a1(redeclare package Medium =
        Medium)
    "Fluid connector a for district heating network (positive design flow direction is from port_a1 to port_b1)"
    annotation (Placement(transformation(extent={{-110,50},{-90,70}})));
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
  IBPSA.Fluid.Sensors.RelativePressure senRelPre(redeclare package Medium =
        Medium)
    annotation (Placement(transformation(extent={{-10,110},{10,90}})));
equation
  connect(total_power.y,P)
    annotation (Line(points={{87,0},{110,0}}, color={0,0,127}));
  connect(senRelPre.port_a, port_a1) annotation (Line(points={{-10,100},{-100,100},
          {-100,60}}, color={0,127,255}));
  connect(senRelPre.port_b, port_b1)
    annotation (Line(points={{10,100},{100,100},{100,60}}, color={0,127,255}));
  connect(port_a1, port_a1)
    annotation (Line(points={{-100,60},{-100,60}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end SubstationParallelInterface;
