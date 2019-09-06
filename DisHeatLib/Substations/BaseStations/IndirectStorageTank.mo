within DisHeatLib.Substations.BaseStations;
model IndirectStorageTank
  extends BaseClasses.BaseStation(
    final OutsideDependent=false);

  //Heat exchanger parameter
  parameter Modelica.SIunits.Efficiency hex_efficiency(max=1)=0.90
    "Constant efficiency of the heat exchanger"
    annotation(Dialog(group = "Heat exchanger and flow"));
  parameter Modelica.SIunits.PressureDifference dp_hex_nominal=0
    "Nominal pressure difference at the heat exchanger at primary side"
    annotation(Dialog(group = "Heat exchanger and flow"));
  parameter Real k(min=0, unit="1") = 0.05 "Gain of flow controller"
    annotation(Dialog(group = "Heat exchanger and flow"));
  parameter Modelica.SIunits.Time Ti(min=Modelica.Constants.small)=30
    "Time constant of Integrator block of flow controller"
    annotation(Dialog(group = "Heat exchanger and flow"));

  parameter Real min_y(max=1)=0.0
    "Minimum position of flow controller (e.g, to mimic bypass)"
    annotation(Dialog(group = "Heat exchanger and flow"));

  // Storage tank
  parameter Modelica.SIunits.Temperature TemSupTan_nominal "Nominal supply temperature"
    annotation(Evaluate=false, Dialog(group = "Storage tank"));
  parameter Modelica.SIunits.Volume VTan "Tank volume"
    annotation(Evaluate=false, Dialog(group = "Storage tank"));
  parameter Modelica.SIunits.Length hTan = 1 "Height of tank (without insulation)"
    annotation(Evaluate=true, Dialog(group = "Storage tank"));
  parameter Modelica.SIunits.Length dIns = 0.2 "Thickness of insulation"
    annotation(Evaluate=true, Dialog(group = "Storage tank"));
  parameter Modelica.SIunits.ThermalConductivity kIns = 0.04
    "Specific heat conductivity of insulation"
    annotation(Evaluate=true, Dialog(group = "Storage tank"));
  parameter Integer nSeg(min=4) = 4 "Number of volume segments"
    annotation(Evaluate=true, Dialog(group = "Storage tank"));
  parameter Modelica.SIunits.Temperature TemInit
    "Initial temperature of the storage tank"
    annotation(Evaluate=true, Dialog(group = "Storage tank"));
  parameter Modelica.SIunits.Temperature TemRoom = 20.0 + 273.15
    "Constant temperature surrounding the storage tank"
    annotation(Evaluate=true, Dialog(group = "Storage tank"));

  // Controller
  parameter Modelica.SIunits.MassFlowRate m_flow_charging
    "Nominal mass flow rate"
    annotation(Dialog(group = "Storage controller"));
  parameter Integer nSegMeasure=1 "Volume segment to take top temperature from"
    annotation(Dialog(group="Storage controller"));
  parameter Modelica.SIunits.Temperature T_top_set(displayUnit="degC") "Constant temperature setpoint for top layer"
    annotation(Evaluate=true, Dialog(group = "Storage controller"));
  parameter Modelica.SIunits.Temperature T_bot_set(displayUnit="degC") "Constant temperature setpoint for bottom layer"
    annotation(Evaluate=true, Dialog(group = "Storage controller"));
  parameter Modelica.SIunits.TemperatureDifference T_top_bandwidth(displayUnit="degC") = 5 "Bandwidth for controller activation"
    annotation(Evaluate=true, Dialog(group = "Storage controller"));
public
  IBPSA.Fluid.HeatExchangers.ConstantEffectiveness hex(redeclare package
      Medium1 = Medium, redeclare package Medium2 = Medium,
    allowFlowReversal1=allowFlowReversal1,
    allowFlowReversal2=allowFlowReversal2,
    m1_flow_small=m1_flow_small,
    m2_flow_small=m2_flow_small,
    eps=hex_efficiency,
    m1_flow_nominal=m1_flow_nominal,
    m2_flow_nominal=m_flow_charging,
    dp2_nominal(displayUnit="kPa") = 0,
    dp1_nominal=0)
    annotation (Placement(transformation(extent={{-20,28},{0,48}})));
protected
  IBPSA.Fluid.Storage.ExpansionVessel exp(redeclare package Medium = Medium,
    T_start=TemSup2_nominal,
    V_start=m2_flow_nominal*0.1)
    annotation (Placement(transformation(extent={{58,-44},{78,-24}})));
protected
  IBPSA.Fluid.Sensors.MassFlowRate senMasFlo(redeclare package Medium = Medium,
      allowFlowReversal=allowFlowReversal2)
    annotation (Placement(transformation(extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={-40,10})));
