within DisHeatLib.Substations;
model Substation
  replaceable package Medium =
    Modelica.Media.Water.ConstantPropertyLiquidWater;

  // General
  parameter BaseClasses.BaseStationFlowType FlowType = DisHeatLib.Substations.BaseClasses.BaseStationFlowType.Pump "Flow type at primary side"
    annotation(Dialog(group = "General"));
  parameter Modelica.SIunits.Temperature TemSup_nominal(displayUnit="degC")
    "Nominal supply temperature at the primary side"
    annotation(Dialog(group = "General"));
  final parameter Modelica.SIunits.Power Q_flow_nominal=BaseStationDHW.Q_flow_nominal
       + BaseStationSH.Q_flow_nominal
    "Nominal heat flow rate through station at secondary side"
    annotation (Dialog(group="Space heating"));
  final parameter Modelica.SIunits.MassFlowRate m_flow_nominal=BaseStationDHW.m_flow_nominal
       + BaseStationSH.m_flow_nominal
    "Nominal mass flow rate at the primary side"
    annotation (Evaluate=true, Dialog(group="Primary side"));

  parameter Modelica.SIunits.PressureDifference dp_nominal
    "Nominal pressure difference at the primary side"
    annotation(Dialog(group = "General"));

    // Bypass valve - Tab: Advanced
  parameter Boolean use_bypass = true "Use a bypass valve"
    annotation(Dialog(tab="Advanced", group = "Bypass"), HideResult=true, choices(checkBox=true));
  parameter Boolean use_thermostat = true "Use a thermostat to control the bypass valve, otherwise always opened"
    annotation(Dialog(enable=use_bypass, tab="Advanced", group = "Bypass"), HideResult=true, choices(checkBox=true));
  parameter Real FracBypass(max=1)=0.05
    "Fraction of nominal mass flow running through bypass when opened"
    annotation(Dialog(tab="Advanced", group = "Bypass", use_bypass));
  parameter Modelica.SIunits.Temperature TemSupMinBypass(displayUnit="degC")=TemSup_nominal-5.0
    "Minimum supply temperature before bypass valve is opened"
    annotation(Dialog(tab="Advanced", group = "Bypass", enable=use_thermostat and use_bypass));
  parameter Modelica.SIunits.TemperatureDifference TemBandwidthBypass(displayUnit="degC")=3.0
    "Temperature bandwidth for bypass activation"
    annotation(Dialog(tab="Advanced", group = "Bypass", enable=use_thermostat and use_bypass));

  // Advanced
  parameter Boolean linearized = false
    "= true, use linear relation between m_flow and dp for any flow rate"
    annotation(Evaluate=true, Dialog(tab="Advanced"));
  parameter Boolean from_dp = false
    "= true, use linear relation between m_flow and dp for any flow rate"
    annotation(Evaluate=true, Dialog(tab = "Advanced"));

protected
      final parameter Modelica.SIunits.SpecificHeatCapacity cp_default=
        Medium.cp_const
        "Specific heat capacity of the fluid";
public
  replaceable BaseClasses.BaseStation         BaseStationDHW(
    redeclare package Medium = Medium,
    final dp_nominal=dp_nominal,
    TemSup_nominal_sec=333.15,
    TemRet_nominal_sec=283.15,
    final TemSup_nominal=TemSup_nominal,
    TemRet_nominal=283.15,
    final FlowType=FlowType)
                       annotation (Dialog(group="Domestic hot water station"), Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={-52,42})), __Dymola_choicesAllMatching=true);
  replaceable BaseClasses.BaseStation         BaseStationSH(
    redeclare package Medium = Medium,
    final dp_nominal=dp_nominal,
    final TemSup_nominal=TemSup_nominal,
    final FlowType=FlowType)
                       annotation (Dialog(group="Space heating station"), Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={50,40})), __Dymola_choicesAllMatching=true);
