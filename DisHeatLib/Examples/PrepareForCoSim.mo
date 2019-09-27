within DisHeatLib.Examples;
model PrepareForCoSim
  extends Network.baseLowTemQT;
  Utilities.FMI.FMIhelper fMIhelper[14](deltaT=900, mode=DisHeatLib.Utilities.FMI.FMIInterfaceType.Mean)
    annotation (Placement(transformation(extent={{-120,-110},{-100,-90}})));
  Modelica.Blocks.Sources.RealExpression PBld1(y=Building1.substation.P)
    annotation (Placement(transformation(extent={{-162,-110},{-142,-90}})));
  Modelica.Blocks.Sources.RealExpression PBld2(y=Building2.substation.P)
    annotation (Placement(transformation(extent={{-162,-124},{-142,-104}})));
  Utilities.FMI.FMIhelper fMIhelper1(deltaT=900, mode=DisHeatLib.Utilities.FMI.FMIInterfaceType.Mean)
    annotation (Placement(transformation(extent={{14,-152},{34,-132}})));
  Modelica.Blocks.Sources.RealExpression PBld3(y=Building3.substation.P)
    annotation (Placement(transformation(extent={{-162,-138},{-142,-118}})));
  Modelica.Blocks.Sources.RealExpression PBld4(y=Building4.substation.P)
    annotation (Placement(transformation(extent={{-162,-152},{-142,-132}})));
  Modelica.Blocks.Sources.RealExpression PBld5(y=Building5.substation.P)
    annotation (Placement(transformation(extent={{-162,-168},{-142,-148}})));
  Modelica.Blocks.Sources.RealExpression PBld6(y=Building6.substation.P)
    annotation (Placement(transformation(extent={{-162,-184},{-142,-164}})));
  Modelica.Blocks.Sources.RealExpression PBld7(y=Building7.substation.P)
    annotation (Placement(transformation(extent={{-100,-184},{-120,-164}})));
  Modelica.Blocks.Sources.RealExpression PBld8(y=Building8.substation.P)
    annotation (Placement(transformation(extent={{-100,-168},{-120,-148}})));
  Modelica.Blocks.Sources.RealExpression PBld9(y=Building9.substation.P)
    annotation (Placement(transformation(extent={{-100,-152},{-120,-132}})));
  Modelica.Blocks.Sources.RealExpression PBld10(y=Building10.substation.P)
    annotation (Placement(transformation(extent={{-100,-138},{-120,-118}})));
  Modelica.Blocks.Sources.RealExpression PBld11(y=Building11.substation.P)
    annotation (Placement(transformation(extent={{-68,-138},{-88,-118}})));
  Modelica.Blocks.Sources.RealExpression PBld12(y=Building12.substation.P)
    annotation (Placement(transformation(extent={{-68,-152},{-88,-132}})));
  Modelica.Blocks.Sources.RealExpression PBld13(y=Building13.substation.P)
    annotation (Placement(transformation(extent={{-68,-168},{-88,-148}})));
  Modelica.Blocks.Sources.RealExpression PBld14(y=Building14.substation.P)
    annotation (Placement(transformation(extent={{-68,-184},{-88,-164}})));
  Modelica.Blocks.Sources.RealExpression PQT(y=supply_QT.P)
    annotation (Placement(transformation(extent={{-22,-152},{-2,-132}})));
