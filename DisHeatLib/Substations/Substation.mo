within DisHeatLib.Substations;
model Substation
  extends BaseClasses.SubstationInterface(
    final m_flow_nominal=baseStationDHW.m1_flow_nominal+baseStationSH.m1_flow_nominal,
      total_power(y=baseStationSH.P + baseStationDHW.P));

  // General
  parameter Modelica.SIunits.Temperature TemSup_nominal(displayUnit="degC")
    "Nominal supply temperature"
    annotation(Dialog(group = "Nominal condition"));

  final parameter Modelica.SIunits.Power Q_flow_nominal=baseStationDHW.Q_flow_nominal
       +baseStationSH.Q_flow_nominal
    "Nominal heat flow rate through station at secondary side"
    annotation (Dialog(group="Space heating"));

  // Bypass valve - Tab: Bypass
  parameter Boolean use_bypass = true "Use a bypass valve"
    annotation(Dialog(tab="Bypass"), HideResult=true, choices(checkBox=true));

protected
      final parameter Modelica.SIunits.SpecificHeatCapacity cp_default=
        Medium.cp_const
        "Specific heat capacity of the fluid";
public
  replaceable BaseClasses.BaseStation         baseStationDHW(
    final allowFlowReversal1=allowFlowReversal,
    final m1_flow_small=m_flow_small,
    redeclare final package Medium = Medium,
    final from_dp=from_dp,
    final linearizeFlowResistance=linearizeFlowResistance,
    final FlowType=FlowType,
    final TemSup1_nominal=TemSup_nominal,
    final dp1_nominal=dp_nominal)
                       annotation (Dialog(group="Domestic hot water station"), Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-50,40})), __Dymola_choicesAllMatching=true);
  replaceable BaseClasses.BaseStation         baseStationSH(
    final allowFlowReversal1=allowFlowReversal,
    final m1_flow_small=m_flow_small,
    redeclare final package Medium = Medium,
    final from_dp=from_dp,
    final linearizeFlowResistance=linearizeFlowResistance,
    final FlowType=FlowType,
    final TemSup1_nominal=TemSup_nominal,
    final dp1_nominal=dp_nominal)
                       annotation (Dialog(group="Space heating station"), Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={50,40})), __Dymola_choicesAllMatching=true);
