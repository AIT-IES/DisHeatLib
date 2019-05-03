within DisHeatLib.Controls;
block bypass_control
  parameter Real max_y(min=0, max=1) = 1.0 "Maximum set-point value for valve/pump";
  parameter Boolean use_thermostat = true "Use a thermostat to control the bypass valve, otherwise always opened"
    annotation(HideResult=true, choices(checkBox=true));
  parameter Real min_y(min=0, max=1) = 0.0 "Minimum set-point value for valve/pump"
    annotation(Dialog(enable = use_thermostat));
  parameter Modelica.SIunits.Temperature T_min = 65.0 + 273.15 "Minimum temperature for bypass activation"
    annotation(Dialog(enable = use_thermostat));
  parameter Modelica.SIunits.TemperatureDifference T_bandwidth=2.0 "Temperature bandwidth for bypass activation"
    annotation(Dialog(enable = use_thermostat));

  Modelica.Blocks.Interfaces.RealOutput y "Valve/pump set-point"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Interfaces.RealInput T_measurement(unit="K", displayUnit="degC") if
    use_thermostat "Supply temperature measurement"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
protected
  Modelica.Blocks.Sources.RealExpression TSetConst(y=T_min) if use_thermostat
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-62,28})));
  Modelica.Blocks.Logical.OnOffController onOffController(pre_y_start=true,
      bandwidth=T_bandwidth) if use_thermostat
    annotation (Placement(transformation(extent={{-26,-10},{-6,10}})));
  Modelica.Blocks.Logical.Switch switch1 if use_thermostat
    annotation (Placement(transformation(extent={{18,-10},{38,10}})));
  Modelica.Blocks.Sources.RealExpression zero(y=min_y) if
                                                        use_thermostat
                                                     annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-10,-30})));
  Modelica.Blocks.Sources.RealExpression one(y=max_y) if
                                                       use_thermostat
                                                    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-10,30})));
  Modelica.Blocks.Sources.RealExpression constantly_open(y=max_y) if
                                                                   not
    use_thermostat annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={50,40})));
equation
  connect(onOffController.y, switch1.u2)
    annotation (Line(points={{-5,0},{16,0}}, color={255,0,255}));
  connect(TSetConst.y, onOffController.reference) annotation (Line(points={{-51,28},
          {-44,28},{-44,6},{-28,6}}, color={0,0,127}));
  connect(switch1.y, y)
    annotation (Line(points={{39,0},{110,0}}, color={0,0,127}));
  connect(zero.y, switch1.u3)
    annotation (Line(points={{1,-30},{8,-30},{8,-8},{16,-8}}, color={0,0,127}));
  connect(one.y, switch1.u1)
    annotation (Line(points={{1,30},{8,30},{8,8},{16,8}}, color={0,0,127}));
  connect(T_measurement, onOffController.u) annotation (Line(points={{-120,0},{-50,
          0},{-50,-6},{-28,-6}}, color={0,0,127}));
  connect(constantly_open.y, y) annotation (Line(points={{61,40},{74,40},{74,0},
          {110,0}}, color={0,0,127}));
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
end bypass_control;
