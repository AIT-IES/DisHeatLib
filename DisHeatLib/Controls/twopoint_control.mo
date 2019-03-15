within DisHeatLib.Controls;
model twopoint_control
  parameter Real y_max = 1.0 "Maximum set-point value for valve/pump";
  parameter Real y_min = 0.0 "Minimum set-point value for valve/pump";
  parameter Real u_min "Minimum input value for charging activation";
  parameter Real u_bandwidth "bandwidth for charging de-/activation";

  Modelica.Blocks.Interfaces.RealOutput y "Valve/pump set-point"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Interfaces.RealInput u "measurement"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
protected
  Modelica.Blocks.Sources.RealExpression Const(y=u_min)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-62,28})));
  Modelica.Blocks.Logical.OnOffController onOffController(pre_y_start=true,
      bandwidth=u_bandwidth)
    annotation (Placement(transformation(extent={{-26,-10},{-6,10}})));
  Modelica.Blocks.Logical.Switch switch1
    annotation (Placement(transformation(extent={{18,-10},{38,10}})));
  Modelica.Blocks.Sources.RealExpression zero(y=y_min)
                                                     annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-10,-30})));
  Modelica.Blocks.Sources.RealExpression one(y=y_max)
                                                    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-10,30})));
equation
  connect(onOffController.y, switch1.u2)
    annotation (Line(points={{-5,0},{16,0}}, color={255,0,255}));
  connect(switch1.y, y)
    annotation (Line(points={{39,0},{110,0}}, color={0,0,127}));
  connect(zero.y, switch1.u3)
    annotation (Line(points={{1,-30},{8,-30},{8,-8},{16,-8}}, color={0,0,127}));
  connect(one.y, switch1.u1)
    annotation (Line(points={{1,30},{8,30},{8,8},{16,8}}, color={0,0,127}));
  connect(u, onOffController.u) annotation (Line(points={{-120,0},{-50,0},{-50,
          -6},{-28,-6}}, color={0,0,127}));
  connect(Const.y, onOffController.reference) annotation (Line(points={{-51,28},
          {-40,28},{-40,6},{-28,6}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                              Rectangle(extent={{-100,100},{100,-100}},  lineColor = {135, 135, 135}, fillColor = {255, 255, 170},
            fillPattern =                                                                                                   FillPattern.Solid), Text(extent = {{-58, 32}, {62, -20}}, lineColor = {175, 175, 175}, textString = "%name")}),
      Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>Control function that sets the position of the bypass valve. The bypass valve can be opened constantly to allow a continous flow or it is controlled via a thermostat that opens the valve in case the temperature goes below the minimum setpoint (minus the bandwidth) and closes the valve once the temperature is above the minimum setpoint (plus the bandwidth).</p>
</html>", revisions="<html>
<ul>
<li>Feburary 27, 2019, by Benedikt Leitner:<br>Implementation and added User&apos;s guide. </li>
</ul>
</html>"));
end twopoint_control;
