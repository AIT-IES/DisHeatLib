within DisHeatLib.Supply.BaseClasses;
model ElectricHeatingRod
  parameter Modelica.SIunits.HeatFlowRate Q_flow_nominal "Nominal heat flow rate";
  parameter Modelica.SIunits.Efficiency eff "Power-to-heat efficiency";
  parameter Integer nPorts(min=1) "Number of heat ports";
  parameter Real u_min "Minimum input value for charging activation";
  parameter Real u_bandwidth "bandwidth for charging de-/activation";

protected
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow prescribedHeatFlow[nPorts]
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={32,0})));
  Modelica.Blocks.Routing.Replicator replicator(nout=nPorts)
                                                annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-14,0})));
public
  Controls.twopoint_control control(
    y_max=Q_flow_nominal/nPorts,
    y_min=0,
    u_min=u_min,
    u_bandwidth=u_bandwidth) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-60,0})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b port[nPorts]
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  Modelica.Blocks.Interfaces.RealInput u "measurement"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));


protected
  Modelica.Blocks.Sources.RealExpression total_power(y=sum(prescribedHeatFlow[i].Q_flow
        for i in 1:nPorts)/eff)
    "sum of all power consumption/generation in component"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,-74})));
public
  Modelica.Blocks.Interfaces.RealOutput P(
    final quantity="Power",
    final unit="W",
    displayUnit="W") "Electric power" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,-110})));
equation
  connect(u, control.u) annotation (Line(points={{-120,0},{-94,0},{-94,1.33227e-15},
          {-72,1.33227e-15}}, color={0,0,127}));
  connect(control.y, replicator.u) annotation (Line(points={{-49,-1.33227e-15},{
          -36,-1.33227e-15},{-36,0},{-26,0}}, color={0,0,127}));
  connect(replicator.y, prescribedHeatFlow.Q_flow)
    annotation (Line(points={{-3,0},{22,0}}, color={0,0,127}));
  connect(total_power.y, P)
    annotation (Line(points={{0,-85},{0,-110}}, color={0,0,127}));
  connect(prescribedHeatFlow.port, port)
    annotation (Line(points={{42,0},{100,0}}, color={191,0,0}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          lineColor={200,200,200},
          fillColor={248,248,248},
          fillPattern=FillPattern.HorizontalCylinder,
          extent={{-100,-100},{100,100}},
          radius=25.0),
        Ellipse(
          extent={{-50,50},{48,-50}},
          lineColor={0,0,0},
          fillColor={247,247,247},
          fillPattern=FillPattern.Solid,
          lineThickness=0.5),
        Polygon(
          points={{-10,-40},{-2,-6},{-22,-6},{6,36},{-2,2},{18,2},{-10,-40}},
          lineColor={0,0,0},
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid,
          lineThickness=0.5),
        Rectangle(
          lineColor={128,128,128},
          extent={{-100,-100},{100,100}},
          radius=25.0)}),       Diagram(coordinateSystem(preserveAspectRatio=false)));
end ElectricHeatingRod;