public
  IBPSA.Fluid.Sensors.TemperatureTwoPort senTemSL(redeclare package Medium =
        Medium,
    allowFlowReversal=allowFlowReversal,
                m_flow_nominal=m_flow_nominal,
    T(displayUnit="degC"),
    initType=Modelica.Blocks.Types.Init.InitialOutput,
    T_start=TemSup_nominal,
    transferHeat=true,
    TAmb=293.15)
    annotation (Placement(transformation(extent={{-90,-70},{-70,-50}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_ht if baseStationSH.OutsideDependent
     or baseStationDHW.OutsideDependent
    "Outside temperature port"
    annotation (Placement(transformation(extent={{-10,90},{10,110}})));
  replaceable
  BaseClasses.Bypass bypass(
    redeclare final package Medium = Medium,
    final allowFlowReversal=allowFlowReversal,
    m_flow_nominal=0.03*m_flow_nominal,
    final m_flow_small=m_flow_small,
    final from_dp=from_dp,
    final dp_nominal=dp_nominal,
    final linearizeFlowResistance=linearizeFlowResistance,
    final FlowType=FlowType) if
                        use_bypass constrainedby BaseClasses.Bypass
    annotation (Dialog(tab = "Bypass", enable=use_bypass), Placement(transformation(extent={{-4,-70},{16,-50}})));
protected
  IBPSA.Fluid.FixedResistances.Junction jun(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    T_start=TemSup_nominal,
    dp_nominal={0,0,0},
    m_flow_nominal={m_flow_nominal,FracBypass*m_flow_nominal,m_flow_nominal},
    linearized=linearizeFlowResistance,
    from_dp=from_dp) if       use_bypass
    annotation (Placement(transformation(extent={{-32,-54},{-20,-66}})));
  IBPSA.Fluid.FixedResistances.Junction jun1(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    T_start=TemSup_nominal,
    dp_nominal={0,0,0},
    m_flow_nominal={m_flow_nominal,baseStationDHW.m1_flow_nominal,baseStationSH.m1_flow_nominal},
    linearized=linearizeFlowResistance,
    from_dp=from_dp)
    annotation (Placement(transformation(
        extent={{6,6},{-6,-6}},
        rotation=-90,
        origin={-26,46})));
  IBPSA.Fluid.FixedResistances.Junction jun2(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    dp_nominal={0,0,0},
    m_flow_nominal={baseStationSH.m1_flow_nominal,m_flow_nominal,baseStationDHW.m1_flow_nominal},
    linearized=linearizeFlowResistance,
    from_dp=from_dp)
    annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=-90,
        origin={44,12})));
  IBPSA.Fluid.FixedResistances.Junction jun3(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    dp_nominal={0,0,0},
    m_flow_nominal={bypass.m_flow_nominal,m_flow_nominal,m_flow_nominal},
    linearized=linearizeFlowResistance,
    from_dp=from_dp) if       use_bypass
    annotation (Placement(transformation(
        extent={{-6,6},{6,-6}},
        rotation=0,
        origin={36,-60})));
  IBPSA.Fluid.FixedResistances.LosslessPipe pip(redeclare package Medium =
        Medium,
    allowFlowReversal=allowFlowReversal,
                m_flow_nominal=m_flow_nominal) if not use_bypass
    "replaces bypass if disabled"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={-48,-28})));
  IBPSA.Fluid.FixedResistances.LosslessPipe pip1(
                                                redeclare package Medium =
        Medium,
    allowFlowReversal=allowFlowReversal,
                m_flow_nominal=m_flow_nominal) if not use_bypass
    "replaces bypass if disabled"
    annotation (Placement(transformation(extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={50,-32})));
