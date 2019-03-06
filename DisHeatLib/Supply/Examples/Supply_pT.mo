within DisHeatLib.Supply.Examples;
model Supply_pT
  import DisHeatLib;
  extends Modelica.Icons.Example;
  package Medium = IBPSA.Media.Water;

  DisHeatLib.Supply.Supply_pT supply_pT(
    redeclare package Medium = Medium,
    Q_flow_nominal=10000,
    TemSup_nominal=353.15,
    TemRet_nominal=313.15,
    powerCha(Q_flow={0,1000}, P={0,-2000}),
    dp_controller=false,
    dp_nominal=1000000)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  IBPSA.Fluid.HeatExchangers.SensibleCooler_T coo(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    dp_nominal=10)
    annotation (Placement(transformation(extent={{10,34},{-10,54}})));
  Modelica.Blocks.Sources.RealExpression TSetConst(y=40 + 273.15)
                                                annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={38,62})));
equation
  connect(TSetConst.y, coo.TSet) annotation (Line(points={{27,62},{22,62},{22,
          52},{12,52}}, color={0,0,127}));
  connect(supply_pT.port_rl, coo.port_b) annotation (Line(points={{-10,0},{-20,
          0},{-20,44},{-10,44}}, color={0,127,255}));
  connect(coo.port_a, supply_pT.port_sl) annotation (Line(points={{10,44},{20,
          44},{20,0},{10,0}}, color={0,127,255}));
  annotation (__Dymola_Commands(file="modelica://DisHeatLib/Resources/Scripts/Dymola/Supply/Examples/Supply_pT.mos"
        "Simulate and plot"),
        Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(revisions="<html>
<ul>
<li>Feburary 27, 2019, by Benedikt Leitner:<br>Implementation and added User&apos;s guide. </li>
</ul>
</html>"));
end Supply_pT;
