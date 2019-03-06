within DisHeatLib.Boundary.Examples;
model SoilTemperature
  extends Modelica.Icons.Example;
  DisHeatLib.Boundary.SoilTemperature soilTemperature
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  annotation (__Dymola_Commands(file="modelica://DisHeatLib/Resources/Scripts/Dymola/Boundary/Examples/SoilTemperature.mos"
        "Simulate and plot"),
        Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(revisions="<html>
<ul>
<li>Feburary 27, 2019, by Benedikt Leitner:<br>Implementation and added User&apos;s guide. </li>
</ul>
</html>"));
end SoilTemperature;
