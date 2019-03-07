within DisHeatLib.Demand;
model Demand
  extends IBPSA.Fluid.Interfaces.PartialTwoPortInterface(
    m_flow_nominal=Q_flow_nominal/((TemSup_nominal-TemRet_nominal)*cp_default));
  extends IBPSA.Fluid.Interfaces.TwoPortFlowResistanceParameters(
    final computeFlowResistance=(abs(dp_nominal) > Modelica.Constants.eps));
  // Basic parameters
  parameter DisHeatLib.Substations.BaseClasses.BaseStationFlowType FlowType = DisHeatLib.Substations.BaseClasses.BaseStationFlowType.Pump "Flow type";
  // Nominal parameters
  parameter Modelica.SIunits.Power Q_flow_nominal
    "Nominal heat flow rate"
    annotation(Evaluate = true, Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.Temperature TemSup_nominal(displayUnit="degC")=60.0+273.15 "Nominal supply temperature"
    annotation(Evaluate = true, Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.Temperature TemRet_nominal(displayUnit="degC")=35.0+273.15 "Nominal return temperature"
    annotation(Evaluate = true, Dialog(group="Nominal condition"));

  // Heat load
  parameter DisHeatLib.Demand.BaseClasses.InputTypeQ heatLoad = DisHeatLib.Demand.BaseClasses.InputTypeQ.Constant "Calculation of heat load"
    annotation(Evaluate = true, Dialog(group="Heat demand"));
  parameter Real scaling = 1.0 "Scaling factor for heat demand"
  annotation (Evaluate = true, Dialog(group="Heat demand"));
  parameter Modelica.SIunits.Power Q_constant = 0.0 "Constant heat demand"
    annotation (Evaluate = true, Dialog(enable = heatLoad==DisHeatLib.Demand.BaseClasses.InputTypeQ.Constant, group="Heat demand"));
  parameter String tableName="NoName"
    "Table name on file or in function usertab (see docu)"
    annotation (Dialog(enable = heatLoad==DisHeatLib.Demand.BaseClasses.InputTypeQ.File, group="Heat demand"));
  parameter String fileName="NoName" "File where matrix is stored"
    annotation (Dialog(enable = heatLoad==DisHeatLib.Demand.BaseClasses.InputTypeQ.File, group="Heat demand",
      loadSelector(filter="Text files (*.txt);;MATLAB MAT-files (*.mat)",
          caption="Open file in which table is present")));
  parameter Integer columns[:]={2}
    "Columns of table to be interpolated"
    annotation (Dialog(enable = heatLoad==DisHeatLib.Demand.BaseClasses.InputTypeQ.File, group="Heat demand"));

protected
  Modelica.Blocks.Continuous.LimPID PID(
    Ti=60,
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    initType=Modelica.Blocks.Types.InitPID.InitialOutput,
    yMin=0,
    y_start=1.0,
    k=1.0/Q_flow_nominal,
    yMax=1.0)
    annotation (Placement(transformation(extent={{6,50},{26,70}})));

  Modelica.Blocks.Sources.CombiTimeTable load_profile(
    tableOnFile=true,
    tableName=tableName,
    columns=columns,
    extrapolation=Modelica.Blocks.Types.Extrapolation.HoldLastPoint,
    fileName=Modelica.Utilities.Files.loadResource(fileName)) if
                          heatLoad==DisHeatLib.Demand.BaseClasses.InputTypeQ.File
                 annotation (Placement(transformation(extent={{-88,50},
            {-68,70}})));
public
 Modelica.SIunits.Power Q_flow "Actual heat flow rate ";
 Modelica.SIunits.Power Q_flow_demand "Heat flow rate demanded";

protected
  parameter Modelica.SIunits.SpecificHeatCapacity cp_default=
      Medium.specificHeatCapacityCp(
        Medium.setState_pTX(
          p=Medium.p_default,
          T=Medium.T_default,
          X=Medium.X_default)) "Specific heat capacity at default medium state";

protected
  Modelica.Blocks.Sources.RealExpression load_const_input(y=
        Q_constant) if heatLoad==DisHeatLib.Demand.BaseClasses.InputTypeQ.Constant annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-78,34})));
