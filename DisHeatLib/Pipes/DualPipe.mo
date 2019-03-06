within DisHeatLib.Pipes;
model DualPipe
  replaceable package Medium =
      Modelica.Media.Water.ConstantPropertyLiquidWater
       annotation (choicesAllMatching=true);

  // Parameters
  replaceable parameter DisHeatLib.Pipes.BaseClasses.BasePipe pipeType "Pipe type"
  annotation (choicesAllMatching=true);
  parameter Modelica.SIunits.Length L "Length of the pipes";
  parameter Real cf = 1.0 "Correction factor of heat losses (needed for aggregation)";
  parameter Modelica.SIunits.Temperature T_sl_init = Medium.T_default "Initial temperature of supply line"
    annotation(Dialog(group = "Initialization"));
  parameter Modelica.SIunits.Temperature T_rl_init = Medium.T_default "Initial temperature of return line"
    annotation(Dialog(group = "Initialization"));

 // Assumptions
  parameter Boolean allowFlowReversal = true
    "= false to simplify equations, assuming, but not enforcing, no flow reversal"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);

  // Advanced
  parameter Boolean linearized = false
    "= true, use linear relation between m_flow and dp for any flow rate"
    annotation(Evaluate=true, Dialog(tab="Advanced"));
  parameter Boolean from_dp = false
    "= true, use m_flow = f(dp) else dp = f(m_flow)"
    annotation(Evaluate=true, Dialog(tab = "Advanced"));

  // Parameter for vectorized inputs
  parameter Integer nPorts_sl "Number of ports"
    annotation(Evaluate=true, Dialog(connectorSizing=true, tab="General",group="Ports"));
  parameter Integer nPorts_rl "Number of ports"
    annotation(Evaluate=true, Dialog(connectorSizing=true, tab="General",group="Ports"));

  Modelica.SIunits.Power Q_flow "Heat flow to soil (i.e., losses)";
  IBPSA.Fluid.FixedResistances.PlugFlowPipe pipe_sl(
    redeclare package Medium = Medium,
    roughness=pipeType.pipeMaterial.roughness,
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
    linearized=linearized,
    nPorts=nPorts_sl,
    allowFlowReversal=allowFlowReversal,
    from_dp=from_dp,
    kIns=cf*pipeType.kIns)
    annotation (Placement(transformation(extent={{-10,50},{10,70}})));
  IBPSA.Fluid.FixedResistances.PlugFlowPipe pipe_rl(
    redeclare package Medium = Medium,
    roughness=pipeType.pipeMaterial.roughness,
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
    linearized=linearized,
    nPorts=nPorts_rl,
    allowFlowReversal=allowFlowReversal,
    from_dp=from_dp,
    kIns=cf*pipeType.kIns)
    annotation (Placement(transformation(extent={{10,-70},{-10,-50}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_ht
    annotation (Placement(transformation(extent={{-10,90},{10,110}})));
public
  Modelica.Fluid.Interfaces.FluidPort_a port_sl_a(redeclare package Medium =
        Medium)
    "Supply fluid port (positive design direction is from port port_sl_a to port port_sl_b)"
    annotation (Placement(transformation(extent={{-110,50},{-90,70}})));
  Modelica.Fluid.Interfaces.FluidPorts_b port_sl_b[nPorts_sl](redeclare package
      Medium = Medium)
    "Supply fluid port Supply fluid port (positive design direction is from port port_sl_a to port port_sl_b)"
    annotation (Placement(transformation(extent={{90,20},{110,100}})));
public
  Modelica.Fluid.Interfaces.FluidPort_a port_rl_a(redeclare package Medium =
        Medium)
    "Return fluid port (positive design direction is from port port_sl_a to port port_sl_b)"
    annotation (Placement(transformation(extent={{90,-70},{110,-50}})));
  Modelica.Fluid.Interfaces.FluidPorts_b port_rl_b[nPorts_rl](redeclare package
      Medium = Medium)
    "Return fluid port Supply fluid port (positive design direction is from port port_sl_a to port port_sl_b)"
    annotation (Placement(transformation(extent={{-110,-100},{-90,-20}})));
equation
  Q_flow = port_ht.Q_flow;
  connect(pipe_rl.ports_b, port_rl_b)
    annotation (Line(points={{-10,-60},{-100,-60}}, color={0,127,255}));
  connect(pipe_sl.ports_b, port_sl_b) annotation (Line(points={{10,60},{54,60},
          {54,60},{100,60}}, color={0,127,255}));
  connect(port_sl_a, pipe_sl.port_a)
    annotation (Line(points={{-100,60},{-10,60}}, color={0,127,255}));
  connect(pipe_rl.port_a, port_rl_a)
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
