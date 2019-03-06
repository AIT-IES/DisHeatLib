within DisHeatLib.Substations.BaseClasses;
model DirectBaseStation
  extends BaseStation(
    Q_flow_nominal=m_flow_nominal_sec*(TemSup_nominal-TemRet_nominal)*cp_default,
    m_flow_nominal=Q_flow_nominal/((TemSup_nominal-TemRet_nominal)*cp_default),
    final TemSup_nominal_sec=Medium.T_default,
    final TemRet_nominal_sec=Medium.T_default,
    final m_flow_nominal_sec=m_flow_nominal,
    final OutsideDependent=false);

protected
      final parameter Modelica.SIunits.SpecificHeatCapacity cp_default=
        Medium.cp_const
        "Specific heat capacity of the fluid"
        annotation(Evaluate=true);

equation
  connect(port_sl_p, port_sl_s) annotation (Line(points={{-100,-60},{-62,-60},{-62,
          62},{-100,62},{-100,60}}, color={0,127,255}));
  connect(port_rl_s, port_rl_p) annotation (Line(points={{100,60},{64,60},{64,-60},
          {100,-60}}, color={0,127,255}));
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
