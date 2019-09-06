within DisHeatLib.Storage.BaseClasses;
model ThermostatMixer
  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium
    "Medium in the component";
  parameter DisHeatLib.BaseClasses.FlowType FlowType=DisHeatLib.BaseClasses.FlowType.Valve
    "Flow type";
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal
    "Nominal mass flow rate";
  parameter Modelica.SIunits.PressureDifference dp_nominal
    "Nominal pressure difference";
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

  replaceable
  Controls.flow_control flow_control(
    final reverseAction=if FlowType == DisHeatLib.BaseClasses.FlowType.Pump
         then true else false,
    k=0.05,
    Ti=30,
    final min_y=0,
    final use_T_in=false,
    final use_m_flow_in=true,
    final T_const=Tem_set,
    final m_flow_nominal=m_flow_nominal,
    final m_flow_min=0.0001*abs(m_flow_nominal))
    annotation (Dialog(group="Controller"), Placement(transformation(extent={{-10,-10},
            {10,10}},
        rotation=-90,
        origin={0,68})));
protected
  IBPSA.Fluid.Sensors.MassFlowRate senMasFlo(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
public
  IBPSA.Fluid.Sensors.TemperatureTwoPort senTem(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    initType=Modelica.Blocks.Types.Init.InitialOutput,
    T_start=Tem_set)
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  replaceable
  IBPSA.Fluid.Actuators.Valves.ThreeWayEqualPercentageLinear val(
    redeclare package Medium = Medium,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final massDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    use_inputFilter=true,
    riseTime=10,
    final m_flow_nominal=m_flow_nominal,
    final dpValve_nominal=dp_nominal) if FlowType == DisHeatLib.BaseClasses.FlowType.Valve
    constrainedby IBPSA.Fluid.Actuators.BaseClasses.PartialThreeWayValve
    annotation (Dialog(enable=FlowType == DisHeatLib.BaseClasses.FlowType.Valve), Placement(transformation(extent={{-10,10},{10,30}})),
      __Dymola_choicesAllMatching=true);
protected
  IBPSA.Fluid.FixedResistances.Junction jun(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial,
    m_flow_nominal={m_flow_nominal,m_flow_nominal,m_flow_nominal},
    dp_nominal={0,0,0}) if FlowType == DisHeatLib.BaseClasses.FlowType.Pump
    annotation (Placement(transformation(extent={{-40,-30},{-60,-10}})));
public
  replaceable IBPSA.Fluid.Movers.FlowControlled_m_flow pump if
                                                   FlowType == DisHeatLib.BaseClasses.FlowType.Pump
    constrainedby IBPSA.Fluid.Movers.FlowControlled_m_flow(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=m_flow_nominal,
    m_flow_small=m_flow_small,
    tau=10,
    riseTime=10,
    final inputType=IBPSA.Fluid.Types.InputType.Continuous,
    final addPowerToMedium=false,
    final nominalValuesDefineDefaultPressureCurve=true,
    final dp_nominal=dp_nominal) annotation (Dialog(enable=FlowType ==
          DisHeatLib.BaseClasses.FlowType.Pump), Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-50,-52})));
  Modelica.Blocks.Math.Gain gain(k=m_flow_nominal) if  FlowType == DisHeatLib.BaseClasses.FlowType.Pump
                                                   annotation (Placement(
        transformation(
        extent={{-4,-4},{4,4}},
        rotation=0,
        origin={-74,-52})));
