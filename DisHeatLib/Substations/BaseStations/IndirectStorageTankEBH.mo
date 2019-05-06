within DisHeatLib.Substations.BaseStations;
model IndirectStorageTankEBH
  extends IndirectStorageTank(
  nSegMeasure=nSegEBH+1,
  total_power(y=EBH.P));


  parameter Modelica.SIunits.Power Q_flow_nominal_EBH = Q2_flow_nominal "Heat capacity of EBH"
    annotation(Dialog(group="Electric booster heater"));
  parameter Modelica.SIunits.Temperature T_min_EBH = TemSup2_nominal "Reference temperature of EBH"
    annotation(Dialog(group="Electric booster heater"));
  parameter Modelica.SIunits.TemperatureDifference T_bandwidth_EBH = 4.0 "Temperature bandwidth of EBH"
    annotation(Dialog(group="Electric booster heater"));
  parameter Integer nSegEBH=1 "Number of top tank segments heated by EBH"
    annotation(Dialog(group="Electric booster heater"));
  parameter Modelica.SIunits.Efficiency eff_EBH = 0.97 "Power-to-heat efficiency of EBH"
    annotation(Dialog(group="Electric booster heater"));

  Supply.BaseClasses.ElectricHeatingRod EBH(
    Q_flow_nominal=Q_flow_nominal_EBH,
    eff=eff_EBH,
    nPorts=nSegEBH,
    u_min=T_min_EBH,
    u_bandwidth=T_bandwidth_EBH) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-12,-28})));
equation
  connect(EBH.port, storageTank.heaPorVol[1:nSegEBH])
    annotation (Line(points={{-12,-38},{-10,-38},{-10,-44}},
                                             color={191,0,0}));
  connect(storageTank.TemTank[1], EBH.u) annotation (Line(points={{-10,-65},{-10,
          -80},{10,-80},{10,-10},{-12,-10},{-12,-16}}, color={0,0,127}));
  annotation (Icon(graphics={
        Line(
          points={{-12,10},{-18,10},{-18,10},{-18,-22},{-8,-8},{2,-22},{12,-8},{
              22,-22},{22,10},{16,10}},
          color={0,0,0},
          thickness=1),
        Ellipse(
          extent={{-14,22},{18,-10}},
          lineColor={0,0,0},
          fillColor={247,247,247},
          fillPattern=FillPattern.Solid,
          lineThickness=0.5),
        Polygon(
          points={{4,20},{2,8},{8,8},{0,-8},{2,4},{-4,4},{4,20}},
          lineColor={0,0,0},
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid,
          lineThickness=0.5)}));
end IndirectStorageTankEBH;
