within DisHeatLib.Storage.Examples;
model StorageTankHex
  extends Modelica.Icons.Example;
  package Medium = IBPSA.Media.Water;

  DisHeatLib.Storage.StorageTankHex
                                 storageTankHex(
    show_T=true,
    redeclare package Medium = Medium,
    Q1_flow_nominal(displayUnit="kW") = 100000,
    Q2_flow_nominal(displayUnit="kW") = 50000,
    TemSup1_nominal=318.15,
    TemRet1_nominal=288.15,
    TemSup2_nominal=313.15,
    TemRet2_nominal=283.15,
    VTan=5,
    hTan=2,
    nSeg=4,
    nInit=4)
    annotation (Placement(transformation(extent={{-10,0},{10,20}})));
  IBPSA.Fluid.Sources.MassFlowSource_T
                                  boundary(
    redeclare package Medium = Medium,
    use_m_flow_in=true,
    m_flow=0.1,
    use_T_in=false,
    T=318.15,
    nPorts=1)
    annotation (Placement(transformation(extent={{-56,24},{-36,44}})));
  IBPSA.Fluid.Sources.Boundary_pT bou_RL_p(
    redeclare package Medium = Medium,
    use_T_in=false,
    p=100000,
    T=313.15,
    nPorts=1) annotation (Placement(transformation(extent={{54,24},{34,44}})));
  IBPSA.Fluid.HeatExchangers.SensibleCooler_T cooler(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    dp_nominal(displayUnit="bar") = 300000)
    annotation (Placement(transformation(extent={{-30,-50},{-10,-30}})));
  Modelica.Blocks.Sources.RealExpression TConst(y=10.0 + 273.15)                      annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-54,-32})));
  IBPSA.Fluid.Movers.FlowControlled_m_flow pump(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=1,
    inputType=IBPSA.Fluid.Types.InputType.Continuous,
    addPowerToMedium=false,
    riseTime(displayUnit="min"),
    nominalValuesDefineDefaultPressureCurve=true,
    dp_nominal=1,
    constantMassFlowRate=0.1)
    annotation (Placement(transformation(extent={{10,-30},{30,-50}})));
  Modelica.Blocks.Sources.Pulse pulse(
    amplitude=storageTankHex.m2_flow_nominal,
    width=10,
    period(displayUnit="h") = 18000,
    startTime(displayUnit="h"))
    annotation (Placement(transformation(extent={{-16,-84},{4,-64}})));
  Controls.twopoint_control storage_control(
    u_min=40 + 273.15,
    u_bandwidth=3)
    annotation (Placement(transformation(extent={{-44,58},{-64,78}})));
  Modelica.Blocks.Math.Gain gain(k=storageTankHex.m1_flow_nominal)
                                                   annotation (Placement(
        transformation(
        extent={{-4,-4},{4,4}},
        rotation=-90,
        origin={-74,60})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow
    prescribedHeatFlow annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,42})));
  Controls.twopoint_control storage_control1(
    u_min=60 + 273.15,
    u_bandwidth=6)
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={0,84})));
  Modelica.Blocks.Math.Gain gain1(k=10000)         annotation (Placement(
        transformation(
        extent={{-4,-4},{4,4}},
        rotation=-90,
        origin={0,60})));
  IBPSA.Fluid.Storage.ExpansionVessel exp(redeclare package Medium = Medium,
      V_start=0.1)
    annotation (Placement(transformation(extent={{60,-24},{80,-4}})));
equation
  connect(cooler.TSet,TConst. y)
    annotation (Line(points={{-32,-32},{-43,-32}},
                                                 color={0,0,127}));
  connect(pump.port_a,cooler. port_b)
    annotation (Line(points={{10,-40},{-10,-40}},
                                                color={0,127,255}));
  connect(boundary.ports[1], storageTankHex.port_a1) annotation (Line(points=
         {{-36,34},{-14,34},{-14,16},{-10,16}}, color={0,127,255}));
  connect(storageTankHex.port_b1, bou_RL_p.ports[1]) annotation (Line(points=
         {{10,16},{22,16},{22,34},{34,34}}, color={0,127,255}));
  connect(storageTankHex.port_a2, pump.port_b) annotation (Line(points={{10,4},
          {52,4},{52,-40},{30,-40}}, color={0,127,255}));
  connect(cooler.port_a, storageTankHex.port_b2) annotation (Line(points={{-30,
          -40},{-40,-40},{-40,4},{-10,4}}, color={0,127,255}));
  connect(pulse.y, pump.m_flow_in)
    annotation (Line(points={{5,-74},{20,-74},{20,-52}}, color={0,0,127}));
  connect(storage_control.y, gain.u) annotation (Line(points={{-65,68},{-74,68},
          {-74,64.8}}, color={0,0,127}));
  connect(gain.y, boundary.m_flow_in) annotation (Line(points={{-74,55.6},{-74,
          42},{-58,42}}, color={0,0,127}));
  connect(gain1.y, prescribedHeatFlow.Q_flow)
    annotation (Line(points={{0,55.6},{0,52}}, color={0,0,127}));
  connect(storage_control1.y, gain1.u)
    annotation (Line(points={{0,73},{0,64.8}}, color={0,0,127}));
  connect(storageTankHex.TemTank[3], storage_control.u) annotation (Line(
        points={{4,-1.25},{4,-10},{20,-10},{20,68},{-42,68}}, color={0,0,127}));
  connect(storageTankHex.TemTank[1], storage_control1.u) annotation (Line(
        points={{4,-0.25},{4,-10},{20,-10},{20,96},{6.66134e-16,96}}, color={
          0,0,127}));
  connect(prescribedHeatFlow.port, storageTankHex.heaPorVol[1])
    annotation (Line(points={{0,32},{0,19.55}}, color={191,0,0}));
  connect(exp.port_a, pump.port_b) annotation (Line(points={{70,-24},{66,-24},
          {66,-32},{30,-32},{30,-40}}, color={0,127,255}));
  annotation (__Dymola_Commands(file="modelica://DisHeatLib/Resources/Scripts/Dymola/Storage/Examples/StorageTankHex.mos"
        "Simulate and plot"),
        Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(
      StopTime=259200,
      Interval=900.00288,
      __Dymola_Algorithm="Cvode"),
    Documentation(revisions="<html>
<ul>
<li>Feburary 27, 2019, by Benedikt Leitner:<br>Implementation and added User&apos;s guide. </li>
</ul>
</html>"));
end StorageTankHex;
