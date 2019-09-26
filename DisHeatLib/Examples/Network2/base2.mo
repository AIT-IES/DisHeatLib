within DisHeatLib.Examples.Network2;
model base2
  extends Modelica.Icons.Example;
  // Limit result variables to selected ones
  //extends dhnet.VariableSelection;

  import DisHeatLib;
  package Medium = IBPSA.Media.Water;

  // Boundary conditions
  DisHeatLib.Boundary.SoilTemperature Soil(
    inputType=DisHeatLib.Boundary.BaseClasses.InputTypeSoilTemp.Undisturbed,
    t_min=1000800,
    z=1,
    T_amp=4,
    T_mean=280.15)                                             annotation (
      Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=0,
        origin={-144,106})));

  // Pipes

     DisHeatLib.Pipes.DualPipe Pipe2(
    redeclare package Medium = Medium,
    L=220,
    T_sl_init=323.15,
    redeclare DisHeatLib.Pipes.Library.Isoplus.Isoplus_1IMP_DN50 pipeType,
    nPorts1=2,
    nPorts2=1)
           annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={152,44})));

  DisHeatLib.Pipes.DualPipe Pipe3(
    redeclare package Medium = Medium,
    L=250,
    T_sl_init=323.15,
    redeclare DisHeatLib.Pipes.Library.Isoplus.Isoplus_1IMP_DN50 pipeType,
    nPorts2=1,
    nPorts1=2)
           annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={194,46})));

  DisHeatLib.Pipes.DualPipe Pipe4(
    redeclare package Medium = Medium,
    L=50,
    T_sl_init=323.15,
    redeclare DisHeatLib.Pipes.Library.Isoplus.Isoplus_1IMP_DN32 pipeType,
    nPorts2=1,
    nPorts1=1)
          annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={248,44})));

  DisHeatLib.Pipes.DualPipe Pipe5(
    redeclare package Medium = Medium,
    L=70,
    T_sl_init=323.15,
    redeclare DisHeatLib.Pipes.Library.Isoplus.Isoplus_1IMP_DN32 pipeType,
    nPorts2=1,
    nPorts1=1)
          annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={224,66})));

  DisHeatLib.Pipes.DualPipe Pipe9(
    redeclare package Medium = Medium,
    T_sl_init=323.15,
    L=110,
    redeclare DisHeatLib.Pipes.Library.Isoplus.Isoplus_1IMP_DN80 pipeType,
    nPorts1=3,
    nPorts2=1)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={4,-50})));

  DisHeatLib.Pipes.DualPipe Pipe10(
    redeclare package Medium = Medium,
    L=170,
    T_sl_init=323.15,
    redeclare DisHeatLib.Pipes.Library.Isoplus.Isoplus_1IMP_DN50 pipeType,
    nPorts2=1,
    nPorts1=2)
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={-58,8})));

  DisHeatLib.Pipes.DualPipe Pipe11(
    redeclare package Medium = Medium,
    L=310,
    T_sl_init=323.15,
    redeclare DisHeatLib.Pipes.Library.Isoplus.Isoplus_1IMP_DN50 pipeType,
    nPorts2=1,
    nPorts1=3)
    annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=270,
        origin={-32,22})));

  DisHeatLib.Pipes.DualPipe Pipe12(
    redeclare package Medium = Medium,
    L=90,
    T_sl_init=323.15,
    redeclare DisHeatLib.Pipes.Library.Isoplus.Isoplus_1IMP_DN32 pipeType,
    nPorts2=1,
    nPorts1=2)
          annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={18,46})));

  // Main supply
  DisHeatLib.Supply.Supply_pT     baseSupply(
    redeclare package Medium = Medium,
    show_T=true,
    powerCha(Q_flow={0}, P={0}),
    SupplyTemperature=DisHeatLib.Supply.BaseClasses.InputTypeSupplyTemp.Constant,
    dp_controller=true,
    Q_flow_nominal(displayUnit="MW") = 3000000,
    TemSup_nominal=323.15,
    TemRet_nominal=318.15,
    dp_nominal=1000000,
    m_flow_nominal=15,
    TemOut_min=263.15,
    TemOut_max=288.15,
    TemSup_min=348.15,
    TemSup_max=368.15,
    dp_min=100000,
    dp_set=100000,
    dp_max=1000000,
    nPorts=1)
    annotation (Placement(transformation(extent={{14,-102},{-6,-82}})));

  // Buildings

  DisHeatLib.Examples.Network2.Buildings.BuildingHT Building2(
    redeclare package Medium = Medium,
    m_flow_nominal_DHW=0.52,
    Q_flow_nominal_SH(displayUnit="kW") = 59000,
    VTan=2.618,
    fileNameSH="modelica://DisHeatLib/Resources/Data/network/bld2SH.txt",
    fileNameDHW="modelica://DisHeatLib/Resources/Data/network/bld1DHW.txt",
    TemSup_nominal=343.15)
    annotation (Placement(transformation(extent={{162,66},{182,86}})));

  DisHeatLib.Examples.Network2.Buildings.BuildingHT Building3(
    redeclare package Medium = Medium,
    m_flow_nominal_DHW=0.41,
    Q_flow_nominal_SH(displayUnit="kW") = 51000,
    VTan=1.795,
    fileNameSH="modelica://DisHeatLib/Resources/Data/network/bld3SH.txt",
    fileNameDHW="modelica://DisHeatLib/Resources/Data/network/bld3DHW.txt",
    TemSup_nominal=343.15)
    annotation (Placement(transformation(extent={{264,54},{284,74}})));

  DisHeatLib.Examples.Network2.Buildings.BuildingHT Building4(
    redeclare package Medium = Medium,
    m_flow_nominal_DHW=0.40,
    Q_flow_nominal_SH(displayUnit="kW") = 74000,
    VTan=2.282,
    fileNameSH="modelica://DisHeatLib/Resources/Data/network/bld4SH.txt",
    fileNameDHW="modelica://DisHeatLib/Resources/Data/network/bld4DHW.txt",
    TemSup_nominal=343.15)
    annotation (Placement(transformation(extent={{216,84},{236,104}})));

  DisHeatLib.Examples.Network2.Buildings.BuildingLT Building9(
    redeclare package Medium = Medium,
    m_flow_nominal_DHW=0.53,
    Q_flow_nominal_SH(displayUnit="kW") = 27000,
    VTan=3.449,
    fileNameSH="modelica://DisHeatLib/Resources/Data/network/bld9SH.txt",
    fileNameDHW="modelica://DisHeatLib/Resources/Data/network/bld9DHW.txt",
    TemSup_nominal=323.15)
    annotation (Placement(transformation(extent={{-68,-26},{-48,-6}})));

  DisHeatLib.Examples.Network2.Buildings.BuildingLT Building10(
    redeclare package Medium = Medium,
    m_flow_nominal_DHW=0.56,
    Q_flow_nominal_SH(displayUnit="kW") = 77000,
    VTan=2.627,
    fileNameSH="modelica://DisHeatLib/Resources/Data/network/bld10SH.txt",
    fileNameDHW="modelica://DisHeatLib/Resources/Data/network/bld10DHW.txt",
    TemSup_nominal=323.15)
    annotation (Placement(transformation(extent={{-98,-16},{-78,4}})));

  DisHeatLib.Examples.Network2.Buildings.BuildingLT Building11(
    redeclare package Medium = Medium,
    m_flow_nominal_DHW=0.66,
    Q_flow_nominal_SH(displayUnit="kW") = 91000,
    VTan=3.45,
    fileNameSH="modelica://DisHeatLib/Resources/Data/network/bld11SH.txt",
    fileNameDHW="modelica://DisHeatLib/Resources/Data/network/bld11DHW.txt",
    TemSup_nominal=323.15)
    annotation (Placement(transformation(extent={{-100,24},{-80,44}})));

  DisHeatLib.Examples.Network2.Buildings.BuildingLT Building12(
    redeclare package Medium = Medium,
    m_flow_nominal_DHW=0.44,
    Q_flow_nominal_SH(displayUnit="kW") = 79000,
    VTan=2.694,
    fileNameSH="modelica://DisHeatLib/Resources/Data/network/bld12SH.txt",
    fileNameDHW="modelica://DisHeatLib/Resources/Data/network/bld12DHW.txt",
    TemSup_nominal=323.15)
    annotation (Placement(transformation(extent={{-22,52},{-2,72}})));

  DisHeatLib.Examples.Network2.Buildings.BuildingLT Building13(
    redeclare package Medium = Medium,
    m_flow_nominal_DHW=0.58,
    Q_flow_nominal_SH(displayUnit="kW") = 78000,
    VTan=3.909,
    fileNameSH="modelica://DisHeatLib/Resources/Data/network/bld13SH.txt",
    fileNameDHW="modelica://DisHeatLib/Resources/Data/network/bld13DHW.txt",
    TemSup_nominal=323.15)
    annotation (Placement(transformation(extent={{-6,10},{14,30}})));

  DisHeatLib.Examples.Network2.Buildings.BuildingLT Building14(
    redeclare package Medium = Medium,
    m_flow_nominal_DHW=0.33,
    Q_flow_nominal_SH(displayUnit="kW") = 55000,
    VTan=1.748,
    fileNameSH="modelica://DisHeatLib/Resources/Data/network/bld14SH.txt",
    fileNameDHW="modelica://DisHeatLib/Resources/Data/network/bld14DHW.txt",
    TemSup_nominal=323.15)
    annotation (Placement(transformation(extent={{32,60},{52,80}})));

  // Electric heaters

  // Heat pump

  Modelica.Blocks.Sources.RealExpression dp_measure_min(y=min([Building9.substation.senRelPre.p_rel,
        Building10.substation.senRelPre.p_rel,Building11.substation.senRelPre.p_rel,
        Building12.substation.senRelPre.p_rel,Building13.substation.senRelPre.p_rel,
        Building14.substation.senRelPre.p_rel,substationSingle.senRelPre.p_rel]))
    annotation (Placement(transformation(extent={{46,-84},{26,-64}})));

  DisHeatLib.Substations.SubstationSingle substationSingle(
    show_T=true,
    redeclare package Medium = Medium,
    dp1_nominal=100000,
    TemSup_nominal=323.15,
    redeclare DisHeatLib.Substations.BaseStations.IndirectStationEBH
      baseStation(
      Q1_flow_nominal(displayUnit="kW") = 500000,
      TemSup2_nominal=318.15,
      hex_efficiency=0.95,
      electricBoosterHeater(
        Q_flow_nominal(displayUnit="kW") = 500000,
        TemSup_nominal=343.15,
        powerCha(Q_flow={0,4}, P={0,1}))))
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={78,44})));
public
  replaceable
  IBPSA.Fluid.Movers.FlowControlled_dp     pump(
    redeclare package Medium = Medium,
    addPowerToMedium=true,
    final nominalValuesDefineDefaultPressureCurve=true,
    final m_flow_nominal=substationSingle.m2_flow_nominal,
    final constantHead(displayUnit="bar"),
    final dp_nominal(displayUnit="bar") = 100000,
    each final heads={0})
    annotation (Placement(transformation(extent={{100,48},{120,68}})));
