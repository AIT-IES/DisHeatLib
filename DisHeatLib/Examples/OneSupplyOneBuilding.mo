within DisHeatLib.Examples;
model OneSupplyOneBuilding
  extends Modelica.Icons.Example;
  import DisHeatLib;
  package Medium = IBPSA.Media.Water;

  DisHeatLib.Demand.Demand demandSH(
    redeclare package Medium = Medium,
    FlowType=DisHeatLib.Substations.BaseClasses.BaseStationFlowType.Valve,
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

  DisHeatLib.Pipes.DualPipe pipe(
    redeclare package Medium = Medium,
    L=100,
    redeclare DisHeatLib.Pipes.Library.Isoplus.Isoplus_Std_DN25 pipeType,
    nPorts_rl=1,
    nPorts_sl=1)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,-14})));
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
    TemSup_nominal=353.15,
    TemRet_nominal=318.15,
    dp_nominal(displayUnit="bar") = 100000,
    TemOut_min=268.15,
    TemOut_max=288.15,
    TemSup_min=343.15,
    TemSup_max=333.15,
    dp_min(displayUnit="bar") = 500000,
    dp_max(displayUnit="bar") = 1000000)
    annotation (Placement(transformation(extent={{10,-54},{-10,-74}})));
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
    annotation (Placement(transformation(extent={{-40,52},{-20,72}})));

  DisHeatLib.Substations.Substation substation(
    redeclare package Medium = Medium,
    FlowType=DisHeatLib.Substations.BaseClasses.BaseStationFlowType.Valve,
    TemSup_nominal=343.15,
    dp_nominal=100000,
    redeclare DisHeatLib.Substations.BaseClasses.IndirectBaseStation
      BaseStationDHW(
      Q_flow_nominal(displayUnit="kW") = 10000,
      OutsideDependent=false,
      Ti=120),
    redeclare DisHeatLib.Substations.BaseClasses.DirectBaseStation
      BaseStationSH(Q_flow_nominal(displayUnit="kW") = 10000))
    annotation (Placement(transformation(extent={{-10,26},{10,46}})));
equation
  connect(pipe.port_ht,soil. port)
    annotation (Line(points={{-10,-14},{-68,-14}}, color={191,0,0}));
  connect(baseSupply.port_sl,pipe. port_sl_a) annotation (Line(points={{-10,-64},
          {-20,-64},{-20,-42},{-6,-42},{-6,-24}},   color={0,127,255}));
  connect(pipe.port_rl_b[1], baseSupply.port_rl) annotation (Line(points={{6,-24},
          {6,-42},{20,-42},{20,-64},{10,-64}},           color={0,127,255}));
  connect(substation.dp, baseSupply.dp_measure) annotation (Line(points={{11,36.9091},
          {36,36.9091},{36,-82},{6,-82},{6,-76}},     color={0,0,127}));
  connect(substation.port_sl_DHW,demandDHW. port_a) annotation (Line(points={{-10,
          42.3636},{-42,42.3636},{-42,62},{-40,62}},     color={0,127,255}));
  connect(pipe.port_sl_b[1], substation.port_sl_p) annotation (Line(points={{-6,-4},
          {-6,20},{-16,20},{-16,31.4545},{-10,31.4545}},     color={0,127,255}));
  connect(pipe.port_rl_a, substation.port_rl_p) annotation (Line(points={{6,-4},{
          6,20},{16,20},{16,31.4545},{10,31.4545}},  color={0,127,255}));
  connect(outsideTemperature.port, substation.port_ht)
    annotation (Line(points={{-66,82},{0,82},{0,46}}, color={191,0,0}));
  connect(substation.port_rl_DHW, demandDHW.port_b) annotation (Line(points={{
          -10,38.7273},{-16,38.7273},{-16,62},{-20,62}}, color={0,127,255}));
  connect(substation.port_sl_SH, demandSH.port_a) annotation (Line(points={{10,
          42.3636},{14,42.3636},{14,60},{20,60}}, color={0,127,255}));
  connect(demandSH.port_b, substation.port_rl_SH) annotation (Line(points={{40,
          60},{42,60},{42,38.7273},{10,38.7273}}, color={0,127,255}));
  annotation (__Dymola_Commands(file="modelica://DisHeatLib/Resources/Scripts/Dymola/Examples/OneSupplyOneBuilding.mos"
        "Simulate and plot"), experiment(
      StopTime=604800,
      Interval=900.00288,
      Tolerance=1e-06,
      __Dymola_Algorithm="Radau"),
    Documentation(revisions="<html>
<ul>
<li>Feburary 27, 2019, by Benedikt Leitner:<br>Implementation and added User&apos;s guide. </li>
</ul>
</html>", info="<html>
<p>Example of a single pressure supply unit providing heat through one pipe to a single substation with a indirect domestic hot water connection and a direct space heating connection.</p>
</html>"));
end OneSupplyOneBuilding;