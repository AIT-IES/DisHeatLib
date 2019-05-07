within DisHeatLib.Substations;
model SubstationParallel
  extends BaseClasses.SubstationParallelInterface(
    final m1_flow_nominal=baseStation1.m1_flow_nominal+baseStation2.m1_flow_nominal,
    final m2_flow_nominal=baseStation1.m1_flow_nominal,
    final m3_flow_nominal=baseStation2.m1_flow_nominal,
      total_power(y=baseStation2.P + baseStation1.P));

  // General
  parameter Modelica.SIunits.Temperature TemSup_nominal(displayUnit="degC")
    "Nominal supply temperature"
    annotation(Dialog(group = "Nominal condition"));

  // Bypass valve
  parameter Boolean use_bypass = true "Use a bypass valve"
    annotation(Dialog(group="Bypass"), HideResult=true, choices(checkBox=true));

protected
      final parameter Modelica.SIunits.SpecificHeatCapacity cp_default=
        Medium.cp_const
        "Specific heat capacity of the fluid";
public
  replaceable BaseClasses.BaseStation baseStation1 constrainedby
    BaseClasses.BaseStation(
    final allowFlowReversal1=allowFlowReversal1,
    final m1_flow_small=m1_flow_small,
    redeclare final package Medium = Medium,
    final from_dp=from_dp1,
    final linearizeFlowResistance=linearizeFlowResistance1,
    final TemSup1_nominal=TemSup_nominal,
    final dp1_nominal=dp1_nominal) annotation (
    Dialog(group="Substation model 1"),
    Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={-50,-60})),
    __Dymola_choicesAllMatching=true);
  replaceable BaseClasses.BaseStation baseStation2 constrainedby
    BaseClasses.BaseStation(
    final allowFlowReversal1=allowFlowReversal1,
    final m1_flow_small=m1_flow_small,
    redeclare final package Medium = Medium,
    final from_dp=from_dp1,
    final linearizeFlowResistance=linearizeFlowResistance1,
    final TemSup1_nominal=TemSup_nominal,
    final dp1_nominal=dp1_nominal) annotation (
    Dialog(group="Substation model 2"),
    Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=-90,
        origin={50,-60})),
    __Dymola_choicesAllMatching=true);
public
  IBPSA.Fluid.Sensors.TemperatureTwoPort senTemSL(redeclare package Medium =
        Medium,
    allowFlowReversal=allowFlowReversal1,
    m_flow_nominal=m1_flow_nominal,
    m_flow_small=m1_flow_small,
    T(displayUnit="degC"),
    initType=Modelica.Blocks.Types.Init.InitialOutput,
    T_start=TemSup_nominal,
    transferHeat=true,
    TAmb=293.15)
    annotation (Placement(transformation(extent={{-86,50},{-66,70}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_ht if baseStation1.OutsideDependent
     or baseStation2.OutsideDependent   "Outside temperature port"
    annotation (Placement(transformation(extent={{-10,-110},{10,-90}})));
  replaceable
  BaseClasses.Bypass bypass(
    redeclare final package Medium = Medium,
    final allowFlowReversal=allowFlowReversal,
    m_flow_nominal=0.03*m_flow_nominal,
    final m_flow_small=m_flow_small,
    final from_dp=from_dp,
    final dp_nominal=dp_nominal,
    final linearizeFlowResistance=linearizeFlowResistance) if use_bypass
                                   constrainedby BaseClasses.Bypass
    annotation (Dialog(group = "Bypass", enable=use_bypass), Placement(transformation(extent={{-10,50},
            {10,70}})));
protected
  IBPSA.Fluid.FixedResistances.Junction jun1(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    T_start=TemSup_nominal,
    dp_nominal={0,0,0},
    m_flow_nominal={m1_flow_nominal,m1_flow_nominal,m1_flow_nominal}) if
                              use_bypass
    annotation (Placement(transformation(extent={{-46,54},{-34,66}})));
  IBPSA.Fluid.FixedResistances.Junction jun2(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    T_start=TemSup_nominal,
    dp_nominal={0,0,0},
    m_flow_nominal={m1_flow_nominal,baseStation1.m1_flow_nominal,baseStation2.m1_flow_nominal})
    annotation (Placement(transformation(
        extent={{-6,6},{6,-6}},
        rotation=-90,
        origin={-20,-72})));
  IBPSA.Fluid.FixedResistances.Junction jun3(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    dp_nominal={0,0,0},
    m_flow_nominal={m1_flow_nominal,baseStation2.m1_flow_nominal,baseStation1.m1_flow_nominal})
    annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=-90,
        origin={20,-40})));
  IBPSA.Fluid.FixedResistances.Junction jun4(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    dp_nominal={0,0,0},
    m_flow_nominal={bypass.m1_flow_nominal,m1_flow_nominal,m1_flow_nominal}) if
                              use_bypass
    annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=0,
        origin={40,60})));
  IBPSA.Fluid.FixedResistances.LosslessPipe pip1(
    redeclare package Medium = Medium,
    allowFlowReversal=allowFlowReversal1,
    m_flow_nominal=m1_flow_nominal,
    m_flow_small=m1_flow_small) if                not use_bypass
    "replaces bypass if disabled" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-60,30})));
  IBPSA.Fluid.FixedResistances.LosslessPipe pip2(
                                                redeclare package Medium =
        Medium,
    allowFlowReversal=allowFlowReversal1,
    m_flow_nominal=m1_flow_nominal,
    m_flow_small=m1_flow_small) if                not use_bypass
    "replaces bypass if disabled"
    annotation (Placement(transformation(extent={{10,10},{-10,-10}},
        rotation=-90,
        origin={60,30})));
