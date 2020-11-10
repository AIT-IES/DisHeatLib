within DisHeatLib.Demand.BaseDemands;
model FixedDeltaT
  extends BaseClasses.BaseDemand;

  IBPSA.Fluid.Sensors.TemperatureTwoPort senTemSL(
    redeclare package Medium = Medium,
    allowFlowReversal=allowFlowReversal,
    m_flow_nominal=m_flow_nominal,
    m_flow_small=m_flow_small)
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
protected
  Modelica.Blocks.Sources.RealExpression calculateReturnTemperature(y=senTemSL.T
         - (TemSup_nominal - TemRet_nominal)) annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-50,60})));
protected
  IBPSA.Fluid.HeatExchangers.SensibleCooler_T cooler(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    m_flow_small=m_flow_small,
    dp_nominal(displayUnit="Pa") = 0,
    allowFlowReversal=allowFlowReversal,
    T_start=TemSup_nominal)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
equation
  connect(port_a, senTemSL.port_a)
    annotation (Line(points={{-100,0},{-60,0}}, color={0,127,255}));
  connect(senTemSL.port_b, cooler.port_a)
    annotation (Line(points={{-40,0},{-10,0}}, color={0,127,255}));
  connect(cooler.port_b, port_b) annotation (Line(points={{10,0},{56,0},{56,0},
          {100,0}}, color={0,127,255}));
  connect(cooler.Q_flow, Q_flow) annotation (Line(points={{11,8},{20,8},{20,-80},
          {0,-80},{0,-110}}, color={0,0,127}));
  connect(calculateReturnTemperature.y, cooler.TSet) annotation (Line(points={{
          -39,60},{-20,60},{-20,8},{-12,8}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>This demand model has a fixed temperature difference. Attention, this might lead to return temperatures below the freezing point that would raise an error!</p>
</html>"));
end FixedDeltaT;