public
  Modelica.Blocks.Interfaces.RealInput Qin(final unit="W") if  heatLoad==DisHeatLib.Demand.BaseClasses.InputTypeQ.Input
    "Connector of Real input signal" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={0,120})));
  replaceable BaseClasses.BaseDemand demandType(
    redeclare final package Medium = Medium,
    allowFlowReversal=allowFlowReversal,
    m_flow_small=m_flow_small,
    final Q_flow_nominal=Q_flow_nominal,
    final m_flow_nominal=m_flow_nominal,
    final TemSup_nominal=TemSup_nominal,
    final TemRet_nominal=TemRet_nominal) "Type of heat demand" annotation (Dialog(group="Nominal parameters"), Placement(
        transformation(extent={{-10,-10},{10,10}})),
      __Dymola_choicesAllMatching=true);
  IBPSA.Fluid.Movers.FlowControlled_m_flow pump(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    allowFlowReversal=allowFlowReversal,
    m_flow_small=m_flow_small,
    riseTime(displayUnit="min"),
    nominalValuesDefineDefaultPressureCurve=true,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=dp_nominal,
    addPowerToMedium=false) if FlowType == DisHeatLib.Substations.BaseClasses.BaseStationFlowType.Pump
    annotation (Placement(transformation(extent={{40,-42},{60,-22}})));
protected
  Modelica.Blocks.Math.Gain gain_scaling(k=scaling)
    annotation (Placement(transformation(extent={{-24,50},{-4,70}})));

protected
  Modelica.Blocks.Sources.RealExpression Q_flow_in(y=Q_flow) annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={0,32})));
protected
  Modelica.Blocks.Math.Gain gain(k=m_flow_nominal) if FlowType == DisHeatLib.Substations.BaseClasses.BaseStationFlowType.Pump
                                                   annotation (Placement(
        transformation(
        extent={{-4,-4},{4,4}},
        rotation=-90,
        origin={50,-10})));
protected
  IBPSA.Fluid.Actuators.Valves.TwoWayEqualPercentage     valve(
    redeclare package Medium = Medium,
    allowFlowReversal=allowFlowReversal,
    from_dp=from_dp,
    linearized=linearizeFlowResistance,
    dpValve_nominal(displayUnit="bar") = dp_nominal,
    m_flow_nominal=m_flow_nominal) if
                        FlowType == DisHeatLib.Substations.BaseClasses.BaseStationFlowType.Valve
    annotation (Placement(transformation(extent={{38,12},{58,32}})));
