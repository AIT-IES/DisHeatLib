within DisHeatLib.Controls;
model dp_control
  parameter Modelica.SIunits.Pressure dp_setpoint(displayUnit="bar") "Set-point for differential pressure";
  parameter Real k=50 "Gain of controller";
  parameter Modelica.SIunits.Time Ti(min=Modelica.Constants.small)=120
    "Time constant of Integrator block";
  parameter Modelica.SIunits.Pressure dp_min(displayUnit="bar")=50000 "Minimum differential pressure";
  parameter Modelica.SIunits.Pressure dp_max(displayUnit="bar")=500000 "Maximum differential pressure";
  Modelica.Blocks.Continuous.LimPID PID(
    yMax=dp_max,
    yMin=dp_min,
    k=k,
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    Ti=Ti)    annotation (Placement(transformation(extent={{-16,-10},{4,10}})));
protected
  Modelica.Blocks.Sources.RealExpression dp_setpoint_in(y=dp_setpoint)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-40,0})));
public
  Modelica.Blocks.Interfaces.RealInput dp(each min=0, each final unit="Pa",
    displayUnit="bar")
    "Connector of Real input signal" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,0})));
  Modelica.Blocks.Interfaces.RealOutput y(unit="Pa", displayUnit="bar")
    "Connector of Real output signal"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
equation
  connect(dp_setpoint_in.y, PID.u_s)
    annotation (Line(points={{-29,0},{-18,0}}, color={0,0,127}));
  connect(PID.y, y) annotation (Line(points={{5,0},{110,0}}, color={0,0,127}));
  connect(PID.u_m, dp) annotation (Line(points={{-6,-12},{-6,-24},{-78,-24},{
          -78,0},{-120,0}}, color={0,0,127}));
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
end dp_control;
