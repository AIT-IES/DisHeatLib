within DisHeatLib.Boundary.Examples;
model SoilTemperature
  extends Modelica.Icons.Example;
  DisHeatLib.Boundary.SoilTemperature soilTemperature(inputType=DisHeatLib.Boundary.BaseClasses.InputTypeSoilTemp.Undisturbed,
    T_mean=288.15,
    T_amp=10,
    t_min=0)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  annotation (__Dymola_Commands(file="modelica://DisHeatLib/Resources/Scripts/Dymola/Boundary/Examples/SoilTemperature.mos"
        "Simulate and plot"),
        Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(revisions="<html>
<ul>
<li>Feburary 27, 2019, by Benedikt Leitner:<br>Implementation and added User&apos;s guide. </li>
</ul>
</html>", info="<html>
<p><span style=\"font-family: Arial,sans-serif;\">The example shows how the model uses depth z and time, as well as mean annual temperature (T_mean), annual temperature amplitude (T_amp) and ground thermal diffusivity alpha to describes the temperature using the Kusuda equations.</span></p>
</html>"));
end SoilTemperature;
