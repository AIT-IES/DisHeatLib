within DisHeatLib.Boundary;
model OutsideTemperature "Outside temperature model"
  // Choose input type
  parameter DisHeatLib.Boundary.BaseClasses.InputTypeTemp inputType=DisHeatLib.Boundary.BaseClasses.InputTypeTemp.Constant "Input type for temperature"
  annotation (choicesAllMatching=true);

  // From parameter
  parameter Modelica.SIunits.Temperature TemOut_const = 20.0+273.15 "Constant outside temperature"
    annotation(Dialog(group = "Constant", enable = inputType==DisHeatLib.Boundary.BaseClasses.InputTypeTemp.Constant), Evaluate=true);

  // From file
  parameter Boolean use_degC = false
    "Data in degC instead of K"
    annotation(Dialog(group="From file", enable = inputType==DisHeatLib.Boundary.BaseClasses.InputTypeTemp.File), Evaluate=true, HideResult=true, choices(checkBox=true));
  parameter String tableName="NoName" "Table name on file or in function usertab (see docu)"
    annotation(Dialog(enable = inputType==DisHeatLib.Boundary.BaseClasses.InputTypeTemp.File, group = "From file"), HideResult=true);
  parameter String fileName="NoName" "File where matrix is stored"
    annotation(Dialog(enable = inputType==DisHeatLib.Boundary.BaseClasses.InputTypeTemp.File, group = "From file", loadSelector(filter="Text files (*.txt);;MATLAB MAT-files (*.mat)",
          caption="Open file in which table is present")), HideResult=true);
  parameter Integer columns[:]={2} "Columns of table to be interpolated"
    annotation(Dialog(enable = inputType==DisHeatLib.Boundary.BaseClasses.InputTypeTemp.File, group = "From file"), HideResult=true);

public
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b port annotation (
      Placement(transformation(extent={{-10,90},{10,110}}, rotation=0),
        iconTransformation(extent={{-10,90},{10,110}})));

  Modelica.Blocks.Sources.CombiTimeTable outsideTemperatureProfile(
    tableOnFile=true,
    tableName=tableName,
    columns=columns,
    extrapolation=Modelica.Blocks.Types.Extrapolation.HoldLastPoint,
    fileName=Modelica.Utilities.Files.loadResource(fileName)) if
                        inputType==DisHeatLib.Boundary.BaseClasses.InputTypeTemp.File
    annotation (Placement(transformation(extent={{-88,-52},{-68,-32}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature
    outsideTemperature if not (use_degC and inputType == DisHeatLib.Boundary.BaseClasses.InputTypeTemp.File)
    annotation (Placement(transformation(extent={{-30,-10},{-10,10}})));
  Modelica.Blocks.Sources.RealExpression TConst(y=TemOut_const) if inputType ==
    DisHeatLib.Boundary.BaseClasses.InputTypeTemp.Constant
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-80,36})));
  // From input
  Modelica.Blocks.Interfaces.RealInput TemOut_in(unit="K", displayUnit="degC") if  inputType==DisHeatLib.Boundary.BaseClasses.InputTypeTemp.Input
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,0})));
  Modelica.Thermal.HeatTransfer.Celsius.PrescribedTemperature
    outsideTemperature1 if use_degC and inputType == DisHeatLib.Boundary.BaseClasses.InputTypeTemp.File
    annotation (Placement(transformation(extent={{-30,-52},{-10,-32}})));
equation

  connect(outsideTemperature.port, port) annotation (
      Line(points={{-10,0},{0,0},{0,100}},    color={191,
          0,0}));
  connect(outsideTemperatureProfile.y[1], outsideTemperature.T)
    annotation (Line(points={{-67,-42},{-46,-42},{-46,0},{-32,0}},
                                               color={0,0,127}));
  connect(TConst.y, outsideTemperature.T) annotation (Line(points={{-69,36},{-46,
          36},{-46,0},{-32,0}}, color={0,0,127}));
  connect(outsideTemperature.T, TemOut_in)
    annotation (Line(points={{-32,0},{-120,0}}, color={0,0,127}));
  connect(outsideTemperature1.port, port)
    annotation (Line(points={{-10,-42},{0,-42},{0,100}}, color={191,0,0}));
  connect(outsideTemperatureProfile.y[1], outsideTemperature1.T)
    annotation (Line(points={{-67,-42},{-32,-42}}, color={0,0,127}));
  annotation (Icon(graphics={    Text(
          extent={{-141,-99},{159,-139}},
          lineColor={0,0,255},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255},
          textString="%name"),
        Rectangle(
          lineColor={200,200,200},
          fillColor={248,248,248},
          fillPattern=FillPattern.HorizontalCylinder,
          extent={{-100.0,-100.0},{100.0,100.0}},
          radius=25.0),
        Rectangle(
          lineColor={128,128,128},
          extent={{-100.0,-100.0},{100.0,100.0}},
          radius=25.0),
        Ellipse(
        extent={{-76,80},{6,-2}},
        lineColor={255,255,255},
        lineThickness=1,
        fillPattern=FillPattern.Sphere,
        fillColor={255,255,255}),
      Line(
        points={{32,-24},{76,-82}},
        color={95, 95, 95}),
      Line(
        points={{4,-24},{48,-82}},
        color={95, 95, 95}),
      Line(
        points={{-26,-24},{18,-82}},
        color={95, 95, 95}),
      Line(
        points={{-56,-24},{-12,-82}},
        color={95, 95, 95}),
      Polygon(
        points={{64,6},{50,-2},{40,-18},{70,-24},{78,-52},{26,-52},{-6,-54},{
            -72,-52},{-72,-22},{-52,-10},{-42,10},{-78,34},{-44,52},{40,56},{76,
            40},{64,6}},
        lineColor={150,150,150},
        lineThickness=0.1,
        fillPattern=FillPattern.Sphere,
        smooth=Smooth.Bezier,
        fillColor={150,150,150})}), Documentation(revisions="<html>
<ul>
<li>Feburary 27, 2019, by Benedikt Leitner:<br>Implementation and added User&apos;s guide. </li>
</ul>
</html>"));
end OutsideTemperature;
