within DisHeatLib.Substations.BaseStations;
model DirectStation
  extends BaseClasses.BaseStation(
    final Q2_flow_nominal=Q1_flow_nominal,
    final TemSup2_nominal=Medium.T_default,
    final TemRet2_nominal=Medium.T_default,
    allowFlowReversal2=allowFlowReversal1,
    m2_flow_small=m1_flow_small,
    final m2_flow_nominal=m1_flow_nominal,
    final OutsideDependent=false);

equation
  connect(port_b2, port_a1) annotation (Line(points={{-100,-60},{-60,-60},{-60,60},
          {-100,60}}, color={0,127,255}));
  connect(port_b1, port_a2) annotation (Line(points={{100,60},{60,60},{60,-60},{
          100,-60}}, color={0,127,255}));
  annotation (Icon(graphics={            Rectangle(
          extent={{-70,80},{70,-80}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-100,60},{-48,62},{-44,62},{-48,-64},{-100,-60}},
          color={0,0,255},
          pattern=LinePattern.None),
        Line(
          points={{-100,60},{-32,60},{-32,-60},{-100,-60}},
          color={238,46,47},
          thickness=1),
        Line(
          points={{100,60},{32,60},{32,-60},{100,-60}},
          color={28,108,200},
          thickness=1)}),                   Documentation(info="<html>
<p>This is a model for an direct district heating substation. It is directly connects the primary side with the secondary side. It is basically only used as placeholder and to simplify compatibility issues.</p>
</html>"));
end DirectStation;
