within DisHeatLib.Substations.BaseClasses;
model DirectBaseStation
  extends BaseStation(
    final TemSup2_nominal=Medium.T_default,
    final TemRet2_nominal=Medium.T_default,
    final allowFlowReversal2=allowFlowReversal1,
    final m2_flow_small=m1_flow_small,
    final m2_flow_nominal=m1_flow_nominal,
    final OutsideDependent=false);



equation
  connect(port_b2, port_a1) annotation (Line(points={{-100,-60},{-80,-60},{-80,60},
          {-100,60}}, color={0,127,255}));
  connect(port_b1, port_a2) annotation (Line(points={{100,60},{80,60},{80,-60},{
          100,-60}}, color={0,127,255}));
  annotation (Icon(graphics={            Rectangle(
          extent={{-70,80},{70,-80}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{100,64},{38,56}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-64,-4},{64,4}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          origin={42,0},
          rotation=-90),
        Rectangle(
          extent={{100,-56},{38,-64}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-64,-4},{64,4}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid,
          origin={-42,0},
          rotation=-90),
        Rectangle(
          extent={{-38,-56},{-100,-64}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-38,64},{-100,56}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid)}), Documentation(info="<html>
<p>This is a model for an direct district heating substation. It is directly connects the primary side with the secondary side. It is basically only used as placeholder and to simplify compatibility issues.</p>
</html>"));
end DirectBaseStation;
