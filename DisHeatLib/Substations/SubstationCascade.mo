within DisHeatLib.Substations;
model SubstationCascade
  extends DisHeatLib.Substations.BaseClasses.SubstationCascadeInterface;

public
  IBPSA.Fluid.HeatExchangers.ConstantEffectiveness hex(
    redeclare package Medium1 = Medium,
    redeclare package Medium2 = Medium,
    allowFlowReversal1=allowFlowReversal1,
    allowFlowReversal2=allowFlowReversal2,
    m1_flow_small=m1_flow_small,
    m2_flow_small=m2_flow_small,
    eps=hex_efficiency,
    m1_flow_nominal=m1_flow_nominal,
    m2_flow_nominal=m2_flow_nominal,
    dp2_nominal(displayUnit="kPa") = 0,
    dp1_nominal(displayUnit="bar") = 0)
    annotation (Placement(transformation(extent={{12,-8},{32,12}})));
public
  IBPSA.Fluid.Sensors.TemperatureTwoPort senTem2(
    redeclare package Medium = Medium,
    transferHeat=false,
    T(displayUnit="degC"),
    T_start=TemSup2_nominal,
    m_flow_nominal=m2_flow_nominal,
    allowFlowReversal=allowFlowReversal2,
    initType=Modelica.Blocks.Types.Init.InitialOutput,
    m_flow_small=m2_flow_small)
    annotation (Placement(transformation(extent={{12,-44},{-8,-24}})));
public
  DisHeatLib.Controls.TemSup_control
                          TemSup_controller(
    TemSup_min=TemSup2_min,
    TemSup_max=TemSup2_max,
    TemOut_min=TemOut_min,
    TemOut_max=TemOut_max) if OutsideDependent
    "outside temperature dependent supply temperature set-point"
    annotation (Placement(transformation(extent={{-38,-84},{-58,-64}})));
public
  Modelica.Blocks.Sources.RealExpression TConst(y=TemSup2_nominal) if
                                                                 not OutsideDependent annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-48,-94})));
public
  DisHeatLib.Controls.flow_control pump_control(
    min_y=0,
    use_T_in=true,
    use_m_flow_in=true,
    m_flow_nominal=m2_flow_nominal,
    k=k,
    Ti=Ti) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-56,16})));
              DisHeatLib.BaseClasses.FlowUnit flowUnit(
    redeclare final package Medium = Medium,
    final allowFlowReversal=allowFlowReversal1,
    final m_flow_nominal=m1_flow_nominal_supply,
    final m_flow_small=m1_flow_small,
    FlowType=DisHeatLib.BaseClasses.FlowType.Valve,
    final dp_nominal=dp1_nominal_supply,
    final dpFixed_nominal=dp_hex_nominal,
    final from_dp=from_dp,
    final linearizeFlowResistance=linearizeFlowResistance)
    annotation (Dialog(group="Parameters"), Placement(transformation(extent={{-10,-10},
            {10,10}},
        rotation=-90,
        origin={0,80})));
public
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_ht if
    OutsideDependent
    "Outside temperature port"
    annotation (Placement(transformation(extent={{-10,-90},{10,-110}})));
  IBPSA.Fluid.FixedResistances.CheckValve cheVal(
    redeclare package Medium = Medium,
    allowFlowReversal=allowFlowReversal1,
    m_flow_nominal=m1_flow_nominal,
    dpValve_nominal=dpCheckValve_nominal,
    dpFixed_nominal=dp_hex_nominal)
    annotation (Placement(transformation(extent={{-40,50},{-20,70}})));
