within DisHeatLib.Demand;
model Demand
  extends IBPSA.Fluid.Interfaces.PartialTwoPortInterface(
    m_flow_nominal=Q_flow_nominal/((TemSup_nominal-TemRet_nominal)*cp_default));
  extends IBPSA.Fluid.Interfaces.TwoPortFlowResistanceParameters(
    final computeFlowResistance=(abs(dp_nominal) > Modelica.Constants.eps));

  // Nominal parameters
  parameter Modelica.SIunits.Power Q_flow_nominal
    "Nominal heat flow rate"
    annotation(Evaluate = true, Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.Temperature TemSup_nominal(displayUnit="degC")=60.0+273.15 "Nominal supply temperature"
    annotation(Evaluate = true, Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.Temperature TemRet_nominal(displayUnit="degC")=35.0+273.15 "Nominal return temperature"
    annotation(Evaluate = true, Dialog(group="Nominal condition"));

  // Heat/flow load
  parameter DisHeatLib.Demand.BaseClasses.InputTypeDemand heatLoad = DisHeatLib.Demand.BaseClasses.InputTypeDemand.ConstantQ "Calculation of heat load"
    annotation(Evaluate = true, Dialog(group="Heat/flow demand"));
  parameter Real scaling = 1.0 "Scaling factor for heat demand"
  annotation (Evaluate = true, Dialog(group="Heat/flow demand"));
  parameter Modelica.SIunits.Power Q_constant = 0.0 "Constant heat demand"
    annotation (Evaluate = true, Dialog(enable = heatLoad==DisHeatLib.Demand.BaseClasses.InputTypeDemand.ConstantQ, group="Heat/flow demand"));
  parameter Modelica.SIunits.MassFlowRate m_constant = 0.0 "Constant flow demand"
    annotation (Evaluate = true, Dialog(enable = heatLoad==DisHeatLib.Demand.BaseClasses.InputTypeDemand.ConstantM, group="Heat/flow demand"));
  parameter String tableName="NoName"
    "Table name on file or in function usertab (see docu)"
    annotation (Dialog(enable = heatLoad==DisHeatLib.Demand.BaseClasses.InputTypeDemand.FileQ or heatLoad==DisHeatLib.Demand.BaseClasses.InputTypeDemand.FileM, group="Heat/flow demand"));
  parameter String fileName="NoName" "File where matrix is stored"
    annotation (Dialog(enable = heatLoad==DisHeatLib.Demand.BaseClasses.InputTypeDemand.FileQ or heatLoad==DisHeatLib.Demand.BaseClasses.InputTypeDemand.FileM, group="Heat/flow demand",
      loadSelector(filter="Text files (*.txt);;MATLAB MAT-files (*.mat)",
          caption="Open file in which table is present")));
  parameter Integer columns[:]={2}
    "Columns of table to be interpolated"
    annotation (Dialog(enable = heatLoad==DisHeatLib.Demand.BaseClasses.InputTypeDemand.FileQ or heatLoad==DisHeatLib.Demand.BaseClasses.InputTypeDemand.FileM, group="Heat/flow demand"));

public
  Modelica.Blocks.Continuous.LimPID PID(
    Ti=60,
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    initType=Modelica.Blocks.Types.InitPID.InitialOutput,
    yMin=0,
    y_start=1.0,
    k=1.0/Q_flow_nominal,
    yMax=1.0) if heatLoad == DisHeatLib.Demand.BaseClasses.InputTypeDemand.ConstantQ
     or heatLoad == DisHeatLib.Demand.BaseClasses.InputTypeDemand.InputQ or
    heatLoad == DisHeatLib.Demand.BaseClasses.InputTypeDemand.FileQ
    annotation (Placement(transformation(extent={{16,42},{36,62}})));

protected
  Modelica.Blocks.Sources.CombiTimeTable load_profile(
    tableOnFile=true,
    tableName=tableName,
    columns=columns,
    extrapolation=Modelica.Blocks.Types.Extrapolation.HoldLastPoint,
    fileName=Modelica.Utilities.Files.loadResource(fileName)) if heatLoad ==
    DisHeatLib.Demand.BaseClasses.InputTypeDemand.FileQ or heatLoad ==
    DisHeatLib.Demand.BaseClasses.InputTypeDemand.FileM
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
  Modelica.Blocks.Sources.RealExpression load_constQ_input(y=Q_constant) if
    heatLoad == DisHeatLib.Demand.BaseClasses.InputTypeDemand.ConstantQ
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-78,34})));
public
  Modelica.Blocks.Interfaces.RealInput u(final unit=if heatLoad == DisHeatLib.Demand.BaseClasses.InputTypeDemand.InputQ
         then "W" else "kg/s") if heatLoad == DisHeatLib.Demand.BaseClasses.InputTypeDemand.InputQ
     or heatLoad == DisHeatLib.Demand.BaseClasses.InputTypeDemand.InputM
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
  replaceable DisHeatLib.BaseClasses.FlowUnit flowUnit(
    redeclare final package Medium = Medium,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=m_flow_nominal,
    final m_flow_small=m_flow_small,
    FlowType=DisHeatLib.BaseClasses.FlowType.Pump,
    final dp_nominal=dp_nominal,
    final dpFixed_nominal=0,
    final from_dp=from_dp,
    final linearizeFlowResistance=linearizeFlowResistance)
    annotation (Dialog(group="Parameters"), Placement(transformation(extent={{40,-10},{60,10}})));
