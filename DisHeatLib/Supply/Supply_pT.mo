within DisHeatLib.Supply;
model Supply_pT "Differential pressure and temperature supply"
  extends DisHeatLib.Supply.BaseClasses.BaseSupply(otherPowerUnits(y=pump.P), nPorts=
        1);


  parameter Modelica.SIunits.PressureDifference dp_nominal
    "Nominal pressure difference of pump"
    annotation(Dialog(group = "Nominal condition"));

  // Outside dependent supply temperature
  parameter DisHeatLib.Supply.BaseClasses.InputTypeSupplyTemp SupplyTemperature=DisHeatLib.Supply.BaseClasses.InputTypeSupplyTemp.Constant "Supply temperature type"
    annotation (Dialog(group="Supply temperature"));
  parameter Modelica.SIunits.Temperature TemOut_min(displayUnit="degC") "Outside temperature where maximum supply temperature is used"
  annotation (Evaluate = true,
                Dialog(group="Supply temperature", enable = SupplyTemperature==DisHeatLib.Supply.BaseClasses.InputTypeSupplyTemp.OutsideDependent));
  parameter Modelica.SIunits.Temperature TemOut_max(displayUnit="degC") "Outside temperature where minimum supply temperature is used"
    annotation (Evaluate = true,
                Dialog(group="Supply temperature", enable = SupplyTemperature==DisHeatLib.Supply.BaseClasses.InputTypeSupplyTemp.OutsideDependent));
  parameter Modelica.SIunits.Temperature TemSup_min(displayUnit="degC") "Minimum supply temperature"
    annotation (Evaluate = true,
                Dialog(group="Supply temperature", enable = SupplyTemperature==DisHeatLib.Supply.BaseClasses.InputTypeSupplyTemp.OutsideDependent));
  parameter Modelica.SIunits.Temperature TemSup_max(displayUnit="degC")  "Maximum supply temperature"
    annotation (Evaluate = true,
                Dialog(group="Supply temperature", enable = SupplyTemperature==DisHeatLib.Supply.BaseClasses.InputTypeSupplyTemp.OutsideDependent));

  // Differential pressure
  parameter Boolean dp_controller = true
    "Use differential pressure controller (otherwise constant pressure head, using nominal pressure, between supply and demand is used)"
    annotation(Dialog(group="Differential pressure"), Evaluate=true, HideResult=true, choices(checkBox=true));
  parameter Modelica.SIunits.Pressure dp_min(displayUnit="bar") "Minimum differential pressure"
    annotation (Evaluate = true, Dialog(group="Differential pressure", enable = dp_controller));
  parameter Modelica.SIunits.Pressure dp_set(displayUnit="bar") "Differential pressure setpoint"
    annotation (Evaluate = true, Dialog(group="Differential pressure", enable = dp_controller));
  parameter Modelica.SIunits.Pressure dp_max(displayUnit="bar") "Maximum differential pressure"
    annotation (Evaluate = true, Dialog(group="Differential pressure", enable = dp_controller));
  parameter Real k=50 "Gain of controller"
    annotation (Evaluate = true, Dialog(group="Differential pressure", enable = dp_controller));

public
  Modelica.Blocks.Interfaces.RealInput dp_measure(unit="Pa", displayUnit="bar") if
    dp_controller
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={-60,120})));

public
  Modelica.Blocks.Sources.RealExpression TSetConst(y=
        TemSup_nominal) if SupplyTemperature==DisHeatLib.Supply.BaseClasses.InputTypeSupplyTemp.Constant annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-46,48})));
public
  Controls.dp_control dp_control(
    k=40,
    dp_min=dp_min,
    dp_max=dp_max,
    dp_setpoint=dp_set) if dp_controller
    annotation (Placement(transformation(extent={{0,40},{20,60}})));
public
  Controls.TemSup_control TsupController(
    TemOut_min=TemOut_min,
    TemOut_max=TemOut_max,
    TemSup_min=TemSup_min,
    TemSup_max=TemSup_max,
    y(start=TemSup_max)) if
                        SupplyTemperature==DisHeatLib.Supply.BaseClasses.InputTypeSupplyTemp.OutsideDependent
    annotation (Placement(transformation(extent={{20,70},{0,90}})));
public
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_ht if
              SupplyTemperature==DisHeatLib.Supply.BaseClasses.InputTypeSupplyTemp.OutsideDependent
    annotation (Placement(transformation(extent={{50,90},{70,110}})));
public
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor
    outsideTemperatureSensor(T(start=TemOut_min)) if
                                SupplyTemperature==DisHeatLib.Supply.BaseClasses.InputTypeSupplyTemp.OutsideDependent annotation (Placement(
        transformation(extent={{52,70},{32,90}})));
