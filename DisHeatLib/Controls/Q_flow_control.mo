within DisHeatLib.Controls;
block Q_flow_control
  parameter Modelica.SIunits.HeatFlowRate Q_flow_nominal "Nominal heat flow rate";
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal "Nominal mass flow rate";
  parameter Boolean limit_m_flow "Use input to limit m_flow"
    annotation(HideResult=true, choices(checkBox=true));
  parameter Boolean normalize_y = false "Use m_flow_nominal to normalize output to [0,1]"
    annotation(HideResult=true, choices(checkBox=true));
  parameter Real k=if Q_flow_nominal < Modelica.Constants.small then 1 else 0.5*m_flow_nominal/Q_flow_nominal "Gain of controller";
  parameter Modelica.SIunits.Time Ti(min=Modelica.Constants.small)=120
    "Time constant of Integrator block";

  Modelica.Blocks.Interfaces.RealOutput y(unit="kg/s", displayUnit="kg/s")
    "Connector of Real output signal"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
public
  Modelica.Blocks.Continuous.LimPID PID(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    yMin=0,
    yMax=if Q_flow_nominal < Modelica.Constants.small then 0 else m_flow_nominal,
    k=k,
    Ti=Ti)
    "uses correlation Q_flow = c_p delta_T m_flow and allowing for a 50 percent smaller delta_T than nominal when limiting m_flow"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
protected
  Modelica.Blocks.Math.Min input_min
    "Limit the input signal to maximum heat capacity; avoids problems when heat capacity is set directly at heater"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-50,0})));
protected
  Modelica.Blocks.Math.Min min1 if limit_m_flow
    "Limit the input signal to m_flow_limit; avoids injection of higher mass flows than needed in network"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={50,30})));
  Modelica.Blocks.Routing.RealPassThrough realPassThrough2 if not limit_m_flow
                     annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={50,-30})));
public
  Modelica.Blocks.Interfaces.RealInput Q_flow_set(each final unit="W",
      displayUnit="W") "Connector of Real input signal" annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,0})));
public
  Modelica.Blocks.Interfaces.RealInput Q_flow_measure(each final unit="W",
      displayUnit="W") "Connector of Real input signal" annotation (Placement(
        transformation(
        extent={{20,-20},{-20,20}},
        rotation=-90,
        origin={0,-120})));
public
  Modelica.Blocks.Interfaces.RealInput m_flow_max(each final unit="kg/s",
      displayUnit="kg/s") if limit_m_flow
                          "Connector of Real input signal" annotation (
      Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={0,120})));
  Modelica.Blocks.Math.Gain normalize(k=if normalize_y then 1/m_flow_nominal
         else 1)
    annotation (Placement(transformation(extent={{72,-10},{92,10}})));
protected
  Modelica.Blocks.Sources.Constant const1(k=Q_flow_nominal)
             annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-88,40})));
equation
  connect(const1.y, input_min.u1) annotation (Line(points={{-77,40},{-70,40},{-70,
          6},{-62,6}},   color={0,0,127}));
  connect(input_min.y, PID.u_s) annotation (Line(points={{-39,0},{-12,0}},
                       color={0,0,127}));
  connect(Q_flow_measure, PID.u_m)
    annotation (Line(points={{0,-120},{0,-12}},
                                              color={0,0,127}));
  connect(PID.y, realPassThrough2.u) annotation (Line(points={{11,0},{28,0},{28,
          -30},{38,-30}}, color={0,0,127}));
  connect(PID.y, min1.u2)
    annotation (Line(points={{11,0},{28,0},{28,24},{38,24}}, color={0,0,127}));
  connect(Q_flow_set, input_min.u2) annotation (Line(points={{-120,0},{-80,0},{-80,
          -6},{-62,-6}}, color={0,0,127}));
  connect(m_flow_max, min1.u1)
    annotation (Line(points={{0,120},{0,36},{38,36}}, color={0,0,127}));
  connect(y, normalize.y)
    annotation (Line(points={{110,0},{93,0}}, color={0,0,127}));
  connect(min1.y, normalize.u)
    annotation (Line(points={{61,30},{66,30},{66,0},{70,0}}, color={0,0,127}));
  connect(realPassThrough2.y, normalize.u) annotation (Line(points={{61,-30},{66,
          -30},{66,0},{70,0}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                              Rectangle(extent={{-100,100},{100,-100}},  lineColor = {135, 135, 135}, fillColor = {255, 255, 170},
            fillPattern =                                                                                                   FillPattern.Solid), Text(extent = {{-58, 32}, {62, -20}}, lineColor = {175, 175, 175}, textString = "%name")}),
      Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(revisions="<html>
<ul>
<li>Feburary 27, 2019, by Benedikt Leitner:<br>Implementation and added User&apos;s guide. </li>
</ul>
</html>", info="<html>
<h4>General</h4>
<p>This controller is used to set the differential pressure according to a measurement signal using a PI-control function. It can be used by a supply unit to determine the pressure rise needed to keep the measurement signal <span style=\"font-family: Courier New;\">dp</span> at its reference value <span style=\"font-family: Courier New;\">dp_setpoint</span>.</p>
</html>"));
end Q_flow_control;
