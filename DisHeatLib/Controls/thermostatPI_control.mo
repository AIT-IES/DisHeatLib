within DisHeatLib.Controls;
model thermostatPI_control
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
  IBPSA.Controls.Continuous.LimPID  PI(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=m_flow_nominal,
    Ti=900,
    yMax=m_flow_nominal,
    yMin=0)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
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
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Modelica.Blocks.Interfaces.RealOutput y(quantity="MassFlowRate")
    "Connector of Real output signal"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

equation
  connect(tempSetpoint.y[1], PI.u_s)
    annotation (Line(points={{-19,0},{-12,0}}, color={0,0,127}));
  connect(T_measurement, PI.u_m) annotation (Line(points={{-120,0},{-80,0},{-80,
          -20},{0,-20},{0,-12}}, color={0,0,127}));
  connect(PI.y, y) annotation (Line(points={{11,0},{110,0}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                              Rectangle(extent={{-100,100},{100,-100}},  lineColor = {135, 135, 135}, fillColor = {255, 255, 170},
            fillPattern =                                                                                                   FillPattern.Solid), Text(extent = {{-58, 32}, {62, -20}}, lineColor = {175, 175, 175}, textString = "%name")}),
      Diagram(coordinateSystem(preserveAspectRatio=false)));
end thermostatPI_control;
