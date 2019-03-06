within DisHeatLib.Pipes.BaseClasses;
record BasePipe "Record that contains the properties of a generic pipes"
  parameter Modelica.SIunits.Length dh=sqrt(4*m_flow_nominal/995/v_nominal/3.14) "Hydraulic diameter of pipe"
  annotation(Dialog(group="Nominal values"));
  parameter Modelica.SIunits.Velocity v_nominal=m_flow_nominal/(995*3.14*dh.^2/4) "Nominal velocity of flow"
  annotation(Dialog(group="Nominal values"));
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal=995*v_nominal*3.14*dh.^2/4 "Nominal mass flow"
  annotation(Dialog(group="Nominal values"));
  replaceable parameter DisHeatLib.Pipes.BaseClasses.BasePipeMaterial pipeMaterial "Material of pipe wall"
   annotation(Dialog(group="Pipe material"), choicesAllMatching=true);
  parameter Modelica.SIunits.Length dWall=0.0035 "Tickness of pipe wall"
  annotation(Dialog(group="Pipe material"));
  parameter Modelica.SIunits.ThermalConductivity kIns=0.024
    "Thermal conductivity of the insulation material"
    annotation(Dialog(group="Thermal insulation"));
  parameter Modelica.SIunits.Length dIns=0.1 "Tickness of insulation"
    annotation(Dialog(group="Thermal insulation"));
  annotation (Documentation(revisions="<html>
<ul>
<li>Feburary 27, 2019, by Benedikt Leitner:<br>Implementation and added User&apos;s guide. </li>
</ul>
</html>", info="<html>
<p>This record contains all the properties that are specified for a district heating pipe. </p>
</html>"));
end BasePipe;
