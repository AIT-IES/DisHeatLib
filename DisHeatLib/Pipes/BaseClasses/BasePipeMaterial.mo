within DisHeatLib.Pipes.BaseClasses;
record BasePipeMaterial
  "Record that contains the properties of a pipe material"
  parameter Modelica.SIunits.Height roughness
    "Average height of surface asperities";
  parameter Modelica.SIunits.SpecificHeatCapacity cPip
    "Specific heat of pipe wall material";
  parameter Modelica.SIunits.Density rhoPip(displayUnit="kg/m3")
    "Density of pipe wall material";
  annotation (Documentation(revisions="<html>
<ul>
<li>Feburary 27, 2019, by Benedikt Leitner:<br>Implementation and added User&apos;s guide. </li>
</ul>
</html>", info="<html>
<p>This record contains all the properties needed to specify the material of district heating pipe. </p>
</html>"));
end BasePipeMaterial;
