within DisHeatLib.Demand.BaseDemands;
model Radiator
  extends BaseClasses.BaseDemand(show_radiator=true);
  // EN442 parameters
  parameter Modelica.SIunits.Temperature TemRoom(displayUnit="degC") = 21.0+273.15
    "Room temperature at nominal condition";
  parameter Integer nEle(min=1) = 5
    "Number of elements used in the discretization";
  parameter Real fraRad(min=0, max=1) = 0.35 "Fraction radiant heat transfer";
  parameter Real n=1.3
    "Heat transfer exponent";

protected
  IBPSA.Fluid.HeatExchangers.Radiators.RadiatorEN442_2 rad(
    redeclare package Medium = Medium,
    m_flow_small=m_flow_small,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    T_start=TemSup_nominal,
    nEle=nEle,
    fraRad=fraRad,
    n=n,
    m_flow_nominal=m_flow_nominal,
    Q_flow_nominal=Q_flow_nominal,
    T_a_nominal=TemSup_nominal,
    T_b_nominal=TemRet_nominal,
    TAir_nominal=TemRoom,
    TRad_nominal=TemRoom,
    dp_nominal(displayUnit="kPa") = 0,
    allowFlowReversal=allowFlowReversal)
    annotation (Placement(transformation(extent={{-10,10},{10,-10}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T=TemRoom)
    annotation (Placement(transformation(extent={{80,-60},{60,-40}})));
protected
  Modelica.Thermal.HeatTransfer.Sensors.HeatFlowSensor heatFlowSensor
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,-30})));
equation
  connect(heatFlowSensor.port_a, fixedTemperature.port) annotation (Line(points=
         {{-4.44089e-16,-40},{-4.44089e-16,-50},{60,-50}}, color={191,0,0}));
  connect(heatFlowSensor.Q_flow, Q_flow) annotation (Line(points={{10,-30},{50,
          -30},{50,-94},{0,-94},{0,-110}}, color={0,0,127}));
  connect(port_a, rad.port_a)
    annotation (Line(points={{-100,0},{-10,0}}, color={0,127,255}));
  connect(rad.port_b, port_b)
    annotation (Line(points={{10,0},{100,0}}, color={0,127,255}));
  connect(rad.heatPortCon, heatFlowSensor.port_b) annotation (Line(points={{-2,
          -7.2},{-2,-14},{-2,-20},{4.44089e-16,-20}}, color={191,0,0}));
  connect(rad.heatPortRad, heatFlowSensor.port_b)
    annotation (Line(points={{2,-7.2},{2,-20},{0,-20}}, color={191,0,0}));
  annotation (Icon(graphics={
        Ellipse(
          extent={{-20,22},{20,-20}},
          fillColor={127,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-95,6},{106,-4}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-102,-4},{-2,6}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-20,22},{20,-20}},
          fillColor={127,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-80,60},{80,-60}},
          lineColor={0,0,0},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-66,30},{66,30}}),
        Line(
          points={{-66,2},{66,2}}),
        Line(
          points={{-66,-30},{66,-30}}),
        Line(
          points={{-66,60},{-66,-60}}),
        Line(
          points={{66,60},{66,-60}})}), Documentation(info="<html>
<p>This demand model uses a radiator model based on the standard EN 442 to calculate the return temperature as a function of supply temperature and room temperature.</p>
</html>", revisions="<html>
<ul>
<li>Feburary 27, 2019, by Benedikt Leitner:<br>Implementation and added User&apos;s guide. </li>
</ul>
</html>"));
end Radiator;
