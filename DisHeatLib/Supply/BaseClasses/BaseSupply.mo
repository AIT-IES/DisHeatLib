within DisHeatLib.Supply.BaseClasses;
partial model BaseSupply
  extends IBPSA.Fluid.Interfaces.PartialTwoPortVector;



  // Nominal parameters
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal(min=0) = Q_flow_nominal/((TemSup_nominal-TemRet_nominal)*cp_default)
    "Nominal mass flow rate"
    annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.SIunits.Power Q_flow_nominal
    "Nominal heat flow rate"
    annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.SIunits.Temperature TemSup_nominal(displayUnit="degC")
    "Nominal supply temperature"
    annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.SIunits.Temperature TemRet_nominal(displayUnit="degC")
    "Nominal return temperature"
    annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.SIunits.MassFlowRate m_flow_small(min=0) = 1E-4*abs(m_flow_nominal)
    "Small mass flow rate for regularization of zero flow"
    annotation(Dialog(tab = "Advanced"));

protected
      final parameter Modelica.SIunits.SpecificHeatCapacity cp_default=
        Medium.cp_const
        "Specific heat capacity of the fluid"
        annotation(Evaluate=true);

  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          lineColor={200,200,200},
          fillColor={248,248,248},
          fillPattern=FillPattern.HorizontalCylinder,
          extent={{-100.0,-100.0},{100.0,100.0}},
          radius=25.0),
        Line(
          points={{-70,-62}},
          color={28,108,200},
          thickness=1),
        Rectangle(
          lineColor={128,128,128},
          extent={{-100.0,-100.0},{100.0,100.0}},
          radius=25.0)}), Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(revisions="<html>
<ul>
<li>Feburary 27, 2019, by Benedikt Leitner:<br>Implementation and added User&apos;s guide. </li>
</ul>
</html>"));
end BaseSupply;