protected
  IBPSA.Fluid.FixedResistances.LosslessPipe pip1(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal) if FlowType == DisHeatLib.BaseClasses.FlowType.Valve
                                  annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-50,20})));
  IBPSA.Fluid.FixedResistances.LosslessPipe pip2(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal) if FlowType == DisHeatLib.BaseClasses.FlowType.Valve
                                  annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={0,-50})));
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
  connect(senMasFlo.port_b, senTem.port_a)
    annotation (Line(points={{40,0},{60,0}}, color={0,127,255}));
  connect(senTem.port_b, port_2)
    annotation (Line(points={{80,0},{100,0}}, color={0,127,255}));
  connect(val.port_2, senMasFlo.port_a)
    annotation (Line(points={{10,20},{20,20},{20,0}},
                                             color={0,127,255}));
  connect(senMasFlo.m_flow, flow_control.m_flow_measurement)
    annotation (Line(points={{30,11},{30,86},{5,86},{5,80}}, color={0,0,127}));
  connect(flow_control.T_measurement, senTem.T) annotation (Line(points={{-5,80},
          {-5,90},{70,90},{70,11}}, color={0,0,127}));
  connect(flow_control.y, val.y)
    annotation (Line(points={{0,57},{0,32}}, color={0,0,127}));
  connect(port_1, port_1)
    annotation (Line(points={{-100,0},{-100,0}}, color={0,127,255}));
  connect(jun.port_2, port_1) annotation (Line(points={{-60,-20},{-80,-20},{-80,
          0},{-100,0}}, color={0,127,255}));
  connect(pip1.port_a, port_1) annotation (Line(points={{-60,20},{-80,20},{-80,0},
          {-100,0}}, color={0,127,255}));
  connect(pip1.port_b, val.port_1) annotation (Line(points={{-40,20},{-10,20}},
                       color={0,127,255}));
  connect(port_3, pip2.port_a)
    annotation (Line(points={{0,-100},{0,-60}}, color={0,127,255}));
  connect(pip2.port_b, val.port_3)
    annotation (Line(points={{0,-40},{0,10}},  color={0,127,255}));
  connect(jun.port_1, senMasFlo.port_a)
    annotation (Line(points={{-40,-20},{20,-20},{20,0}}, color={0,127,255}));
  connect(gain.y, pump.m_flow_in)
    annotation (Line(points={{-69.6,-52},{-62,-52}}, color={0,0,127}));
  connect(gain.u, flow_control.y) annotation (Line(points={{-78.8,-52},{-84,-52},
          {-84,40},{0,40},{0,57}}, color={0,0,127}));
  connect(pump.port_b, jun.port_3)
    annotation (Line(points={{-50,-42},{-50,-30}}, color={0,127,255}));
  connect(pump.port_a, port_3) annotation (Line(points={{-50,-62},{-50,-80},{0,-80},
          {0,-100}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,44},{100,-36}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={192,192,192}),
        Rectangle(
          extent={{-22,-20},{24,-100}},
          lineColor={0,0,0},
          fillPattern=FillPattern.VerticalCylinder,
          fillColor={192,192,192}),
        Rectangle(
          extent={{-14,-12},{14,-100}},
          lineColor={0,0,0},
          fillPattern=FillPattern.VerticalCylinder,
          fillColor={0,127,255}),
        Rectangle(
          extent={{0,26},{100,-20}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={244,125,35}),
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
        Rectangle(
          extent={{-100,26},{0,-20}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={238,46,47}),
        Polygon(
          points={{-68,56},{0,2},{56,44},{76,60},{-68,56}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          visible=FlowType == DisHeatLib.BaseClasses.FlowType.Valve),
        Polygon(
          points={{-56,-40},{0,2},{56,44},{60,-40},{-56,-40}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          visible=FlowType == DisHeatLib.BaseClasses.FlowType.Valve),
        Polygon(
          points={{0,2},{82,64},{82,-54},{0,2}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          visible=FlowType == DisHeatLib.BaseClasses.FlowType.Valve),
        Polygon(
          points={{0,2},{62,-80},{-58,-80},{0,2}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          visible=FlowType == DisHeatLib.BaseClasses.FlowType.Valve),
        Polygon(
          points={{0,2},{-78,64},{-78,-56},{0,2}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          visible=FlowType == DisHeatLib.BaseClasses.FlowType.Valve),
        Line(
          points={{0,100},{0,-2}},
          visible=FlowType == DisHeatLib.BaseClasses.FlowType.Valve),
        Rectangle(
          extent={{-28,46},{28,96}},
          lineColor={0,0,0},
          fillColor={255,255,170},
          fillPattern=FillPattern.Solid,
          visible=FlowType == DisHeatLib.BaseClasses.FlowType.Valve),
        Text(
          extent={{-20,92},{20,48}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid,
          textStyle={TextStyle.Bold},
          textString="PI",
          visible=FlowType == DisHeatLib.BaseClasses.FlowType.Valve),
        Ellipse(
          extent={{-38,36},{40,-40}},
          lineColor={0,0,127},
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid,
          visible=FlowType == DisHeatLib.BaseClasses.FlowType.Pump),
        Line(points={{20,-64},{44,-64}}, color={0,0,0},
          visible=FlowType == DisHeatLib.BaseClasses.FlowType.Pump),
        Ellipse(
          extent={{-20,20},{20,-20}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={247,247,247},
          fillPattern=FillPattern.Solid,
          origin={0,-64},
          rotation=360,
          visible=FlowType == DisHeatLib.BaseClasses.FlowType.Pump),
        Line(
          points={{18,-21},{0,7},{-18,-21}},
          color={0,0,0},
          thickness=0.5,
          origin={0,-51},
          rotation=360,
          visible=FlowType == DisHeatLib.BaseClasses.FlowType.Pump),
        Rectangle(
          extent={{-28,-25},{28,25}},
          lineColor={0,0,0},
          fillColor={255,255,170},
          fillPattern=FillPattern.Solid,
          visible=FlowType == DisHeatLib.BaseClasses.FlowType.Pump,
          origin={68,-67},
          rotation=-90),
        Text(
          extent={{-20,22},{20,-22}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid,
          textStyle={TextStyle.Bold},
          textString="PI",
          visible=FlowType == DisHeatLib.BaseClasses.FlowType.Pump,
          origin={68,-68},
          rotation=-90)}),                                                                                   Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end ThermostatMixer;