public
              IBPSA.Fluid.Movers.FlowControlled_dp     pump(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    T_start=TemRet1_nominal,
    m_flow_nominal=m1_flow_nominal,
    addPowerToMedium=false,
    nominalValuesDefineDefaultPressureCurve=true,
    dp_nominal=dp1_nominal)      annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=0,
        origin={-56,60})));
  Modelica.Blocks.Math.Gain gain(k=dp1_nominal)    annotation (Placement(
        transformation(
        extent={{-4,-4},{4,4}},
        rotation=90,
        origin={-56,36})));
              DisHeatLib.Controls.flow_control valve_control(
    final reverseAction=false,
    k=k_valve,
    Ti=Ti_valve,
    final min_y=0,
    final use_T_in=true,
    final use_m_flow_in=false) annotation (Dialog(group="Controller"),
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={32,80})));
public
  IBPSA.Fluid.Sensors.TemperatureTwoPort senTem1(
    redeclare package Medium = Medium,
    transferHeat=false,
    T(displayUnit="degC"),
    m_flow_nominal=m1_flow_nominal,
    allowFlowReversal=allowFlowReversal1,
    m_flow_small=m1_flow_small)
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={0,22})));
public
  Modelica.Blocks.Sources.RealExpression TConst1(y=pump_control.T_set +
        TemSupMargin) if not OutsideDependent annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={62,80})));
protected
      final parameter Modelica.SIunits.SpecificHeatCapacity cp_default=
        Medium.cp_const
        "Specific heat capacity of the fluid";
protected
  IBPSA.Fluid.Storage.ExpansionVessel exp(
    redeclare package Medium = Medium,
    T_start=TemSup2_nominal,
    V_start=m2_flow_nominal*0.1)
    annotation (Placement(transformation(extent={{58,-44},{78,-24}})));
protected
  IBPSA.Fluid.Sensors.MassFlowRate senMasFlo(redeclare package Medium = Medium,
      allowFlowReversal=allowFlowReversal2)
    annotation (Placement(transformation(extent={{-12,-44},{-32,-24}})));
protected
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor
    outsideTemperatureSensor if OutsideDependent annotation (Placement(
        transformation(extent={{-8,-84},{-28,-64}})));
public
  IBPSA.Fluid.FixedResistances.Junction jun(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial,
    m_flow_nominal={m1_flow_nominal,m1_flow_nominal,m1_flow_nominal},
    dp_nominal={0,0,0})
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={0,50})));