public
  replaceable DisHeatLib.BaseClasses.FlowUnit flowUnit(
    redeclare final package Medium = Medium,
    final allowFlowReversal=allowFlowReversal1,
    final m_flow_nominal=m1_flow_nominal,
    final m_flow_small=m1_flow_small,
    final dp_nominal=dp1_nominal,
    final dpFixed_nominal=dp_hex_nominal,
    final from_dp=from_dp,
    final linearizeFlowResistance=linearizeFlowResistance)
    annotation (Dialog(group="Parameters"), Placement(transformation(extent={{-80,70},
            {-60,50}})));
  Storage.StorageTank storageTank(
    redeclare package Medium = Medium,
    VTan=VTan,
    hTan=hTan,
    dIns=dIns,
    kIns=kIns,
    nSeg=nSeg,
    TemInit=TemInit,
    TemRoom=TemRoom,
    m_flow_nominal=m2_flow_nominal,
    m_flow_small=m2_flow_small,
    allowFlowReversal=allowFlowReversal2)
    annotation (Placement(transformation(extent={{-20,-64},{0,-44}})));
              DisHeatLib.BaseClasses.FlowUnit flowUnit1(
    redeclare final package Medium = Medium,
    final allowFlowReversal=allowFlowReversal2,
    m_flow_nominal=m_flow_charging,
    final m_flow_small=m2_flow_small,
    FlowType=DisHeatLib.BaseClasses.FlowType.Pump,
    final dp_nominal=1)
    annotation (Placement(transformation(extent={{10,-10},
            {-10,10}},
        rotation=-90,
        origin={0,10})));
public
  Controls.flow_control valve_control(
    min_y=0,
    use_T_in=false,
    use_m_flow_in=true,
    T_const=TemSupTan_nominal,
    m_flow_nominal=m_flow_charging,
    k=k,
    Ti=Ti)
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={-70,30})));
public
  IBPSA.Fluid.Sensors.TemperatureTwoPort senTem(
    redeclare package Medium = Medium,
    transferHeat=false,
    T(displayUnit="degC"),
    T_start=TemSup2_nominal,
    m_flow_nominal=m_flow_charging,
    allowFlowReversal=allowFlowReversal2,
    initType=Modelica.Blocks.Types.Init.InitialOutput,
    m_flow_small=m2_flow_small)
    annotation (Placement(transformation(extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={-40,-30})));
  Controls.storage_control storage_control(
    T_top_set=T_top_set,
    T_bot_set=T_bot_set,
    T_top_bandwidth=T_top_bandwidth)
    annotation (Placement(transformation(extent={{40,0},{20,20}})));
  Storage.BaseClasses.ThermostatMixer thermostatMixer(
    redeclare package Medium = Medium,
    m_flow_nominal=m2_flow_nominal,
    dp_nominal=100000,
    Tem_set=TemSup2_nominal)
    annotation (Placement(transformation(extent={{-40,-70},{-60,-50}})));
