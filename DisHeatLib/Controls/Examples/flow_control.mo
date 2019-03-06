within DisHeatLib.Controls.Examples;
model flow_control
  extends Modelica.Icons.Example;
  DisHeatLib.Controls.flow_control control(
    use_m_flow_in=false,
    T_const=333.15,
    m_flow_nominal=10)
    annotation (Placement(transformation(extent={{-10,-70},{10,-50}})));
  Modelica.Blocks.Sources.Ramp m_flow_measure(
    startTime(displayUnit="s") = 10000,
    offset=2,
    height=-2,
    duration(displayUnit="h") = 7200)
              annotation (Placement(transformation(extent={{-70,30},{-50,50}})));
  DisHeatLib.Controls.flow_control control_m(
    use_m_flow_in=true,
    T_const=333.15,
    m_flow_nominal=2)
    annotation (Placement(transformation(extent={{-10,-30},{10,-10}})));
  DisHeatLib.Controls.flow_control control_T(
    use_T_in=true,
    use_m_flow_in=false,
    m_flow_nominal=10)
    annotation (Placement(transformation(extent={{-10,10},{10,30}})));
  DisHeatLib.Controls.flow_control control_mT(
    use_T_in=true,
    use_m_flow_in=true,
    m_flow_nominal=2)
    annotation (Placement(transformation(extent={{-10,50},{10,70}})));
  Modelica.Blocks.Sources.Sine Tem_set(
    startTime(displayUnit="s") = 100,
    amplitude=10,
    freqHz=1/86400,
    offset=60.0 + 273.15,
    phase=3.1415926535898)
    annotation (Placement(transformation(extent={{-70,-10},{-50,10}})));
  Modelica.Blocks.Sources.Sine Tem_measure(
    startTime(displayUnit="s") = 100,
    amplitude=10,
    freqHz=1/86400,
    offset=60.0 + 273.15,
    phase=3.6651914291881)
    annotation (Placement(transformation(extent={{-70,-50},{-50,-30}})));
equation
  connect(m_flow_measure.y, control_mT.m_flow_measurement) annotation (Line(
        points={{-49,40},{-40,40},{-40,65},{-12,65}}, color={0,0,127}));
  connect(m_flow_measure.y, control_m.m_flow_measurement) annotation (Line(
        points={{-49,40},{-40,40},{-40,-15},{-12,-15}}, color={0,0,127}));
  connect(Tem_set.y, control_mT.T_set) annotation (Line(points={{-49,0},{-36,0},
          {-36,60},{-12,60}}, color={0,0,127}));
  connect(Tem_set.y, control_T.T_set) annotation (Line(points={{-49,0},{-36,0},{
          -36,20},{-12,20}}, color={0,0,127}));
  connect(Tem_measure.y, control_mT.T_measurement) annotation (Line(points={{-49,
          -40},{-32,-40},{-32,55},{-12,55}}, color={0,0,127}));
  connect(Tem_measure.y, control_T.T_measurement) annotation (Line(points={{-49,
          -40},{-32,-40},{-32,15},{-12,15}}, color={0,0,127}));
  connect(Tem_measure.y, control_m.T_measurement) annotation (Line(points={{-49,
          -40},{-32,-40},{-32,-25},{-12,-25}}, color={0,0,127}));
  connect(Tem_measure.y, control.T_measurement) annotation (Line(points={{-49,-40},
          {-32,-40},{-32,-65},{-12,-65}}, color={0,0,127}));
  annotation (__Dymola_Commands(file="modelica://DisHeatLib/Resources/Scripts/Dymola/Controls/Examples/flow_control.mos"
        "Simulate and plot"),
        Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(revisions="<html>
<ul>
<li>Feburary 27, 2019, by Benedikt Leitner:<br>Implementation and added User&apos;s guide. </li>
</ul>
</html>"));
end flow_control;
