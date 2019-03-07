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

  // Electric interface
  parameter DisHeatLib.Supply.BaseClasses.BasePowerCharacteristic powerCha "Characteristic for heat and power units"
    annotation(Dialog(tab = "Electric power"));

  parameter Modelica.SIunits.MassFlowRate m_flow_small(min=0) = 1E-4*abs(m_flow_nominal)
    "Small mass flow rate for regularization of zero flow"
    annotation(Dialog(tab = "Advanced"));

  Modelica.SIunits.Power Q_flow
    "Heat flow through supply";

protected
      final parameter Modelica.SIunits.SpecificHeatCapacity cp_default=
        Medium.cp_const
        "Specific heat capacity of the fluid"
        annotation(Evaluate=true);

public
  Modelica.Blocks.Interfaces.RealOutput P(unit="W")
    "Active power consumption (positive)/generation(negative)"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,-110})));
protected
  Modelica.Blocks.Tables.CombiTable1Ds powerCharacteristic(
    table=[powerCha.Q_flow,powerCha.P],
    columns={2},
    smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments)
    "Get power consumption/generation corresponding to current heat flow"
    annotation (Placement(transformation(extent={{-54,-68},{-34,-48}})));
public
  Modelica.Blocks.Sources.RealExpression Q_flow1(y=Q_flow) annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-74,-58})));
protected
  Modelica.Blocks.Math.Add add
    "Sum of all power consumption/generation; enables additional power connections"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,-80})));
public
  Modelica.Blocks.Sources.RealExpression otherPowerUnits(y=0.0)
    "Reserved for other power units (e.g., pumps); negative is generation, positive is consumption"
                                                   annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={26,-58})));

equation
  connect(powerCharacteristic.u, Q_flow1.y)
    annotation (Line(points={{-56,-58},{-63,-58}}, color={0,0,127}));
  connect(add.y, P)
    annotation (Line(points={{0,-91},{0,-110}}, color={0,0,127}));
  connect(powerCharacteristic.y[1], add.u2)
    annotation (Line(points={{-33,-58},{-6,-58},{-6,-68}}, color={0,0,127}));
  connect(otherPowerUnits.y, add.u1)
    annotation (Line(points={{15,-58},{6,-58},{6,-68}}, color={0,0,127}));
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