equation
  connect(port_a2, exp.port_a)
    annotation (Line(points={{100,-60},{68,-60},{68,-44}}, color={0,127,255}));
  connect(port_a1, flowUnit.port_a)
    annotation (Line(points={{-100,60},{-80,60}}, color={0,127,255}));
  connect(flowUnit.port_b, hex.port_a1)
    annotation (Line(points={{-60,60},{-20,60},{-20,44}},
                                                       color={0,127,255}));
  connect(hex.port_b1, port_b1)
    annotation (Line(points={{0,44},{0,60},{100,60}}, color={0,127,255}));
  connect(port_a2, storageTank.port_a2)
    annotation (Line(points={{100,-60},{0,-60}}, color={0,127,255}));
  connect(flowUnit1.port_b, hex.port_a2) annotation (Line(points={{1.77636e-15,
          20},{0,20},{0,32}}, color={0,127,255}));
  connect(flowUnit1.port_a, storageTank.port_b1) annotation (Line(points={{
          -1.77636e-15,1.77636e-15},{-1.77636e-15,-40},{0,-40},{0,-48}}, color=
          {0,127,255}));
  connect(valve_control.y, flowUnit.y)
    annotation (Line(points={{-70,41},{-70,48}}, color={0,0,127}));
  connect(valve_control.m_flow_measurement, senMasFlo.m_flow)
    annotation (Line(points={{-65,18},{-65,10},{-51,10}}, color={0,0,127}));
  connect(valve_control.T_measurement, senTem.T)
    annotation (Line(points={{-75,18},{-75,-30},{-51,-30}}, color={0,0,127}));
  connect(senTem.port_b, storageTank.port_a1) annotation (Line(points={{-40,-40},
          {-20,-40},{-20,-48}}, color={0,127,255}));
  connect(senMasFlo.port_a, hex.port_b2)
    annotation (Line(points={{-40,20},{-20,20},{-20,32}}, color={0,127,255}));
  connect(senMasFlo.port_b, senTem.port_a)
    annotation (Line(points={{-40,0},{-40,-20}}, color={0,127,255}));
  connect(flowUnit1.y, storage_control.y)
    annotation (Line(points={{12,10},{19,10}}, color={0,0,127}));
  connect(storageTank.TemTank[nSegMeasure], storage_control.T_top) annotation (Line(
        points={{-10,-65},{-10,-80},{52,-80},{52,15},{42,15}}, color={0,0,127}));
  connect(storageTank.TemTank[nSeg], storage_control.T_bot) annotation (Line(
        points={{-10,-65},{-10,-80},{52,-80},{52,5},{42,5}}, color={0,0,127}));
  connect(thermostatMixer.port_2, port_b2)
    annotation (Line(points={{-60,-60},{-100,-60}}, color={0,127,255}));
  connect(thermostatMixer.port_1, storageTank.port_b2)
    annotation (Line(points={{-40,-60},{-20,-60}}, color={0,127,255}));
  connect(storageTank.port_a2, thermostatMixer.port_3) annotation (Line(points={
          {0,-60},{0,-76},{-50,-76},{-50,-70}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-120},
            {100,100}}),                                        graphics={
        Line(
          points={{-70,-62}},
          color={28,108,200},
          thickness=1),
        Ellipse(
          extent={{-24,0},{26,-16}},
          fillColor={255,85,85},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0},
          lineThickness=1),
        Rectangle(
          extent={{-24,-8},{26,-32}},
          fillColor={255,85,85},
          fillPattern=FillPattern.Solid,
          lineThickness=1,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Line(
          points={{-24,-8},{-24,-64}},
          color={0,0,0},
          thickness=1),
        Ellipse(
          extent={{-24,-54},{26,-70}},
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0},
          lineThickness=1),
        Rectangle(
          extent={{26,-32},{-24,-62}},
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid,
          lineThickness=1,
          pattern=LinePattern.None),
        Line(
          points={{26,-8},{26,-62}},
          color={0,0,0},
          thickness=1),
        Rectangle(
          extent={{-24,66},{26,24}},
          lineColor={0,0,0},
          fillColor={185,185,185},
          fillPattern=FillPattern.Solid,
          lineThickness=1),
        Line(
          points={{-100,62}},
          color={238,46,47},
          thickness=1),
        Line(
          points={{-100,60},{-18,60},{-8,48},{2,60}},
          color={238,46,47},
          thickness=1),
        Line(
          points={{-40,-12},{-40,-60},{-100,-60}},
          color={238,46,47},
          thickness=1),
        Line(
          points={{42,-60},{26,-60}},
          color={28,108,200},
          thickness=1),
        Line(
          points={{2,60},{12,48},{22,60},{102,60}},
          color={28,108,200},
          thickness=1),
        Line(
          points={{-24,-12},{-40,-12},{-40,32},{-18,32},{-18,46},{-8,32},{2,44}},
          color={238,46,47},
          thickness=1),
        Line(
          points={{2,44},{12,32},{22,44},{22,32},{42,32},{42,-60},{102,-60}},
          color={28,108,200},
          thickness=1),
        Ellipse(
          extent={{-10,10},{10,-10}},
          lineColor={0,0,0},
          lineThickness=1,
          fillColor={247,247,247},
          fillPattern=FillPattern.Solid,
          origin={42,6},
          rotation=360),
        Line(
          points={{8,-9},{0,7},{-8,-9}},
          color={0,0,0},
          thickness=1,
          origin={42,9},
          rotation=360)}),Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),
    Documentation(info="<html>
<p>This is a model for an indirect district heating substation. Its main components are a heat exchanger, a flow regulating valve, a pump to deliver heat to the customers, an expansion vessel and controller that maintains the temperature at the secondary side by setting the position of the flow regulating valve/pump. The supply temperature setpoint at the secondary side can thereby be set to a constant or can be changed depending on the outside temperature.</p>
<p>A mismatch between the setpoint and the actual value of the secondary supply temperature can have different reasons:</p>
<ul>
<li>The differential pressure at the station is too low, resulting in a too low mass flow at the primary side even if the valve is completely open.</li>
<li>The nominal mass flow rate at the primary side is too low, leading to a too low secondary supply temperature even with a fully opend valve.</li>
<li>The supply temperature at the primary side is too low, i.e., lower than the secondary supply temperature setpoint, leading to a fully opened valve.</li>
</ul>
<p><br>Redimensioning the substation, e.g., by using a more efficient heat exchanger or a higher differential pressure at the primary side, might solve these issues.</p>
</html>",
        revisions="<html>
<ul>
<li>Feburary 27, 2019, by Benedikt Leitner:<br>Implementation and added User&apos;s guide. </li>
</ul>
</html>"));
end IndirectStorageTank;
