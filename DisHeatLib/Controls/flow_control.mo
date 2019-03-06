within DisHeatLib.Controls;
model flow_control
  parameter Real k(min=0, unit="1") = 0.01 "Gain of controller";
  parameter Modelica.SIunits.Time Ti(min=Modelica.Constants.small)=120
    "Time constant of Integrator block";
  parameter Real min_y(max=1) = 0.0 "Minimum valve position (e.g., bypass)";
  parameter Boolean use_T_in = false
  "Use input for temperature setpoint"
  annotation(Evaluate=true, HideResult=true, choices(checkBox=true));
  parameter Boolean use_m_flow_in = false
  "Use minimum valve/pump position in case of small mass flow"
  annotation(Evaluate=true, HideResult=true, choices(checkBox=true));
  parameter Modelica.SIunits.Temperature T_const(displayUnit="degC") = 60.0+273.15 "Constant temperature setpoint"
    annotation(Dialog(enable = not use_T_in));
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal "Nominal mass flow rate at secondary side"
    annotation(Dialog(enable = use_m_flow_in));
  parameter Modelica.SIunits.MassFlowRate m_flow_min = 0.0001*abs(m_flow_nominal) "Mass flow rate at secondary side where minimum valve/pump position is set"
    annotation(Dialog(enable = use_m_flow_in));

  Modelica.Blocks.Interfaces.RealInput T_set(unit="K", displayUnit="degC") if
    use_T_in
    "Input signal connector"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealOutput y
    "Connector of Real output signal"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
protected
  Modelica.Blocks.Continuous.LimPID PID(
    yMax=1,
    yMin=min_y,
    k=k,
    Ti(displayUnit="s") = Ti,
    wd=0.1,
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    strict=false)
            annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Modelica.Blocks.Sources.RealExpression minValvePos(y=min_y) if use_m_flow_in
                                                          annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-50,76})));
public
  Modelica.Blocks.Interfaces.RealInput m_flow_measurement( quantity="MassFlowRate",
      displayUnit="kg/s") if use_m_flow_in "Input signal connector"
    annotation (Placement(transformation(extent={{-140,30},{-100,70}})));
  Modelica.Blocks.Interfaces.RealInput T_measurement(unit="K", displayUnit="degC")
    "Input signal connector"
    annotation (Placement(transformation(extent={{-140,-70},{-100,-30}})));
protected
  Modelica.Blocks.Sources.RealExpression TSetConst(y=T_const) if not use_T_in
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-88,-22})));
  Modelica.Blocks.Routing.RealPassThrough realPassThrough if not use_m_flow_in
    annotation (Placement(transformation(extent={{-10,-50},{10,-30}})));
  BaseClasses.RegStep regStep(x_small=0.00002*abs(m_flow_nominal)) if
    use_m_flow_in
    annotation (Placement(transformation(extent={{-10,50},{10,30}})));
  Modelica.Blocks.Math.Add add(k2=-1) if use_m_flow_in
    annotation (Placement(transformation(extent={{-62,30},{-42,50}})));
  Modelica.Blocks.Sources.RealExpression m_flow_min_set(y=m_flow_min) if
    use_m_flow_in    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-86,26})));
equation
  connect(T_measurement, PID.u_m) annotation (Line(points={{-120,-50},{-50,-50},
          {-50,-12}}, color={0,0,127}));
  connect(T_set, PID.u_s) annotation (Line(points={{-120,0},{-62,0}},
                color={0,0,127}));
  connect(TSetConst.y, PID.u_s) annotation (Line(points={{-77,-22},{-70,-22},{
          -70,0},{-62,0}},
                         color={0,0,127}));
  connect(PID.y, realPassThrough.u) annotation (Line(points={{-39,0},{-26,0},{
          -26,-40},{-12,-40}}, color={0,0,127}));
  connect(minValvePos.y, regStep.y2) annotation (Line(points={{-39,76},{-26,76},
          {-26,46},{-12,46}}, color={0,0,127}));
  connect(PID.y, regStep.y1) annotation (Line(points={{-39,0},{-26,0},{-26,34},
          {-12,34}}, color={0,0,127}));
  connect(m_flow_min_set.y, add.u2) annotation (Line(points={{-75,26},{-70,26},{
          -70,34},{-64,34}}, color={0,0,127}));
  connect(m_flow_measurement, add.u1) annotation (Line(points={{-120,50},{-70,
          50},{-70,46},{-64,46}}, color={0,0,127}));
  connect(add.y, regStep.x)
    annotation (Line(points={{-41,40},{-12,40}}, color={0,0,127}));
  connect(regStep.y, y) annotation (Line(points={{11,40},{40,40},{40,0},{110,0}},
        color={0,0,127}));
  connect(realPassThrough.y, y) annotation (Line(points={{11,-40},{40,-40},{40,
          0},{110,0}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                              Rectangle(extent={{-100,100},{100,-100}},  lineColor = {135, 135, 135}, fillColor = {255, 255, 170},
            fillPattern =                                                                                                   FillPattern.Solid), Text(extent = {{-58, 32}, {62, -20}}, lineColor = {175, 175, 175}, textString = "%name")}),
      Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>Control function that sets the position of a valve/pump in order to reach a desired temperature at the measurement point of the input. The main use case for this controller is actuating the valve/pump at the primary side of a district heating substation in a way to keep the temperature at the secondary side at a setpoint. A PI-control function is used to determine the desired valve/pump position. A minimum value can be set for the output to, e.g., mimic a bypass. The output <span style=\"font-family: Courier New;\">y </span>is in the range <span style=\"font-family: Courier New;\">[min_y, 1]</span>, thus, when a pump is used the value needs to be multiplied by the nominal mass flow value.</p>
<p>If <span style=\"font-family: Courier New;\">use_T_in</span> is true the temperature set-point is taken from the input T_set else from the constant <span style=\"font-family: Courier New;\">T_const.</span></p>
<p>If <span style=\"font-family: Courier New;\">use_m_flow_in </span>is true the mass flow measurement signal is used to set the valve/pump set-point to its minimum position in times of small mass flows <span style=\"font-family: Courier New;\">m_flow_min.</span></p>
</html>", revisions="<html>
<ul>
<li>Feburary 27, 2019, by Benedikt Leitner:<br>Implementation and added User&apos;s guide. </li>
</ul>
</html>"));
end flow_control;