public
  replaceable
  IBPSA.Fluid.Movers.FlowControlled_dp     pump(
    redeclare package Medium = Medium,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final massDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final p_start=Medium.p_default,
    final T_start=TemSup_nominal,
    final X_start=Medium.X_default,
    final C_start=fill(0, Medium.nC),
    final C_nominal=fill(1E-2, Medium.nC),
    final m_flow_small=m_flow_small,
    addPowerToMedium=true,
    final nominalValuesDefineDefaultPressureCurve=true,
    final m_flow_nominal=m_flow_nominal,
    final inputType=if dp_controller then IBPSA.Fluid.Types.InputType.Continuous
         else IBPSA.Fluid.Types.InputType.Constant,
    final constantHead=dp_nominal,
    final allowFlowReversal=allowFlowReversal,
    final dp_nominal=dp_nominal,
    each final heads={0},
    final prescribeSystemPressure=false)
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
public
  IBPSA.Fluid.HeatExchangers.Heater_T heater(redeclare package Medium = Medium,
      m_flow_nominal=m_flow_nominal,
    m_flow_small=m_flow_small,
    dp_nominal=0,
    allowFlowReversal=allowFlowReversal,
    QMax_flow=Q_flow_nominal)
    annotation (Placement(transformation(extent={{-14,-10},{6,10}})));
  IBPSA.Fluid.Storage.ExpansionVessel exp(redeclare package Medium = Medium,
    V_start=m_flow_nominal*0.1,
    T_start=TemRet_nominal)
    annotation (Placement(transformation(extent={{-46,14},{-26,34}})));
public
  Modelica.Blocks.Interfaces.RealOutput P                 "Active power consumption/generation"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,-110})));
public
  Modelica.Blocks.Interfaces.RealInput TSup_in(unit="K", displayUnit="degC") if
       SupplyTemperature == DisHeatLib.Supply.BaseClasses.InputTypeSupplyTemp.Input
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={60,120})));
equation
  Q_flow = heater.Q_flow;

  connect(dp_control.dp, dp_measure) annotation (Line(points={{-2,50},{-10,50},{
          -10,64},{-60,64},{-60,120}},color={0,0,127}));
  connect(outsideTemperatureSensor.port, port_ht)
    annotation (Line(points={{52,80},{60,80},{60,100}}, color={191,0,0}));
  connect(outsideTemperatureSensor.T, TsupController.TemOut)
    annotation (Line(points={{32,80},{22,80}}, color={0,0,127}));
  connect(heater.port_b, pump.port_a)
    annotation (Line(points={{6,0},{20,0}},  color={0,127,255}));
  connect(TsupController.y, heater.TSet) annotation (Line(points={{-1,80},{-20,80},
          {-20,8},{-16,8}}, color={0,0,127}));
  connect(dp_control.y, pump.dp_in)
    annotation (Line(points={{21,50},{30,50},{30,12}}, color={0,0,127}));
  connect(TSetConst.y, heater.TSet) annotation (Line(points={{-35,48},{-20,48},{
          -20,8},{-16,8}}, color={0,0,127}));
  connect(port_a, heater.port_a)
    annotation (Line(points={{-100,0},{-14,0}}, color={0,127,255}));
  connect(port_a, exp.port_a)
    annotation (Line(points={{-100,0},{-36,0},{-36,14}}, color={0,127,255}));
  connect(pump.port_b, ports_b[1])
    annotation (Line(points={{40,0},{100,0}}, color={0,127,255}));
  connect(TSup_in, heater.TSet) annotation (Line(points={{60,120},{60,80},{-20,
          80},{-20,8},{-16,8}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false),
        graphics={      Polygon(
    points={{-28,52},{-50,42},{-36,66},{-20,78},{-6,92},{16,84},{34,86},{58,68},
              {54,62},{54,56},{42,48},{28,58},{18,60},{-12,60},{-28,52}},
    lineColor={0,0,0},
    lineThickness=0.5,
    smooth=Smooth.Bezier,
    fillColor={215,215,215},
    fillPattern=FillPattern.Solid),
        Line(
          points={{-100,0},{-80,0},{-80,-64},{-50,-64}},
          color={28,108,200},
          thickness=1),
        Line(
          points={{46,-66},{80,-66},{80,0},{100,0}},
          color={238,46,47},
          thickness=1),
        Polygon(
          points={{-54,-86},{-50,38},{-36,38},{-32,-36},{12,-10},{12,-36},{56,-10},
              {56,-20},{56,-20},{56,-86},{-54,-86}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={244,125,35})}),                             Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(revisions="<html>
<ul>
<li>Feburary 27, 2019, by Benedikt Leitner:<br>Implementation and added User&apos;s guide. </li>
</ul>
</html>", info="<html>
<h4>General</h4>
<p>This supply unit is modeled as a pressure source with a prescribed supply temperature. The delivered pressure lift of this unit is either determined by a fixed set-point or via a PI-controller that receives measurements from the network, e.g., from the weakest point in the network. The supply temperature can be set to be outside temperature controlled or constant. The main supply unit is considered as an ideal heating unit without any constraints regarding mass fow or ramp rates. The maximum heat generation is, however, limited by its nominal heat flow parameter (Q_flow_nominal).</p>
<h4>Heat and power</h4>
<p>The unit can be modelled as a simple heat and power unit using the characteristic powerCha. Electric power consumption/generation is then set according to the power values corresponding to current heat flow using table entries from the characteristic (and linearly interpolating). Electric power consumption of the pump is also considered. Since the pump is considered to be cooled by the fluid, a one to one conversion between heat added to the fluid and pumping power is considered.</p>
</html>"));
end Supply_pT;