equation
  connect(senTemSL.port_b, jun1.port_1)
    annotation (Line(points={{-66,60},{-46,60}}, color={0,127,255}));
  connect(senTemSL.T, bypass.T_measurement) annotation (Line(points={{-76,71},{-76,
          84},{0,84},{0,72}},         color={0,0,127}));
  connect(port_ht, baseStation2.port_ht) annotation (Line(points={{0,-100},{80,-100},
          {80,-60},{60,-60}}, color={191,0,0}));
  connect(port_ht, baseStation1.port_ht) annotation (Line(points={{0,-100},{-80,
          -100},{-80,-60},{-60,-60}}, color={191,0,0}));
  connect(jun1.port_2, bypass.port_a)
    annotation (Line(points={{-34,60},{-10,60}}, color={0,127,255}));
  connect(bypass.port_b,jun4. port_1)
    annotation (Line(points={{10,60},{34,60}},   color={0,127,255}));
  connect(baseStation1.port_b2, port_b2) annotation (Line(points={{-56,-70},{-56,
          -80},{-100,-80}}, color={0,127,255}));
  connect(baseStation1.port_a2, port_a2) annotation (Line(points={{-56,-50},{-56,
          -40},{-100,-40}}, color={0,127,255}));
  connect(baseStation2.port_a2, port_a3)
    annotation (Line(points={{56,-50},{56,-40},{100,-40}}, color={0,127,255}));
  connect(baseStation2.port_b2, port_b3)
    annotation (Line(points={{56,-70},{56,-80},{100,-80}}, color={0,127,255}));
  connect(senTemSL.port_b, pip1.port_a)
    annotation (Line(points={{-66,60},{-60,60},{-60,40}}, color={0,127,255}));
  connect(jun2.port_2, baseStation1.port_a1) annotation (Line(points={{-20,-78},
          {-20,-80},{-44,-80},{-44,-70}}, color={0,127,255}));
  connect(jun2.port_3, baseStation2.port_a1) annotation (Line(points={{-14,-72},
          {30,-72},{30,-80},{44,-80},{44,-70}}, color={0,127,255}));
  connect(pip1.port_b, jun2.port_1) annotation (Line(points={{-60,20},{-60,0},{-20,
          0},{-20,-66}}, color={0,127,255}));
  connect(jun1.port_3, jun2.port_1) annotation (Line(points={{-40,54},{-40,0},{-20,
          0},{-20,-66}}, color={0,127,255}));
  connect(baseStation1.port_b1, jun3.port_3) annotation (Line(points={{-44,-50},
          {-44,-40},{14,-40}}, color={0,127,255}));
  connect(jun3.port_1, jun4.port_3) annotation (Line(points={{20,-34},{20,0},{40,
          0},{40,54}}, color={0,127,255}));
  connect(jun3.port_1,pip2. port_a) annotation (Line(points={{20,-34},{20,0},{60,
          0},{60,20}}, color={0,127,255}));
  connect(jun4.port_2, port_b1)
    annotation (Line(points={{46,60},{100,60}}, color={0,127,255}));
  connect(pip2.port_b, port_b1)
    annotation (Line(points={{60,40},{60,60},{100,60}}, color={0,127,255}));
  connect(port_a1, senTemSL.port_a)
    annotation (Line(points={{-100,60},{-86,60}}, color={0,127,255}));
  connect(jun3.port_2, baseStation2.port_b1) annotation (Line(points={{20,-46},{
          20,-48},{44,-48},{44,-50}}, color={0,127,255}));
  connect(port_a3, port_a3)
    annotation (Line(points={{100,-40},{100,-40}}, color={0,127,255}));
  connect(port_b1, port_b1) annotation (Line(points={{100,60},{106,60},{106,60},
          {100,60}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}),                                        graphics={
        Rectangle(
          lineColor={200,200,200},
          fillColor={248,248,248},
          fillPattern=FillPattern.HorizontalCylinder,
          extent={{-100.0,-100.0},{100.0,100.0}},
          radius=25.0),
        Rectangle(
          extent={{-102,65},{99,55}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-100,-75},{101,-85}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-100,-35},{101,-45}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-70,-62}},
          color={28,108,200},
          thickness=1),                  Rectangle(
          extent={{-72,88},{72,-88}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Line(
          points={{0,60},{30,24},{60,60},{100,60}},
          color={28,108,200},
          thickness=1),
        Line(
          points={{0,60},{-30,26},{-60,60},{-98,60}},
          color={238,46,47},
          thickness=1),
        Line(
          points={{-100,-80},{-32,-80},{-52,-70},{-32,-62},{-32,-62}},
          color={238,46,47},
          thickness=1),
        Line(
          points={{-32,-62},{-52,-54},{-32,-40},{-32,-40},{-100,-40}},
          color={28,108,200},
          thickness=1),
        Rectangle(
          lineColor={128,128,128},
          extent={{-100.0,-100.0},{100.0,100.0}},
          radius=25.0),
        Text(
          extent={{-28,14},{28,-14}},
          lineColor={255,255,255},
          origin={-16,-62},
          rotation=-90,
          textString="1"),
        Text(
          extent={{-20,-14},{20,14}},
          lineColor={255,255,255},
          origin={16,-62},
          rotation=90,
          textString="2"),
        Line(
          points={{32,-62},{52,-54},{32,-40},{32,-40},{100,-40}},
          color={28,108,200},
          thickness=1),
        Line(
          points={{100,-80},{32,-80},{52,-70},{32,-62},{32,-62}},
          color={238,46,47},
          thickness=1),
        Text(
          extent={{-28,-14},{28,14}},
          lineColor={255,255,255},
          origin={2,10},
          rotation=0,
          textString="NET"),     Text(
          extent={{-151,147},{149,107}},
          lineColor={0,0,255},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255},
          textString="%name")}),                                 Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
