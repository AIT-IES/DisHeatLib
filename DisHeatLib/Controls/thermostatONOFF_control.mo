within DisHeatLib.Controls;
model thermostatONOFF_control
  parameter Real setpointTable[:,:]=[0,18; 6,21; 9,18; 15,21; 21,18]
    "Table matrix (time = first column [h]; temperature setpoints = second column [degC])";
  parameter Modelica.SIunits.TemperatureDifference bandwidth=0.5 "Bandwidth around reference signal";
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal "Nominal mass flow rate";

public
  Modelica.Blocks.Interfaces.RealInput T_measurement(each final unit="K",
      displayUnit="degC") "Connector of Real input signal" annotation (
      Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,0})));
  Modelica.Blocks.Logical.OnOffController
                                    PI(bandwidth=bandwidth)
    annotation (Placement(transformation(extent={{-30,-10},{-10,10}})));
public
  Modelica.Blocks.Sources.CombiTimeTable tempSetpoint(
    tableOnFile=false,
    table=setpointTable,
    columns={2},
    smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    y(unit="K"),
    offset={273.15},
    timeScale(displayUnit="h") = 3600) "Table used for interpolation"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Modelica.Blocks.Math.BooleanToReal booleanToReal(realTrue=m_flow_nominal)
    annotation (Placement(transformation(extent={{10,-10},{30,10}})));
  Modelica.Blocks.Interfaces.RealOutput y(quantity="MassFlowRate")
    "Connector of Real output signal"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

equation
  connect(PI.y,booleanToReal. u)
    annotation (Line(points={{-9,0},{8,0}},    color={255,0,255}));
  connect(T_measurement, PI.u) annotation (Line(points={{-120,0},{-60,0},{-60,-6},
          {-32,-6}}, color={0,0,127}));
  connect(tempSetpoint.y[1], PI.reference) annotation (Line(points={{-59,30},{-40,
          30},{-40,6},{-32,6}}, color={0,0,127}));
  connect(booleanToReal.y, y)
    annotation (Line(points={{31,0},{110,0}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                              Rectangle(extent={{-100,100},{100,-100}},  lineColor = {135, 135, 135}, fillColor = {255, 255, 170},
            fillPattern =                                                                                                   FillPattern.Solid), Text(extent = {{-58, 32}, {62, -20}}, lineColor = {175, 175, 175}, textString = "%name")}),
      Diagram(coordinateSystem(preserveAspectRatio=false)));
end thermostatONOFF_control;