public
  Modelica.Fluid.Interfaces.FluidPort_a port_sl_p(redeclare package Medium =
        Medium) "Supply fluid port at primary side "
    annotation (Placement(transformation(extent={{-110,-70},{-90,-50}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_rl_p(redeclare package Medium =
        Medium) "Return fluid port at primary side "
    annotation (Placement(transformation(extent={{90,-70},{110,-50}})));
public
  Modelica.Fluid.Interfaces.FluidPort_a port_sl_DHW(redeclare package Medium =
        Medium) "Supply fluid port at primary side "
    annotation (Placement(transformation(extent={{-110,50},{-90,70}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_rl_DHW(redeclare package Medium =
        Medium) "Return fluid port at primary side "
    annotation (Placement(transformation(extent={{-110,10},{-90,30}})));
public
  Modelica.Fluid.Interfaces.FluidPort_a port_sl_SH(redeclare package Medium =
        Medium) "Supply fluid port at primary side "
    annotation (Placement(transformation(extent={{90,50},{110,70}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_rl_SH(redeclare package Medium =
        Medium) "Return fluid port at primary side "
    annotation (Placement(transformation(extent={{90,10},{110,30}})));
public
  IBPSA.Fluid.Sensors.TemperatureTwoPort senTemSL(redeclare package Medium =
        Medium, m_flow_nominal=m_flow_nominal,
    T(displayUnit="degC"),
    initType=Modelica.Blocks.Types.Init.InitialOutput,
    T_start=TemSup_nominal,
    transferHeat=use_thermostat,
    TAmb=293.15)
    annotation (Placement(transformation(extent={{-90,-70},{-70,-50}})));
  IBPSA.Fluid.Sensors.TemperatureTwoPort senTemRL(redeclare package Medium =
        Medium, m_flow_nominal=m_flow_nominal,
    T(displayUnit="degC"))
    annotation (Placement(transformation(extent={{50,-70},{70,-50}})));
public
  IBPSA.Fluid.Sensors.RelativePressure sendp(redeclare package Medium = Medium)
    "differential pressure sensor"
    annotation (Placement(transformation(extent={{-10,-112},{10,-92}})));
public
  Modelica.Blocks.Interfaces.RealOutput dp "Connector of Real output signal"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_ht if BaseStationSH.OutsideDependent
     or BaseStationDHW.OutsideDependent
    "Outside temperature port"
    annotation (Placement(transformation(extent={{-10,90},{10,110}})));
  BaseClasses.Bypass bypass(
    redeclare package Medium = Medium,
    FlowType=FlowType,
    m_flow_nominal=FracBypass*m_flow_nominal,
    dp_nominal=dp_nominal,
    use_thermostat=use_thermostat,
    TemSupMinBypass=TemSupMinBypass,
    TemBandwidthBypass=TemBandwidthBypass,
    linearized=linearized,
    from_dp=from_dp) if use_bypass
    annotation (Placement(transformation(extent={{-10,-70},{10,-50}})));
protected
  IBPSA.Fluid.FixedResistances.Junction jun(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    T_start=TemSup_nominal,
    dp_nominal={0,0,0},
    m_flow_nominal={m_flow_nominal,FracBypass*m_flow_nominal,m_flow_nominal},
    linearized=linearized,
    from_dp=from_dp) if       use_bypass
    annotation (Placement(transformation(extent={{-40,-54},{-28,-66}})));
  IBPSA.Fluid.FixedResistances.Junction jun1(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    T_start=TemSup_nominal,
    dp_nominal={0,0,0},
    m_flow_nominal={m_flow_nominal,BaseStationDHW.m_flow_nominal,BaseStationSH.m_flow_nominal},
    linearized=linearized,
    from_dp=from_dp)
    annotation (Placement(transformation(
        extent={{6,6},{-6,-6}},
        rotation=-90,
        origin={-34,48})));
  IBPSA.Fluid.FixedResistances.Junction jun2(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    dp_nominal={0,0,0},
    m_flow_nominal={BaseStationSH.m_flow_nominal,m_flow_nominal,BaseStationDHW.m_flow_nominal},
    linearized=linearized,
    from_dp=from_dp)
    annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=-90,
        origin={44,12})));
  IBPSA.Fluid.FixedResistances.Junction jun3(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    dp_nominal={0,0,0},
    m_flow_nominal={FracBypass*m_flow_nominal,m_flow_nominal,m_flow_nominal},
    linearized=linearized,
    from_dp=from_dp) if       use_bypass
    annotation (Placement(transformation(
        extent={{-6,6},{6,-6}},
        rotation=0,
        origin={36,-60})));
  IBPSA.Fluid.FixedResistances.LosslessPipe pip(redeclare package Medium =
        Medium, m_flow_nominal=m_flow_nominal) if not use_bypass
    "replaces bypass if disabled"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={-48,-28})));
  IBPSA.Fluid.FixedResistances.LosslessPipe pip1(
                                                redeclare package Medium =
        Medium, m_flow_nominal=m_flow_nominal) if not use_bypass
    "replaces bypass if disabled"
    annotation (Placement(transformation(extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={50,-32})));
equation
  connect(sendp.p_rel,dp)  annotation (Line(points={{0,-111},{0,-116},{90,-116},
          {90,0},{110,0}},color={0,0,127}));
  connect(senTemSL.port_a, port_sl_p)
    annotation (Line(points={{-90,-60},{-100,-60}}, color={0,127,255}));
  connect(sendp.port_b, port_rl_p) annotation (Line(points={{10,-102},{100,-102},
          {100,-60}},color={0,127,255}));
  connect(sendp.port_a, port_sl_p) annotation (Line(points={{-10,-102},{-100,-102},
          {-100,-60}}, color={0,127,255}));
  connect(BaseStationDHW.port_sl_s, port_sl_DHW) annotation (Line(points={{-58,52},
          {-58,52},{-58,60},{-58,60},{-58,60},{-100,60}},     color={0,127,255}));
  connect(BaseStationSH.port_sl_s, port_sl_SH) annotation (Line(points={{56,50},
          {56,50},{56,60},{56,60},{56,60},{100,60}}, color={0,127,255}));
  connect(BaseStationSH.port_rl_s, port_rl_SH)
    annotation (Line(points={{56,30},{56,20},{100,20}}, color={0,127,255}));
  connect(BaseStationDHW.port_rl_s, port_rl_DHW)
    annotation (Line(points={{-58,32},{-58,20},{-100,20}}, color={0,127,255}));
  connect(jun1.port_2, BaseStationDHW.port_sl_p) annotation (Line(points={{-34,54},
          {-34,60},{-46,60},{-46,52}},     color={0,127,255}));
  connect(jun1.port_3, BaseStationSH.port_sl_p) annotation (Line(points={{-28,48},
          {-20,48},{-20,60},{44,60},{44,50}},     color={0,127,255}));
  connect(BaseStationSH.port_rl_p, jun2.port_1)
    annotation (Line(points={{44,30},{44,24},{44,24},{44,18}},
                                               color={0,127,255}));
  connect(jun2.port_3, BaseStationDHW.port_rl_p) annotation (Line(points={{38,12},
          {32,12},{32,20},{-46,20},{-46,32}},     color={0,127,255}));
  connect(jun3.port_2, senTemRL.port_a)
    annotation (Line(points={{42,-60},{50,-60}}, color={0,127,255}));
  connect(jun3.port_3, jun2.port_2)
    annotation (Line(points={{36,-54},{36,-10},{44,-10},{44,6}},
                                               color={0,127,255}));
  connect(jun2.port_2, pip1.port_a) annotation (Line(points={{44,6},{44,-10},{50,
          -10},{50,-22}},    color={0,127,255}));
  connect(pip1.port_b, senTemRL.port_a)
    annotation (Line(points={{50,-42},{50,-60}},          color={0,127,255}));
  connect(senTemRL.port_b, port_rl_p)
    annotation (Line(points={{70,-60},{100,-60}}, color={0,127,255}));
  connect(senTemSL.port_b, jun.port_1)
    annotation (Line(points={{-70,-60},{-40,-60}}, color={0,127,255}));
  connect(senTemSL.port_b, pip.port_a) annotation (Line(points={{-70,-60},{-48,-60},
          {-48,-38}},      color={0,127,255}));
  connect(jun.port_3, jun1.port_1)
    annotation (Line(points={{-34,-54},{-34,42}}, color={0,127,255}));
  connect(pip.port_b, jun1.port_1) annotation (Line(points={{-48,-18},{-48,2},{
          -34,2},{-34,42}}, color={0,127,255}));
  connect(jun.port_2, bypass.port_a)
    annotation (Line(points={{-28,-60},{-10,-60}}, color={0,127,255}));
  connect(bypass.port_b, jun3.port_1)
    annotation (Line(points={{10,-60},{30,-60}}, color={0,127,255}));
  connect(senTemSL.T, bypass.T_measurement) annotation (Line(points={{-80,-49},{
          -80,-44},{0,-44},{0,-48}},  color={0,0,127}));
  connect(port_ht, BaseStationSH.port_ht) annotation (Line(points={{0,100},{0,74},
          {70,74},{70,40},{60,40}}, color={191,0,0}));
  connect(port_ht, BaseStationDHW.port_ht) annotation (Line(points={{0,100},{0,74},
          {-76,74},{-76,42},{-62,42}}, color={191,0,0}));
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
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-120},{100,100}})),
    Documentation(info="<html>
<p>This is a model for a district heating substation with indirectly connected domestic hot water and space heating load. This substation contains a base station for domestic hot water (DHW) preparation and a base station for space heating (SH) together with a bypass valve. The DHW station is set to deliver a constant supply temperature at the secondary side, while the SH station delivers an outside-dependent supply temperature. The bypass valve is used to ensure a minimum supply temperature at the connection point at the primary side. Thus, it opens in case the supply temperature is below the minimum (minus bandwidth) and closes once the temperature is above the minimum (plus bandwidth). </p>
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
