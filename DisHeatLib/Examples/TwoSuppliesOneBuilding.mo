within DisHeatLib.Examples;
model TwoSuppliesOneBuilding
  extends Modelica.Icons.Example;
  import DisHeatLib;
  package Medium = IBPSA.Media.Water;

  DisHeatLib.Demand.Demand demandSH(
    redeclare package Medium = Medium,
    dp_nominal=100000,
    tableName="SHprofile",
    fileName="modelica://DisHeatLib/Resources/Data/SHprofile.txt",
    redeclare DisHeatLib.Demand.BaseClasses.Radiator demandType,
    Q_constant(displayUnit="kW") = 100000,
    heatLoad=DisHeatLib.Demand.BaseClasses.InputTypeQ.File,
    Q_flow_nominal(displayUnit="kW") = 10000,
    TemSup_nominal=333.15,
    TemRet_nominal=318.15)
    annotation (Placement(transformation(extent={{20,50},{40,70}})));

  DisHeatLib.Pipes.DualPipe pipe1(
    redeclare package Medium = Medium,
    L=100,
    redeclare DisHeatLib.Pipes.Library.Isoplus.Isoplus_Std_DN25 pipeType,
    T_sl_init=353.15,
    nPorts_rl=1,
    nPorts_sl=1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-32,-14})));
  DisHeatLib.Boundary.SoilTemperature soil(
    z=1,
    T_amp=1,
    t_min=1,
    T_mean=283.15)                                             annotation (
      Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={-78,-14})));
  DisHeatLib.Supply.Supply_pT baseSupply(
    redeclare package Medium = Medium,
    Q_flow_nominal(displayUnit="kW") = 20000,
    powerCha(Q_flow={0,1}, P={0,1}),
    OutsideDependent=false,
    dp_set=500000,
    k=1,
    TemSup_nominal=343.15,
    TemRet_nominal=318.15,
    dp_nominal(displayUnit="kPa") = 80000,
    TemOut_min=268.15,
    TemOut_max=288.15,
    TemSup_min=343.15,
    TemSup_max=333.15,
    dp_min(displayUnit="bar") = 500000,
    dp_max(displayUnit="bar") = 1000000)
    annotation (Placement(transformation(extent={{-22,-52},{-42,-72}})));
  DisHeatLib.Boundary.OutsideTemperature outsideTemperature(
    inputType=DisHeatLib.Boundary.BaseClasses.InputTypeTemp.File,
    tableName="TempOut",
    fileName=Modelica.Utilities.Files.loadResource(
        "modelica://DisHeatLib/Resources/Data/TempOut.txt"))
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-76,82})));
  DisHeatLib.Demand.Demand demandDHW(
    redeclare package Medium = Medium,
    dp_nominal=100000,
    tableName="Table",
    fileName="modelica://DisHeatLib/Resources/Data/DHWprofile_E2340_P40.txt",
    redeclare DisHeatLib.Demand.BaseClasses.FixedReturn demandType,
    Q_constant(displayUnit="kW") = 100000,
    heatLoad=DisHeatLib.Demand.BaseClasses.InputTypeQ.File,
    Q_flow_nominal(displayUnit="kW") = 10000,
    TemSup_nominal=333.15,
    TemRet_nominal=288.15)
    annotation (Placement(transformation(extent={{-38,52},{-18,72}})));

  DisHeatLib.Substations.Substation substation(
    redeclare package Medium = Medium,
    FlowType=DisHeatLib.Substations.BaseClasses.BaseStationFlowType.Valve,
    TemSup_nominal=343.15,
    dp_nominal=100000,
    redeclare DisHeatLib.Substations.BaseClasses.IndirectBaseStation
      BaseStationDHW(Q_flow_nominal(displayUnit="kW") = 10000, OutsideDependent=
         false),
    redeclare DisHeatLib.Substations.BaseClasses.IndirectBaseStation
      BaseStationSH(Q_flow_nominal(displayUnit="kW") = 10000, Ti=900))
    annotation (Placement(transformation(extent={{-10,26},{10,46}})));
  DisHeatLib.Supply.Supply_QT supply_QT(
    redeclare package Medium = Medium,
    Q_flow_nominal(displayUnit="kW") = 50000,
    TemSup_nominal=393.15,
    TemRet_nominal=323.15,
    dp_nominal=100000,
    powerCha(Q_flow={0,1}, P={0,1}),
    use_Q_in=true)
    annotation (Placement(transformation(extent={{74,-50},{54,-70}})));
  DisHeatLib.Pipes.DualPipe pipe(
    redeclare package Medium = Medium,
    L=100,
    redeclare DisHeatLib.Pipes.Library.Isoplus.Isoplus_Std_DN25 pipeType,
    T_sl_init=353.15,
    nPorts_rl=2,
    nPorts_sl=1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,10})));
  DisHeatLib.Pipes.DualPipe pipe2(
    redeclare package Medium = Medium,
    L=100,
    redeclare DisHeatLib.Pipes.Library.Isoplus.Isoplus_Std_DN25 pipeType,
    T_sl_init=353.15,
    nPorts_rl=1,
    nPorts_sl=1)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={64,-30})));
  Modelica.Blocks.Sources.Pulse pulse(
    amplitude=7000,
    width=50,
    period(displayUnit="h") = 86400)
    annotation (Placement(transformation(extent={{38,-94},{58,-74}})));
