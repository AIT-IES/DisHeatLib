within DisHeatLib.Supply;
model Supply_QT "Heat flow and temperature controlled supply unit"
  extends DisHeatLib.Supply.BaseClasses.BaseSupply(otherPowerUnits(y=pump.P), nPorts=
        1);

  parameter Modelica.SIunits.PressureDifference dp_nominal
    "Nominal pressure difference of pump"
    annotation(Dialog(group = "Nominal condition"));

  parameter Modelica.SIunits.Efficiency pump_eff = 0.4 "Total efficiency of the pump"
  annotation(Dialog(group="Nominal parameters"), Evaluate=true);

  // Supply temperature
  parameter Boolean use_T_in = false
  "Get the supply temperature from the input connector, otherwise use nominal value"
  annotation(Dialog(group = "Supply temperature"), Evaluate=true, HideResult=true, choices(checkBox=true));

  // Heat supply
  parameter Boolean use_Q_in = false
  "Get the heat supply from the input connector, otherwise use nominal value"
  annotation(Dialog(group = "Heat supply"), Evaluate=true, HideResult=true, choices(checkBox=true));

  // Limit mass flow injection
  parameter Boolean use_m_flow_limit = false
  "Limit mass flow to input signal"
  annotation(Dialog(group = "Heat supply"), Evaluate=true, HideResult=true, choices(checkBox=true));

public
  Modelica.Blocks.Interfaces.RealInput TSet(min=273.15, final unit="K") if
    use_T_in
    "Connector of Real input signal" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={60,120})));
public
  IBPSA.Fluid.HeatExchangers.Heater_T heater(redeclare package Medium = Medium,
      m_flow_nominal=m_flow_nominal,
    m_flow_small=m_flow_small,
    dp_nominal=0,
    allowFlowReversal=allowFlowReversal)
    annotation (Placement(transformation(extent={{8,-10},{28,10}})));
protected
  Modelica.Blocks.Sources.RealExpression TSupplySet(y=TemSup_nominal) if not
    use_T_in                                                annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-8,26})));
public
  Modelica.Blocks.Continuous.LimPID PID(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    yMin=0,
    yMax=if Q_flow_nominal < 0.001 then 0 else m_flow_nominal,
    k=if Q_flow_nominal < 0.001 then 1 else 0.5*m_flow_nominal/Q_flow_nominal,
    Ti=60)
    "uses correlation Q_flow = c_p delta_T m_flow and allowing for a 50 percent smaller delta_T than nominal when limiting m_flow"
    annotation (Placement(transformation(extent={{-54,64},{-34,44}})));
public
  Modelica.Blocks.Interfaces.RealInput QSet if use_Q_in annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={-60,120})));
public
  IBPSA.Fluid.Movers.FlowControlled_m_flow pump(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    T_start=TemSup_nominal,
    m_flow_small=m_flow_small,
    nominalValuesDefineDefaultPressureCurve=true,
    m_flow_nominal=m_flow_nominal,
    allowFlowReversal=allowFlowReversal,
    dp_nominal=dp_nominal,
    per(hydraulicEfficiency(eta={sqrt(pump_eff)}), motorEfficiency(eta={sqrt(
            pump_eff)})),
    addPowerToMedium=true,
    tau=30)
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
protected
  Modelica.Blocks.Sources.RealExpression QconstSet(y=Q_flow_nominal) if
                                                                not use_Q_in
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-76,30})));
protected
  Modelica.Blocks.Sources.RealExpression Q_flow_nominal1(y=Q_flow_nominal) if
    use_Q_in annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-86,90})));
public
  Modelica.Blocks.Math.Min min if use_Q_in
    "Limit the input signal to maximum heat capacity; avoids problems when heat capacity is set directly at heater"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-66,74})));
public
  Modelica.Blocks.Interfaces.RealInput m_flow_limit if use_m_flow_limit
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={0,120})));
public
  Modelica.Blocks.Math.Min min1 if use_m_flow_limit
    "Limit the input signal to m_flow_limit; avoids injection of higher mass flows than needed in network"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-12,52})));
  Modelica.Blocks.Routing.RealPassThrough realPassThrough if not
    use_m_flow_limit annotation (Placement(transformation(
        extent={{-7,-7},{7,7}},
        rotation=-90,
        origin={-43,27})));
