within DisHeatLib.Storage.BaseClasses;
model Mixer
  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium
    "Medium in the component";

  parameter Modelica.SIunits.MassFlowRate m_flow_nominal
    "Nominal mass flow rate";
  parameter Modelica.SIunits.Temperature Tem_set
    "Temperature set-point for port_2";

  parameter Modelica.Fluid.Types.PortFlowDirection portFlowDirection_1=Modelica.Fluid.Types.PortFlowDirection.Bidirectional
    "Flow direction for port_1"
   annotation(Dialog(tab="Advanced"));
  parameter Modelica.Fluid.Types.PortFlowDirection portFlowDirection_2=Modelica.Fluid.Types.PortFlowDirection.Bidirectional
    "Flow direction for port_2"
   annotation(Dialog(tab="Advanced"));
  parameter Modelica.Fluid.Types.PortFlowDirection portFlowDirection_3=Modelica.Fluid.Types.PortFlowDirection.Bidirectional
    "Flow direction for port_3"
   annotation(Dialog(tab="Advanced"));
  parameter Boolean verifyFlowReversal = false
    "=true, to assert that the flow does not reverse when portFlowDirection_* does not equal Bidirectional"
    annotation(Dialog(tab="Advanced"));
  parameter Modelica.SIunits.MassFlowRate m_flow_small(min=0) = 1E-4*abs(m_flow_nominal)
    "Small mass flow rate for checking flow reversal"
    annotation(Dialog(tab="Advanced",enable=verifyFlowReversal));

  // Diagnostics
  parameter Boolean show_T=false
    "= true, if actual temperature at port is computed"
   annotation(Dialog(tab="Advanced",group="Diagnostics"));

  Medium.ThermodynamicState sta_1=Medium.setState_phX(
      port_1.p,
      noEvent(actualStream(port_1.h_outflow)),
      noEvent(actualStream(port_1.Xi_outflow))) if show_T
    "Medium properties in port_1";

  Medium.ThermodynamicState sta_2=Medium.setState_phX(
      port_2.p,
      noEvent(actualStream(port_2.h_outflow)),
      noEvent(actualStream(port_2.Xi_outflow))) if show_T
    "Medium properties in port_2";

  Medium.ThermodynamicState sta_3=Medium.setState_phX(
      port_3.p,
      noEvent(actualStream(port_3.h_outflow)),
      noEvent(actualStream(port_3.Xi_outflow))) if show_T
    "Medium properties in port_3";

  Modelica.Fluid.Interfaces.FluidPort_a port_1(
    redeclare package Medium = Medium,
    h_outflow(start=Medium.h_default, nominal=Medium.h_default),
    m_flow(min=if (portFlowDirection_1 == Modelica.Fluid.Types.PortFlowDirection.Entering) then 0.0 else -Modelica.Constants.inf,
           max=if (portFlowDirection_1== Modelica.Fluid.Types.PortFlowDirection.Leaving) then 0.0 else Modelica.Constants.inf))
    "First port, typically inlet"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_2(
    redeclare package Medium = Medium,
    h_outflow(start=Medium.h_default, nominal=Medium.h_default),
    m_flow(min=if (portFlowDirection_2 == Modelica.Fluid.Types.PortFlowDirection.Entering) then 0.0 else -Modelica.Constants.inf,
           max=if (portFlowDirection_2 == Modelica.Fluid.Types.PortFlowDirection.Leaving) then 0.0 else Modelica.Constants.inf))
    "Second port, typically outlet"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_3(
    redeclare package Medium=Medium,
    h_outflow(start=Medium.h_default, nominal=Medium.h_default),
    m_flow(min=if (portFlowDirection_3==Modelica.Fluid.Types.PortFlowDirection.Entering) then 0.0 else -Modelica.Constants.inf,
           max=if (portFlowDirection_3==Modelica.Fluid.Types.PortFlowDirection.Leaving) then 0.0 else Modelica.Constants.inf))
    "Third port, can be either inlet or outlet"
    annotation (Placement(transformation(extent={{-10,-110},{10,-90}})));

  IBPSA.Fluid.FixedResistances.Junction jun(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial,
    m_flow_nominal={m_flow_nominal,m_flow_nominal,m_flow_nominal},
    dp_nominal={0,0,0})
    annotation (Placement(transformation(extent={{10,-10},{-10,10}})));
  DisHeatLib.BaseClasses.FlowUnit flowUnit(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,         FlowType=DisHeatLib.BaseClasses.FlowType.Pump,
    dp_nominal=1,
    pump(use_inputFilter=false))
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,-50})));
  replaceable
  Controls.flow_control flow_control(
    final reverseAction=true,
    k=0.05,
    Ti=30,
    final min_y=0,
    final use_T_in=false,
    final use_m_flow_in=true,
    final T_const=Tem_set,
    final m_flow_nominal=m_flow_nominal,
    final m_flow_min=0.0001*abs(m_flow_nominal))
    annotation (Dialog(group="Controller"), Placement(transformation(extent={{-40,-60},{-20,-40}})));
  IBPSA.Fluid.Sensors.MassFlowRate senMasFlo(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  IBPSA.Fluid.Sensors.TemperatureTwoPort senTem(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    initType=Modelica.Blocks.Types.Init.InitialOutput,
    T_start=Tem_set)
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
initial equation
  assert(portFlowDirection_1<>Modelica.Fluid.Types.PortFlowDirection.Leaving or
         portFlowDirection_2<>Modelica.Fluid.Types.PortFlowDirection.Leaving or
         portFlowDirection_3<>Modelica.Fluid.Types.PortFlowDirection.Leaving,
         "In " + getInstanceName() + ": All ports are configured to
         Modelica.Fluid.Types.PortFlowDirection.Leaving, which is non-physical.");
  assert(portFlowDirection_1<>Modelica.Fluid.Types.PortFlowDirection.Entering or
         portFlowDirection_2<>Modelica.Fluid.Types.PortFlowDirection.Entering or
         portFlowDirection_3<>Modelica.Fluid.Types.PortFlowDirection.Entering,
         "In " + getInstanceName() + ": All ports are configured to
         Modelica.Fluid.Types.PortFlowDirection.Entering, which is non-physical.");

equation
  if verifyFlowReversal then
    if portFlowDirection_1==Modelica.Fluid.Types.PortFlowDirection.Entering then
      assert(port_1.m_flow> -m_flow_small,
      "In " + getInstanceName() + ":
      Flow is leaving port_1 but portFlowDirection_1=PortFlowDirection.Entering since m_flow=" +
      String(port_1.m_flow) + ">-"+String(m_flow_small));
    end if;
    if portFlowDirection_1==Modelica.Fluid.Types.PortFlowDirection.Leaving then
      assert(port_1.m_flow< m_flow_small,
      "In " + getInstanceName() + ":
      Flow is entering port_1 but portFlowDirection_1=PortFlowDirection.Leaving since m_flow=" +
      String(port_1.m_flow) + "<"+String(m_flow_small));
    end if;
    if portFlowDirection_2==Modelica.Fluid.Types.PortFlowDirection.Entering then
      assert(port_2.m_flow> -m_flow_small,
      "In " + getInstanceName() + ":
      Flow is leaving port_2 but portFlowDirection_2=PortFlowDirection.Entering since m_flow=" +
      String(port_2.m_flow) + ">-"+String(m_flow_small));
    end if;
    if portFlowDirection_2==Modelica.Fluid.Types.PortFlowDirection.Leaving then
      assert(port_2.m_flow< m_flow_small,
      "In " + getInstanceName() + ":
      Flow is entering port_2 but portFlowDirection_2=PortFlowDirection.Leaving since m_flow=" +
      String(port_2.m_flow) + "<"+String(m_flow_small));
    end if;
    if portFlowDirection_3==Modelica.Fluid.Types.PortFlowDirection.Entering then
      assert(port_3.m_flow> -m_flow_small,
      "In " + getInstanceName() + ":
      Flow is leaving port_3 but portFlowDirection_3=PortFlowDirection.Entering since m_flow=" +
      String(port_3.m_flow) + ">-"+String(m_flow_small));
    end if;
    if portFlowDirection_3==Modelica.Fluid.Types.PortFlowDirection.Leaving then
      assert(port_3.m_flow< m_flow_small,
      "In " + getInstanceName() + ": 
      Flow is entering port_3 but portFlowDirection_3=PortFlowDirection.Leaving since m_flow=" +
      String(port_3.m_flow) + "<"+String(m_flow_small));
    end if;
  end if;
  connect(flow_control.y, flowUnit.y)
    annotation (Line(points={{-19,-50},{-12,-50}}, color={0,0,127}));
  connect(senMasFlo.port_b, senTem.port_a)
    annotation (Line(points={{40,0},{60,0}}, color={0,127,255}));
  connect(senTem.port_b, port_2)
    annotation (Line(points={{80,0},{100,0}}, color={0,127,255}));
  connect(jun.port_3, flowUnit.port_b)
    annotation (Line(points={{0,-10},{0,-40}}, color={0,127,255}));
  connect(flowUnit.port_a, port_3)
    annotation (Line(points={{0,-60},{0,-100}}, color={0,127,255}));
  connect(flow_control.m_flow_measurement, senMasFlo.m_flow) annotation (Line(
        points={{-42,-45},{-60,-45},{-60,20},{30,20},{30,11}}, color={0,0,127}));
  connect(senTem.T, flow_control.T_measurement) annotation (Line(points={{70,11},
          {70,24},{-64,24},{-64,-55},{-42,-55}}, color={0,0,127}));
  connect(jun.port_1, senMasFlo.port_a)
    annotation (Line(points={{10,0},{20,0}}, color={0,127,255}));
  connect(jun.port_2, port_1)
    annotation (Line(points={{-10,0},{-100,0}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Polygon(
          points={{100,-46},{32,-40},{32,-100},{-30,-100},{-30,-36},{-100,-30},
              {-100,38},{100,52},{100,-46}},
          lineColor={0,0,0},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-18,-100},{-18,-34},{18,-34},{18,-100},{-18,-100}},
          lineColor={0,0,0},
          pattern=LinePattern.None,
          lineThickness=1,
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{100,36},{100,-36},{-8,-28},{-8,28},{100,36}},
          lineThickness=1,
          fillColor={244,125,35},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Polygon(
          points={{-100,-22},{-100,20},{-4,28},{-4,-30},{-100,-22}},
          pattern=LinePattern.None,
          lineThickness=1,
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Ellipse(
          visible=not energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState,
          extent={{-38,36},{40,-40}},
          lineColor={0,0,127},
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-18,-100},{-18,-100}},
          lineColor={0,0,0},
          pattern=LinePattern.None,
          lineThickness=1,
          fillColor={244,125,35},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-151,142},{149,102}},
          lineColor={0,0,255},
          textString="%name"),
        Ellipse(
          extent={{-20,20},{20,-20}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={247,247,247},
          fillPattern=FillPattern.Solid,
          origin={0,-64},
          rotation=360),
        Line(
          points={{18,-21},{0,7},{-18,-21}},
          color={0,0,0},
          thickness=0.5,
          origin={0,-51},
          rotation=360)}),                                       Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Mixer;
