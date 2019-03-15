within DisHeatLib.Examples;
model OneSupplyOneBuilding
  extends Modelica.Icons.Example;
  import DisHeatLib;
  package Medium = IBPSA.Media.Water;

  DisHeatLib.Demand.Demand demandSH(
    redeclare package Medium = Medium,
    show_T=true,
    flowUnit(FlowType=DisHeatLib.BaseClasses.FlowType.Valve),
    dp_nominal=100000,
    tableName="SHprofile",
    fileName="modelica://DisHeatLib/Resources/Data/SHprofile.txt",
    redeclare DisHeatLib.Demand.BaseClasses.Radiator demandType,
    Q_constant(displayUnit="kW") = 100000,
    heatLoad=DisHeatLib.Demand.BaseClasses.InputTypeQ.File,
    Q_flow_nominal(displayUnit="kW") = 10000,
    TemSup_nominal=318.15,
    TemRet_nominal=303.15)
    annotation (Placement(transformation(extent={{20,50},{40,70}})));

  DisHeatLib.Pipes.DualPipe pipe(
    redeclare package Medium = Medium,
    L=100,
    redeclare DisHeatLib.Pipes.Library.Isoplus.Isoplus_Std_DN25 pipeType,
    nPorts1=1,
    nPorts2=1)
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
    dp_set=100000,
    k=1,
    TemSup_nominal=323.15,
    TemRet_nominal=293.15,
    dp_nominal(displayUnit="bar") = 100000,
    TemOut_min=268.15,
    TemOut_max=288.15,
    TemSup_min=343.15,
    TemSup_max=333.15,
    dp_min(displayUnit="bar") = 100000,
    dp_max(displayUnit="bar") = 1000000,
    nPorts=1)
    annotation (Placement(transformation(extent={{10,-54},{-10,-74}})));
  DisHeatLib.Demand.Demand demandDHW(
    redeclare package Medium = Medium,
    show_T=true,
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
    show_T=true,
    use_bypass=false,
    redeclare DisHeatLib.Substations.BaseClasses.DirectStation baseStationSH(
        Q1_flow_nominal=10000),
    redeclare DisHeatLib.Substations.BaseClasses.StorageTankHexEBH
      baseStationDHW(
      Q1_flow_nominal=10000,
      Q2_flow_nominal=10000,
      VTan=1,
      hTan=1,
      u_min=45 + 273.15,
      u_bandwidth=4,
      Q_flow_nominal_EBH(displayUnit="kW") = 2000,
      T_min_EBH=333.15,
      T_bandwidth_EBH=4,
      eff_EBH=1),
    redeclare package Medium = Medium,
    TemSup_nominal=323.15,
    dp_nominal=100000)
    annotation (Placement(transformation(extent={{-10,26},{10,46}})));
equation
  connect(pipe.port_ht,soil. port)
    annotation (Line(points={{-10,-14},{-68,-14}}, color={191,0,0}));
  connect(substation.dp, baseSupply.dp_measure) annotation (Line(points={{0,
          26.9091},{36,26.9091},{36,-82},{6,-82},{6,-76}},
                                                      color={0,0,127}));
  connect(substation.port_b_SH, demandSH.port_a) annotation (Line(points={{10,
          42.3636},{12,42.3636},{12,60},{20,60}}, color={0,127,255}));
  connect(substation.port_a_SH, demandSH.port_b) annotation (Line(points={{10,
          38.7273},{46,38.7273},{46,60},{40,60}}, color={0,127,255}));
  connect(substation.port_b_DHW, demandDHW.port_a) annotation (Line(points={{-10,
          42.3636},{-44,42.3636},{-44,62},{-40,62}},     color={0,127,255}));
  connect(demandDHW.port_b, substation.port_a_DHW) annotation (Line(points={{-20,62},
          {-14,62},{-14,38.7273},{-10,38.7273}},         color={0,127,255}));
  connect(pipe.ports_b1[1], substation.port_a) annotation (Line(points={{-6,-4},
          {-6,16},{-10,16},{-10,31.4545}}, color={0,127,255}));
  connect(pipe.port_a2, substation.port_b) annotation (Line(points={{6,-4},{6,
          16},{10,16},{10,31.4545}}, color={0,127,255}));
  connect(pipe.ports_b2[1], baseSupply.port_a) annotation (Line(points={{6,-24},
          {6,-40},{16,-40},{16,-64},{10,-64}}, color={0,127,255}));
  connect(baseSupply.ports_b[1], pipe.port_a1) annotation (Line(points={{-10,
          -64},{-16,-64},{-16,-40},{-6,-40},{-6,-24}}, color={0,127,255}));
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
<p>This example contains the following function units:</p>
<ul>
<li>a supply unit working as pressure and temperature source</li>
<li>a dual pipe for fluid transport (supply and return)</li>
<li>a substation with a thermal storage tank and electric booster heater for domestic hot water supply and a direct connection for space heating</li>
<li>a domestic hot water demand with heat demand value from a file and with a constant return temperature</li>
<li>a space heating demand with heat demand value from a file and with a varying return temperature</li>
</ul>
</html>"));
end OneSupplyOneBuilding;
