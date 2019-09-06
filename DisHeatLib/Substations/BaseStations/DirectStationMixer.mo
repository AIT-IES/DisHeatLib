within DisHeatLib.Substations.BaseStations;
model DirectStationMixer
  extends BaseClasses.BaseStation(
    final Q2_flow_nominal=Q1_flow_nominal,
    TemSup2_nominal=Medium.T_default,
    final TemRet2_nominal=Medium.T_default,
    allowFlowReversal2=allowFlowReversal1,
    m2_flow_small=m1_flow_small,
    final m2_flow_nominal=m1_flow_nominal,
    final OutsideDependent=false);

  Storage.BaseClasses.ThermostatMixer mixerValve(
    redeclare package Medium = Medium,
    m_flow_nominal=m1_flow_nominal,
    dp_nominal=dp1_nominal,
    Tem_set=TemSup2_nominal) annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=-90,
        origin={-60,30})));
  IBPSA.Fluid.FixedResistances.Junction jun(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial,
    m_flow_nominal={m1_flow_nominal,m1_flow_nominal,m1_flow_nominal},
    dp_nominal={0,0,0})
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={60,30})));
equation
  connect(jun.port_1, port_b1)
    annotation (Line(points={{60,40},{60,60},{100,60}}, color={0,127,255}));
  connect(jun.port_2, port_a2)
    annotation (Line(points={{60,20},{60,-60},{100,-60}}, color={0,127,255}));
  connect(jun.port_3, mixerValve.port_3)
    annotation (Line(points={{50,30},{-50,30}}, color={0,127,255}));
  connect(mixerValve.port_2, port_a1)
    annotation (Line(points={{-60,40},{-60,60},{-100,60}}, color={0,127,255}));
  connect(mixerValve.port_1, port_b2) annotation (Line(points={{-60,20},{-60,-60},
          {-100,-60}}, color={0,127,255}));
  annotation (Icon(graphics={
        Line(
          points={{-100,60},{-48,62},{-44,62},{-48,-64},{-100,-60}},
          color={0,0,255},
          pattern=LinePattern.None),
        Line(
          points={{100,60},{32,60},{32,-60},{100,-60}},
          color={28,108,200},
          thickness=1),
        Line(
          points={{-78,10},{-48,-10},{-52,-4},{-54,-2},{-58,18},{-62,32},{-62,
              38}},
          color={0,0,0},
          pattern=LinePattern.None,
          thickness=1),
        Line(
          points={{-64,60}},
          color={238,46,47},
          thickness=1),
        Line(
          points={{32,2},{-30,2}},
          color={28,108,200},
          thickness=1),
        Line(
          points={{-100,60},{-32,60},{-32,6}},
          color={244,125,35},
          thickness=1),
        Polygon(
          points={{-32,2},{-44,20},{-20,20},{-32,2}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-100,-60},{-32,-60},{-32,-2}},
          color={238,46,47},
          thickness=1),
        Polygon(
          points={{-32,2},{-44,-16},{-20,-16},{-32,2}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{0,-9},{-12,9},{12,9},{0,-9}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          origin={-23,2},
          rotation=-90)}),                  Documentation(info="<html>
<p>This is a model for an direct district heating substation. It is directly connects the primary side with the secondary side. It is basically only used as placeholder and to simplify compatibility issues.</p>
</html>"));
end DirectStationMixer;
