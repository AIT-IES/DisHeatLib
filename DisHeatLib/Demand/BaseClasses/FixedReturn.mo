within DisHeatLib.Demand.BaseClasses;
model FixedReturn
  extends BaseDemand;

  // Return temperature
  parameter DisHeatLib.Demand.BaseClasses.InputTypeTret returnTemperature = DisHeatLib.Demand.BaseClasses.InputTypeTret.Constant "Fixed return temperature"
    annotation(Evaluate = true, Dialog(group="Return temperature"));

  // File parameters
  parameter String tableName="NoName"
    "Table name on file or in function usertab (see docu)"
    annotation (Dialog(group="Return temperature - From file",enable= returnTemperature == DisHeatLib.Demand.BaseClasses.InputTypeTret.File));
  parameter String fileName="NoName" "File where matrix is stored"
    annotation (Dialog(
      group="Return temperature - From file",
      enable=returnTemperature == DisHeatLib.Demand.BaseClasses.InputTypeTret.File,
      loadSelector(filter="Text files (*.txt);;MATLAB MAT-files (*.mat)",
          caption="Open file in which table is present")));
  parameter Integer columns[:]={2}
    "Columns of table to be interpolated"
    annotation (Dialog(group="Return temperature - From file",enable=returnTemperature == DisHeatLib.Demand.BaseClasses.InputTypeTret.File));

protected
  IBPSA.Fluid.HeatExchangers.SensibleCooler_T cooler(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    m_flow_small=m_flow_small,
    dp_nominal(displayUnit="Pa") = 0,
    allowFlowReversal=allowFlowReversal,
    T_start=TemSup_nominal)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
protected
  Modelica.Blocks.Sources.RealExpression TSet(y=TemRet_nominal) if returnTemperature==DisHeatLib.Demand.BaseClasses.InputTypeTret.Constant    annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-44,60})));
  Modelica.Blocks.Sources.CombiTimeTable Tret_profile(
    tableOnFile=true,
    tableName=tableName,
    columns=columns,
    extrapolation=Modelica.Blocks.Types.Extrapolation.HoldLastPoint,
    fileName=Modelica.Utilities.Files.loadResource(fileName)) if
                            returnTemperature == DisHeatLib.Demand.BaseClasses.InputTypeTret.File
    annotation (Placement(transformation(extent={{-54,22},{-34,42}})));
equation
  connect(cooler.Q_flow, Q_flow) annotation (Line(points={{11,8},{20,8},{20,-70},
          {0,-70},{0,-110}}, color={0,0,127}));
  connect(cooler.port_b, port_b) annotation (Line(points={{10,0},{56,0},{56,0},{
          100,0}}, color={0,127,255}));
  connect(cooler.port_a, port_a)
    annotation (Line(points={{-10,0},{-100,0}}, color={0,127,255}));
  connect(TSet.y, cooler.TSet) annotation (Line(points={{-33,60},{-26,60},{-26,8},
          {-12,8}},                            color={0,0,
          127}));
  connect(Tret_profile.y[1], cooler.TSet) annotation (
      Line(points={{-33,32},{-26,32},{-26,8},{-12,8}},
        color={0,0,127}));
  annotation (Icon(graphics={
        Rectangle(
          extent={{-70,60},{70,-60}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-102,5},{99,-5}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-70,60},{70,-60}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid)}), Documentation(info="<html>
<p>This demand model has a fixed return temperature in case the supply temperature is above the return temperature set-point. Otherwise the return temperature equals the supply temperature.</p>
</html>", revisions="<html>
<ul>
<li>Feburary 27, 2019, by Benedikt Leitner:<br>Implementation and added User&apos;s guide. </li>
</ul>
</html>"));
end FixedReturn;
