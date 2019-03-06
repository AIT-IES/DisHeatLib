within DisHeatLib.Controls;
model TemSup_control

  parameter Modelica.SIunits.Temperature TemOut_min(displayUnit="degC") = -5.0 + 273.15 "Outside temperature where maximum supply temperature is used";
  parameter Modelica.SIunits.Temperature TemOut_max(displayUnit="degC") = 15.0 + 273.15 "Outside temperature where minimum supply temperature is used";
  parameter Modelica.SIunits.Temperature TemSup_min(displayUnit="degC") = 60.0 + 273.15 "Minimum supply temperature";
  parameter Modelica.SIunits.Temperature TemSup_max(displayUnit="degC") = 80.0 + 273.15 "Maximum supply temperature";

protected
  Modelica.Blocks.Nonlinear.Limiter limiter(uMax=TemSup_max, uMin=TemSup_min)
    annotation (Placement(transformation(extent={{26,-10},{46,10}})));
  Modelica.Blocks.Math.Gain gain1(k=(TemSup_min - TemSup_max)/(TemOut_max - TemOut_min))
    annotation (Placement(transformation(extent={{-50,-4},{-30,16}})));
  Modelica.Blocks.Math.Add add
    annotation (Placement(transformation(extent={{-14,-10},{6,10}})));
  Modelica.Blocks.Sources.Constant const(k=TemSup_max - (TemSup_min - TemSup_max)/(
        TemOut_max - TemOut_min)*TemOut_min)
    annotation (Placement(transformation(extent={{-52,-34},{-32,-14}})));
public
  Modelica.Blocks.Interfaces.RealInput TemOut(unit="K", displayUnit="degC")
    "Input signal connector"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealOutput y(start=TemSup_max, unit="K", displayUnit="degC")
    "Connector of Real output signal"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
equation

  connect(gain1.y, add.u1) annotation (Line(
      points={{-29,6},{-16,6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(const.y, add.u2) annotation (Line(
      points={{-31,-24},{-26,-24},{-26,-6},{-16,-6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(add.y, limiter.u) annotation (Line(
      points={{7,0},{24,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(limiter.y, y) annotation (Line(
      points={{47,0},{110,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TemOut, gain1.u) annotation (Line(
      points={{-120,0},{-86,0},{-86,6},{-52,6}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})), Icon(graphics={
                              Rectangle(extent={{-100,100},{100,-100}},  lineColor = {135, 135, 135}, fillColor = {255, 255, 170},
            fillPattern =                                                                                                   FillPattern.Solid), Text(extent = {{-58, 32}, {62, -20}}, lineColor = {175, 175, 175}, textString = "%name")}),
    Documentation(revisions="<html>
<ul>
<li>Feburary 27, 2019, by Benedikt Leitner:<br>Implementation and added User&apos;s guide. </li>
</ul>
</html>", info="<html>
<h4>General</h4>
<p>Controller that generates temperature set-point according to outside temperature measurement. The output linearly interpolates between the minimum temperature <span style=\"font-family: Courier New;\">TemSup_min</span>, reached at maximum outside temperature <span style=\"font-family: Courier New;\">TemOut_max</span>, and the maximum temperature, reached at the minimum outside temperature <span style=\"font-family: Courier New;\">TemOut_min.</span> The controller can be used to set the supply temperature set-point at a substation or at a supply unit with respect to the current outside temperature (and thus, current heat demand).</p>
</html>"));
end TemSup_control;
