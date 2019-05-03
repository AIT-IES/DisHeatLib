within DisHeatLib.Controls.BaseClasses;
block RegStep
  "Approximation of a general step, such that the approximation is continuous and differentiable"
  parameter Real x_small(min=0) = 1e-5
    "Approximation of step for -x_small <= x <= x_small; x_small >= 0 required";

  Modelica.Blocks.Interfaces.RealInput y1 "Ordinate value for x > 0"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
  Modelica.Blocks.Interfaces.RealInput y2 "Ordinate value for x < 0"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}})));
  Modelica.Blocks.Interfaces.RealInput x "Abscissa value"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealOutput y
    "Connector of Real output signal"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
equation
  y = IBPSA.Utilities.Math.Functions.regStep(y1=y1, y2=y2, x=x, x_small=x_small);

  annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},
            {100,100}}), graphics={
                                Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),                                                                                                         Text(extent = {{-58, 32}, {62, -20}}, lineColor = {175, 175, 175}, textString = "%name")}),
                             Documentation(info="<html>
<p>This model is used to approximate the equation </p>
<p>    y = if x &gt; 0 then y1 else y2; </p>
<p>by a smooth characteristic, so that the expression is continuous and differentiable: </p>
<p>   y = smooth(1, if x &gt;  x_small then y1 else</p>
<p>                 if x &lt; -x_small then y2 else f(y1, y2)); </p>
<p>In the region -x_small &lt; x &lt; x_small a 2nd order polynomial is used for a smooth transition from y1 to y2. </p>
</html>",
        revisions="<html>
<ul>
<li>Feburary 27, 2019, by Benedikt Leitner:<br>Implementation and added User&apos;s guide. </li>
</ul>
</html>"));
end RegStep;
