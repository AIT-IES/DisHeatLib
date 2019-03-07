within DisHeatLib.BaseClasses;
partial model PartialFourPortVector "Partial model with four ports"

  replaceable package Medium1 =
    Modelica.Media.Interfaces.PartialMedium "Medium 1 in the component"
      annotation (choices(
        choice(redeclare package Medium = IBPSA.Media.Air "Moist air"),
        choice(redeclare package Medium = IBPSA.Media.Water "Water"),
        choice(redeclare package Medium =
            IBPSA.Media.Antifreeze.PropyleneGlycolWater (
          property_T=293.15,
          X_a=0.40)
          "Propylene glycol water, 40% mass fraction")));
  replaceable package Medium2 =
    Modelica.Media.Interfaces.PartialMedium "Medium 2 in the component"
      annotation (choices(
        choice(redeclare package Medium = IBPSA.Media.Air "Moist air"),
        choice(redeclare package Medium = IBPSA.Media.Water "Water"),
        choice(redeclare package Medium =
            IBPSA.Media.Antifreeze.PropyleneGlycolWater (
          property_T=293.15,
          X_a=0.40)
          "Propylene glycol water, 40% mass fraction")));

  parameter Boolean allowFlowReversal1 = true
    "= false to simplify equations, assuming, but not enforcing, no flow reversal for medium 1"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);
  parameter Boolean allowFlowReversal2 = true
    "= false to simplify equations, assuming, but not enforcing, no flow reversal for medium 2"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);
  parameter Integer nPorts1 "Number of ports 1"
    annotation(Evaluate=true, Dialog(connectorSizing=true, tab="General",group="Ports"));
  parameter Integer nPorts2 "Number of ports 2"
    annotation(Evaluate=true, Dialog(connectorSizing=true, tab="General",group="Ports"));
  Modelica.Fluid.Interfaces.FluidPort_a port_a1(
                     redeclare final package Medium = Medium1,
                     m_flow(min=if allowFlowReversal1 then -Modelica.Constants.inf else 0),
                     h_outflow(start = Medium1.h_default, nominal = Medium1.h_default))
    "Fluid connector a1 (positive design flow direction is from port_a1 to port_b1)"
    annotation (Placement(transformation(extent={{-110,50},{-90,70}})));

  Modelica.Fluid.Interfaces.FluidPort_a port_a2(
                     redeclare final package Medium = Medium2,
                     m_flow(min=if allowFlowReversal2 then -Modelica.Constants.inf else 0),
                     h_outflow(start = Medium2.h_default, nominal = Medium2.h_default))
    "Fluid connector a2 (positive design flow direction is from port_a2 to port_b2)"
    annotation (Placement(transformation(extent={{90,-70},{110,-50}})));

  Modelica.Fluid.Interfaces.FluidPorts_b ports_b1[nPorts1](
    redeclare each package Medium = Medium1,
    each m_flow(max=if allowFlowReversal1 then +Modelica.Constants.inf else 0),
    each h_outflow(start=Medium1.h_default, nominal=Medium1.h_default))
    "Fluid connectors b1 (positive design flow direction is from port_a1 to ports_b1)"
    annotation (Placement(transformation(extent={{90,20},{110,100}})));

  Modelica.Fluid.Interfaces.FluidPorts_b ports_b2[nPorts2](
    redeclare each package Medium = Medium2,
    each m_flow(max=if allowFlowReversal2 then +Modelica.Constants.inf else 0),
    each h_outflow(start=Medium2.h_default, nominal=Medium2.h_default))
    "Fluid connectors b2 (positive design flow direction is from port_a2 to ports_b2)"
    annotation (Placement(transformation(extent={{-110,-100},{-90,-20}})));

  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
This model defines an interface for components with four ports each with a vectorized port at one end.
The parameters <code>allowFlowReversal1</code> and
<code>allowFlowReversal2</code> may be used by models that extend
this model to treat flow reversal.
</p>
<p>
This model is identical to
<a href=\"modelica://IBPSA.Fluid.Interfaces.PartialFourPort\">
IBPSA.Fluid.Interfaces.PartialFourPort</a>, except for the vectorized ports at the end.
</html>"));
end PartialFourPortVector;
