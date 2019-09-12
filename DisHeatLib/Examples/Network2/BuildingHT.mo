within DisHeatLib.Examples.Network2;
model BuildingHT
  extends IBPSA.Fluid.Interfaces.PartialTwoPortInterface(
    final m_flow_nominal = substation.baseStation1.m1_flow_nominal + substation.baseStation2.m1_flow_nominal);

  parameter Modelica.SIunits.Temperature TemSup_nominal;
  parameter Modelica.SIunits.HeatFlowRate Q_flow_nominal_SH(displayUnit="kW");
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal_DHW(displayUnit="kg/s");
  parameter Modelica.SIunits.Volume VTan "Tank volume";
  parameter String fileNameSH;
  parameter String fileNameDHW;

              DisHeatLib.Demand.Demand demandDHW(
    redeclare final package Medium = Medium,
    m_flow_nominal=m_flow_nominal_DHW,
    show_T=true,
    dp_nominal=1,
    Q_flow_nominal=m_flow_nominal_DHW*4186*(55 - 10),
    TemSup_nominal=328.15,
    TemRet_nominal=283.15,
    heatLoad=DisHeatLib.Demand.BaseClasses.InputTypeDemand.FileQ,
    scaling=(4186*(55 - 10)),
    tableName="Table",
    fileName=fileNameDHW,
    redeclare final DisHeatLib.Demand.BaseDemands.FixedReturn demandType,
    flowUnit(FlowType=DisHeatLib.BaseClasses.FlowType.Pump)) "DHW demand"
    annotation (Placement(transformation(extent={{-60,50},{-40,70}})));

              DisHeatLib.Demand.Demand demandSH(
    redeclare final package Medium = Medium,
    show_T=true,
    dp_nominal=10,
    Q_flow_nominal=Q_flow_nominal_SH,
    TemSup_nominal=318.15,
    TemRet_nominal=303.15,
    heatLoad=DisHeatLib.Demand.BaseClasses.InputTypeDemand.FileQ,
    tableName="Table",
    fileName=fileNameSH,
    redeclare final DisHeatLib.Demand.BaseDemands.Radiator demandType,
    flowUnit(FlowType=DisHeatLib.BaseClasses.FlowType.Pump)) "SH demand"
    annotation (Placement(transformation(extent={{40,50},{60,70}})));

  DisHeatLib.Substations.SubstationParallel substation(
    redeclare package Medium = Medium,
    dp1_nominal=100000,
    TemSup_nominal=TemSup_nominal,
    redeclare DisHeatLib.Substations.BaseStations.StorageTankHex baseStation1(
      m1_flow_nominal=substation.baseStation1.VTan*1000/3600,
      m2_flow_nominal=m_flow_nominal_DHW,
      TemSup2_nominal=328.15,
      TemRet2_nominal=283.15,
      VTan=VTan,
      hTan=2,
      T_const=333.15),
    redeclare DisHeatLib.Substations.BaseStations.IndirectStation baseStation2(
      Q1_flow_nominal=Q_flow_nominal_SH,
      TemRet1_nominal=303.15,
      TemSup2_nominal=318.15,
      TemRet2_nominal=303.15,
      hex_efficiency=0.95),
    bypass(m_flow_nominal=0.05*m_flow_nominal))
    annotation (Placement(transformation(extent={{-10,20},{10,0}})));
equation
  connect(substation.port_b2, demandDHW.port_a) annotation (Line(points={{-10,
          18},{-68,18},{-68,60},{-60,60}}, color={0,127,255}));
  connect(substation.port_a2, demandDHW.port_b) annotation (Line(points={{-10,
          14},{-32,14},{-32,60},{-40,60}}, color={0,127,255}));
  connect(substation.port_a3, demandSH.port_b) annotation (Line(points={{10,14},
          {70,14},{70,60},{60,60}}, color={0,127,255}));
  connect(substation.port_b3, demandSH.port_a) annotation (Line(points={{10,18},
          {32,18},{32,60},{40,60}}, color={0,127,255}));
  connect(substation.port_b1, port_b) annotation (Line(points={{10,4},{20,4},{20,
          0},{100,0}}, color={0,127,255}));
  connect(port_a, substation.port_a1) annotation (Line(points={{-100,0},{-20,0},
          {-20,4},{-10,4}}, color={0,127,255}));
  annotation (Icon(graphics={
        Rectangle(
          lineColor={200,200,200},
          fillColor={248,248,248},
          fillPattern=FillPattern.HorizontalCylinder,
          extent={{-100,-100},{100,100}},
          radius=25.0),
        Rectangle(
          lineColor={128,128,128},
          extent={{-100,-100},{100,100}},
          radius=25.0),
      Polygon(
        points={{0,80},{-78,38},{80,38},{0,80}},
        lineColor={95,95,95},
        smooth=Smooth.None,
        fillPattern=FillPattern.Solid,
        fillColor={95,95,95}),
      Rectangle(
          extent={{-64,38},{64,-70}},
          lineColor={150,150,150},
          fillPattern=FillPattern.VerticalCylinder,
          fillColor={217,67,180}),
      Rectangle(
        extent={{-42,-4},{-14,24}},
        lineColor={255,255,255},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Rectangle(
        extent={{16,-4},{44,24}},
        lineColor={255,255,255},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Rectangle(
        extent={{16,-54},{44,-26}},
        lineColor={255,255,255},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Rectangle(
        extent={{-42,-54},{-14,-26}},
        lineColor={255,255,255},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Line(
          points={{-100,0},{-64,0}},
          color={238,46,47},
          thickness=1),
        Line(
          points={{100,0},{98,0},{64,0}},
          color={28,108,200},
          thickness=1)}));
end BuildingHT;
