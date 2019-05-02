within DisHeatLib.Substations.BaseClasses;
partial model SubstationSingleInterface
   extends IBPSA.Fluid.Interfaces.PartialFourPortInterface(
    redeclare package Medium1 = Medium,
    redeclare package Medium2 = Medium);
  replaceable package Medium =
    Modelica.Media.Interfaces.PartialMedium "Medium in the component"
      annotation (choices(
        choice(redeclare package Medium = IBPSA.Media.Air "Moist air")));

  parameter Modelica.SIunits.PressureDifference dp1_nominal
    "Nominal pressure difference"
    annotation(Dialog(group = "Nominal condition"));

  parameter Boolean from_dp1 = false
    "= true, use m_flow = f(dp) else dp = f(m_flow)"
    annotation (Evaluate=true, Dialog(enable=FlowType == DisHeatLib.BaseClasses.FlowType.Valve,
                tab="Flow resistance", group="Primary side"));

  parameter Boolean linearizeFlowResistance1 = false
    "= true, use linear relation between m_flow and dp for any flow rate"
    annotation(Dialog(enable=FlowType == DisHeatLib.BaseClasses.FlowType.Valve,
               tab="Flow resistance", group="Primary side"));

  Modelica.Blocks.Sources.RealExpression total_power
    "sum of all power consumption/generation in component"
    annotation (Placement(transformation(extent={{66,-10},{86,10}})));
public
  Modelica.Blocks.Interfaces.RealOutput P(
    final quantity="Power",
    final unit="W",
    displayUnit="W") "Electric power" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={110,0})));
  IBPSA.Fluid.Sensors.RelativePressure senRelPre(redeclare package Medium =
        Medium)
    annotation (Placement(transformation(extent={{-10,110},{10,90}})));
equation
  connect(total_power.y,P)
    annotation (Line(points={{87,0},{110,0}}, color={0,0,127}));
  connect(port_a1, senRelPre.port_a) annotation (Line(points={{-100,60},{-100,100},
          {-10,100}},color={0,127,255}));
  connect(senRelPre.port_b, port_b1)
    annotation (Line(points={{10,100},{100,100},{100,60}},
                                                         color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end SubstationSingleInterface;
