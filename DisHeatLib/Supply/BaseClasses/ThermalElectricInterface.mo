within DisHeatLib.Supply.BaseClasses;
model ThermalElectricInterface
    // Electric interface
  parameter Boolean isElectric=true "Unit has electric interface"
    annotation(Dialog(tab = "Electric power"), Evaluate=true, HideResult=true, choices(checkBox=true));
  parameter DisHeatLib.Supply.BaseClasses.BasePowerCharacteristic powerCha "Characteristic for heat and power units"
    annotation(Dialog(tab = "Electric power", enable=isElectric));


protected
  Modelica.Blocks.Tables.CombiTable1Ds powerCharacteristic(
    table=[powerCha.Q_flow,powerCha.P],
    columns={2},
    smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments) if isElectric
    "Get power consumption/generation corresponding to current heat flow"
    annotation (Placement(transformation(extent={{-54,-68},{-34,-48}})));
protected
  Modelica.Blocks.Math.Add add if isElectric
    "Sum of all power consumption/generation; enables additional power connections"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,-80})));
public
  Modelica.Blocks.Sources.RealExpression otherPowerUnits(y=0.0) if isElectric
    "Reserved for other power units (e.g., pumps); negative is generation, positive is consumption"
                                                   annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={26,-58})));
public
  Modelica.Blocks.Interfaces.RealOutput P(unit="W") if isElectric
    "Active power consumption (positive)/generation(negative)"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,-110})));
equation
  connect(add.y,P)
    annotation (Line(points={{0,-91},{0,-110}}, color={0,0,127}));
  connect(powerCharacteristic.y[1],add. u2)
    annotation (Line(points={{-33,-58},{-6,-58},{-6,-68}}, color={0,0,127}));
  connect(otherPowerUnits.y,add. u1)
    annotation (Line(points={{15,-58},{6,-58},{6,-68}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end ThermalElectricInterface;
