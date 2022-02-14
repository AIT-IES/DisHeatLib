within DisHeatLib.Examples.ComputationTime;
package Buildings
  model BuildingFRVal
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
      redeclare Substations.BaseStations.IndirectStorageTank baseStation1(
        m1_flow_nominal=substation.baseStation1.VTan*1000/3600,
        m2_flow_nominal=m_flow_nominal_DHW,
        TemSup2_nominal=328.15,
        TemRet2_nominal=283.15,
        hex_efficiency=0.95,
        TemSupTan_nominal=338.15,
        VTan=VTan,
        hTan=2,
        TemInit=333.15,
        m_flow_charging=substation.baseStation1.VTan*1000/3600,
        T_top_set=333.15,
        T_bot_set=323.15,
        T_top_bandwidth=3),
      redeclare DisHeatLib.Substations.BaseStations.IndirectStation baseStation2(
        Q1_flow_nominal=Q_flow_nominal_SH,
        TemRet1_nominal=303.15,
        TemSup2_nominal=318.15,
        TemRet2_nominal=303.15,
        hex_efficiency=0.95),
      bypass(m_flow_nominal=0.05*m_flow_nominal))
      annotation (Placement(transformation(extent={{-10,20},{10,0}})));
    IBPSA.Fluid.Sensors.TemperatureTwoPort senTemAft(
      redeclare package Medium = Medium,
      m_flow_nominal=substation.m1_flow_nominal,
      T_start=substation.TemSup_nominal)
      annotation (Placement(transformation(extent={{40,-10},{60,10}})));
    IBPSA.Fluid.Sensors.TemperatureTwoPort senTemBef(
      redeclare package Medium = Medium,
      m_flow_nominal=substation.m1_flow_nominal,
      T_start=substation.TemSup_nominal)
      annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  equation
    connect(substation.port_b2, demandDHW.port_a) annotation (Line(points={{-10,
            18},{-68,18},{-68,60},{-60,60}}, color={0,127,255}));
    connect(substation.port_a2, demandDHW.port_b) annotation (Line(points={{-10,
            14},{-32,14},{-32,60},{-40,60}}, color={0,127,255}));
    connect(substation.port_a3, demandSH.port_b) annotation (Line(points={{10,14},
            {70,14},{70,60},{60,60}}, color={0,127,255}));
    connect(substation.port_b3, demandSH.port_a) annotation (Line(points={{10,18},
            {32,18},{32,60},{40,60}}, color={0,127,255}));
    connect(substation.port_b1, senTemAft.port_a)
      annotation (Line(points={{10,4},{20,4},{20,0},{40,0}}, color={0,127,255}));
    connect(senTemAft.port_b, port_b)
      annotation (Line(points={{60,0},{100,0}}, color={0,127,255}));
    connect(port_a, senTemBef.port_a)
      annotation (Line(points={{-100,0},{-60,0}}, color={0,127,255}));
    connect(senTemBef.port_b, substation.port_a1) annotation (Line(points={{-40,0},
            {-20,0},{-20,4},{-10,4}}, color={0,127,255}));
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
            thickness=1)}), Documentation(info="<html>
<p>This is a model of a building using hot water supply to power space heating and domestic hot water, using an indirect station for the former and a storage Tank with internal heat exchanger for the latter. Additionally, there is a bypass.</p>
</html>"));
  end BuildingFRVal;

  model BuildingFRValLin
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
      dp_nominal=1,
      linearizeFlowResistance=true,
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
      dp_nominal=10,
      linearizeFlowResistance=true,
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
      linearizeFlowResistance1=true,
      TemSup_nominal=TemSup_nominal,
      redeclare Substations.BaseStations.IndirectStorageTank baseStation1(
        m1_flow_nominal=substation.baseStation1.VTan*1000/3600,
        m2_flow_nominal=m_flow_nominal_DHW,
        TemSup2_nominal=328.15,
        TemRet2_nominal=283.15,
        hex_efficiency=0.95,
        TemSupTan_nominal=338.15,
        VTan=VTan,
        hTan=2,
        TemInit=333.15,
        m_flow_charging=substation.baseStation1.VTan*1000/3600,
        T_top_set=333.15,
        T_bot_set=323.15,
        T_top_bandwidth=3),
      redeclare DisHeatLib.Substations.BaseStations.IndirectStation baseStation2(
        Q1_flow_nominal=Q_flow_nominal_SH,
        TemRet1_nominal=303.15,
        TemSup2_nominal=318.15,
        TemRet2_nominal=303.15,
        hex_efficiency=0.95),
      bypass(m_flow_nominal=0.05*m_flow_nominal))
      annotation (Placement(transformation(extent={{-10,20},{10,0}})));
    IBPSA.Fluid.Sensors.TemperatureTwoPort senTemAft(
      redeclare package Medium = Medium,
      m_flow_nominal=substation.m1_flow_nominal,
      T_start=substation.TemSup_nominal)
      annotation (Placement(transformation(extent={{40,-10},{60,10}})));
    IBPSA.Fluid.Sensors.TemperatureTwoPort senTemBef(
      redeclare package Medium = Medium,
      m_flow_nominal=substation.m1_flow_nominal,
      T_start=substation.TemSup_nominal)
      annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  equation
    connect(substation.port_b2, demandDHW.port_a) annotation (Line(points={{-10,
            18},{-68,18},{-68,60},{-60,60}}, color={0,127,255}));
    connect(substation.port_a2, demandDHW.port_b) annotation (Line(points={{-10,
            14},{-32,14},{-32,60},{-40,60}}, color={0,127,255}));
    connect(substation.port_a3, demandSH.port_b) annotation (Line(points={{10,14},
            {70,14},{70,60},{60,60}}, color={0,127,255}));
    connect(substation.port_b3, demandSH.port_a) annotation (Line(points={{10,18},
            {32,18},{32,60},{40,60}}, color={0,127,255}));
    connect(substation.port_b1, senTemAft.port_a)
      annotation (Line(points={{10,4},{20,4},{20,0},{40,0}}, color={0,127,255}));
    connect(senTemAft.port_b, port_b)
      annotation (Line(points={{60,0},{100,0}}, color={0,127,255}));
    connect(port_a, senTemBef.port_a)
      annotation (Line(points={{-100,0},{-60,0}}, color={0,127,255}));
    connect(senTemBef.port_b, substation.port_a1) annotation (Line(points={{-40,0},
            {-20,0},{-20,4},{-10,4}}, color={0,127,255}));
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
            thickness=1)}), Documentation(info="<html>
<p>This is a model of a building using hot water supply to power space heating and domestic hot water, using an indirect station for the former and a storage Tank with internal heat exchanger for the latter. Additionally, there is a bypass. </p>
<p>The flag linearizeflowresistance has been set to true.</p>
</html>"));
  end BuildingFRValLin;

  model BuildingFRPum
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
      redeclare Substations.BaseStations.IndirectStorageTank baseStation1(
        m1_flow_nominal=substation.baseStation1.VTan*1000/3600,
        m2_flow_nominal=m_flow_nominal_DHW,
        TemSup2_nominal=328.15,
        TemRet2_nominal=283.15,
        hex_efficiency=0.95,
        TemSupTan_nominal=338.15,
        VTan=VTan,
        hTan=2,
        TemInit=333.15,
        m_flow_charging=substation.baseStation1.VTan*1000/3600,
        T_top_set=333.15,
        T_bot_set=323.15,
        T_top_bandwidth=3),
      redeclare DisHeatLib.Substations.BaseStations.IndirectStation baseStation2(
        Q1_flow_nominal=Q_flow_nominal_SH,
        TemRet1_nominal=303.15,
        TemSup2_nominal=318.15,
        TemRet2_nominal=303.15,
        hex_efficiency=0.95,
        flowUnit(FlowType=DisHeatLib.BaseClasses.FlowType.Pump)),
      bypass(m_flow_nominal=0.05*m_flow_nominal, flowUnit(FlowType=DisHeatLib.BaseClasses.FlowType.Pump)))
      annotation (Placement(transformation(extent={{-10,20},{10,0}})));
    IBPSA.Fluid.Sensors.TemperatureTwoPort senTemAft(
      redeclare package Medium = Medium,
      m_flow_nominal=substation.m1_flow_nominal,
      T_start=substation.TemSup_nominal)
      annotation (Placement(transformation(extent={{40,-10},{60,10}})));
    IBPSA.Fluid.Sensors.TemperatureTwoPort senTemBef(
      redeclare package Medium = Medium,
      m_flow_nominal=substation.m1_flow_nominal,
      T_start=substation.TemSup_nominal)
      annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  equation
    connect(substation.port_b2, demandDHW.port_a) annotation (Line(points={{-10,
            18},{-68,18},{-68,60},{-60,60}}, color={0,127,255}));
    connect(substation.port_a2, demandDHW.port_b) annotation (Line(points={{-10,
            14},{-32,14},{-32,60},{-40,60}}, color={0,127,255}));
    connect(substation.port_a3, demandSH.port_b) annotation (Line(points={{10,14},
            {70,14},{70,60},{60,60}}, color={0,127,255}));
    connect(substation.port_b3, demandSH.port_a) annotation (Line(points={{10,18},
            {32,18},{32,60},{40,60}}, color={0,127,255}));
    connect(substation.port_b1, senTemAft.port_a)
      annotation (Line(points={{10,4},{20,4},{20,0},{40,0}}, color={0,127,255}));
    connect(senTemAft.port_b, port_b)
      annotation (Line(points={{60,0},{100,0}}, color={0,127,255}));
    connect(port_a, senTemBef.port_a)
      annotation (Line(points={{-100,0},{-60,0}}, color={0,127,255}));
    connect(senTemBef.port_b, substation.port_a1) annotation (Line(points={{-40,0},
            {-20,0},{-20,4},{-10,4}}, color={0,127,255}));
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
            thickness=1)}), Documentation(info="<html>
<p>This is a model of a building using hot water supply to power space heating and domestic hot water, using an indirect station for the former and a storage Tank with internal heat exchanger for the latter. Additionally, there is a bypass. </p>
<p>Valves have been exchanged for pumps.</p>
</html>"));
  end BuildingFRPum;

  model BuildingNoFRVal
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
      allowFlowReversal=false,
      m_flow_nominal=m_flow_nominal_DHW,
      m_flow_small=1E-3*abs(demandDHW.m_flow_nominal),
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
      allowFlowReversal=false,
      m_flow_small=1E-3*abs(demandSH.m_flow_nominal),
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
      m1_flow_small=1E-3*abs(substation.m1_flow_nominal),
      m2_flow_small=1E-3*abs(substation.m2_flow_nominal),
      m3_flow_small=1E-3*abs(substation.m3_flow_nominal),
      dp1_nominal=100000,
      allowFlowReversal1=false,
      allowFlowReversal2=false,
      allowFlowReversal3=false,
      TemSup_nominal=TemSup_nominal,
      redeclare Substations.BaseStations.IndirectStorageTank baseStation1(
        m1_flow_nominal=substation.baseStation1.VTan*1000/3600,
        m2_flow_nominal=m_flow_nominal_DHW,
        TemSup2_nominal=328.15,
        TemRet2_nominal=283.15,
        hex_efficiency=0.95,
        TemSupTan_nominal=338.15,
        VTan=VTan,
        hTan=2,
        TemInit=333.15,
        m_flow_charging=substation.baseStation1.VTan*1000/3600,
        T_top_set=333.15,
        T_bot_set=323.15,
        T_top_bandwidth=3),
      redeclare DisHeatLib.Substations.BaseStations.IndirectStation baseStation2(
        Q1_flow_nominal=Q_flow_nominal_SH,
        TemRet1_nominal=303.15,
        TemSup2_nominal=318.15,
        TemRet2_nominal=303.15,
        hex_efficiency=0.95),
      bypass(m_flow_nominal=0.05*m_flow_nominal))
      annotation (Placement(transformation(extent={{-10,20},{10,0}})));
    IBPSA.Fluid.Sensors.TemperatureTwoPort senTemAft(
      redeclare package Medium = Medium,
      allowFlowReversal=false,
      m_flow_nominal=substation.m1_flow_nominal,
      m_flow_small=1E-3*abs(senTemAft.m_flow_nominal),
      T_start=substation.TemSup_nominal)
      annotation (Placement(transformation(extent={{40,-10},{60,10}})));
    IBPSA.Fluid.Sensors.TemperatureTwoPort senTemBef(
      redeclare package Medium = Medium,
      allowFlowReversal=false,
      m_flow_nominal=substation.m1_flow_nominal,
      m_flow_small=1E-3*abs(senTemBef.m_flow_nominal),
      T_start=substation.TemSup_nominal)
      annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  equation
    connect(substation.port_b2, demandDHW.port_a) annotation (Line(points={{-10,
            18},{-68,18},{-68,60},{-60,60}}, color={0,127,255}));
    connect(substation.port_a2, demandDHW.port_b) annotation (Line(points={{-10,
            14},{-32,14},{-32,60},{-40,60}}, color={0,127,255}));
    connect(substation.port_a3, demandSH.port_b) annotation (Line(points={{10,14},
            {70,14},{70,60},{60,60}}, color={0,127,255}));
    connect(substation.port_b3, demandSH.port_a) annotation (Line(points={{10,18},
            {32,18},{32,60},{40,60}}, color={0,127,255}));
    connect(substation.port_b1, senTemAft.port_a)
      annotation (Line(points={{10,4},{20,4},{20,0},{40,0}}, color={0,127,255}));
    connect(senTemAft.port_b, port_b)
      annotation (Line(points={{60,0},{100,0}}, color={0,127,255}));
    connect(port_a, senTemBef.port_a)
      annotation (Line(points={{-100,0},{-60,0}}, color={0,127,255}));
    connect(senTemBef.port_b, substation.port_a1) annotation (Line(points={{-40,0},
            {-20,0},{-20,4},{-10,4}}, color={0,127,255}));
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
            thickness=1)}), Documentation(info="<html>
<p>This is a model of a building using hot water supply to power space heating and domestic hot water, using an indirect station for the former and a storage Tank with internal heat exchanger for the latter. Additionally, there is a bypass. </p>
<p>The flag allowFlowReversal has been set to false.</p>
</html>"));
  end BuildingNoFRVal;

  model BuildingNoFRPum
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
      allowFlowReversal=false,
      m_flow_nominal=m_flow_nominal_DHW,
      m_flow_small=1E-3*abs(demandDHW.m_flow_nominal),
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

    DisHeatLib.Substations.SubstationParallel substation(
      redeclare package Medium = Medium,
      m1_flow_small=1E-3*abs(substation.m1_flow_nominal),
      m2_flow_small=1E-3*abs(substation.m2_flow_nominal),
      m3_flow_small=1E-3*abs(substation.m3_flow_nominal),
      dp1_nominal=100000,
      allowFlowReversal1=false,
      allowFlowReversal2=false,
      allowFlowReversal3=false,
      TemSup_nominal=TemSup_nominal,
      redeclare Substations.BaseStations.IndirectStorageTank baseStation1(
        m1_flow_nominal=substation.baseStation1.VTan*1000/3600,
        m2_flow_nominal=m_flow_nominal_DHW,
        TemSup2_nominal=328.15,
        TemRet2_nominal=283.15,
        hex_efficiency=0.95,
        TemSupTan_nominal=338.15,
        VTan=VTan,
        hTan=2,
        TemInit=333.15,
        m_flow_charging=substation.baseStation1.VTan*1000/3600,
        T_top_set=333.15,
        T_bot_set=323.15,
        T_top_bandwidth=3),
      redeclare DisHeatLib.Substations.BaseStations.IndirectStation baseStation2(
        Q1_flow_nominal=Q_flow_nominal_SH,
        TemRet1_nominal=303.15,
        TemSup2_nominal=318.15,
        TemRet2_nominal=303.15,
        hex_efficiency=0.95,
        flowUnit(FlowType=DisHeatLib.BaseClasses.FlowType.Pump)),
      bypass(m_flow_nominal=0.05*m_flow_nominal, flowUnit(FlowType=DisHeatLib.BaseClasses.FlowType.Pump)))
      annotation (Placement(transformation(extent={{-10,20},{10,0}})));
                DisHeatLib.Demand.Demand demandSH(
      redeclare final package Medium = Medium,
      allowFlowReversal=false,
      m_flow_small=1E-3*abs(demandSH.m_flow_nominal),
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

    IBPSA.Fluid.Sensors.TemperatureTwoPort senTemAft(
      redeclare package Medium = Medium,
      allowFlowReversal=false,
      m_flow_nominal=substation.m1_flow_nominal,
      m_flow_small=1E-3*abs(senTemAft.m_flow_nominal),
      T_start=substation.TemSup_nominal)
      annotation (Placement(transformation(extent={{40,-10},{60,10}})));
    IBPSA.Fluid.Sensors.TemperatureTwoPort senTemBef(
      redeclare package Medium = Medium,
      allowFlowReversal=false,
      m_flow_nominal=substation.m1_flow_nominal,
      m_flow_small=1E-3*abs(senTemBef.m_flow_nominal),
      T_start=substation.TemSup_nominal)
      annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  equation
    connect(substation.port_b2, demandDHW.port_a) annotation (Line(points={{-10,
            18},{-68,18},{-68,60},{-60,60}}, color={0,127,255}));
    connect(substation.port_a2, demandDHW.port_b) annotation (Line(points={{-10,
            14},{-32,14},{-32,60},{-40,60}}, color={0,127,255}));
    connect(substation.port_a3, demandSH.port_b) annotation (Line(points={{10,14},
            {70,14},{70,60},{60,60}}, color={0,127,255}));
    connect(substation.port_b3, demandSH.port_a) annotation (Line(points={{10,18},
            {32,18},{32,60},{40,60}}, color={0,127,255}));
    connect(substation.port_b1, senTemAft.port_a)
      annotation (Line(points={{10,4},{20,4},{20,0},{40,0}}, color={0,127,255}));
    connect(senTemAft.port_b, port_b)
      annotation (Line(points={{60,0},{100,0}}, color={0,127,255}));
    connect(port_a, senTemBef.port_a)
      annotation (Line(points={{-100,0},{-60,0}}, color={0,127,255}));
    connect(senTemBef.port_b, substation.port_a1) annotation (Line(points={{-40,0},
            {-20,0},{-20,4},{-10,4}}, color={0,127,255}));
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
            thickness=1)}), Documentation(info="<html>
<p>This is a model of a building using hot water supply to power space heating and domestic hot water, using an indirect station for the former and a storage Tank with internal heat exchanger for the latter. Additionally, there is a bypass. </p>
<p>The flag allowFlowReversal has been set to false. Valves have been exchanged for pumps.</p>
</html>"));
  end BuildingNoFRPum;
  annotation (Documentation(info="<html>
<p>This subpackage contains the building used in the examples of the parent folder.</p>
</html>"));
end Buildings;
