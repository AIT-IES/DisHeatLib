within DisHeatLib.Controls;
block storage_control
  parameter Modelica.SIunits.Temperature T_top_set(displayUnit="degC") = 60.0+273.15 "Constant temperature setpoint for top layer";
  parameter Modelica.SIunits.Temperature T_bot_set(displayUnit="degC") = 60.0+273.15 "Constant temperature setpoint for bottom layer";
  parameter Modelica.SIunits.TemperatureDifference T_top_bandwidth(displayUnit="degC") = 5 "Bandwidth for controller activation";

  Modelica.Blocks.Interfaces.RealInput T_bot(unit="K", displayUnit="degC")
             "Input signal connector"
    annotation (Placement(transformation(extent={{-140,-70},{-100,-30}})));
  Modelica.Blocks.Interfaces.RealOutput y
    "Connector of Real output signal"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Interfaces.RealInput T_top(unit="K", displayUnit="degC")
    "Input signal connector"
    annotation (Placement(transformation(extent={{-140,30},{-100,70}})));
  Modelica.Blocks.Logical.Pre pre1
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
  Modelica.Blocks.Logical.Or or1
    annotation (Placement(transformation(extent={{-20,40},{0,60}})));
  Modelica.Blocks.Routing.BooleanReplicator booleanReplicator(nout=2)
    annotation (Placement(transformation(extent={{20,40},{40,60}})));
  Modelica.Blocks.Math.BooleanToReal booleanToReal
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Modelica.Blocks.MathBoolean.And and1(nu=2)
    annotation (Placement(transformation(extent={{-20,-36},{-8,-24}})));
protected
  Modelica.Blocks.Logical.OnOffController onOffController(pre_y_start=true,
      bandwidth=T_top_bandwidth)
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  Modelica.Blocks.Sources.RealExpression T1(y=T_top_set) annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-78,56})));
  Modelica.Blocks.Logical.LessEqualThreshold
                                          lessEqualThreshold(threshold=
        T_bot_set)
    annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));
equation
  connect(onOffController.reference, T1.y)
    annotation (Line(points={{-62,56},{-67,56}}, color={0,0,127}));
  connect(T_bot, lessEqualThreshold.u) annotation (Line(points={{-120,-50},{-80,
          -50},{-80,-50},{-62,-50}}, color={0,0,127}));
  connect(T_top, onOffController.u) annotation (Line(points={{-120,50},{-80,50},
          {-80,44},{-62,44}}, color={0,0,127}));
  connect(onOffController.y, or1.u1)
    annotation (Line(points={{-39,50},{-22,50}}, color={255,0,255}));
  connect(booleanToReal.y, y)
    annotation (Line(points={{81,0},{110,0}}, color={0,0,127}));
  connect(or1.y, booleanReplicator.u)
    annotation (Line(points={{1,50},{18,50}}, color={255,0,255}));
  connect(booleanReplicator.y[1], booleanToReal.u)
    annotation (Line(points={{41,49.5},{58,49.5},{58,0}}, color={255,0,255}));
  connect(booleanReplicator.y[2], pre1.u) annotation (Line(points={{41,50.5},{44,
          50.5},{44,20},{-72,20},{-72,-10},{-62,-10}}, color={255,0,255}));
  connect(lessEqualThreshold.y, and1.u[1]) annotation (Line(points={{-39,-50},{-20,
          -50},{-20,-27.9}}, color={255,0,255}));
  connect(pre1.y, and1.u[2]) annotation (Line(points={{-39,-10},{-20,-10},{-20,-32.1}},
        color={255,0,255}));
  connect(and1.y, or1.u2) annotation (Line(points={{-7.1,-30},{0,-30},{0,8},{-28,
          8},{-28,42},{-22,42}}, color={255,0,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                              Rectangle(extent={{-100,100},{100,-100}},  lineColor = {135, 135, 135}, fillColor = {255, 255, 170},
            fillPattern =                                                                                                   FillPattern.Solid), Text(extent = {{-58, 32}, {62, -20}}, lineColor = {175, 175, 175}, textString = "%name")}),
      Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>Control function for storage tank charging de-/activation. Charging starts when the temperature in the top segment <span style=\"font-family: Courier New;\">T_top</span> falls below the setpoint minus half the bandwith <span style=\"font-family: Courier New;\">T_top_set - T_top_bandwidth/2</span>. Charging is continued until the temperature at the bottom of the tank reaches its setpoint <span style=\"font-family: Courier New;\">T_bot_set</span> or until the temperature of the top segement rises above the setpoint plus half the bandwidth <span style=\"font-family: Courier New;\">T_top_set + T_top_bandwidth/2</span> (might occur later).</p>
</html>", revisions="<html>
<ul>
<li>Feburary 27, 2019, by Benedikt Leitner:<br>Implementation and added User&apos;s guide. </li>
</ul>
</html>"));
end storage_control;