public
  DisHeatLib.Controls.dp_control
                      dp_control(
    k=40,
    dp_min=100000,
    dp_max=1000000,
    dp_setpoint=100000)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={110,88})));
  Modelica.Blocks.Sources.RealExpression dp_measure_min1(y=Building3.substation.senRelPre.p_rel)
    annotation (Placement(transformation(extent={{134,106},{114,126}})));
equation
  // Soil connections
  connect(Soil.port, Pipe12.port_ht) annotation (Line(points={{-144,96},{-144,88},
          {18,88},{18,56}},        color={191,0,0}));
  connect(Soil.port, Pipe11.port_ht) annotation (Line(points={{-144,96},{-144,88},
          {-42,88},{-42,22}},     color={191,0,0}));
  connect(Soil.port, Pipe10.port_ht) annotation (Line(points={{-144,96},{-144,88},
          {-58,88},{-58,18}},       color={191,0,0}));
  connect(Soil.port, Pipe2.port_ht) annotation (Line(points={{-144,96},{-144,146},
          {152,146},{152,54}},     color={191,0,0}));
  connect(Soil.port, Pipe3.port_ht) annotation (Line(points={{-144,96},{-144,146},
          {194,146},{194,56}},     color={191,0,0}));
  connect(Soil.port, Pipe5.port_ht) annotation (Line(points={{-144,96},{-144,146},
          {214,146},{214,66}},    color={191,0,0}));
  connect(Soil.port, Pipe4.port_ht) annotation (Line(points={{-144,96},{-144,146},
          {248,146},{248,54}},       color={191,0,0}));
  connect(Soil.port, Pipe9.port_ht) annotation (Line(points={{-144,96},{-144,88},
          {-6,88},{-6,-50}},     color={191,0,0}));

  // Outside temperature connections

  // Pipes

  connect(Pipe2.ports_b1[1], Building2.port_a)
    annotation (Line(points={{162,48},{162,76}},
                                               color={0,127,255}));
  connect(Pipe2.ports_b1[2], Pipe3.port_a1)
    annotation (Line(points={{162,52},{184,52}},          color={0,127,255}));
  connect(Building2.port_b, Pipe2.port_a2) annotation (Line(points={{182,76},{184,
          76},{184,56},{172,56},{172,38},{162,38}},color={0,127,255}));
  connect(Pipe3.ports_b2[1], Pipe2.port_a2) annotation (Line(points={{184,40},{182,
          40},{182,38},{162,38}},     color={0,127,255}));
  connect(Pipe3.ports_b1[1], Pipe5.port_a1) annotation (Line(points={{204,50},{218,
          50},{218,56}},       color={0,127,255}));
  connect(Pipe5.ports_b2[1], Pipe3.port_a2) annotation (Line(points={{230,56},{230,
          40},{204,40}},       color={0,127,255}));
  connect(Pipe4.ports_b2[1], Pipe3.port_a2)
    annotation (Line(points={{238,38},{204,38},{204,40}},  color={0,127,255}));
  connect(Pipe3.ports_b1[2], Pipe4.port_a1) annotation (Line(points={{204,54},{210,
          54},{210,48},{238,48},{238,50}},       color={0,127,255}));
  connect(Pipe5.ports_b1[1], Building4.port_a) annotation (Line(points={{218,76},
          {218,80},{210,80},{210,94},{216,94}},
                                              color={0,127,255}));
  connect(Pipe5.port_a2, Building4.port_b) annotation (Line(points={{230,76},{230,
          78},{240,78},{240,94},{236,94}},     color={0,127,255}));
  connect(Pipe4.ports_b1[1], Building3.port_a) annotation (Line(points={{258,50},
          {260,50},{260,64},{264,64}},       color={0,127,255}));
  connect(Pipe4.port_a2, Building3.port_b) annotation (Line(points={{258,38},{288,
          38},{288,64},{284,64}},      color={0,127,255}));
  connect(Pipe9.ports_b1[1], Building9.port_a) annotation (Line(points={{0.666667,
          -40},{0.666667,-20},{-72,-20},{-72,-16},{-68,-16}},
                                               color={0,127,255}));
  connect(Building9.port_b, Pipe9.port_a2)
    annotation (Line(points={{-48,-16},{10,-16},{10,-40}},
                                                      color={0,127,255}));
  connect(Pipe9.ports_b1[2], Pipe11.port_a1) annotation (Line(points={{-2,-40},{
          -2,-12},{-38,-12},{-38,12}},
                                 color={0,127,255}));
  connect(Pipe11.ports_b2[1], Pipe9.port_a2) annotation (Line(points={{-26,12},{
          -28,12},{-28,-40},{10,-40}},   color={0,127,255}));
  connect(Pipe10.ports_b2[1], Pipe9.port_a2)
    annotation (Line(points={{-48,2},{10,2},{10,-40}},color={0,127,255}));
  connect(Pipe9.ports_b1[3], Pipe10.port_a1)
    annotation (Line(points={{-4.66667,-40},{-4.66667,14},{-48,14}},
                                                        color={0,127,255}));
  connect(Pipe10.ports_b1[1], Building10.port_a) annotation (Line(points={{-68,12},
          {-102,12},{-102,-6},{-98,-6}},                     color={0,127,255}));
  connect(Building10.port_b, Pipe10.port_a2) annotation (Line(points={{-78,-6},{
          -74,-6},{-74,2},{-68,2}},    color={0,127,255}));
  connect(Pipe10.ports_b1[2], Building11.port_a) annotation (Line(points={{-68,16},
          {-86,16},{-86,18},{-100,18},{-100,34}},   color={0,127,255}));
  connect(Building11.port_b, Pipe10.port_a2) annotation (Line(points={{-80,34},{
          -80,30},{-68,30},{-68,2}},   color={0,127,255}));
  connect(Pipe11.ports_b1[1], Building12.port_a) annotation (Line(points={{
          -35.3333,32},{-36,32},{-36,62},{-22,62}},
                                                color={0,127,255}));
  connect(Pipe12.ports_b2[1], Pipe11.port_a2)
    annotation (Line(points={{8,40},{-26,40},{-26,32}},color={0,127,255}));
  connect(Building12.port_b, Pipe11.port_a2) annotation (Line(points={{-2,62},{2,
          62},{2,32},{-26,32}},      color={0,127,255}));
  connect(Pipe11.ports_b1[2], Building13.port_a) annotation (Line(points={{-38,32},
          {-38,36},{-8,36},{-8,20},{-6,20}},                         color={0,
          127,255}));
  connect(Building13.port_b, Pipe11.port_a2) annotation (Line(points={{14,20},{18,
          20},{18,32},{-26,32}},   color={0,127,255}));
  connect(Pipe12.ports_b1[1], Building14.port_a)
    annotation (Line(points={{28,50},{32,50},{32,70}},    color={0,127,255}));
  connect(Pipe12.port_a2, Building14.port_b) annotation (Line(points={{28,40},{54,
          40},{54,70},{52,70}},      color={0,127,255}));
  connect(dp_measure_min.y, baseSupply.dp_measure)
    annotation (Line(points={{25,-74},{10,-74},{10,-80}}, color={0,0,127}));
  connect(Pipe11.ports_b1[3], Pipe12.port_a1) annotation (Line(points={{
          -40.6667,32},{-40.6667,52},{8,52}},    color={0,127,255}));

  // THexSet connections

  // EHQSet connections

  // EBHPSet connections

  //EBHPlus to FMIOutput connections

  // Building to FMIOutput connections
  connect(substationSingle.port_b1, Pipe12.port_a2) annotation (Line(points={{72,
          34},{70,34},{70,24},{28,24},{28,40}}, color={0,127,255}));
  connect(Pipe12.ports_b1[2], substationSingle.port_a1) annotation (Line(points=
         {{28,54},{36,54},{36,50},{62,50},{62,60},{72,60},{72,54}}, color={0,127,
          255}));
  connect(dp_control.y, pump.dp_in)
    annotation (Line(points={{110,77},{110,70}}, color={0,0,127}));
  connect(substationSingle.port_b2, pump.port_a)
    annotation (Line(points={{84,54},{84,58},{100,58}}, color={0,127,255}));
  connect(pump.port_b, Pipe2.port_a1) annotation (Line(points={{120,58},{136,58},
          {136,50},{142,50}}, color={0,127,255}));
  connect(Pipe2.ports_b2[1], substationSingle.port_a2) annotation (Line(points={
          {142,38},{114,38},{114,26},{84,26},{84,34}}, color={0,127,255}));
  connect(dp_measure_min1.y, dp_control.dp)
    annotation (Line(points={{113,116},{110,116},{110,100}}, color={0,0,127}));
  connect(baseSupply.ports_b[1], Pipe9.port_a1) annotation (Line(points={{-6,-92},
          {-16,-92},{-16,-68},{-2,-68},{-2,-60}}, color={0,127,255}));
  connect(Pipe9.ports_b2[1], baseSupply.port_a) annotation (Line(points={{10,-60},
          {12,-60},{12,-68},{20,-68},{20,-92},{14,-92}}, color={0,127,255}));
  annotation (Diagram(coordinateSystem(extent={{-180,-120},{300,180}}),
        graphics={
        Rectangle(extent={{80,142},{292,-16}}, lineColor={28,108,200}),
        Text(
          extent={{-110,-42},{-24,-54}},
          lineColor={28,108,200},
          textString="Low temperature area"),
        Rectangle(extent={{-126,82},{76,-58}}, lineColor={28,108,200}),
        Text(
          extent={{162,0},{248,-12}},
          lineColor={28,108,200},
          textString="High temperature area")}),                         Icon(
        coordinateSystem(extent={{-180,-120},{300,180}})),
    experiment(
      StopTime=31536000,
      Interval=900.00288,
      __Dymola_Algorithm="Cvode"),
    __Dymola_experimentFlags(
      Advanced(
        EvaluateAlsoTop=false,
        GenerateVariableDependencies=false,
        OutputModelicaCode=true),
      Evaluate=true,
      OutputCPUtime=true,
      OutputFlatModelica=true),
    __Dymola_experimentSetupOutput,
    Documentation(info="<html>
<p>In this example the heat supply needs a low supply temperature for the first group of buildings and the substation transfers the heat to a medium with higher supply temperature for the second group of buildings.</p>
</html>"));
end base2;