equation
  connect(PBld1.y, fMIhelper[1].u)
    annotation (Line(points={{-141,-100},{-122,-100}}, color={0,0,127}));
  connect(PBld2.y, fMIhelper[2].u) annotation (Line(points={{-141,-114},{-132,
          -114},{-132,-100},{-122,-100}}, color={0,0,127}));
  connect(PBld3.y, fMIhelper[3].u) annotation (Line(points={{-141,-128},{-132,
          -128},{-132,-100},{-122,-100}}, color={0,0,127}));
  connect(PBld4.y, fMIhelper[4].u) annotation (Line(points={{-141,-142},{-132,
          -142},{-132,-100},{-122,-100}}, color={0,0,127}));
  connect(PBld5.y, fMIhelper[5].u) annotation (Line(points={{-141,-158},{-132,
          -158},{-132,-100},{-122,-100}}, color={0,0,127}));
  connect(PBld6.y, fMIhelper[6].u) annotation (Line(points={{-141,-174},{-132,
          -174},{-132,-100},{-122,-100}}, color={0,0,127}));
  connect(PBld7.y, fMIhelper[7].u) annotation (Line(points={{-121,-174},{-132,
          -174},{-132,-100},{-122,-100}}, color={0,0,127}));
  connect(PBld8.y, fMIhelper[8].u) annotation (Line(points={{-121,-158},{-132,
          -158},{-132,-100},{-122,-100}}, color={0,0,127}));
  connect(PBld9.y, fMIhelper[9].u) annotation (Line(points={{-121,-142},{-132,
          -142},{-132,-100},{-122,-100}}, color={0,0,127}));
  connect(PBld10.y, fMIhelper[10].u) annotation (Line(points={{-121,-128},{-132,
          -128},{-132,-100},{-122,-100}}, color={0,0,127}));
  connect(PBld11.y, fMIhelper[11].u) annotation (Line(points={{-89,-128},{-96,
          -128},{-96,-114},{-132,-114},{-132,-100},{-122,-100}}, color={0,0,127}));
  connect(PBld12.y, fMIhelper[12].u) annotation (Line(points={{-89,-142},{-96,
          -142},{-96,-114},{-132,-114},{-132,-100},{-122,-100}}, color={0,0,127}));
  connect(PBld13.y, fMIhelper[13].u) annotation (Line(points={{-89,-158},{-96,
          -158},{-96,-114},{-132,-114},{-132,-100},{-122,-100}}, color={0,0,127}));
  connect(PBld14.y, fMIhelper[14].u) annotation (Line(points={{-89,-174},{-96,
          -174},{-96,-114},{-132,-114},{-132,-100},{-122,-100}}, color={0,0,127}));
  connect(PQT.y, fMIhelper1.u)
    annotation (Line(points={{-1,-142},{12,-142}}, color={0,0,127}));
  annotation (Documentation(info="<html>
<p>This example extendends baseLowTemQT such that it can be linked to an electric simulation by using the model &quot;FMIhelper&quot; which takes averages of power consumption values over 15 minutes, to communicate those with an electric steady-state simulation.</p>
<p>Before simulating it is recommended to type &quot;Advanced.SparseActivate=true&quot; into the commands to reduce computation time substantially.</p>
<h4>Available commands:</h4>
<ul>
<li>Simulate 1 week: Simulates the model for a duration of 1 week after using the command &quot;Advanced.SparseActivate=true&quot;</li>
<li>Simulate 1 day: Simulates the model for a duration of 1 day after using the command &quot;Advanced.SparseActivate=true&quot;</li>
</ul>
<p><br>After simulating there are 8 different plot commands available to better understand this example:</p>
<ol>
<li>This plot compares the demand to the actual supply of space heating each building is receiving by both overlapping the two curves and plotting their difference below. After a short starting period the difference is negligibly small, since space heating demand is quite smooth.</li>
<li>This plot compares the demand to the actual supply of domestic hot water each building is receiving by both overlapping the two curves and plotting their difference below. The difference isn&apos;t negligible as domestic hot water demand can change rapidly and by great amounts, but still is rather small compared to the values of the demand. (To highlight the differences in the plot click on peaks dipping below the x-axis.)</li>
<li>This plot compares the temperature of the water flowing in and out of the building therefor showing how the consumption affects the temperature in the supply.</li>
<li>This plot shows the difference in pressure of the water in the buildings before and after consumption.</li>
<li>This plot shows the mass flow of the water in the buildings before and after consumption.</li>
<li>This plot shows the losses of heat through the pipes and the temperature of the water returning to the supply station, for reference the supply temperature is plotted aswell.</li>
<li>This plot compares the mass flow and the heat flow of the two different supplies.</li>
<li>This plot shows how the FMIHelper takes the average of the power concumption of a building in short time windows to allow a co-simulation with an electric simulation.</li>
</ol>
</html>"), __Dymola_Commands(
      file=
          "Resources/Scripts/Dymola/Examples/PrepareForCoSim/PrepareForCoSimSimulateWeek.mos"
        "Simulate 1 week",
      file=
          "Resources/Scripts/Dymola/Examples/PrepareForCoSim/PrepareForCoSimSimulateDay.mos"
        "Simulate 1 day",
      file=
          "Resources/Scripts/Dymola/Examples/PrepareForCoSim/PrepareForCoSimSupplyAndDemandSpaceHeating.mos"
        "1. Plot supply and demand space heating",
      file=
          "Resources/Scripts/Dymola/Examples/PrepareForCoSim/PrepareForCoSimSupplyAndDemandDomesticHotWater.mos"
        "2. Plot supply and demand domestic hot water",
      file=
          "Resources/Scripts/Dymola/Examples/PrepareForCoSim/PrepareForCoSimBuildingSupplyAndReturnTemperature.mos"
        "3. Plot incoming and outgoing temperature",
      file=
          "Resources/Scripts/Dymola/Examples/PrepareForCoSim/PrepareForCoSimDifferentialPressure.mos"
        "4. Plot differential pressure",
      file=
          "Resources/Scripts/Dymola/Examples/PrepareForCoSim/PrepareForCoSimMassFlow.mos"
        "5. Plot mass flow",
      file=
          "Resources/Scripts/Dymola/Examples/PrepareForCoSim/PrepareForCoSimLossAndReturnTemperature.mos"
        "6. Plot heat loss and return temperature",
      file=
          "Resources/Scripts/Dymola/Examples/PrepareForCoSim/PrepareForCoSimSupplyHeatAndMassFlow.mos"
        "7. Plot heat and mass flow of both supplies",
      file=
          "Resources/Scripts/Dymola/Examples/PrepareForCoSim/PrepareForCoSimFMIHelper.mos"
        "8. Plot power consumption of a building and the corresponding FMIHelper function"));
end PrepareForCoSim;
