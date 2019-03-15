within DisHeatLib.BaseClasses;
model FlowUnit
  extends IBPSA.Fluid.Interfaces.PartialTwoPortInterface;
  parameter DisHeatLib.BaseClasses.FlowType FlowType=DisHeatLib.BaseClasses.FlowType.Valve
    "Flow type";

  parameter Modelica.SIunits.PressureDifference dp_nominal(min=0,
                                                           displayUnit="Pa")
    "Nominal pressure difference"
    annotation(Dialog(group="Nominal condition"));

  parameter Modelica.SIunits.PressureDifference dpFixed_nominal=0
    "Pressure drop of pipe and other resistances that are in series"
        annotation(Dialog(group="Nominal condition", enable=FlowType == DisHeatLib.BaseClasses.FlowType.Valve));

  parameter Boolean from_dp=false
    "= true, use m_flow = f(dp) else dp = f(m_flow)"
    annotation(Dialog(enable=FlowType == DisHeatLib.BaseClasses.FlowType.Valve,
               tab="Flow resistance"));

  parameter Boolean linearizeFlowResistance = false
    "= true, use linear relation between m_flow and dp for any flow rate"
    annotation(Dialog(enable=FlowType == DisHeatLib.BaseClasses.FlowType.Valve,
               tab="Flow resistance"));

public
  replaceable
  IBPSA.Fluid.Actuators.Valves.TwoWayEqualPercentage valve if FlowType == DisHeatLib.BaseClasses.FlowType.Valve
    constrainedby IBPSA.Fluid.Actuators.BaseClasses.PartialTwoWayValve(
    redeclare package Medium = Medium,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=m_flow_nominal,
    final from_dp=from_dp,
    final linearized=linearizeFlowResistance,
    final dpValve_nominal=dp_nominal-dpFixed_nominal,
    final dpFixed_nominal=dpFixed_nominal)
    annotation (Dialog(enable=FlowType == DisHeatLib.BaseClasses.FlowType.Valve), Placement(transformation(extent={{-10,30},{10,50}})),
      __Dymola_choicesAllMatching=true);
  replaceable
  IBPSA.Fluid.Movers.FlowControlled_m_flow pump if FlowType == DisHeatLib.BaseClasses.FlowType.Pump
    constrainedby IBPSA.Fluid.Movers.FlowControlled_m_flow(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=m_flow_nominal,
    final m_flow_small=m_flow_small,
    final inputType=IBPSA.Fluid.Types.InputType.Continuous,
    final addPowerToMedium=false,
    final nominalValuesDefineDefaultPressureCurve=true,
    final dp_nominal=dp_nominal)
    annotation (Dialog(enable=FlowType == DisHeatLib.BaseClasses.FlowType.Pump), Placement(transformation(extent={{-10,-50},{10,-30}})));
  Modelica.Blocks.Math.Gain gain(k=m_flow_nominal) if  FlowType == DisHeatLib.BaseClasses.FlowType.Pump
                                                   annotation (Placement(
        transformation(
        extent={{-4,-4},{4,4}},
        rotation=-90,
        origin={0,-16})));
  Modelica.Blocks.Interfaces.RealInput y annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={0,120})));

equation
  connect(gain.y, pump.m_flow_in)
    annotation (Line(points={{0,-20.4},{0,-28}}, color={0,0,127}));
  connect(y, valve.y)
    annotation (Line(points={{0,120},{0,52}}, color={0,0,127}));
  connect(y, gain.u) annotation (Line(points={{0,120},{0,60},{20,60},{20,-11.2},
          {0,-11.2}}, color={0,0,127}));
  connect(port_a, pump.port_a) annotation (Line(points={{-100,0},{-40,0},{-40,
          -40},{-10,-40}}, color={0,127,255}));
  connect(port_a, valve.port_a) annotation (Line(points={{-100,0},{-40,0},{-40,
          40},{-10,40}}, color={0,127,255}));
  connect(valve.port_b, port_b) annotation (Line(points={{10,40},{40,40},{40,
          0},{100,0}}, color={0,127,255}));
  connect(pump.port_b, port_b) annotation (Line(points={{10,-40},{40,-40},{40,
          0},{100,0}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,22},{-38,-20}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255}),
        Polygon(
          points={{-60,-46},{-60,46},{0,0},{-60,-46}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          visible=FlowType == DisHeatLib.BaseClasses.FlowType.Valve),
        Rectangle(
          extent={{100,22},{38,-20}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255}),
        Polygon(
          points={{60,-46},{60,46},{0,0},{60,-46}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          visible=FlowType == DisHeatLib.BaseClasses.FlowType.Valve),
        Ellipse(
          extent={{-62,62},{62,-62}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={247,247,247},
          fillPattern=FillPattern.Solid,
          origin={7.10543e-15,-7.10543e-15},
          rotation=-90,
          visible=FlowType == DisHeatLib.BaseClasses.FlowType.Pump),
        Line(
          points={{11,-8},{-51,54},{-113,-8}},
          color={0,0,0},
          thickness=0.5,
          origin={8,-51},
          rotation=-90,
          visible=FlowType == DisHeatLib.BaseClasses.FlowType.Pump)}),                                       Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end FlowUnit;
