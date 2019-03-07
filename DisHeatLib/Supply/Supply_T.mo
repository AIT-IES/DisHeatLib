within DisHeatLib.Supply;
model Supply_T "Temperature controlled supply unit"
  extends DisHeatLib.Supply.BaseClasses.BaseSupply(otherPowerUnits(y=0),      nPorts=
        1);

  // Supply temperature
  parameter Boolean use_T_in = false
  "Get the supply temperature from the input connector, otherwise use nominal value"
  annotation(Dialog(group = "Supply temperature"), Evaluate=true, HideResult=true, choices(checkBox=true));

public
  Modelica.Blocks.Interfaces.RealInput TSet(min=273.15, final unit="K") if
    use_T_in
    "Connector of Real input signal" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={0,120})));
public
  IBPSA.Fluid.HeatExchangers.Heater_T heater(redeclare package Medium = Medium,
      m_flow_nominal=m_flow_nominal,
    m_flow_small=m_flow_small,
    dp_nominal=0,
    allowFlowReversal=allowFlowReversal,
    QMax_flow=Q_flow_nominal)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
protected
  Modelica.Blocks.Sources.RealExpression TSupplySet(y=TemSup_nominal) if not
    use_T_in                                                annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-26,26})));
public
  Modelica.Blocks.Interfaces.RealOutput P if is_electric
    "Active power consumption/generation" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,-110})));
equation
  Q_flow = heater.Q_flow;
  connect(TSupplySet.y, heater.TSet)
    annotation (Line(points={{-15,26},{-12,26},{-12,8}},
                                                      color={0,0,127}));
  connect(heater.TSet, TSet) annotation (Line(points={{-12,8},{-12,86},{0,86},{0,
          120}},    color={0,0,127}));
  connect(P, P) annotation (Line(points={{0,-110},{0,-110}}, color={0,0,127}));
  connect(heater.port_b, ports_b[1])
    annotation (Line(points={{10,0},{100,0}}, color={0,127,255}));
  connect(port_a, heater.port_a)
    annotation (Line(points={{-100,0},{-10,0}}, color={0,127,255}));
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
        Line(
          points={{-12,6}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{-12,4}},
          color={0,0,0},
          thickness=0.5),
        Line(points={{-2,-32}}, color={200,200,200}),
        Ellipse(
          extent={{-50,52},{48,-48}},
          lineColor={0,0,0},
          fillColor={247,247,247},
          fillPattern=FillPattern.Solid,
          lineThickness=0.5),
        Polygon(
          points={{-10,-38},{-2,-4},{-22,-4},{6,38},{-2,4},{18,4},{-10,-38}},
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
end Supply_T;
