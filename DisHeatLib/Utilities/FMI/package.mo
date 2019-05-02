within DisHeatLib.Utilities;
package FMI
  extends Modelica.Icons.Package;

  model FMIhelper
    extends Modelica.Blocks.Interfaces.SISO;

    parameter Modelica.SIunits.Time deltaT(start=900.0) "Time step"
      annotation(Dialog(enable = mode <> DisHeatLib.Utilities.FMI.FMIInterfaceType.Instantaneous));
    parameter DisHeatLib.Utilities.FMI.FMIInterfaceType mode = DisHeatLib.Utilities.FMI.FMIInterfaceType.Instantaneous;


protected
    Modelica.Blocks.Math.Mean mean(f=1/deltaT, x0=0) if mode ==
      DisHeatLib.Utilities.FMI.FMIInterfaceType.Integral or mode == DisHeatLib.Utilities.FMI.FMIInterfaceType.Mean
      annotation (Placement(transformation(extent={{-30,30},{-10,50}})));
    Modelica.Blocks.Math.Gain gain(k=deltaT) if mode == DisHeatLib.Utilities.FMI.FMIInterfaceType.Integral
      annotation (Placement(transformation(extent={{10,50},{30,70}})));
    Modelica.Blocks.Routing.RealPassThrough realPassThrough if mode ==
      DisHeatLib.Utilities.FMI.FMIInterfaceType.Mean
      annotation (Placement(transformation(extent={{10,10},{30,30}})));
    Modelica.Blocks.Routing.RealPassThrough realPassThrough1 if mode ==
      DisHeatLib.Utilities.FMI.FMIInterfaceType.Instantaneous
      annotation (Placement(transformation(extent={{-10,-50},{10,-30}})));
  equation
    connect(mean.y, gain.u)
      annotation (Line(points={{-9,40},{0,40},{0,60},{8,60}},
                                               color={0,0,127}));
    connect(u, mean.u) annotation (Line(points={{-120,0},{-40,0},{-40,40},{-32,
            40}},
          color={0,0,127}));
    connect(mean.y, realPassThrough.u) annotation (Line(points={{-9,40},{0,40},
            {0,20},{8,20}},    color={0,0,127}));
    connect(u, realPassThrough1.u) annotation (Line(points={{-120,0},{-40,0},{-40,
            -40},{-12,-40}}, color={0,0,127}));
    connect(gain.y, y) annotation (Line(points={{31,60},{40,60},{40,0},{110,0}},
          color={0,0,127}));
    connect(realPassThrough.y, y) annotation (Line(points={{31,20},{40,20},{40,
            0},{110,0}}, color={0,0,127}));
    connect(realPassThrough1.y, y) annotation (Line(points={{11,-40},{40,-40},{
            40,0},{110,0}}, color={0,0,127}));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>When interfacing different FMUs with the dynamic models in Modelica output variables can be used as</p>
<ul>
<li><span style=\"font-family: Courier New;\">Instantaneous:</span> The instantaneous/current value is directly used</li>
<li> <span style=\"font-family: Courier New;\">Mean:</span> The mean value over the last time step  is used</li>
<li><span style=\"font-family: Courier New;\">Integral:</span> The integrated value over the last time step is used</li>
</ul>
</html>"));
  end FMIhelper;

  type FMIInterfaceType = enumeration(
    Instantaneous   "Instantaneous",
    Mean   "Mean",
    Integral   "Integral");

annotation (Icon(graphics={
                 Bitmap(extent={{-90,-86},{84,88}}, fileName=
            "modelica://DisHeatLib/Resources/Images/FMI_icon.png")}));
end FMI;
