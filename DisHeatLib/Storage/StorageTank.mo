within DisHeatLib.Storage;
model StorageTank
  extends IBPSA.Fluid.Interfaces.PartialTwoPortInterface;

  parameter Modelica.SIunits.Temperature TemSup_nominal(displayUnit="degC")
    "Nominal supply temperature"
    annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.SIunits.Volume VTan "Tank volume"
    annotation(Evaluate=false, Dialog(group = "Storage tank"));
  parameter Modelica.SIunits.Length hTan = 1 "Height of tank (without insulation)"
    annotation(Evaluate=true, Dialog(group = "Storage tank"));
  parameter Modelica.SIunits.Length dIns = 0.2 "Thickness of insulation"
    annotation(Evaluate=true, Dialog(group = "Storage tank"));
  parameter Modelica.SIunits.ThermalConductivity kIns = 0.04
    "Specific heat conductivity of insulation"
    annotation(Evaluate=true, Dialog(group = "Storage tank"));
  parameter Integer nSeg(min=4) = 4 "Number of volume segments"
    annotation(Evaluate=true, Dialog(group = "Storage tank"));
  parameter Modelica.SIunits.Temperature TemInit = TemSup_nominal
    "Initial temperature of the storage tank"
    annotation(Evaluate=true, Dialog(group = "Storage tank"));

protected
  Modelica.Blocks.Sources.RealExpression Tin[nSeg](y=tan.vol[:].T) annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={40,80})));
public
  IBPSA.Fluid.Storage.StratifiedEnhanced tan(
    allowFlowReversal=allowFlowReversal,
    m_flow_small=m_flow_small,
    VTan=VTan,
    hTan=hTan,
    dIns=dIns,
    kIns=kIns,
    nSeg=nSeg,
    m_flow_nominal=m_flow_nominal,
    redeclare package Medium = Medium,
    T_start=TemInit)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_ht
    "heat port to ambient"
    annotation (Placement(transformation(extent={{-10,90},{10,110}})));
  BaseClasses.CalculateSOC calculateSOC(nin=nSeg, TemHot=TemSup_nominal)
    annotation (Placement(transformation(extent={{60,70},{80,90}})));
public
  Modelica.Blocks.Interfaces.RealOutput SOC
    "State of charge of thermal storage tank" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={110,80}), iconTransformation(extent={{100,70},{120,90}})));
equation
  connect(port_ht, tan.heaPorTop)
    annotation (Line(points={{0,100},{0,7.4},{2,7.4}}, color={191,0,0}));
  connect(port_ht, tan.heaPorSid)
    annotation (Line(points={{0,100},{0,0},{5.6,0}}, color={191,0,0}));
  connect(port_ht, tan.heaPorBot)
    annotation (Line(points={{0,100},{0,-7.4},{2,-7.4}}, color={191,0,0}));
  connect(port_a, tan.port_a)
    annotation (Line(points={{-100,0},{-10,0}}, color={0,127,255}));
  connect(tan.port_b, port_b)
    annotation (Line(points={{10,0},{100,0}}, color={0,127,255}));
  connect(calculateSOC.y, SOC)
    annotation (Line(points={{81,80},{110,80}}, color={0,0,127}));
  connect(Tin.y, calculateSOC.u)
    annotation (Line(points={{51,80},{58,80}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Ellipse(
          extent={{-50,80},{50,54}},
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0},
          lineThickness=1),
        Ellipse(
          extent={{-50,-48},{50,-74}},
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0},
          lineThickness=1),
        Rectangle(
          extent={{-50,68},{50,20}},
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid,
          lineThickness=1,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Rectangle(
          extent={{50,28},{-50,-60}},
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid,
          lineThickness=1,
          pattern=LinePattern.None),
        Line(
          points={{-50,68},{-50,-60}},
          color={0,0,0},
          thickness=1),
        Line(
          points={{50,68},{50,-60}},
          color={0,0,0},
          thickness=1),
        Line(
          points={{-100,0},{-70,0},{-70,60},{-70,60},{-44,60},{-44,60},{-42,60}},
          color={238,46,47},
          thickness=1),
        Line(
          points={{100,0},{70,0},{70,-60},{40,-60},{42,-60}},
          color={0,0,127},
          thickness=1),
        Rectangle(
          extent={{66,26},{70,82}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{70,82},{100,78}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{28,108},{96,84}},
          lineColor={0,0,127},
          textString="SOC"),
        Rectangle(
          extent={{50,30},{68,26}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid)}),                      Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(
      StopTime=36000,
      Interval=60,
      __Dymola_Algorithm="Cvode"),
    Documentation(revisions="<html>
<ul>
<li>Feburary 27, 2019, by Benedikt Leitner:<br>Implementation and added User&apos;s guide. </li>
</ul>
</html>"));
end StorageTank;
