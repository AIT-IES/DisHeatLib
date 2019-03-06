within DisHeatLib.Boundary.Examples;
model OutsideTemperature
  extends Modelica.Icons.Example;
  DisHeatLib.Boundary.OutsideTemperature outsideTemperature_const(inputType=
        DisHeatLib.Boundary.BaseClasses.InputTypeTemp.Constant, TemOut_const=283.15)
    annotation (Placement(transformation(extent={{-10,30},{10,50}})));
  DisHeatLib.Boundary.OutsideTemperature outsideTemperature_file(
    inputType=DisHeatLib.Boundary.BaseClasses.InputTypeTemp.File,
    tableName="TempOut",
    fileName=Modelica.Utilities.Files.loadResource("modelica://DisHeatLib/Resources/Data/TempOut.txt"))
    annotation (Placement(transformation(extent={{-10,-12},{10,8}})));
  DisHeatLib.Boundary.OutsideTemperature outsideTemperature_input(inputType=
        DisHeatLib.Boundary.BaseClasses.InputTypeTemp.Input)
    annotation (Placement(transformation(extent={{-10,-50},{10,-30}})));
  Modelica.Blocks.Sources.Sine sine(
    amplitude=10,
    phase=-1.5707963267949,
    offset=273.15 + 5,
    freqHz=1/31536000)
    annotation (Placement(transformation(extent={{-56,-50},{-36,-30}})));
equation
  connect(sine.y, outsideTemperature_input.TemOut_in)
    annotation (Line(points={{-35,-40},{-12,-40}}, color={0,0,127}));
  annotation (__Dymola_Commands(file="modelica://DisHeatLib/Resources/Scripts/Dymola/Boundary/Examples/OutsideTemperature.mos"
        "Simulate and plot"),
        Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(
      StopTime=31536000,
      Interval=900,
      Tolerance=1e-006),
    Documentation(revisions="<html>
<ul>
<li>Feburary 27, 2019, by Benedikt Leitner:<br>Implementation and added User&apos;s guide. </li>
</ul>
</html>"));
end OutsideTemperature;
