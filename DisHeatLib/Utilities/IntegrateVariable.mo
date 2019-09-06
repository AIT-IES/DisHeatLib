within DisHeatLib.Utilities;
model IntegrateVariable
  Modelica.Blocks.Continuous.Integrator integrator
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.RealOutput y "Connector of Real output signal"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Sources.RealExpression u(y=x)
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Modelica.Blocks.Interfaces.RealOutput x=0.0 "Value of Real output"
    annotation (Dialog(group="Time varying output signal"));
equation
  connect(integrator.y, y)
    annotation (Line(points={{11,0},{110,0}}, color={0,0,127}));
  connect(u.y, integrator.u)
    annotation (Line(points={{-39,0},{-12,0}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                                Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-96,-45},{96,-75}},
          lineColor={0,0,0},
          textString="%x"),
                 Bitmap(extent={{-30,-14},{30,82}}, fileName=
              "modelica://DisHeatLib/Resources/Images/integrate.png")}),
                                                     Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end IntegrateVariable;