equation
  Q_flow = heater.Q_flow;
  connect(TSupplySet.y, heater.TSet)
    annotation (Line(points={{3,26},{6,26},{6,8}},    color={0,0,127}));
  connect(heater.Q_flow, PID.u_m) annotation (Line(points={{29,8},{30,8},{30,76},
          {-44,76},{-44,66}},   color={0,0,127}));
  connect(pump.port_b, heater.port_a) annotation (Line(
        points={{-20,0},{8,0}},color={0,127,255}));
  connect(QconstSet.y, PID.u_s) annotation (Line(points={{-65,30},{-60,30},{-60,
          54},{-56,54}},                        color={0,
          0,127}));
  connect(heater.TSet, TSet) annotation (Line(points={{6,8},{6,86},{60,86},{60,
          120}},    color={0,0,127}));
  connect(QSet,min. u1)
    annotation (Line(points={{-60,120},{-60,86}}, color={0,0,127}));
  connect(min.y, PID.u_s)
    annotation (Line(points={{-66,63},{-66,54},{-56,54}}, color={0,0,127}));
  connect(min.u2, Q_flow_nominal1.y)
    annotation (Line(points={{-72,86},{-72,90},{-75,90}}, color={0,0,127}));
  connect(port_a, pump.port_a)
    annotation (Line(points={{-100,0},{-40,0}}, color={0,127,255}));
  connect(heater.port_b, ports_b[1])
    annotation (Line(points={{28,0},{100,0}}, color={0,127,255}));
  connect(m_flow_limit, min1.u1) annotation (Line(points={{0,120},{-2,120},{-2,64},
          {-6,64}}, color={0,0,127}));
  connect(PID.y, min1.u2) annotation (Line(points={{-33,54},{-30,54},{-30,72},{-18,
          72},{-18,64}}, color={0,0,127}));
  connect(min1.y, pump.m_flow_in) annotation (Line(points={{-12,41},{-12,38},{-30,
          38},{-30,12}}, color={0,0,127}));
  connect(PID.y, realPassThrough.u) annotation (Line(points={{-33,54},{-30,54},{
          -30,40},{-43,40},{-43,35.4}}, color={0,0,127}));
  connect(realPassThrough.y, pump.m_flow_in) annotation (Line(points={{-43,19.3},
          {-43,18},{-30,18},{-30,12}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false),
        graphics={
        Line(
          points={{-12,6}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{-12,4}},
          color={0,0,0},
          thickness=0.5),
        Line(points={{-2,-32}}, color={200,200,200}),
        Line(
          points={{-70,-62}},
          color={28,108,200},
          thickness=1),
        Rectangle(
          lineColor={128,128,128},
          extent={{-100.0,-100.0},{100.0,100.0}},
          radius=25.0),
        Rectangle(
          lineColor={128,128,128},
          extent={{-100,-100},{100,100}},
          radius=25.0),
      Rectangle(
        fillColor={0,128,255},
        pattern=LinePattern.None,
        fillPattern=FillPattern.Solid,
        extent={{-47.875,-4.125},{47.875,4.125}},
        lineColor={0,0,0},
          origin={-52.125,-0.125},
          rotation=0),
      Rectangle(
        fillColor={255,85,85},
        pattern=LinePattern.None,
        fillPattern=FillPattern.Solid,
        extent={{-34.5,-3.5},{34.5,3.5}},
        lineColor={0,0,0},
          origin={64.5,-0.5},
          rotation=180),
        Ellipse(
          extent={{-14,13},{14,-13}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={247,247,247},
          fillPattern=FillPattern.Solid,
          origin={-66,1},
          rotation=-90),
        Line(
          points={{-12,6}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{-12,4}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{14,-7},{0,7},{-14,-7}},
          color={0,0,0},
          thickness=0.5,
          origin={-60,1},
          rotation=-90),
        Line(points={{-2,-32}}, color={200,200,200}),
        Ellipse(
          extent={{-34,52},{64,-48}},
          lineColor={0,0,0},
          fillColor={247,247,247},
          fillPattern=FillPattern.Solid,
          lineThickness=0.5),
        Polygon(
          points={{6,-38},{14,-4},{-6,-4},{22,38},{14,4},{34,4},{6,-38}},
          lineColor={0,0,0},
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid,
          lineThickness=0.5)}),                                  Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<h4>General</h4>
<p>This supply unit is modelled as a perfect heater delivering a prescribed supply temperature. The mass flow is controlled by a PI-controller using a set point for heat generation. The unit is constraint by a maximum heat flow capacity.</p>
<h4>Heat and power</h4>
<p>The unit can be modelled as a simple heat and power unit using the characteristic powerCha. Electric power consumption/generation is then set according to the power values corresponding to current heat flow using table entries from the characteristic (and linearly interpolating). Electric power consumption of the pump is also considered. Since the pump is considered to be cooled by the fluid, a one to one conversion between heat added to the fluid and pumping power is considered.</p>
</html>", revisions="<html>
<ul>
<li>Feburary 27, 2019, by Benedikt Leitner:<br>Implementation and added User&apos;s guide. </li>
</ul>
</html>"));
end Supply_QT;