<p>This is a model for a district heating substation with <b>parallel</b> domestic hot water and space heating stations. This substation contains a base station for domestic hot water (DHW) preparation and a base station for space heating (SH) together with an optional bypass valve. </p>
<p>Care must be taken when chosing the nominal values for differential presure, mass flow and/or heat load, as different issues might occure:</p>
<ul>
<li>In cases where the differential pressure is below its nominal value, the nominal mass flow is not reached. Thus, in times of high heat demand, not enough heat might be delivered to the individual stations.</li>
<li>For differential pressure above the nominal value, the mass flow through the valve might be quite high. This, can lead to a flicker in the valve controllers in the base stations.</li>
<li>Nominal values of mass flow should be chosen such that the heat load can be satisfied (maybe even with supply and return temperatures away from their nominal value).</li>
<li>Nominal heat load should not be set too strict, as nominal values for supply and return temperature are used to derive nominal mass flow values.</li>
</ul>
</html>", revisions="<html>
<ul>
<li>Feburary 27, 2019, by Benedikt Leitner:<br>Implementation and added User&apos;s guide. </li>
</ul>
</html>"),
    experiment(
      StopTime=31536000,
      Interval=900,
      __Dymola_Algorithm="Cvode"),
    __Dymola_experimentFlags(
      Advanced(
        EvaluateAlsoTop=false,
        GenerateVariableDependencies=false,
        OutputModelicaCode=true),
      Evaluate=true,
      OutputCPUtime=true,
      OutputFlatModelica=true));
end SubstationParallel;
