within DisHeatLib.Supply.BaseClasses;
partial model BaseSupply
  replaceable package Medium =
    Modelica.Media.Water.ConstantPropertyLiquidWater;
    Modelica.SIunits.Power Q_flow
    "Heat flow through supply";

  // Nominal parameters
  parameter Modelica.SIunits.Power Q_flow_nominal
    "Nominal heat flow rate"
    annotation(Dialog(group = "Nominal parameters"));
  parameter Modelica.SIunits.Temperature TemSup_nominal(displayUnit="degC")
    "Nominal supply temperature"
    annotation(Dialog(group = "Nominal parameters"));
  parameter Modelica.SIunits.Temperature TemRet_nominal(displayUnit="degC")
    "Nominal return temperature"
    annotation(Dialog(group = "Nominal parameters"));
  parameter Modelica.SIunits.PressureDifference dp_nominal "Nominal pressure drop"
    annotation(Dialog(group = "Nominal parameters"));
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal=Q_flow_nominal/((TemSup_nominal-TemRet_nominal)*cp_default)
    "Nominal mass flow rate"
     annotation(Dialog(group = "Nominal parameters"));

  // Electric interface
  parameter DisHeatLib.Supply.BaseClasses.BasePowerCharacteristic powerCha "Characteristic for heat and power units";

  // Advanced
  parameter Boolean linearized = false
    "= true, use linear relation between m_flow and dp for any flow rate"
    annotation(Evaluate=true, Dialog(tab = "Advanced"));
  parameter Boolean from_dp = false
    "= true, use linear relation between m_flow and dp for any flow rate"
    annotation(Evaluate=true, Dialog(tab = "Advanced"));

 // Assumptions
  parameter Boolean allowFlowReversal = true
    "= false to simplify equations, assuming, but not enforcing, no flow reversal"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);

public
  Modelica.Blocks.Interfaces.RealOutput P
    "Active power consumption (positive)/generation(negative)"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,-110})));
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
protected
      final parameter Modelica.SIunits.SpecificHeatCapacity cp_default=
        Medium.cp_const
        "Specific heat capacity of the fluid";
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
          radius=25.0),          Text(
          extent={{-141,-99},{159,-139}},
          lineColor={0,0,255},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255},
          textString="%name"),
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
