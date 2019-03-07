within DisHeatLib.Pipes;
model DualPipe
  extends DisHeatLib.BaseClasses.PartialFourPortVectorInterface(
    redeclare package Medium1 = Medium,
    redeclare package Medium2 = Medium,
    final m1_flow_nominal = pipeType.m_flow_nominal,
    final m2_flow_nominal = pipeType.m_flow_nominal,
    final m1_flow_small = m_flow_small,
    final m2_flow_small = m_flow_small,
    final allowFlowReversal1 = allowFlowReversal,
    final allowFlowReversal2 = allowFlowReversal);

  replaceable package Medium =
    Modelica.Media.Interfaces.PartialMedium "Medium in the component"
      annotation (choices(
        choice(redeclare package Medium = IBPSA.Media.Water "Water")));

  parameter Boolean allowFlowReversal = true
    "= false to simplify equations, assuming, but not enforcing, no flow reversal"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);
  parameter Medium.MassFlowRate m_flow_small(min=0) = 1E-4*abs(pipeType.m_flow_nominal)
    "Small mass flow rate for regularization of zero flow"
    annotation(Dialog(tab = "Advanced"));
  parameter Boolean from_dp = false
    "= true, use m_flow = f(dp) else dp = f(m_flow)"
    annotation (Evaluate=true, Dialog(tab="Flow resistance"));
  parameter Boolean linearizeFlowResistance = false
    "= true, use linear relation between m_flow and dp for any flow rate"
    annotation(Dialog(tab="Flow resistance"));

  // Parameters
  replaceable parameter DisHeatLib.Pipes.BaseClasses.BasePipe pipeType "Pipe type"
  annotation (choicesAllMatching=true);
  parameter Modelica.SIunits.Length L "Length of the pipes";
  parameter Real ReC=4000
    "Reynolds number where transition to turbulent starts"
    annotation (Evaluate=true, Dialog(group="Additional parameters"));
  parameter Real fac=1
    "Factor to take into account flow resistance of bends etc., fac=dp_nominal/dpStraightPipe_nominal"
    annotation (Evaluate=true, Dialog(group="Additional parameters"));
  parameter Real cf = 1.0 "Correction factor of heat losses (needed for aggregation)"
    annotation (Evaluate=true, Dialog(group="Additional parameters"));

  // Initialization
  parameter Modelica.SIunits.Temperature T_sl_init = Medium.T_default "Initial temperature of supply pipe"
    annotation(Dialog(tab = "Initialization"));
  parameter Modelica.SIunits.Temperature T_rl_init = Medium.T_default "Initial temperature of return pipe"
    annotation(Dialog(tab = "Initialization"));

  Modelica.SIunits.Power Q_flow "Heat flow to soil (i.e., losses)";
  IBPSA.Fluid.FixedResistances.PlugFlowPipe pipe_sl(
    redeclare package Medium = Medium,
    from_dp=from_dp,
    ReC=ReC,
    roughness=pipeType.pipeMaterial.roughness,
    m_flow_small=m_flow_small,
    dIns=pipeType.dIns,
    length=L,
    m_flow_nominal=pipeType.m_flow_nominal,
    T_start_in=T_sl_init,
    T_start_out=T_sl_init,
    cPip=pipeType.pipeMaterial.cPip,
    rhoPip=pipeType.pipeMaterial.rhoPip,
    v_nominal=pipeType.v_nominal,
    dh=pipeType.dh,
    thickness=pipeType.dWall,
    fac=fac,
    linearized=linearizeFlowResistance,
    nPorts=nPorts1,
    allowFlowReversal=allowFlowReversal,
    kIns=cf*pipeType.kIns)
    annotation (Placement(transformation(extent={{-10,50},{10,70}})));
  IBPSA.Fluid.FixedResistances.PlugFlowPipe pipe_rl(
    redeclare package Medium = Medium,
    from_dp=from_dp,
    ReC=ReC,
    roughness=pipeType.pipeMaterial.roughness,
    m_flow_small=m_flow_small,
    dIns=pipeType.dIns,
    length=L,
    m_flow_nominal=pipeType.m_flow_nominal,
    T_start_in=T_rl_init,
    T_start_out=T_rl_init,
    cPip=pipeType.pipeMaterial.cPip,
    rhoPip=pipeType.pipeMaterial.rhoPip,
    dh=pipeType.dh,
    v_nominal=pipeType.v_nominal,
    thickness=pipeType.dWall,
    fac=fac,
    linearized=linearizeFlowResistance,
    nPorts=nPorts2,
    allowFlowReversal=allowFlowReversal,
    kIns=cf*pipeType.kIns)
    annotation (Placement(transformation(extent={{10,-70},{-10,-50}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_ht
    annotation (Placement(transformation(extent={{-10,90},{10,110}})));
equation
  Q_flow = port_ht.Q_flow;
  connect(pipe_rl.ports_b, ports_b2)
    annotation (Line(points={{-10,-60},{-100,-60}}, color={0,127,255}));
  connect(pipe_sl.ports_b, ports_b1) annotation (Line(points={{10,60},{54,60},
          {54,60},{100,60}}, color={0,127,255}));
  connect(port_a1, pipe_sl.port_a)
    annotation (Line(points={{-100,60},{-10,60}}, color={0,127,255}));
  connect(pipe_rl.port_a, port_a2)
    annotation (Line(points={{10,-60},{100,-60}}, color={0,127,255}));
  connect(pipe_sl.heatPort, port_ht)
    annotation (Line(points={{0,70},{0,70},{0,100}}, color={191,0,0}));
  connect(pipe_rl.heatPort, port_ht) annotation (Line(points={{0,-50},{0,0},{-40,
          0},{-40,80},{0,80},{0,100}}, color={191,0,0}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          lineColor={200,200,200},
          fillColor={248,248,248},
          fillPattern=FillPattern.HorizontalCylinder,
          extent={{-100.0,-100.0},{100.0,100.0}},
          radius=25.0),          Text(
          extent={{-141,-99},{159,-139}},
          lineColor={0,0,255},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255},
          textString="%name"),
        Line(
          points={{-70,-62}},
          color={28,108,200},
          thickness=1),
        Rectangle(
          lineColor={128,128,128},
          extent={{-100.0,-100.0},{100.0,100.0}},
          radius=25.0),
        Rectangle(
          extent={{-80,80},{80,40}},
          lineColor={238,46,47},
          lineThickness=1,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{80,60},{100,60}},
          color={238,46,47},
          thickness=1),
        Line(
          points={{-100,60},{-80,60}},
          color={238,46,47},
          thickness=1),
        Line(
          points={{-100,-60},{-80,-60}},
          color={28,108,200},
          thickness=1),
        Rectangle(
          extent={{-80,-40},{80,-80}},
          lineColor={28,108,200},
          lineThickness=1,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{80,-60},{100,-60}},
          color={28,108,200},
          thickness=1)}),                                        Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(revisions="<html>
<ul>
<li>Feburary 27, 2019, by Benedikt Leitner:<br>Implementation and added User&apos;s guide. </li>
</ul>
</html>"));
end DualPipe;