equation
  Q_flow = -demandType.Q_flow;
  Q_flow_demand = gain_scaling.y;

  connect(gain_scaling.y, PID.u_s)
    annotation (Line(points={{-3,60},{4,60}}, color={0,0,127}));
  connect(load_profile.y[1], gain_scaling.u)
    annotation (Line(points={{-67,60},{-26,60}}, color={0,0,127}));
  connect(load_const_input.y, gain_scaling.u) annotation (Line(points={{-67,34},
          {-40,34},{-40,60},{-26,60}}, color={0,0,127}));
  connect(gain_scaling.u, Qin) annotation (Line(points={{-26,60},{-40,60},{-40,80},
          {0,80},{0,120}}, color={0,0,127}));
  connect(Q_flow_in.y, PID.u_m)
    annotation (Line(points={{11,32},{16,32},{16,48}}, color={0,0,127}));
  connect(demandType.port_a, port_a)
    annotation (Line(points={{-10,0},{-100,0}}, color={0,127,255}));
  connect(gain.y, pump.m_flow_in)
    annotation (Line(points={{50,-14.4},{50,-20}}, color={0,0,127}));
  connect(PID.y, valve.y)
    annotation (Line(points={{27,60},{48,60},{48,34}}, color={0,0,127}));
  connect(demandType.port_b, valve.port_a) annotation (Line(points={{10,0},{28,0},
          {28,22},{38,22}}, color={0,127,255}));
  connect(valve.port_b, port_b) annotation (Line(points={{58,22},{70,22},{70,0},
          {100,0}}, color={0,127,255}));
  connect(PID.y, gain.u) annotation (Line(points={{27,60},{64,60},{64,-5.2},{50,
          -5.2}}, color={0,0,127}));
  connect(demandType.port_b, pump.port_a) annotation (Line(points={{10,0},{28,0},
          {28,-32},{40,-32}}, color={0,127,255}));
  connect(pump.port_b, port_b) annotation (Line(points={{60,-32},{70,-32},{70,0},
          {100,0}}, color={0,127,255}));
    annotation (
              Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          lineColor={200,200,200},
          fillColor={248,248,248},
          fillPattern=FillPattern.HorizontalCylinder,
          extent={{-100.0,-100.0},{100.0,100.0}},
          radius=25.0),
        Rectangle(
          lineColor={128,128,128},
          extent={{-100.0,-100.0},{100.0,100.0}},
          radius=25.0),
      Rectangle(
        fillColor={238,46,47},
        pattern=LinePattern.None,
        fillPattern=FillPattern.Solid,
        extent={{-47.875,-4.125},{47.875,4.125}},
        lineColor={0,0,0},
          origin={-52.125,-0.125},
          rotation=0),
        Ellipse(
          extent={{-14,13},{14,-13}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={247,247,247},
          fillPattern=FillPattern.Solid,
          origin={-66,1},
          rotation=-90),
        Line(
          points={{14,-7},{0,7},{-14,-7}},
          color={0,0,0},
          thickness=0.5,
          origin={-60,1},
          rotation=-90),
      Rectangle(
        fillColor={28,108,200},
        pattern=LinePattern.None,
        fillPattern=FillPattern.Solid,
        extent={{-34.5,-3.5},{34.5,3.5}},
        lineColor={0,0,0},
          origin={64.5,-0.5},
          rotation=180),
        Rectangle(
          extent={{-38,56},{80,-60}},
          lineColor={244,125,35},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          lineThickness=0.5),
        Bitmap(extent={{-20,-48},{58,44}}, fileName="modelica://DisHeatLib/Resources/Images/tap_icon.png", visible=not demandType.show_radiator),
        Bitmap(extent={{-26,-60},{74,58}}, fileName="modelica://DisHeatLib/Resources/Images/radiator_icon.png", visible=demandType.show_radiator)}),
                                                                            Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>This model is able to represent a thermal demand. The main idea is to model the characteristics of a heat demand by modelling its main variables, i.e., heat load and return temperature.</p>
<p>Three different options to model the heat load are possible:</p>
<ul>
<li>Use heat load profile from file</li>
<li>Use input connector as heat demand signal</li>
<li>Use a constant heat demand</li>
</ul>
<p>To represent the behaviour of the thermal demand in terms of its return temperature, three different options are available:</p>
<ul>
<li>Use return temperature profile from file</li>
<li>Use constant return temperature</li>
<li>Derive the return temperature using a radiator model based on the EN442 standard</li>
</ul>
<p>Different issues can accure with this model:</p>
<ul>
<li>Heat demand and heat supply do not always match (as a result of too low supply temperature, too high demand, etc.)</li>
<li>Low supply temperature or low temperature difference between supply and return might lead to high mass flows but might still result in an undersupply of the demand</li>
</ul>
<p><br>To avoid this issues, care must be taken in specifying the nominal values such as heat load, supply temperature, return temperature and mass flow.</p>
</html>", revisions="<html>
<ul>
<li>Feburary 27, 2019, by Benedikt Leitner:<br>Implementation and added User&apos;s guide. </li>
</ul>
</html>"));
end Demand;