equation
  connect(jun3.port_3, jun2.port_2)
    annotation (Line(points={{36,-54},{36,-10},{44,-10},{44,6}},
                                               color={0,127,255}));
  connect(jun2.port_2, pip1.port_a) annotation (Line(points={{44,6},{44,-10},{50,
          -10},{50,-22}},    color={0,127,255}));
  connect(senTemSL.port_b, jun.port_1)
    annotation (Line(points={{-70,-60},{-32,-60}}, color={0,127,255}));
  connect(senTemSL.port_b, pip.port_a) annotation (Line(points={{-70,-60},{-48,-60},
          {-48,-38}},      color={0,127,255}));
  connect(jun.port_3, jun1.port_1)
    annotation (Line(points={{-26,-54},{-26,40}}, color={0,127,255}));
  connect(pip.port_b, jun1.port_1) annotation (Line(points={{-48,-18},{-48,2},{-26,
          2},{-26,40}},     color={0,127,255}));
  connect(senTemSL.T, bypass.T_measurement) annotation (Line(points={{-80,-49},{
          -80,-42},{6,-42},{6,-48}},  color={0,0,127}));
  connect(port_ht,baseStationSH. port_ht) annotation (Line(points={{0,100},{0,74},
          {70,74},{70,40},{60,40}}, color={191,0,0}));
  connect(port_ht,baseStationDHW. port_ht) annotation (Line(points={{0,100},{0,74},
          {-76,74},{-76,40},{-60,40}}, color={191,0,0}));
  connect(baseStationSH.port_b1, jun2.port_1)
    annotation (Line(points={{44,30},{44,18}}, color={0,127,255}));
  connect(jun1.port_2, baseStationDHW.port_a1) annotation (Line(points={{-26,52},
          {-26,60},{-44,60},{-44,50}}, color={0,127,255}));
  connect(baseStationDHW.port_b1, jun2.port_3)
    annotation (Line(points={{-44,30},{-44,12},{38,12}}, color={0,127,255}));
  connect(jun.port_2, bypass.port_a)
    annotation (Line(points={{-20,-60},{-4,-60}}, color={0,127,255}));
  connect(bypass.port_b, jun3.port_1)
    annotation (Line(points={{16,-60},{30,-60}}, color={0,127,255}));
  connect(port_a, senTemSL.port_a)
    annotation (Line(points={{-100,-60},{-90,-60}}, color={0,127,255}));
  connect(sendp.port_b, port_b) annotation (Line(points={{10,-88},{100,-88},{100,
          -60}}, color={0,127,255}));
  connect(sendp.port_a, port_a) annotation (Line(points={{-10,-88},{-100,-88},{-100,
          -60}}, color={0,127,255}));
  connect(jun1.port_3, baseStationSH.port_a1) annotation (Line(points={{-20,46},
          {20,46},{20,60},{44,60},{44,50}}, color={0,127,255}));
  connect(jun3.port_2, port_b)
    annotation (Line(points={{42,-60},{100,-60}}, color={0,127,255}));
  connect(pip1.port_b, port_b)
    annotation (Line(points={{50,-42},{50,-60},{100,-60}}, color={0,127,255}));
  connect(port_a_DHW, baseStationDHW.port_a2)
    annotation (Line(points={{-100,20},{-56,20},{-56,30}}, color={0,127,255}));
  connect(baseStationDHW.port_b2, port_b_DHW)
    annotation (Line(points={{-56,50},{-56,60},{-100,60}}, color={0,127,255}));
  connect(baseStationSH.port_b2, port_b_SH)
    annotation (Line(points={{56,50},{56,60},{100,60}}, color={0,127,255}));
  connect(baseStationSH.port_a2, port_a_SH)
    annotation (Line(points={{56,30},{56,20},{100,20}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-120},
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
                                 Text(
          extent={{-141,-99},{159,-139}},
          lineColor={0,0,255},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255},
          textString="%name"),
        Rectangle(
          extent={{-104,-55},{97,-65}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-100,25},{101,15}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),Rectangle(
          extent={{-72,80},{68,-80}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-70,-62}},
          color={28,108,200},
          thickness=1),
        Line(
          points={{0,-60},{30,-24},{60,-60},{70,-60}},
          color={28,108,200},
          thickness=1),
        Line(
          points={{0,-60},{-30,-26},{-60,-60},{-70,-60}},
          color={238,46,47},
          thickness=1),
        Line(
          points={{-100,60},{-32,60},{-52,50},{-32,42},{-32,42}},
          color={238,46,47},
          thickness=1),
        Line(
          points={{-32,42},{-52,34},{-32,20},{-32,20},{-100,20}},
          color={28,108,200},
          thickness=1),
        Rectangle(
          lineColor={128,128,128},
          extent={{-100.0,-100.0},{100.0,100.0}},
          radius=25.0),
        Text(
          extent={{-28,-14},{28,14}},
          lineColor={255,255,255},
          origin={-16,40},
          rotation=90,
          textString="DHW"),
        Text(
          extent={{-20,-14},{20,14}},
          lineColor={255,255,255},
          origin={20,40},
          rotation=90,
          textString="SH"),
        Line(
          points={{32,42},{52,34},{32,20},{32,20},{100,20}},
          color={28,108,200},
          thickness=1),
        Line(
          points={{100,60},{32,60},{52,50},{32,42},{32,42}},
          color={238,46,47},
          thickness=1),
        Text(
          extent={{-28,-14},{28,14}},
          lineColor={255,255,255},
          origin={0,-12},
          rotation=0,
          textString="NET")}),                                   Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
<p>This is a model for a district heating substation with <b>parallel</b> domestic hot water and space heating stations. This substation contains a base station for domestic hot water (DHW) preparation and a base station for space heating (SH) together with a bypass valve. The DHW station is set to deliver a constant supply temperature at the secondary side, while the SH station delivers an outside-dependent supply temperature. The bypass valve is used to ensure a minimum supply temperature at the connection point at the primary side. Thus, it opens in case the supply temperature is below the minimum (minus bandwidth) and closes once the temperature is above the minimum (plus bandwidth). </p>
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
end Substation;