equation
  connect(TemSup_controller.TemOut,outsideTemperatureSensor. T)
    annotation (Line(points={{-36,-74},{-28,-74}},
                                                 color={0,0,127}));
  connect(pump_control.T_set, TemSup_controller.y) annotation (Line(points={{-56,
          4},{-78,4},{-78,-74},{-59,-74}}, color={0,0,127}));
  connect(TConst.y, pump_control.T_set) annotation (Line(points={{-59,-94},{-64,
          -94},{-64,-74},{-78,-74},{-78,4},{-56,4}}, color={0,0,127}));
  connect(senTem2.T, pump_control.T_measurement) annotation (Line(points={{2,-23},
          {2,-2},{-51,-2},{-51,4}}, color={0,0,127}));
  connect(senTem2.port_a, hex.port_b2)
    annotation (Line(points={{12,-34},{12,-4}}, color={0,127,255}));
  connect(outsideTemperatureSensor.port,port_ht)
    annotation (Line(points={{-8,-74},{0,-74},{0,-100}}, color={191,0,0}));
  connect(senMasFlo.port_a, senTem2.port_b)
    annotation (Line(points={{-12,-34},{-8,-34}}, color={0,127,255}));
  connect(senMasFlo.m_flow, pump_control.m_flow_measurement) annotation (Line(
        points={{-22,-23},{-22,-4},{-61,-4},{-61,4}}, color={0,0,127}));
  connect(port_c1, flowUnit.port_a)
    annotation (Line(points={{0,100},{1.83187e-15,90}}, color={0,127,255}));
  connect(flowUnit.port_b, jun.port_2) annotation (Line(points={{-1.77636e-15,
          70},{1.83187e-15,60}}, color={0,127,255}));
  connect(cheVal.port_b, jun.port_3) annotation (Line(points={{-20,60},{-14,60},
          {-14,50},{-10,50}}, color={0,127,255}));
  connect(hex.port_b1, port_b1) annotation (Line(points={{32,8},{40,8},{40,60},
          {100,60}}, color={0,127,255}));
  connect(hex.port_a2, port_a2)
    annotation (Line(points={{32,-4},{32,-60},{100,-60}}, color={0,127,255}));
  connect(exp.port_a, port_a2)
    annotation (Line(points={{68,-44},{68,-60},{100,-60}}, color={0,127,255}));
  connect(senMasFlo.port_b, port_b2) annotation (Line(points={{-32,-34},{-60,
          -34},{-60,-60},{-100,-60}}, color={0,127,255}));
  connect(cheVal.port_a, pump.port_b)
    annotation (Line(points={{-40,60},{-46,60}}, color={0,127,255}));
  connect(pump_control.y, gain.u)
    annotation (Line(points={{-56,27},{-56,31.2}}, color={0,0,127}));
  connect(pump.dp_in, gain.y)
    annotation (Line(points={{-56,48},{-56,40.4}}, color={0,0,127}));
  connect(jun.port_1,senTem1. port_b) annotation (Line(points={{-1.83187e-15,40},
          {1.77636e-15,32}}, color={0,127,255}));
  connect(senTem1.port_a, hex.port_a1)
    annotation (Line(points={{0,12},{0,8},{12,8}}, color={0,127,255}));
  connect(valve_control.y, flowUnit.y)
    annotation (Line(points={{21,80},{12,80}}, color={0,0,127}));
  connect(senTem1.T, valve_control.T_measurement) annotation (Line(points={{11,22},
          {54,22},{54,75},{44,75}}, color={0,0,127}));
  connect(port_a1, pump.port_a)
    annotation (Line(points={{-100,60},{-66,60}}, color={0,127,255}));
  connect(valve_control.T_set, TConst1.y)
    annotation (Line(points={{44,80},{51,80}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),                                  graphics={
        Rectangle(
          lineColor={200,200,200},
          fillColor={248,248,248},
          fillPattern=FillPattern.HorizontalCylinder,
          extent={{-100.0,-100.0},{100.0,100.0}},
          radius=25.0),
        Rectangle(
          extent={{-37,44},{37,-44}},
          lineColor={0,0,0},
          fillColor={185,185,185},
          fillPattern=FillPattern.Solid,
          lineThickness=0.5,
          origin={32,-33},
          rotation=90),
        Line(
          points={{-70,-62}},
          color={28,108,200},
          thickness=1),
        Rectangle(
          lineColor={128,128,128},
          extent={{-100.0,-100.0},{100.0,100.0}},
          radius=25.0),
        Line(
          points={{-50,64},{-40,40},{-20,66},{-20,40},{28,40}},
          color={28,108,200},
          thickness=0.5,
          origin={82,-100},
          rotation=360),
        Line(
          points={{-101,15},{-21,15},{-21,15},{-9,15},{-9,41},{9,15},{21,39}},
          color={255,128,0},
          thickness=0.5,
          origin={11,-75},
          rotation=360),
        Line(
          points={{-29,-82},{-5,-82},{-6,-17},{20,-17},{38,5},{50,-17}},
          color={28,108,200},
          thickness=0.5,
          origin={81,-22},
          rotation=180),
        Line(
          points={{-52,-16},{-38,8},{-28,-16},{-20,-16},{-20,-80}},
          color={244,125,35},
          thickness=0.5,
          origin={-20,-20},
          rotation=180),
        Line(
          points={{-100,60},{0,60}},
          color={28,108,200},
          thickness=0.5),
        Ellipse(
          extent={{-15,15},{15,-15}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={247,247,247},
          fillPattern=FillPattern.Solid,
          origin={-51,61},
          rotation=360),
        Line(
          points={{1,6},{-9,-20},{-17,6}},
          color={0,0,0},
          thickness=0.5,
          origin={-56,69},
          rotation=90),
        Line(
          points={{0,100},{0,60}},
          color={238,46,47},
          thickness=0.5),
        Polygon(
          points={{0,74},{-6,82},{6,82},{0,74}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          lineThickness=0.5),
        Polygon(
          points={{0,74},{-6,66},{6,66},{0,74}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          lineThickness=0.5)}),                                  Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}})),
    Documentation(info="<html>
<p>This is a model for a district heating substation with a <b>single</b> subtation together with an optional bypass valve. The bypass valve can be used to ensure a minimum supply temperature at the connection point at the primary side. </p>
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
end SubstationCascade;