public
  Modelica.Blocks.Math.Gain gain_scaling(k=scaling)
    annotation (Placement(transformation(extent={{-24,42},{-4,62}})));

protected
  Modelica.Blocks.Math.Gain gain_relative(k=1/m_flow_nominal) if heatLoad ==
    DisHeatLib.Demand.BaseClasses.InputTypeDemand.InputM or heatLoad ==
    DisHeatLib.Demand.BaseClasses.InputTypeDemand.ConstantM or heatLoad ==
    DisHeatLib.Demand.BaseClasses.InputTypeDemand.FileM
    annotation (Placement(transformation(extent={{16,76},{36,96}})));
protected
  Modelica.Blocks.Sources.RealExpression load_constM_input(y=m_constant) if
    heatLoad == DisHeatLib.Demand.BaseClasses.InputTypeDemand.ConstantM                  annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-78,16})));
protected
  Modelica.Blocks.Math.Gain negative(k=-1) annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=90,
        origin={26,26})));
equation
  Q_flow = -demandType.Q_flow;
  if heatLoad == DisHeatLib.Demand.BaseClasses.InputTypeDemand.ConstantQ or heatLoad == DisHeatLib.Demand.BaseClasses.InputTypeDemand.InputQ or heatLoad == DisHeatLib.Demand.BaseClasses.InputTypeDemand.FileQ then
    Q_flow_demand = gain_scaling.y;
  else
    Q_flow_demand = 0.0;
  end if;

  connect(gain_scaling.y, PID.u_s)
    annotation (Line(points={{-3,52},{14,52}},color={0,0,127}));
  connect(load_profile.y[1], gain_scaling.u)
    annotation (Line(points={{-67,60},{-46,60},{-46,52},{-26,52}},
                                                 color={0,0,127}));
  connect(load_constQ_input.y, gain_scaling.u) annotation (Line(points={{-67,34},
          {-40,34},{-40,52},{-26,52}}, color={0,0,127}));
  connect(gain_scaling.u, u) annotation (Line(points={{-26,52},{-40,52},{-40,80},
          {0,80},{0,120}}, color={0,0,127}));
  connect(demandType.port_a, port_a)
    annotation (Line(points={{-10,0},{-100,0}}, color={0,127,255}));
  connect(demandType.port_b, flowUnit.port_a)
    annotation (Line(points={{10,0},{40,0}}, color={0,127,255}));
  connect(flowUnit.port_b, port_b)
    annotation (Line(points={{60,0},{100,0}}, color={0,127,255}));
  connect(PID.y, flowUnit.y)
    annotation (Line(points={{37,52},{50,52},{50,12}}, color={0,0,127}));
  connect(gain_relative.y, flowUnit.y)
    annotation (Line(points={{37,86},{50,86},{50,12}}, color={0,0,127}));
  connect(gain_scaling.y, gain_relative.u)
    annotation (Line(points={{-3,52},{2,52},{2,86},{14,86}}, color={0,0,127}));
  connect(load_constM_input.y, gain_scaling.u) annotation (Line(points={{-67,16},
          {-40,16},{-40,52},{-26,52}}, color={0,0,127}));
  connect(PID.u_m, negative.y)
    annotation (Line(points={{26,40},{26,32.6}}, color={0,0,127}));
  connect(demandType.Q_flow, negative.u) annotation (Line(points={{0,-11},{0,
          -26},{26,-26},{26,18.8}}, color={0,0,127}));
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
