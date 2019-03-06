within DisHeatLib.Demand.BaseClasses;
partial model BaseDemand
  extends IBPSA.Fluid.Interfaces.PartialTwoPort;

  // Nominal parameters
  parameter Modelica.SIunits.Power Q_flow_nominal=m_flow_nominal*((TemSup_nominal-TemRet_nominal)*cp_default)
    "Nominal heat flow rate"
    annotation(Evaluate = true, Dialog(group="Nominal parameters"));
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal=Q_flow_nominal/((TemSup_nominal-TemRet_nominal)*cp_default)
    "Nominal mass flow rate"
    annotation(Evaluate = true, Dialog(group="Nominal parameters"));
  parameter Modelica.SIunits.Temperature TemSup_nominal(displayUnit="degC")=60.0+273.15 "Nominal supply temperature"
    annotation(Evaluate = true, Dialog(group="Nominal parameters"));
  parameter Modelica.SIunits.Temperature TemRet_nominal(displayUnit="degC")=35.0+273.15 "Nominal return temperature"
    annotation(Evaluate = true, Dialog(group="Nominal parameters"));

  // only for visualization
  parameter Boolean show_radiator = false;

protected
      final parameter Modelica.SIunits.SpecificHeatCapacity cp_default=
        Medium.cp_const
        "Specific heat capacity of the fluid";

public
  Modelica.Blocks.Interfaces.RealOutput Q_flow "Heat taken from flow"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,-110})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          lineColor={200,200,200},
          fillColor={248,248,248},
          fillPattern=FillPattern.HorizontalCylinder,
          extent={{-100,-100},{100,100}},
          radius=25.0),
        Rectangle(
          lineColor={128,128,128},
          extent={{-100,-100},{100,100}},
          radius=25.0)}),                                        Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>This is a partial model as a basis for demand models.</p>
</html>", revisions="<html>
<ul>
<li>Feburary 27, 2019, by Benedikt Leitner:<br>Implementation and added User&apos;s guide. </li>
</ul>
</html>"));
end BaseDemand;