equation
  connect(pipe1.port_ht, soil.port)
    annotation (Line(points={{-42,-14},{-68,-14}}, color={191,0,0}));
  connect(baseSupply.port_sl, pipe1.port_sl_a) annotation (Line(points={{-42,-62},
          {-52,-62},{-52,-40},{-38,-40},{-38,-24}}, color={0,127,255}));
  connect(pipe1.port_rl_b[1], baseSupply.port_rl) annotation (Line(points={{-26,
          -24},{-26,-40},{-12,-40},{-12,-62},{-22,-62}}, color={0,127,255}));
  connect(substation.dp, baseSupply.dp_measure) annotation (Line(points={{11,36.9091},
          {28,36.9091},{28,-80},{-26,-80},{-26,-74}}, color={0,0,127}));
  connect(substation.port_sl_DHW,demandDHW. port_a) annotation (Line(points={{-10,
          42.3636},{-42,42.3636},{-42,62},{-38,62}},     color={0,127,255}));
  connect(outsideTemperature.port, substation.port_ht)
    annotation (Line(points={{-66,82},{0,82},{0,46}}, color={191,0,0}));
  connect(pipe1.port_sl_b[1], pipe.port_sl_a)
    annotation (Line(points={{-38,-4},{-38,0},{-6,0}}, color={0,127,255}));
  connect(pipe1.port_rl_a, pipe.port_rl_b[1])
    annotation (Line(points={{-26,-4},{8,-4},{8,0}}, color={0,127,255}));
  connect(pipe.port_sl_b[1], substation.port_sl_p) annotation (Line(points={{-6,20},
          {-14,20},{-14,31.4545},{-10,31.4545}},     color={0,127,255}));
  connect(substation.port_rl_p, pipe.port_rl_a) annotation (Line(points={{10,
          31.4545},{14,31.4545},{14,20},{6,20}},
                                        color={0,127,255}));
  connect(soil.port, pipe2.port_ht) annotation (Line(points={{-68,-14},{-50,-14},
          {-50,-30},{54,-30}}, color={191,0,0}));
  connect(soil.port, pipe.port_ht) annotation (Line(points={{-68,-14},{-50,-14},
          {-50,10},{-10,10}}, color={191,0,0}));
  connect(pipe2.port_sl_b[1], pipe.port_sl_a) annotation (Line(points={{58,-20},
          {60,-20},{60,-10},{-6,-10},{-6,0}}, color={0,127,255}));
  connect(pipe.port_rl_b[2], pipe2.port_rl_a) annotation (Line(points={{4,0},{8,
          0},{8,-6},{70,-6},{70,-20}}, color={0,127,255}));
  connect(pipe2.port_rl_b[1], supply_QT.port_rl) annotation (Line(points={{70,-40},
          {70,-48},{82,-48},{82,-60},{74,-60}}, color={0,127,255}));
  connect(pipe2.port_sl_a, supply_QT.port_sl) annotation (Line(points={{58,-40},
          {58,-46},{48,-46},{48,-60},{54,-60}}, color={0,127,255}));
  connect(pulse.y, supply_QT.QSet)
    annotation (Line(points={{59,-84},{70,-84},{70,-72}}, color={0,0,127}));
  connect(substation.port_sl_SH, demandSH.port_a) annotation (Line(points={{10,
          42.3636},{16,42.3636},{16,60},{20,60}},
                                         color={0,127,255}));
  connect(demandSH.port_b, substation.port_rl_SH) annotation (Line(points={{40,60},
          {46,60},{46,38.7273},{10,38.7273}}, color={0,127,255}));
  connect(demandDHW.port_b, substation.port_rl_DHW) annotation (Line(points={{-18,62},
          {-14,62},{-14,38.7273},{-10,38.7273}},     color={0,127,255}));
  annotation (__Dymola_Commands(file="modelica://DisHeatLib/Resources/Scripts/Dymola/Examples/TwoSuppliesOneBuilding.mos"
        "Simulate and plot"), experiment(
      StopTime=604800,
      Interval=900.003,
      __Dymola_Algorithm="Cvode"),
    Documentation(revisions="<html>
<ul>
<li>Feburary 27, 2019, by Benedikt Leitner:<br>Implementation and added User&apos;s guide. </li>
</ul>
</html>", info="<html>
<p>Example with a single substation with an indirect domestic hot water connection and an indirect space heating connection. Heat is supplied by a pressure driven base unit with supply temperature 80&deg;C and an additional unit with supply temperature of 120&deg;C receiving heat demand set-points. </p>
</html>"));
end TwoSuppliesOneBuilding;
