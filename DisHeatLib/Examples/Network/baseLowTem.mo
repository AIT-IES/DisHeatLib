within DisHeatLib.Examples.Network;
model baseLowTem
  extends Modelica.Icons.Example;
  // Limit result variables to selected ones
  //extends dhnet.VariableSelection;

  import DisHeatLib;
  package Medium = IBPSA.Media.Water;
  parameter Modelica.SIunits.Temperature TemSup_nominal = 50.0 + 273.15
    "Nominal district heating supply temperature";

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
        origin={-106,158})));

  // Pipes
  DisHeatLib.Pipes.DualPipe Pipe1(
    redeclare package Medium = Medium,
    L=60,
    T_sl_init=TemSup_nominal,
    redeclare DisHeatLib.Pipes.Library.Isoplus.Isoplus_1IMP_DN100 pipeType,
    nPorts1=5,
    nPorts2=1)
          annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={6,-60})));

     DisHeatLib.Pipes.DualPipe Pipe2(
    redeclare package Medium = Medium,
    L=220,
    T_sl_init=TemSup_nominal,
    redeclare DisHeatLib.Pipes.Library.Isoplus.Isoplus_1IMP_DN50 pipeType,
    nPorts2=1,
    nPorts1=2)
           annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={36,-24})));

  DisHeatLib.Pipes.DualPipe Pipe3(
    redeclare package Medium = Medium,
    L=250,
    T_sl_init=TemSup_nominal,
    redeclare DisHeatLib.Pipes.Library.Isoplus.Isoplus_1IMP_DN50 pipeType,
    nPorts2=1,
    nPorts1=2)
           annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={78,-22})));

  DisHeatLib.Pipes.DualPipe Pipe4(
    redeclare package Medium = Medium,
    L=50,
    T_sl_init=TemSup_nominal,
    redeclare DisHeatLib.Pipes.Library.Isoplus.Isoplus_1IMP_DN32 pipeType,
    nPorts2=1,
    nPorts1=1)
          annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={132,-24})));

  DisHeatLib.Pipes.DualPipe Pipe5(
    redeclare package Medium = Medium,
    L=70,
    T_sl_init=TemSup_nominal,
    redeclare DisHeatLib.Pipes.Library.Isoplus.Isoplus_1IMP_DN32 pipeType,
    nPorts2=1,
    nPorts1=1)
          annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={108,-2})));

  DisHeatLib.Pipes.DualPipe Pipe6(
    redeclare package Medium = Medium,
    L=310,
    T_sl_init=TemSup_nominal,
    redeclare DisHeatLib.Pipes.Library.Isoplus.Isoplus_1IMP_DN50 pipeType,
    nPorts2=1,
    nPorts1=3)
           annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={-80,-26})));

  DisHeatLib.Pipes.DualPipe Pipe7(
    redeclare package Medium = Medium,
    L=80,
    T_sl_init=TemSup_nominal,
    redeclare DisHeatLib.Pipes.Library.Isoplus.Isoplus_1IMP_DN32 pipeType,
    nPorts2=1,
    nPorts1=1)
          annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={-146,-32})));

  DisHeatLib.Pipes.DualPipe Pipe8(
    redeclare package Medium = Medium,
    T_sl_init=TemSup_nominal,
    L=120,
    redeclare DisHeatLib.Pipes.Library.Isoplus.Isoplus_1IMP_DN32 pipeType,
    nPorts1=1,
    nPorts2=1)   annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=270,
        origin={-58,-54})));

  DisHeatLib.Pipes.DualPipe Pipe9(
    redeclare package Medium = Medium,
    T_sl_init=TemSup_nominal,
    L=110,
    redeclare DisHeatLib.Pipes.Library.Isoplus.Isoplus_1IMP_DN80 pipeType,
    nPorts2=1,
    nPorts1=3)
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={6,8})));

  DisHeatLib.Pipes.DualPipe Pipe10(
    redeclare package Medium = Medium,
    L=170,
    T_sl_init=TemSup_nominal,
    redeclare DisHeatLib.Pipes.Library.Isoplus.Isoplus_1IMP_DN50 pipeType,
    nPorts2=1,
    nPorts1=2)
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={-20,60})));

  DisHeatLib.Pipes.DualPipe Pipe11(
    redeclare package Medium = Medium,
    L=310,
    T_sl_init=TemSup_nominal,
    redeclare DisHeatLib.Pipes.Library.Isoplus.Isoplus_1IMP_DN50 pipeType,
    nPorts2=1,
    nPorts1=3)
    annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=270,
        origin={6,74})));

  DisHeatLib.Pipes.DualPipe Pipe12(
    redeclare package Medium = Medium,
    L=90,
    T_sl_init=TemSup_nominal,
    redeclare DisHeatLib.Pipes.Library.Isoplus.Isoplus_1IMP_DN32 pipeType,
    nPorts2=1,
    nPorts1=1)
          annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={56,98})));

  // Main supply
  DisHeatLib.Supply.Supply_pT     baseSupply(
    redeclare package Medium = Medium,
    show_T=true,
    powerCha(Q_flow={0}, P={0}),
    SupplyTemperature=DisHeatLib.Supply.BaseClasses.InputTypeSupplyTemp.Constant,
    dp_controller=true,
    Q_flow_nominal(displayUnit="MW") = 3000000,
    TemSup_nominal=TemSup_nominal,
    TemRet_nominal=303.15,
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
  DisHeatLib.Examples.Network.BuildingLowTem
                                       Building1(
    redeclare package Medium = Medium,
    show_T=true,
    m_flow_nominal_DHW=0.45,
    Q_flow_nominal_SH(displayUnit="kW") = 96000,
    VTan=3.01,
    fileNameSH="modelica://DisHeatLib/Resources/Data/network/bld1SH.txt",
    fileNameDHW="modelica://DisHeatLib/Resources/Data/network/bld1DHW.txt",
    TemSup_nominal=TemSup_nominal)
    annotation (Placement(transformation(extent={{-52,-20},{-32,0}})));

  DisHeatLib.Examples.Network.BuildingLowTem
                                       Building2(
    redeclare package Medium = Medium,
    m_flow_nominal_DHW=0.52,
    Q_flow_nominal_SH(displayUnit="kW") = 59000,
    VTan=2.618,
    fileNameSH="modelica://DisHeatLib/Resources/Data/network/bld2SH.txt",
    fileNameDHW="modelica://DisHeatLib/Resources/Data/network/bld1DHW.txt",
    TemSup_nominal=TemSup_nominal)
    annotation (Placement(transformation(extent={{46,-2},{66,18}})));

  DisHeatLib.Examples.Network.BuildingLowTem
                                       Building3(
    redeclare package Medium = Medium,
    m_flow_nominal_DHW=0.41,
    Q_flow_nominal_SH(displayUnit="kW") = 51000,
    VTan=1.795,
    fileNameSH="modelica://DisHeatLib/Resources/Data/network/bld3SH.txt",
    fileNameDHW="modelica://DisHeatLib/Resources/Data/network/bld3DHW.txt",
    TemSup_nominal=TemSup_nominal)
    annotation (Placement(transformation(extent={{148,-14},{168,6}})));

  DisHeatLib.Examples.Network.BuildingLowTem
                                       Building4(
    redeclare package Medium = Medium,
    m_flow_nominal_DHW=0.40,
    Q_flow_nominal_SH(displayUnit="kW") = 74000,
    VTan=2.282,
    fileNameSH="modelica://DisHeatLib/Resources/Data/network/bld4SH.txt",
    fileNameDHW="modelica://DisHeatLib/Resources/Data/network/bld4DHW.txt",
    TemSup_nominal=TemSup_nominal)
    annotation (Placement(transformation(extent={{100,16},{120,36}})));

  DisHeatLib.Examples.Network.BuildingLowTem
                                       Building5(
    redeclare package Medium = Medium,
    m_flow_nominal_DHW=0.43,
    Q_flow_nominal_SH(displayUnit="kW") = 43000,
    VTan=2.556,
    fileNameSH="modelica://DisHeatLib/Resources/Data/network/bld5SH.txt",
    fileNameDHW="modelica://DisHeatLib/Resources/Data/network/bld5DHW.txt",
    TemSup_nominal=TemSup_nominal)
    annotation (Placement(transformation(extent={{-128,-68},{-108,-48}})));

  DisHeatLib.Examples.Network.BuildingLowTem
                                       Building6(
    redeclare package Medium = Medium,
    m_flow_nominal_DHW=0.38,
    Q_flow_nominal_SH(displayUnit="kW") = 41000,
    VTan=1.436,
    fileNameSH="modelica://DisHeatLib/Resources/Data/network/bld6SH.txt",
    fileNameDHW="modelica://DisHeatLib/Resources/Data/network/bld6DHW.txt",
    TemSup_nominal=TemSup_nominal)
    annotation (Placement(transformation(extent={{-128,-12},{-108,8}})));

  DisHeatLib.Examples.Network.BuildingLowTem
                                       Building7(
    redeclare package Medium = Medium,
    m_flow_nominal_DHW=0.43,
    Q_flow_nominal_SH(displayUnit="kW") = 57000,
    VTan=1.896,
    fileNameSH="modelica://DisHeatLib/Resources/Data/network/bld7SH.txt",
    fileNameDHW="modelica://DisHeatLib/Resources/Data/network/bld7DHW.txt",
    TemSup_nominal=TemSup_nominal)
    annotation (Placement(transformation(extent={{-174,-14},{-154,6}})));

  DisHeatLib.Examples.Network.BuildingLowTem
                                       Building8(
    redeclare package Medium = Medium,
    m_flow_nominal_DHW=0.43,
    Q_flow_nominal_SH(displayUnit="kW") = 48000,
    VTan=1.208,
    fileNameSH="modelica://DisHeatLib/Resources/Data/network/bld8SH.txt",
    fileNameDHW="modelica://DisHeatLib/Resources/Data/network/bld8DHW.txt",
    TemSup_nominal=TemSup_nominal)
    annotation (Placement(transformation(extent={{-94,-84},{-74,-64}})));

  DisHeatLib.Examples.Network.BuildingLowTem
                                       Building9(
    redeclare package Medium = Medium,
    m_flow_nominal_DHW=0.53,
    Q_flow_nominal_SH(displayUnit="kW") = 27000,
    VTan=3.449,
    fileNameSH="modelica://DisHeatLib/Resources/Data/network/bld9SH.txt",
    fileNameDHW="modelica://DisHeatLib/Resources/Data/network/bld9DHW.txt",
    TemSup_nominal=TemSup_nominal)
    annotation (Placement(transformation(extent={{-30,26},{-10,46}})));

  DisHeatLib.Examples.Network.BuildingLowTem
                                       Building10(
    redeclare package Medium = Medium,
    m_flow_nominal_DHW=0.56,
    Q_flow_nominal_SH(displayUnit="kW") = 77000,
    VTan=2.627,
    fileNameSH="modelica://DisHeatLib/Resources/Data/network/bld10SH.txt",
    fileNameDHW="modelica://DisHeatLib/Resources/Data/network/bld10DHW.txt",
    TemSup_nominal=TemSup_nominal)
    annotation (Placement(transformation(extent={{-60,36},{-40,56}})));

  DisHeatLib.Examples.Network.BuildingLowTem
                                       Building11(
    redeclare package Medium = Medium,
    m_flow_nominal_DHW=0.66,
    Q_flow_nominal_SH(displayUnit="kW") = 91000,
    VTan=3.45,
    fileNameSH="modelica://DisHeatLib/Resources/Data/network/bld11SH.txt",
    fileNameDHW="modelica://DisHeatLib/Resources/Data/network/bld11DHW.txt",
    TemSup_nominal=TemSup_nominal)
    annotation (Placement(transformation(extent={{-62,76},{-42,96}})));

  DisHeatLib.Examples.Network.BuildingLowTem
                                       Building12(
    redeclare package Medium = Medium,
    m_flow_nominal_DHW=0.44,
    Q_flow_nominal_SH(displayUnit="kW") = 79000,
    VTan=2.694,
    fileNameSH="modelica://DisHeatLib/Resources/Data/network/bld12SH.txt",
    fileNameDHW="modelica://DisHeatLib/Resources/Data/network/bld12DHW.txt",
    TemSup_nominal=TemSup_nominal)
    annotation (Placement(transformation(extent={{16,104},{36,124}})));

  DisHeatLib.Examples.Network.BuildingLowTem
                                       Building13(
    redeclare package Medium = Medium,
    m_flow_nominal_DHW=0.58,
    Q_flow_nominal_SH(displayUnit="kW") = 78000,
    VTan=3.909,
    fileNameSH="modelica://DisHeatLib/Resources/Data/network/bld13SH.txt",
    fileNameDHW="modelica://DisHeatLib/Resources/Data/network/bld13DHW.txt",
    TemSup_nominal=TemSup_nominal)
    annotation (Placement(transformation(extent={{32,62},{52,82}})));

  DisHeatLib.Examples.Network.BuildingLowTem
                                       Building14(
    redeclare package Medium = Medium,
    m_flow_nominal_DHW=0.33,
    Q_flow_nominal_SH(displayUnit="kW") = 55000,
    VTan=1.748,
    fileNameSH="modelica://DisHeatLib/Resources/Data/network/bld14SH.txt",
    fileNameDHW="modelica://DisHeatLib/Resources/Data/network/bld14DHW.txt",
    TemSup_nominal=TemSup_nominal)
    annotation (Placement(transformation(extent={{70,112},{90,132}})));

  // Electric heaters

  // Heat pump

  Modelica.Blocks.Sources.RealExpression dp_measure_min(y=min([Building1.substation.senRelPre.p_rel,
        Building2.substation.senRelPre.p_rel,Building3.substation.senRelPre.p_rel,
        Building4.substation.senRelPre.p_rel,Building5.substation.senRelPre.p_rel,
        Building6.substation.senRelPre.p_rel,Building7.substation.senRelPre.p_rel,
        Building8.substation.senRelPre.p_rel,Building9.substation.senRelPre.p_rel,
        Building10.substation.senRelPre.p_rel,Building11.substation.senRelPre.p_rel,
        Building12.substation.senRelPre.p_rel,Building13.substation.senRelPre.p_rel,
        Building14.substation.senRelPre.p_rel]))
    annotation (Placement(transformation(extent={{46,-84},{26,-64}})));

  IBPSA.Fluid.Sensors.TemperatureTwoPort senTemRet_Supply(
    redeclare package Medium = Medium,
    m_flow_nominal=baseSupply.m_flow_nominal,
    T_start=baseSupply.TemRet_nominal)
    annotation (Placement(transformation(extent={{20,-102},{40,-82}})));
  IBPSA.Fluid.Sensors.TemperatureTwoPort senTemSup_Supply(
    redeclare package Medium = Medium,
    m_flow_nominal=baseSupply.m_flow_nominal,
    T_start=baseSupply.TemRet_nominal)
    annotation (Placement(transformation(extent={{-10,-102},{-30,-82}})));
equation
  // Soil connections
  connect(Soil.port, Pipe12.port_ht) annotation (Line(points={{-106,148},{-106,140},
          {56,140},{56,108}},      color={191,0,0}));
  connect(Soil.port, Pipe11.port_ht) annotation (Line(points={{-106,148},{-106,140},
          {-4,140},{-4,74}},      color={191,0,0}));
  connect(Soil.port, Pipe10.port_ht) annotation (Line(points={{-106,148},{-106,140},
          {-20,140},{-20,70}},      color={191,0,0}));
  connect(Soil.port, Pipe7.port_ht) annotation (Line(points={{-106,148},{-106,
          140},{-146,140},{-146,-22}}, color={191,0,0}));
  connect(Soil.port, Pipe6.port_ht) annotation (Line(points={{-106,148},{-106,140},
          {-80,140},{-80,-16}},      color={191,0,0}));
  connect(Soil.port, Pipe8.port_ht) annotation (Line(points={{-106,148},{-106,140},
          {-68,140},{-68,-54}},      color={191,0,0}));
  connect(Soil.port, Pipe2.port_ht) annotation (Line(points={{-106,148},{-106,140},
          {36,140},{36,-14}},      color={191,0,0}));
  connect(Soil.port, Pipe3.port_ht) annotation (Line(points={{-106,148},{-106,140},
          {78,140},{78,-12}},      color={191,0,0}));
  connect(Soil.port, Pipe5.port_ht) annotation (Line(points={{-106,148},{-106,140},
          {98,140},{98,-2}},      color={191,0,0}));
  connect(Soil.port, Pipe4.port_ht) annotation (Line(points={{-106,148},{-106,140},
          {132,140},{132,-14}},      color={191,0,0}));
  connect(Soil.port, Pipe1.port_ht) annotation (Line(points={{-106,148},{-106,140},
          {-4,140},{-4,-60}},      color={191,0,0}));
  connect(Soil.port, Pipe9.port_ht) annotation (Line(points={{-106,148},{-106,
          140},{16,140},{16,8}}, color={191,0,0}));

  // Outside temperature connections

  // Pipes

  connect(Pipe1.ports_b1[1], Pipe2.port_a1) annotation (Line(points={{3.2,-50},
          {3.2,-18},{26,-18}}, color={0,127,255}));
  connect(Pipe2.ports_b2[1], Pipe1.port_a2)
    annotation (Line(points={{26,-30},{12,-30},{12,-50}}, color={0,127,255}));
  connect(Pipe2.ports_b1[1], Building2.port_a)
    annotation (Line(points={{46,-20},{46,8}}, color={0,127,255}));
  connect(Pipe2.ports_b1[2], Pipe3.port_a1)
    annotation (Line(points={{46,-16},{68,-16},{68,-16}}, color={0,127,255}));
  connect(Building2.port_b, Pipe2.port_a2) annotation (Line(points={{66,8},{68,
          8},{68,-12},{56,-12},{56,-30},{46,-30}}, color={0,127,255}));
  connect(Pipe3.ports_b2[1], Pipe2.port_a2) annotation (Line(points={{68,-28},{
          66,-28},{66,-30},{46,-30}}, color={0,127,255}));
  connect(Pipe3.ports_b1[1], Pipe5.port_a1) annotation (Line(points={{88,-18},{
          102,-18},{102,-12}}, color={0,127,255}));
  connect(Pipe5.ports_b2[1], Pipe3.port_a2) annotation (Line(points={{114,-12},
          {114,-28},{88,-28}}, color={0,127,255}));
  connect(Pipe4.ports_b2[1], Pipe3.port_a2)
    annotation (Line(points={{122,-30},{88,-30},{88,-28}}, color={0,127,255}));
  connect(Pipe3.ports_b1[2], Pipe4.port_a1) annotation (Line(points={{88,-14},{
          94,-14},{94,-20},{122,-20},{122,-18}}, color={0,127,255}));
  connect(Pipe5.ports_b1[1], Building4.port_a) annotation (Line(points={{102,8},
          {102,12},{94,12},{94,26},{100,26}}, color={0,127,255}));
  connect(Pipe5.port_a2, Building4.port_b) annotation (Line(points={{114,8},{
          114,10},{124,10},{124,26},{120,26}}, color={0,127,255}));
  connect(Pipe4.ports_b1[1], Building3.port_a) annotation (Line(points={{142,
          -18},{144,-18},{144,-4},{148,-4}}, color={0,127,255}));
  connect(Pipe4.port_a2, Building3.port_b) annotation (Line(points={{142,-30},{
          172,-30},{172,-4},{168,-4}}, color={0,127,255}));
  connect(Pipe9.ports_b2[1], Pipe1.port_a2) annotation (Line(points={{0,-2},{0,
          -12},{12,-12},{12,-50}}, color={0,127,255}));
  connect(Pipe1.ports_b1[2], Pipe9.port_a1) annotation (Line(points={{1.6,-50},
          {2,-50},{2,-2},{12,-2}}, color={0,127,255}));
  connect(Pipe1.ports_b1[3], Pipe8.port_a1) annotation (Line(points={{
          4.44089e-16,-50},{4.44089e-16,-40},{-64,-40},{-64,-44}}, color={0,127,
          255}));
  connect(Pipe1.ports_b1[4], Pipe6.port_a1) annotation (Line(points={{-1.6,-50},
          {-1.6,-20},{-70,-20}}, color={0,127,255}));
  connect(Pipe1.ports_b1[5], Building1.port_a) annotation (Line(points={{-3.2,-50},
          {0,-50},{0,-24},{-52,-24},{-52,-10}},      color={0,127,255}));
  connect(Building1.port_b, Pipe1.port_a2) annotation (Line(points={{-32,-10},{-38,
          -10},{-38,-12},{12,-12},{12,-50}},     color={0,127,255}));
  connect(Pipe6.ports_b2[1], Pipe1.port_a2)
    annotation (Line(points={{-70,-32},{12,-32},{12,-50}}, color={0,127,255}));
  connect(Pipe8.ports_b1[1], Building8.port_a) annotation (Line(points={{-64,
          -64},{-66,-64},{-66,-94},{-96,-94},{-96,-74},{-94,-74}}, color={0,127,
          255}));
  connect(Building8.port_b, Pipe8.port_a2) annotation (Line(points={{-74,-74},{
          -52,-74},{-52,-64}}, color={0,127,255}));
  connect(Pipe6.ports_b1[1], Pipe7.port_a1) annotation (Line(points={{-90,
          -22.6667},{-94,-22.6667},{-94,-22},{-136,-22},{-136,-26}},
                                                      color={0,127,255}));
  connect(Pipe6.ports_b1[2], Building5.port_a) annotation (Line(points={{-90,-20},
          {-128,-20},{-128,-58}},      color={0,127,255}));
  connect(Building5.port_b, Pipe6.port_a2) annotation (Line(points={{-108,-58},
          {-108,-32},{-90,-32}}, color={0,127,255}));
  connect(Pipe7.ports_b2[1], Pipe6.port_a2) annotation (Line(points={{-136,-38},
          {-134,-38},{-134,-36},{-90,-36},{-90,-32}}, color={0,127,255}));
  connect(Pipe6.ports_b1[3], Building6.port_a) annotation (Line(points={{-90,
          -17.3333},{-132,-17.3333},{-132,-2},{-128,-2}},
                                                color={0,127,255}));
  connect(Building6.port_b, Pipe6.port_a2) annotation (Line(points={{-108,-2},{
          -104,-2},{-104,-32},{-90,-32}}, color={0,127,255}));
  connect(Pipe7.port_a2, Building7.port_b) annotation (Line(points={{-156,-38},
          {-158,-38},{-158,-18},{-150,-18},{-150,-4},{-154,-4}}, color={0,127,
          255}));
  connect(Pipe7.ports_b1[1], Building7.port_a) annotation (Line(points={{-156,
          -26},{-174,-26},{-174,-4}}, color={0,127,255}));
  connect(Pipe9.ports_b1[1], Building9.port_a) annotation (Line(points={{9.33333,
          18},{9.33333,32},{-34,32},{-34,36},{-30,36}},
                                               color={0,127,255}));
  connect(Building9.port_b, Pipe9.port_a2)
    annotation (Line(points={{-10,36},{0,36},{0,18}}, color={0,127,255}));
  connect(Pipe9.ports_b1[2], Pipe11.port_a1) annotation (Line(points={{12,18},{12,
          40},{0,40},{0,64}},    color={0,127,255}));
  connect(Pipe11.ports_b2[1], Pipe9.port_a2) annotation (Line(points={{12,64},{
          10,64},{10,52},{0,52},{0,18}}, color={0,127,255}));
  connect(Pipe10.ports_b2[1], Pipe9.port_a2)
    annotation (Line(points={{-10,54},{0,54},{0,18}}, color={0,127,255}));
  connect(Pipe9.ports_b1[3], Pipe10.port_a1)
    annotation (Line(points={{14.6667,18},{14.6667,66},{-10,66}},
                                                        color={0,127,255}));
  connect(Pipe10.ports_b1[1], Building10.port_a) annotation (Line(points={{-30,
          64},{-46,64},{-46,64},{-64,64},{-64,46},{-60,46}}, color={0,127,255}));
  connect(Building10.port_b, Pipe10.port_a2) annotation (Line(points={{-40,46},
          {-36,46},{-36,54},{-30,54}}, color={0,127,255}));
  connect(Pipe10.ports_b1[2], Building11.port_a) annotation (Line(points={{-30,
          68},{-48,68},{-48,70},{-62,70},{-62,86}}, color={0,127,255}));
  connect(Building11.port_b, Pipe10.port_a2) annotation (Line(points={{-42,86},
          {-42,58},{-30,58},{-30,54}}, color={0,127,255}));
  connect(Pipe11.ports_b1[1], Building12.port_a) annotation (Line(points={{2.66667,
          84},{2,84},{2,114},{16,114}},         color={0,127,255}));
  connect(Pipe12.ports_b2[1], Pipe11.port_a2)
    annotation (Line(points={{46,92},{12,92},{12,84}}, color={0,127,255}));
  connect(Building12.port_b, Pipe11.port_a2) annotation (Line(points={{36,114},
          {40,114},{40,84},{12,84}}, color={0,127,255}));
  connect(Pipe11.ports_b1[2], Building13.port_a) annotation (Line(points={{
          8.88178e-16,84},{8.88178e-16,88},{30,88},{30,72},{32,72}}, color={0,
          127,255}));
  connect(Building13.port_b, Pipe11.port_a2) annotation (Line(points={{52,72},{
          56,72},{56,84},{12,84}}, color={0,127,255}));
  connect(Pipe12.ports_b1[1], Building14.port_a)
    annotation (Line(points={{66,104},{70,104},{70,122}}, color={0,127,255}));
  connect(Pipe12.port_a2, Building14.port_b) annotation (Line(points={{66,92},{
          92,92},{92,122},{90,122}}, color={0,127,255}));
  connect(dp_measure_min.y, baseSupply.dp_measure)
    annotation (Line(points={{25,-74},{10,-74},{10,-80}}, color={0,0,127}));
  connect(Pipe8.ports_b2[1], Pipe1.port_a2) annotation (Line(points={{-52,-44},
          {-44,-44},{-44,-50},{12,-50}}, color={0,127,255}));
  connect(Pipe11.ports_b1[3], Pipe12.port_a1) annotation (Line(points={{
          -2.66667,84},{-2.66667,104},{46,104}}, color={0,127,255}));

  // THexSet connections

  // EHQSet connections

  // EBHPSet connections

  //EBHPlus to FMIOutput connections

  // Building to FMIOutput connections
  connect(baseSupply.port_a, senTemRet_Supply.port_a)
    annotation (Line(points={{14,-92},{20,-92}}, color={0,127,255}));
  connect(senTemRet_Supply.port_b, Pipe1.ports_b2[1]) annotation (Line(points={{40,-92},
          {40,-80},{20,-80},{20,-72},{12,-72},{12,-70}},          color={0,127,
          255}));
  connect(baseSupply.ports_b[1], senTemSup_Supply.port_a)
    annotation (Line(points={{-6,-92},{-10,-92}}, color={0,127,255}));
  connect(senTemSup_Supply.port_b, Pipe1.port_a1) annotation (Line(points={{-30,
          -92},{-30,-80},{-10,-80},{-10,-72},{0,-72},{0,-70}}, color={0,127,255}));
  annotation (Diagram(coordinateSystem(extent={{-180,-180},{200,180}})), Icon(
        coordinateSystem(extent={{-180,-180},{200,180}})),
    experiment(
      StopTime=259200,
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
    __Dymola_Commands(
      file=
          "Resources/Scripts/Dymola/Examples/Network/baseLowTem/BaseLowTemSimulateWeek.mos"
        "Simulate 1 week",
      file=
          "Resources/Scripts/Dymola/Examples/Network/baseLowTem/BaseLowTemSimulateDay.mos"
        "Simulate 1 day",
      file(ensureSimulated=true)=
        "Resources/Scripts/Dymola/Examples/Network/baseLowTem/BaseLowTemSupplyAndDemandSpaceHeating.mos"
        "1. Plot supply and demand space heating",
      file=
          "Resources/Scripts/Dymola/Examples/Network/baseLowTem/BaseLowTemSupplyAndDemandDomesticHotWater.mos"
        "2. Plot supply and demand domestic hot water",
      file=
          "Resources/Scripts/Dymola/Examples/Network/baseLowTem/BaseLowTemBuildingSupplyAndReturnTemperature.mos"
        "3. Plot incoming and outgoing temperature",
      file=
          "Resources/Scripts/Dymola/Examples/Network/baseLowTem/BaseLowTemDifferentialPressure.mos"
        "4. Plot differential pressure",
      file=
          "Resources/Scripts/Dymola/Examples/Network/baseLowTem/BaseLowTemMassFlow.mos"
        "5. Plot mass flow",
      file=
          "Resources/Scripts/Dymola/Examples/Network/baseLowTem/BaseLowTemLossAndReturnTemperature.mos"
        "6. Plot heat loss and return temperature"),
    Documentation(info="<html>
<p>This example simulates a heat supply and consumer network made out of a base heating station, 14 buildings and 12 pipes.</p>
<p>Before simulating it is recommended to type &quot;<span style=\"font-family: Courier New;\">Advanced.SparseActivate=true</span>&quot; into the commands to reduce computation time substantially.</p>
<h4>Available commands:</h4>
<ul>
<li>Simulate 1 week: Simulates the model for a duration of 1 week after using the command &quot;Advanced.SparseActivate=true&quot;</li>
<li>Simulate 1 day: Simulates the model for a duration of 1 day after using the command &quot;Advanced.SparseActivate=true&quot;</li>
</ul>
<p>After simulating there are 6 different plot commands available to better understand this example:</p>
<ol>
<li>This plot compares the demand to the actual supply of space heating each building is receiving by both overlapping the two curves and plotting their difference below. After a short starting period the difference is negligibly small, since space heating demand is quite smooth.</li>
<li>This plot compares the demand to the actual supply of domestic hot water each building is receiving by both overlapping the two curves and plotting their difference below. The difference isn&apos;t negligible as domestic hot water demand can change rapidly and by great amounts, but still is rather small compared to the values of the demand. (To highlight the differences in the plot click on peaks dipping below the x-axis.)</li>
<li>This plot compares the temperature of the water flowing in and out of the building therefor showing how the consumption affects the temperature in the supply.</li>
<li>This plot shows the difference in pressure of the water in the buildings before and after consumption.</li>
<li>This plot shows the mass flow of the water in the buildings before and after consumption.</li>
<li>This plot shows the losses of heat through the pipes and the temperature of the water returning to the supply station, for reference the supply temperature is plotted aswell.</li>
</ol>
</html>"));
end baseLowTem;
