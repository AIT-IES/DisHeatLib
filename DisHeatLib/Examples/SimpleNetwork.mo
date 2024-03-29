within DisHeatLib.Examples;
package SimpleNetwork
  extends Modelica.Icons.ExamplesPackage;
  model OneSupplyOneBuilding
    extends Modelica.Icons.Example;
    import DisHeatLib;
    package Medium = IBPSA.Media.Water;

    DisHeatLib.Demand.Demand demandSH(
      redeclare package Medium = Medium,
      flowUnit(FlowType=DisHeatLib.BaseClasses.FlowType.Valve),
      dp_nominal=100000,
      tableName="SHprofile",
      fileName="Resources/Data/SHprofile.txt",
      redeclare DisHeatLib.Demand.BaseDemands.Radiator demandType,
      Q_constant(displayUnit="kW") = 100000,
      heatLoad=DisHeatLib.Demand.BaseClasses.InputTypeDemand.FileQ,
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
      T_const=283.15,
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
      SupplyTemperature=DisHeatLib.Supply.BaseClasses.InputTypeSupplyTemp.Constant,
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
      annotation (Placement(transformation(extent={{10,-74},{-10,-54}})));

    DisHeatLib.Demand.Demand demandDHW(
      redeclare package Medium = Medium,
      dp_nominal(displayUnit="bar") = 400000,
      tableName="Table",
      fileName="Resources/Data/DHWprofile_E2340_P40.txt",
      redeclare DisHeatLib.Demand.BaseDemands.FixedReturn demandType,
      Q_constant(displayUnit="kW") = 100000,
      heatLoad=DisHeatLib.Demand.BaseClasses.InputTypeDemand.FileQ,
      Q_flow_nominal(displayUnit="kW") = 10000,
      TemSup_nominal=333.15,
      TemRet_nominal=288.15)
      annotation (Placement(transformation(extent={{-40,52},{-20,72}})));

    DisHeatLib.Substations.SubstationParallel substation(
      dp1_nominal=100000,
      redeclare DisHeatLib.Substations.BaseStations.DirectStation baseStation2(
          Q1_flow_nominal=10000),
      redeclare DisHeatLib.Substations.BaseStations.StorageTankHexEBH
        baseStation1(
        Q1_flow_nominal=10000,
        Q2_flow_nominal=10000,
        VTan=1,
        hTan=1,
        Q_flow_nominal_EBH(displayUnit="kW") = 2000,
        T_min_EBH=333.15,
        T_bandwidth_EBH=4,
        eff_EBH=1),
      use_bypass=false,
      redeclare package Medium = Medium,
      TemSup_nominal=323.15)
      annotation (Placement(transformation(extent={{-10,26},{10,46}})));
    Modelica.Blocks.Sources.RealExpression dp_measure_min(y=substation.senRelPre.p_rel)
      annotation (Placement(transformation(extent={{42,-86},{22,-66}})));
  equation
    connect(pipe.port_ht,soil. port)
      annotation (Line(points={{-10,-14},{-68,-14}}, color={191,0,0}));
    connect(substation.port_b3, demandSH.port_a) annotation (Line(points={{10,28},
            {12,28},{12,60},{20,60}}, color={0,127,255}));
    connect(substation.port_a3, demandSH.port_b) annotation (Line(points={{10,32},
            {46,32},{46,60},{40,60}}, color={0,127,255}));
    connect(substation.port_b2, demandDHW.port_a) annotation (Line(points={{-10,
            28},{-44,28},{-44,62},{-40,62}}, color={0,127,255}));
    connect(demandDHW.port_b, substation.port_a2) annotation (Line(points={{-20,
            62},{-14,62},{-14,32},{-10,32}}, color={0,127,255}));
    connect(pipe.ports_b1[1], substation.port_a1) annotation (Line(points={{-6,-4},
            {-6,16},{-10,16},{-10,42}}, color={0,127,255}));
    connect(pipe.port_a2, substation.port_b1) annotation (Line(points={{6,-4},{6,
            16},{10,16},{10,42}}, color={0,127,255}));
    connect(pipe.ports_b2[1], baseSupply.port_a) annotation (Line(points={{6,-24},
            {6,-40},{16,-40},{16,-64},{10,-64}}, color={0,127,255}));
    connect(baseSupply.ports_b[1], pipe.port_a1) annotation (Line(points={{-10,
            -64},{-16,-64},{-16,-40},{-6,-40},{-6,-24}}, color={0,127,255}));
    connect(baseSupply.dp_measure, dp_measure_min.y)
      annotation (Line(points={{6,-52},{14,-52},{14,-76},{21,-76}},
                                                  color={0,0,127}));
    annotation (__Dymola_Commands(file="modelica://DisHeatLib/Resources/Scripts/Dymola/Examples/SimpleNetwork/OneSupplyOneBuilding.mos"
          "Simulate and plot"), experiment(
        StopTime=604800,
        Interval=900.00288,
        Tolerance=1e-06,
        __Dymola_Algorithm="Radau"),
      Documentation(revisions="<html>
<ul>
<li>Feburary 27, 2019, by Benedikt Leitner:<br>Implementation and added User&apos;s guide. </li>
</ul>
</html>",   info="<html>
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

  model TwoSuppliesOneBuilding
    extends Modelica.Icons.Example;
    import DisHeatLib;
    package Medium = IBPSA.Media.Water;

    DisHeatLib.Demand.Demand demandSH(
      redeclare package Medium = Medium,
      dp_nominal(displayUnit="bar") = 100000,
      tableName="SHprofile",
      fileName="Resources/Data/SHprofile.txt",
      redeclare DisHeatLib.Demand.BaseDemands.Radiator demandType,
      Q_constant(displayUnit="kW") = 100000,
      heatLoad=DisHeatLib.Demand.BaseClasses.InputTypeDemand.FileQ,
      Q_flow_nominal(displayUnit="kW") = 10000,
      TemSup_nominal=323.15,
      TemRet_nominal=303.15)
      annotation (Placement(transformation(extent={{20,54},{40,74}})));

    DisHeatLib.Pipes.DualPipe pipe1(
      redeclare package Medium = Medium,
      L=100,
      redeclare DisHeatLib.Pipes.Library.Isoplus.Isoplus_Std_DN25 pipeType,
      T_sl_init=353.15,
      nPorts2=1,
      nPorts1=1)   annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=90,
          origin={-32,-14})));
    DisHeatLib.Boundary.SoilTemperature soil(
      T_const=283.15,
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
      dp_max(displayUnit="bar") = 1000000,
      nPorts=1)
      annotation (Placement(transformation(extent={{-22,-72},{-42,-52}})));
    DisHeatLib.Boundary.OutsideTemperature outsideTemperature(
      inputType=DisHeatLib.Boundary.BaseClasses.InputTypeOutTemp.File,
      tableName="TempOut",
      fileName="Resources/Data/TempOut.txt")                   annotation (
        Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=-90,
          origin={-74,82})));
    DisHeatLib.Demand.Demand demandDHW(
      redeclare package Medium = Medium,
      dp_nominal(displayUnit="bar") = 100000,
      tableName="Table",
      fileName="Resources/Data/DHWprofile_E2340_P40.txt",
      redeclare DisHeatLib.Demand.BaseDemands.FixedReturn demandType,
      Q_constant(displayUnit="kW") = 100000,
      heatLoad=DisHeatLib.Demand.BaseClasses.InputTypeDemand.FileQ,
      Q_flow_nominal(displayUnit="kW") = 10000,
      TemSup_nominal=333.15,
      TemRet_nominal=283.15)
      annotation (Placement(transformation(extent={{-40,54},{-20,74}})));

    DisHeatLib.Supply.Supply_QT supply_QT(
      redeclare package Medium = Medium,
      Q_flow_nominal(displayUnit="kW") = 50000,
      TemSup_nominal=393.15,
      TemRet_nominal=323.15,
      dp_nominal=100000,
      powerCha(Q_flow={0,1}, P={0,1}),
      use_Q_in=true,
      nPorts=1)
      annotation (Placement(transformation(extent={{74,-50},{54,-70}})));
    DisHeatLib.Pipes.DualPipe pipe(
      redeclare package Medium = Medium,
      L=100,
      redeclare DisHeatLib.Pipes.Library.Isoplus.Isoplus_Std_DN25 pipeType,
      T_sl_init=353.15,
      nPorts2=2,
      nPorts1=1)   annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=90,
          origin={0,10})));
    DisHeatLib.Pipes.DualPipe pipe2(
      redeclare package Medium = Medium,
      L=100,
      redeclare DisHeatLib.Pipes.Library.Isoplus.Isoplus_Std_DN25 pipeType,
      T_sl_init=353.15,
      nPorts1=1,
      nPorts2=1)
      annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=90,
          origin={64,-30})));
    Modelica.Blocks.Sources.Pulse pulse(
      amplitude=7000,
      width=50,
      period(displayUnit="h") = 86400)
      annotation (Placement(transformation(extent={{38,-94},{58,-74}})));
    DisHeatLib.Substations.SubstationParallel substation(
      dp1_nominal=100000,
      redeclare DisHeatLib.Substations.BaseStations.IndirectStation baseStation2(
        Q1_flow_nominal=10000,
        TemSup2_nominal=323.15,
        TemRet2_nominal=303.15,
        Ti=900),
      redeclare DisHeatLib.Substations.BaseStations.IndirectStation baseStation1(
        Q1_flow_nominal=10000,
        TemSup2_nominal=333.15,
        TemRet2_nominal=283.15,
        OutsideDependent=false),
      use_bypass=false,
      redeclare package Medium = Medium,
      TemSup_nominal=343.15)
      annotation (Placement(transformation(extent={{-10,50},{10,30}})));
    Modelica.Blocks.Sources.RealExpression dp_measure_min(y=substation.senRelPre.p_rel)
      annotation (Placement(transformation(extent={{12,-84},{-8,-64}})));
  equation
    connect(pipe1.port_ht, soil.port)
      annotation (Line(points={{-42,-14},{-68,-14}}, color={191,0,0}));
    connect(soil.port, pipe2.port_ht) annotation (Line(points={{-68,-14},{-50,-14},
            {-50,-30},{54,-30}}, color={191,0,0}));
    connect(soil.port, pipe.port_ht) annotation (Line(points={{-68,-14},{-50,-14},
            {-50,10},{-10,10}}, color={191,0,0}));
    connect(pulse.y, supply_QT.QSet)
      annotation (Line(points={{59,-84},{70,-84},{70,-72}}, color={0,0,127}));
    connect(baseSupply.ports_b[1], pipe1.port_a1) annotation (Line(points={{-42,
            -62},{-50,-62},{-50,-38},{-38,-38},{-38,-24}}, color={0,127,255}));
    connect(baseSupply.port_a, pipe1.ports_b2[1]) annotation (Line(points={{-22,
            -62},{-14,-62},{-14,-38},{-26,-38},{-26,-24}}, color={0,127,255}));
    connect(pipe.ports_b2[1], pipe1.port_a2)
      annotation (Line(points={{8,0},{8,-4},{-26,-4}}, color={0,127,255}));
    connect(pipe.ports_b2[2], pipe2.port_a2) annotation (Line(points={{4,0},{8,0},
            {8,-4},{70,-4},{70,-20}}, color={0,127,255}));
    connect(pipe2.ports_b1[1], pipe.port_a1) annotation (Line(points={{58,-20},{
            58,-2},{-6,-2},{-6,0}}, color={0,127,255}));
    connect(pipe1.ports_b1[1], pipe.port_a1)
      annotation (Line(points={{-38,-4},{-38,0},{-6,0}}, color={0,127,255}));
    connect(pipe.ports_b1[1], substation.port_a1) annotation (Line(points={{-6,20},
            {-8,20},{-8,22},{-18,22},{-18,34},{-10,34}}, color={0,127,255}));
    connect(substation.port_b1, pipe.port_a2) annotation (Line(points={{10,34},{
            16,34},{16,22},{6,22},{6,20}}, color={0,127,255}));
    connect(demandSH.port_b, substation.port_a3) annotation (Line(points={{40,64},
            {48,64},{48,44},{10,44}}, color={0,127,255}));
    connect(substation.port_b3, demandSH.port_a) annotation (Line(points={{10,48},
            {14,48},{14,64},{20,64}}, color={0,127,255}));
    connect(demandDHW.port_b, substation.port_a2) annotation (Line(points={{-20,
            64},{-16,64},{-16,44},{-10,44}}, color={0,127,255}));
    connect(demandDHW.port_a, substation.port_b2) annotation (Line(points={{-40,
            64},{-46,64},{-46,48},{-10,48}}, color={0,127,255}));
    connect(supply_QT.port_a, pipe2.ports_b2[1]) annotation (Line(points={{74,-60},
            {84,-60},{84,-44},{70,-44},{70,-40}}, color={0,127,255}));
    connect(pipe2.port_a1, supply_QT.ports_b[1]) annotation (Line(points={{58,-40},
            {58,-44},{44,-44},{44,-60},{54,-60}}, color={0,127,255}));
    connect(outsideTemperature.port, substation.port_ht)
      annotation (Line(points={{-64,82},{0,82},{0,50}}, color={191,0,0}));
    connect(baseSupply.dp_measure,dp_measure_min. y)
      annotation (Line(points={{-26,-50},{-18,-50},{-18,-74},{-9,-74}},
                                                  color={0,0,127}));
    annotation (__Dymola_Commands(file="modelica://DisHeatLib/Resources/Scripts/Dymola/Examples/SimpleNetwork/TwoSuppliesOneBuilding.mos"
          "Simulate and plot"), experiment(
        StopTime=604800,
        Interval=900.003,
        __Dymola_Algorithm="Cvode"),
      Documentation(revisions="<html>
<ul>
<li>Feburary 27, 2019, by Benedikt Leitner:<br>Implementation and added User&apos;s guide. </li>
</ul>
</html>",   info="<html>
<p>Example with a single substation with an indirect domestic hot water connection and an indirect space heating connection. Heat is supplied by a pressure driven base unit with supply temperature 80&deg;C and an additional unit with supply temperature of 120&deg;C receiving heat demand set-points. </p>
</html>"));
  end TwoSuppliesOneBuilding;
  annotation (Documentation(info="<html>
<p>This package contains two simpler example, that serve as an easy introduction to district heating simulations.</p>
</html>"));
end SimpleNetwork;
