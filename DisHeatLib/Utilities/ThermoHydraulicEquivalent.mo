within DisHeatLib.Utilities;
package ThermoHydraulicEquivalent "Thermo-Hydraulic Equivalent Library"
  model Demand_mQ "Demand model with prescribed mass flow and heat demand."
    extends IBPSA.Fluid.Interfaces.PartialTwoPortInterface(
      redeclare package Medium = IBPSA.Media.Water);
    IBPSA.Fluid.Actuators.Valves.TwoWayLinear valve(
      redeclare package Medium = IBPSA.Media.Water,
      m_flow_nominal=m_flow_nominal,
      dpValve_nominal(displayUnit="bar") = dp_nominal,
      riseTime=1,
      y_start=0)
      annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));
    IBPSA.Fluid.HeatExchangers.SensibleCooler_T cooler(
      redeclare package Medium = IBPSA.Media.Water,
      m_flow_nominal=m_flow_nominal,
      dp_nominal=0)
      annotation (Placement(transformation(extent={{30,-10},{50,10}})));
    Modelica.Blocks.Math.Gain gain(k=-1) annotation (Placement(transformation(
          extent={{-4,-4},{4,4}},
          rotation=90,
          origin={60,30})));
    IBPSA.Fluid.Sensors.MassFlowRate senMasFlo(redeclare package Medium =
          IBPSA.Media.Water)
      annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
    IBPSA.Controls.Continuous.LimPID PID_m_flow(
      k=0.001,
      yMax=1,
      yMin=0) annotation (Placement(transformation(
          extent={{10,-10},{-10,10}},
          rotation=90,
          origin={-40,60})));
    Modelica.Blocks.Interfaces.RealInput m_flow_set annotation (Placement(
          transformation(
          extent={{-20,-20},{20,20}},
          rotation=-90,
          origin={-40,120})));
    Modelica.Blocks.Interfaces.RealInput Q_demand_set annotation (Placement(
          transformation(
          extent={{-20,-20},{20,20}},
          rotation=-90,
          origin={40,120})));
    IBPSA.Controls.Continuous.LimPID PID_QT(
      k=0.001,
      yMax=T_max,
      yMin=T_min,
      reverseAction=true) annotation (Placement(transformation(
          extent={{-10,10},{10,-10}},
          rotation=-90,
          origin={40,60})));
    IBPSA.Fluid.Sensors.Temperature senTem(redeclare package Medium =
          IBPSA.Media.Water)
      annotation (Placement(transformation(extent={{-90,-40},{-70,-60}})));
    Modelica.Blocks.Interfaces.RealOutput T_supply annotation (Placement(
          transformation(
          extent={{-10,-10},{10,10}},
          rotation=-90,
          origin={-60,-110})));
    Modelica.Blocks.Interfaces.RealOutput delta_p annotation (Placement(
          transformation(
          extent={{-10,-10},{10,10}},
          rotation=-90,
          origin={60,-110})));

    parameter Modelica.SIunits.PressureDifference dp_nominal(displayUnit="bar")
      "Nominal pressure drop" annotation (Dialog(group="Nominal condition"));
    parameter Modelica.SIunits.Temperature T_min=283.15 "Minimum return temperature of consumers";
    parameter Modelica.SIunits.Temperature T_max=373.15 "Maximum return temperature of consumers";

    Modelica.Blocks.Interfaces.RealOutput p_ref annotation (Placement(
          transformation(
          extent={{-10,-10},{10,10}},
          rotation=-90,
          origin={0,-110})));
  equation

    delta_p = dp;
    p_ref = port_b.p;
    connect(cooler.Q_flow, gain.u)
      annotation (Line(points={{51,8},{60,8},{60,25.2}}, color={0,0,127}));
    connect(valve.port_b, senMasFlo.port_a)
      annotation (Line(points={{-30,0},{-20,0}}, color={0,127,255}));
    connect(senMasFlo.port_b, cooler.port_a)
      annotation (Line(points={{0,0},{30,0}},   color={0,127,255}));
    connect(senMasFlo.m_flow, PID_m_flow.u_m)
      annotation (Line(points={{-10,11},{-10,60},{-28,60}}, color={0,0,127}));
    connect(PID_m_flow.y, valve.y)
      annotation (Line(points={{-40,49},{-40,12}}, color={0,0,127}));
    connect(valve.port_a, port_a)
      annotation (Line(points={{-50,0},{-100,0}}, color={0,127,255}));
    connect(PID_m_flow.u_s, m_flow_set) annotation (Line(points={{-40,72},{-40,
            120}},                   color={0,0,127}));
    connect(PID_QT.u_m, gain.y) annotation (Line(points={{52,60},{60,60},{60,
            34.4}},     color={0,0,127}));
    connect(PID_QT.y, cooler.TSet) annotation (Line(points={{40,49},{40,40},{20,
            40},{20,8},{28,8}},      color={0,0,127}));
    connect(cooler.port_b, port_b)
      annotation (Line(points={{50,0},{100,0}}, color={0,127,255}));
    connect(Q_demand_set, PID_QT.u_s)
      annotation (Line(points={{40,120},{40,72}}, color={0,0,127}));
    connect(senTem.port, port_a)
      annotation (Line(points={{-80,-40},{-80,0},{-100,0}}, color={0,127,255}));
    connect(senTem.T,T_supply)  annotation (Line(points={{-73,-50},{-60,-50},{-60,
            -110}}, color={0,0,127}));
    annotation (
        experiment(StopTime=259200, __Dymola_Algorithm="Dassl"), Icon(graphics={
          Rectangle(
            lineColor={200,200,200},
            fillColor={248,248,248},
            fillPattern=FillPattern.HorizontalCylinder,
            extent={{-100,-100},{100,100}},
            radius=25.0),
          Rectangle(
            lineColor={128,128,128},
            extent={{-100,-100},{100,100}},
            radius=25.0),
          Line(
            points={{-40,100},{-182,102},{-170,106},{-168,48},{-132,70}},
            color={0,0,255},
            pattern=LinePattern.None),
          Line(
            points={{-130,102},{-58,52},{-56,56},{-12,78}},
            color={0,0,255},
            pattern=LinePattern.None),
          Text(
            extent={{-100,140},{-80,120}},
            lineColor={0,0,127},
            pattern=LinePattern.None,
            fillColor={0,0,127},
            fillPattern=FillPattern.Solid,
            textString="m"),
          Text(
            extent={{80,140},{100,120}},
            lineColor={0,0,127},
            pattern=LinePattern.None,
            fillColor={0,0,127},
            fillPattern=FillPattern.Solid,
            textString="Q"),
          Rectangle(
            extent={{-44,100},{-36,40}},
            fillColor={0,0,127},
            fillPattern=FillPattern.Solid,
            lineColor={0,0,127}),
          Rectangle(
            extent={{36,100},{44,40}},
            fillColor={0,0,127},
            fillPattern=FillPattern.Solid,
            lineColor={0,0,127}),
          Rectangle(
            extent={{56,-38},{64,-102}},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid,
            lineColor={0,0,127}),
          Rectangle(
            extent={{-4,-38},{4,-102}},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid,
            lineColor={0,0,127}),
          Rectangle(
            extent={{-64,-38},{-56,-102}},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid,
            lineColor={0,0,127}),          Rectangle(
            extent={{-80,40},{80,-40}},
            lineColor={0,0,255},
            pattern=LinePattern.None,
            fillColor={95,95,95},
            fillPattern=FillPattern.Solid),Rectangle(
            extent={{-100,6},{0,-6}},
            lineColor={0,0,255},
            pattern=LinePattern.None,
            fillColor={238,46,47},
            fillPattern=FillPattern.Solid),Rectangle(
            extent={{0,6},{100,-6}},
            lineColor={0,0,255},
            pattern=LinePattern.None,
            fillColor={28,108,200},
            fillPattern=FillPattern.Solid)}),
            Documentation(revisions="<html>
<ul>
<li>Feburary 2, 2022, by Edmund Widl:<br>Implementation and added User&apos;s guide. </li>
</ul>
</html>", info="<html>
        <p>Demand model with prescribed mass flow and heat demand.</p>
</html>"));
  end Demand_mQ;

  model Demand_mT "Demand model with prescribed mass flow and outlet temperature."
    extends IBPSA.Fluid.Interfaces.PartialTwoPortInterface(
      redeclare package Medium = IBPSA.Media.Water);
    IBPSA.Fluid.Actuators.Valves.TwoWayLinear valve(
      redeclare package Medium = IBPSA.Media.Water,
      m_flow_nominal=m_flow_nominal,
      dpValve_nominal(displayUnit="bar") = dp_nominal,
      riseTime=1,
      y_start=0)
      annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));
    IBPSA.Fluid.HeatExchangers.SensibleCooler_T cooler(
      redeclare package Medium = IBPSA.Media.Water,
      m_flow_nominal=m_flow_nominal,
      show_T=true,
      dp_nominal=0)
      annotation (Placement(transformation(extent={{30,-10},{50,10}})));
    IBPSA.Fluid.Sensors.MassFlowRate senMasFlo(redeclare package Medium =
          IBPSA.Media.Water)
      annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
    IBPSA.Controls.Continuous.LimPID PID_m_flow(
      k=0.001,
      yMax=1,
      yMin=0) annotation (Placement(transformation(
          extent={{10,-10},{-10,10}},
          rotation=90,
          origin={-40,60})));
    Modelica.Blocks.Interfaces.RealInput m_flow_set annotation (Placement(
          transformation(
          extent={{-20,-20},{20,20}},
          rotation=-90,
          origin={-40,120})));
    Modelica.Blocks.Interfaces.RealInput T_return_set annotation (Placement(
          transformation(
          extent={{-20,-20},{20,20}},
          rotation=-90,
          origin={40,120})));
    Modelica.Blocks.Interfaces.RealOutput T_supply annotation (Placement(
          transformation(
          extent={{-10,-10},{10,10}},
          rotation=-90,
          origin={-60,-110})));
    Modelica.Blocks.Interfaces.RealOutput delta_p annotation (Placement(
          transformation(
          extent={{-10,-10},{10,10}},
          rotation=-90,
          origin={60,-110})));
    IBPSA.Fluid.Sensors.Temperature senTem(redeclare package Medium =
          IBPSA.Media.Water)
      annotation (Placement(transformation(extent={{-90,-40},{-70,-60}})));

    parameter Modelica.SIunits.PressureDifference dp_nominal(displayUnit="bar")
      "Nominal pressure drop" annotation (Dialog(group="Nominal condition"));
    parameter Modelica.SIunits.Temperature T_min=283.15 "Minimum return temperature of consumers";
    parameter Modelica.SIunits.Temperature T_max=373.15 "Maximum return temperature of consumers";

    Modelica.Blocks.Interfaces.RealOutput p_ref annotation (Placement(
          transformation(
          extent={{-10,-10},{10,10}},
          rotation=-90,
          origin={0,-110})));
  equation

    delta_p = dp;
    p_ref = port_b.p;

    connect(valve.port_b, senMasFlo.port_a)
      annotation (Line(points={{-30,0},{-20,0}}, color={0,127,255}));
    connect(senMasFlo.port_b, cooler.port_a)
      annotation (Line(points={{0,0},{30,0}},   color={0,127,255}));
    connect(senMasFlo.m_flow, PID_m_flow.u_m)
      annotation (Line(points={{-10,11},{-10,60},{-28,60}}, color={0,0,127}));
    connect(PID_m_flow.y, valve.y)
      annotation (Line(points={{-40,49},{-40,12}}, color={0,0,127}));
    connect(valve.port_a, port_a)
      annotation (Line(points={{-50,0},{-100,0}}, color={0,127,255}));
    connect(PID_m_flow.u_s, m_flow_set) annotation (Line(points={{-40,72},{-40,
            120}},                   color={0,0,127}));
    connect(cooler.port_b, port_b)
      annotation (Line(points={{50,0},{100,0}}, color={0,127,255}));
    connect(T_return_set, cooler.TSet) annotation (Line(points={{40,120},{40,20},
            {20,20},{20,8},{28,8}}, color={0,0,127}));
    connect(senTem.port, port_a)
      annotation (Line(points={{-80,-40},{-80,0},{-100,0}}, color={0,127,255}));
    connect(senTem.T, T_supply) annotation (Line(points={{-73,-50},{-60,-50},{-60,
            -110}}, color={0,0,127}));
    annotation (
        experiment(StopTime=259200, __Dymola_Algorithm="Dassl"), Icon(graphics={
          Rectangle(
            lineColor={200,200,200},
            fillColor={248,248,248},
            fillPattern=FillPattern.HorizontalCylinder,
            extent={{-100,-100},{100,100}},
            radius=25.0),
          Rectangle(
            lineColor={128,128,128},
            extent={{-100,-100},{100,100}},
            radius=25.0),
          Line(
            points={{-40,100},{-182,102},{-170,106},{-168,48},{-132,70}},
            color={0,0,255},
            pattern=LinePattern.None),
          Line(
            points={{-130,102},{-58,52},{-56,56},{-12,78}},
            color={0,0,255},
            pattern=LinePattern.None),
          Text(
            extent={{-100,140},{-80,120}},
            lineColor={0,0,127},
            pattern=LinePattern.None,
            fillColor={0,0,127},
            fillPattern=FillPattern.Solid,
            textString="m"),
          Text(
            extent={{80,140},{100,120}},
            lineColor={0,0,127},
            pattern=LinePattern.None,
            fillColor={0,0,127},
            fillPattern=FillPattern.Solid,
            textString="T"),
          Rectangle(
            extent={{-44,100},{-36,40}},
            fillColor={0,0,127},
            fillPattern=FillPattern.Solid,
            lineColor={0,0,127}),
          Rectangle(
            extent={{36,100},{44,40}},
            fillColor={0,0,127},
            fillPattern=FillPattern.Solid,
            lineColor={0,0,127}),
          Rectangle(
            extent={{56,-38},{64,-102}},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid,
            lineColor={0,0,127}),
          Rectangle(
            extent={{-4,-38},{4,-102}},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid,
            lineColor={0,0,127}),
          Rectangle(
            extent={{-64,-38},{-56,-102}},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid,
            lineColor={0,0,127}),          Rectangle(
            extent={{-80,40},{80,-40}},
            lineColor={0,0,255},
            pattern=LinePattern.None,
            fillColor={95,95,95},
            fillPattern=FillPattern.Solid),Rectangle(
            extent={{-100,6},{0,-6}},
            lineColor={0,0,255},
            pattern=LinePattern.None,
            fillColor={238,46,47},
            fillPattern=FillPattern.Solid),Rectangle(
            extent={{0,6},{100,-6}},
            lineColor={0,0,255},
            pattern=LinePattern.None,
            fillColor={28,108,200},
            fillPattern=FillPattern.Solid)}),
            Documentation(revisions="<html>
<ul>
<li>Feburary 2, 2022, by Edmund Widl:<br>Implementation and added User&apos;s guide. </li>
</ul>
</html>", info="<html>
        <p>Demand model with prescribed mass flow and outlet temperature.</p>
</html>"));
  end Demand_mT;

  model DemandWithDelay_mQ "Demand model with prescribed mass flow and heat demand. The effects are delayed."
    extends IBPSA.Fluid.Interfaces.PartialTwoPortInterface(
      redeclare package Medium = IBPSA.Media.Water);
    IBPSA.Fluid.Actuators.Valves.TwoWayLinear valve(
      redeclare package Medium = IBPSA.Media.Water,
      m_flow_nominal=m_flow_nominal,
      show_T=true,
      dpValve_nominal(displayUnit="bar") = dp_nominal,
      riseTime=1,
      y_start=0)
      annotation (Placement(transformation(extent={{-70,-10},{-50,10}})));
    IBPSA.Fluid.HeatExchangers.SensibleCooler_T cooler(
      redeclare package Medium = IBPSA.Media.Water,
      m_flow_nominal=m_flow_nominal,
      show_T=true,
      dp_nominal=0)
      annotation (Placement(transformation(extent={{10,-10},{30,10}})));
    Modelica.Blocks.Math.Gain gain(k=-1) annotation (Placement(transformation(
          extent={{-4,-4},{4,4}},
          rotation=90,
          origin={40,30})));
    IBPSA.Fluid.Sensors.MassFlowRate senMasFlo(redeclare package Medium =
          IBPSA.Media.Water)
      annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
    IBPSA.Controls.Continuous.LimPID PID_m_flow(
      k=0.001,
      yMax=1,
      yMin=0) annotation (Placement(transformation(
          extent={{10,-10},{-10,10}},
          rotation=90,
          origin={-60,60})));
    IBPSA.Fluid.FixedResistances.PlugFlowPipe delay(
      redeclare package Medium = IBPSA.Media.Water,
      length=length,
      m_flow_nominal=m_flow_nominal,
      roughness=pipeType.pipeMaterial.roughness,
      m_flow_small=m_flow_small,
      dIns=pipeType.dIns,
      cPip=pipeType.pipeMaterial.cPip,
      rhoPip=pipeType.pipeMaterial.rhoPip,
      v_nominal=pipeType.v_nominal,
      dh=pipeType.dh,
      thickness=pipeType.dWall,
      fac=fac,
      kIns=cf*pipeType.kIns,
      nPorts=1)
      annotation (Placement(transformation(extent={{60,10},{80,-10}})));
    Modelica.Blocks.Interfaces.RealInput m_flow_set annotation (Placement(
          transformation(
          extent={{-20,-20},{20,20}},
          rotation=-90,
          origin={-40,120})));
    Modelica.Blocks.Interfaces.RealInput Q_demand_set annotation (Placement(
          transformation(
          extent={{-20,-20},{20,20}},
          rotation=-90,
          origin={40,120})));
    Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_ht
      annotation (Placement(transformation(extent={{50,-110},{70,-90}})));
    IBPSA.Controls.Continuous.LimPID PID_QT(
      k=0.001,
      yMax=T_max,
      yMin=T_min,
      reverseAction=true) annotation (Placement(transformation(
          extent={{-10,10},{10,-10}},
          rotation=-90,
          origin={20,60})));
    IBPSA.Fluid.Sensors.Temperature senTem(redeclare package Medium =
          IBPSA.Media.Water)
      annotation (Placement(transformation(extent={{-90,-40},{-70,-60}})));
    Modelica.Blocks.Interfaces.RealOutput T_supply annotation (Placement(
          transformation(
          extent={{-10,-10},{10,10}},
          rotation=-90,
          origin={-60,-110})));
    Modelica.Blocks.Interfaces.RealOutput delta_p annotation (Placement(
          transformation(
          extent={{-10,-10},{10,10}},
          rotation=-90,
          origin={20,-110})));

    parameter Modelica.SIunits.PressureDifference dp_nominal(displayUnit="bar")
      "Nominal pressure drop" annotation (Dialog(group="Nominal condition"));
    parameter Modelica.SIunits.Temperature T_min=283.15 "Minimum return temperature of consumers";
    parameter Modelica.SIunits.Temperature T_max=373.15 "Maximum return temperature of consumers";

    replaceable parameter DisHeatLib.Pipes.BaseClasses.BasePipe pipeType "Pipe type"
      annotation (Dialog(group="Plug Flow Delay"), choicesAllMatching=true);
    parameter Modelica.SIunits.Length length=1000 "Effective pipe length"
      annotation (Dialog(group="Plug Flow Delay"));
    parameter Real fac=1
      "Factor to take into account flow resistance of bends etc., fac=dp_nominal/dpStraightPipe_nominal"
      annotation (Evaluate=true, Dialog(group="Plug Flow Delay"));
    parameter Real cf = 1.0 "Correction factor of heat losses (needed for aggregation)"
      annotation (Evaluate=true, Dialog(group="Plug Flow Delay"));

    Modelica.Blocks.Interfaces.RealOutput p_ref annotation (Placement(
          transformation(
          extent={{-10,-10},{10,10}},
          rotation=-90,
          origin={-20,-110})));
  equation

    delta_p = dp;
    p_ref = port_b.p;

    connect(cooler.Q_flow, gain.u)
      annotation (Line(points={{31,8},{40,8},{40,25.2}}, color={0,0,127}));
    connect(valve.port_b, senMasFlo.port_a)
      annotation (Line(points={{-50,0},{-40,0}}, color={0,127,255}));
    connect(senMasFlo.port_b, cooler.port_a)
      annotation (Line(points={{-20,0},{10,0}}, color={0,127,255}));
    connect(senMasFlo.m_flow, PID_m_flow.u_m)
      annotation (Line(points={{-30,11},{-30,60},{-48,60}}, color={0,0,127}));
    connect(PID_m_flow.y, valve.y)
      annotation (Line(points={{-60,49},{-60,12}}, color={0,0,127}));
    connect(cooler.port_b, delay.port_a)
      annotation (Line(points={{30,0},{60,0}}, color={0,127,255}));
    connect(valve.port_a, port_a)
      annotation (Line(points={{-70,0},{-100,0}}, color={0,127,255}));
    connect(delay.ports_b[1], port_b)
      annotation (Line(points={{80,0},{100,0}}, color={0,127,255}));
    connect(PID_m_flow.u_s, m_flow_set) annotation (Line(points={{-60,72},{-60,
            80},{-40,80},{-40,120}}, color={0,0,127}));
    connect(port_ht, delay.heatPort) annotation (Line(points={{60,-100},{60,-50},
            {70,-50},{70,-10}}, color={191,0,0}));
    connect(PID_QT.u_s, Q_demand_set) annotation (Line(points={{20,72},{20,80},
            {40,80},{40,120}},          color={0,0,127}));
    connect(PID_QT.u_m, gain.y) annotation (Line(points={{32,60},{40,60},{40,
            34.4}},     color={0,0,127}));
    connect(PID_QT.y, cooler.TSet) annotation (Line(points={{20,49},{20,40},{0,
            40},{0,8},{8,8}},        color={0,0,127}));
    connect(senTem.port, port_a)
      annotation (Line(points={{-80,-40},{-80,0},{-100,0}}, color={0,127,255}));
    connect(senTem.T,T_supply)  annotation (Line(points={{-73,-50},{-60,-50},{
            -60,-110}},
                    color={0,0,127}));
    connect(port_ht, port_ht)
      annotation (Line(points={{60,-100},{60,-100}}, color={191,0,0}));
    annotation (
        experiment(StopTime=259200, __Dymola_Algorithm="Dassl"), Icon(graphics={
          Rectangle(
            lineColor={200,200,200},
            fillColor={248,248,248},
            fillPattern=FillPattern.HorizontalCylinder,
            extent={{-100,-100},{100,100}},
            radius=25.0),
          Rectangle(
            lineColor={128,128,128},
            extent={{-100,-100},{100,100}},
            radius=25.0),
          Line(
            points={{-40,100},{-182,102},{-170,106},{-168,48},{-132,70}},
            color={0,0,255},
            pattern=LinePattern.None),
          Line(
            points={{-130,102},{-58,52},{-56,56},{-12,78}},
            color={0,0,255},
            pattern=LinePattern.None),
          Text(
            extent={{-100,140},{-80,120}},
            lineColor={0,0,127},
            pattern=LinePattern.None,
            fillColor={0,0,127},
            fillPattern=FillPattern.Solid,
            textString="m"),
          Text(
            extent={{80,140},{100,120}},
            lineColor={0,0,127},
            pattern=LinePattern.None,
            fillColor={0,0,127},
            fillPattern=FillPattern.Solid,
            textString="Q"),
          Rectangle(
            extent={{56,-38},{64,-102}},
            pattern=LinePattern.None,
            fillColor={191,0,0},
            fillPattern=FillPattern.Solid),
          Rectangle(
            extent={{16,-38},{24,-102}},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid,
            lineColor={0,0,127}),
          Rectangle(
            extent={{-24,-38},{-16,-102}},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid,
            lineColor={0,0,127}),
          Rectangle(
            extent={{-64,-38},{-56,-102}},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid,
            lineColor={0,0,127}),
          Rectangle(
            extent={{-44,100},{-36,40}},
            fillColor={0,0,127},
            fillPattern=FillPattern.Solid,
            lineColor={0,0,127}),
          Rectangle(
            extent={{36,100},{44,40}},
            fillColor={0,0,127},
            fillPattern=FillPattern.Solid,
            lineColor={0,0,127}),
          Polygon(
            points={{-80,40},{-80,-40},{-14,-40},{-24,-20},{4,20},{-6,40},{-80,
                40}},
            fillColor={95,95,95},
            fillPattern=FillPattern.Solid,
            pattern=LinePattern.None),
          Polygon(
            points={{80,-40},{80,40},{14,40},{24,20},{-4,-20},{6,-40},{80,-40}},
            fillColor={95,95,95},
            fillPattern=FillPattern.Solid,
            pattern=LinePattern.None),
          Polygon(
            points={{-100,6},{-6,6},{-14,-6},{-100,-6},{-100,6}},
            fillColor={238,46,47},
            fillPattern=FillPattern.Solid,
            pattern=LinePattern.None),
          Polygon(
            points={{100,-6},{6,-6},{14,6},{100,6},{100,-6}},
            fillColor={28,108,200},
            fillPattern=FillPattern.Solid,
            pattern=LinePattern.None),
          Line(
            points={{-10,48},{4,20},{-24,-20},{-10,-48}},
            color={0,0,0},
            thickness=0.5),
          Line(
            points={{10,48},{24,20},{-4,-20},{10,-48}},
            color={0,0,0},
            thickness=0.5)}),
            Documentation(revisions="<html>
<ul>
<li>Feburary 2, 2022, by Edmund Widl:<br>Implementation and added User&apos;s guide. </li>
</ul>
</html>", info="<html>
        <p>Demand model with prescribed mass flow and heat demand. The effects are delayed.</p>
</html>"));
  end DemandWithDelay_mQ;

  model DemandWithDelay_mT "Demand model with prescribed mass flow and outlet temperature. The effects are delayed."
    extends IBPSA.Fluid.Interfaces.PartialTwoPortInterface(
      redeclare package Medium = IBPSA.Media.Water);
    IBPSA.Fluid.Actuators.Valves.TwoWayLinear valve(
      redeclare package Medium = IBPSA.Media.Water,
      m_flow_nominal=m_flow_nominal,
      show_T=true,
      dpValve_nominal(displayUnit="bar") = dp_nominal,
      riseTime=1,
      y_start=0)
      annotation (Placement(transformation(extent={{-70,-10},{-50,10}})));
    IBPSA.Fluid.HeatExchangers.SensibleCooler_T cooler(
      redeclare package Medium = IBPSA.Media.Water,
      m_flow_nominal=m_flow_nominal,
      show_T=true,
      dp_nominal=0)
      annotation (Placement(transformation(extent={{10,-10},{30,10}})));
    IBPSA.Fluid.Sensors.MassFlowRate senMasFlo(redeclare package Medium =
          IBPSA.Media.Water)
      annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
    IBPSA.Controls.Continuous.LimPID PID_m_flow(
      k=0.001,
      yMax=1,
      yMin=0) annotation (Placement(transformation(
          extent={{10,-10},{-10,10}},
          rotation=90,
          origin={-60,60})));
    IBPSA.Fluid.FixedResistances.PlugFlowPipe delay(
      redeclare package Medium = IBPSA.Media.Water,
      length=length,
      m_flow_nominal=m_flow_nominal,
      roughness=pipeType.pipeMaterial.roughness,
      m_flow_small=m_flow_small,
      dIns=pipeType.dIns,
      cPip=pipeType.pipeMaterial.cPip,
      rhoPip=pipeType.pipeMaterial.rhoPip,
      v_nominal=pipeType.v_nominal,
      dh=pipeType.dh,
      thickness=pipeType.dWall,
      fac=fac,
      kIns=cf*pipeType.kIns,
      nPorts=1)
      annotation (Placement(transformation(extent={{60,10},{80,-10}})));
    Modelica.Blocks.Interfaces.RealInput m_flow_set annotation (Placement(
          transformation(
          extent={{-20,-20},{20,20}},
          rotation=-90,
          origin={-40,120})));
    Modelica.Blocks.Interfaces.RealInput T_return_set annotation (Placement(
          transformation(
          extent={{-20,-20},{20,20}},
          rotation=-90,
          origin={40,120})));
    Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_ht
      annotation (Placement(transformation(extent={{50,-110},{70,-90}})));
    IBPSA.Fluid.Sensors.Temperature senTem(redeclare package Medium =
          IBPSA.Media.Water)
      annotation (Placement(transformation(extent={{-90,-40},{-70,-60}})));
    Modelica.Blocks.Interfaces.RealOutput T_supply annotation (Placement(
          transformation(
          extent={{-10,-10},{10,10}},
          rotation=-90,
          origin={-60,-110})));
    Modelica.Blocks.Interfaces.RealOutput delta_p annotation (Placement(
          transformation(
          extent={{-10,-10},{10,10}},
          rotation=-90,
          origin={20,-110})));

    parameter Modelica.SIunits.PressureDifference dp_nominal(displayUnit="bar")
      "Nominal pressure drop" annotation (Dialog(group="Nominal condition"));
    parameter Modelica.SIunits.Temperature T_min=283.15 "Minimum return temperature of consumers";
    parameter Modelica.SIunits.Temperature T_max=373.15 "Maximum return temperature of consumers";

    replaceable parameter DisHeatLib.Pipes.BaseClasses.BasePipe pipeType "Pipe type"
      annotation (Dialog(group="Plug Flow Delay"), choicesAllMatching=true);
    parameter Modelica.SIunits.Length length=1000 "Effective pipe length"
      annotation (Dialog(group="Plug Flow Delay"));
    parameter Real fac=1
      "Factor to take into account flow resistance of bends etc., fac=dp_nominal/dpStraightPipe_nominal"
      annotation (Evaluate=true, Dialog(group="Plug Flow Delay"));
    parameter Real cf = 1.0 "Correction factor of heat losses (needed for aggregation)"
      annotation (Evaluate=true, Dialog(group="Plug Flow Delay"));

    Modelica.Blocks.Interfaces.RealOutput p_ref annotation (Placement(
          transformation(
          extent={{-10,-10},{10,10}},
          rotation=-90,
          origin={-20,-110})));
  equation

    delta_p = dp;
    p_ref = port_b.p;

    connect(valve.port_b, senMasFlo.port_a)
      annotation (Line(points={{-50,0},{-40,0}}, color={0,127,255}));
    connect(senMasFlo.port_b, cooler.port_a)
      annotation (Line(points={{-20,0},{10,0}}, color={0,127,255}));
    connect(senMasFlo.m_flow, PID_m_flow.u_m)
      annotation (Line(points={{-30,11},{-30,60},{-48,60}}, color={0,0,127}));
    connect(PID_m_flow.y, valve.y)
      annotation (Line(points={{-60,49},{-60,12}}, color={0,0,127}));
    connect(cooler.port_b, delay.port_a)
      annotation (Line(points={{30,0},{60,0}}, color={0,127,255}));
    connect(valve.port_a, port_a)
      annotation (Line(points={{-70,0},{-100,0}}, color={0,127,255}));
    connect(delay.ports_b[1], port_b)
      annotation (Line(points={{80,0},{100,0}}, color={0,127,255}));
    connect(PID_m_flow.u_s, m_flow_set) annotation (Line(points={{-60,72},{-60,
            80},{-40,80},{-40,120}}, color={0,0,127}));
    connect(port_ht, delay.heatPort) annotation (Line(points={{60,-100},{60,-50},{
            70,-50},{70,-10}},  color={191,0,0}));
    connect(T_return_set, cooler.TSet) annotation (Line(points={{40,120},{40,20},
            {0,20},{0,8},{8,8}}, color={0,0,127}));
    connect(T_supply, senTem.T) annotation (Line(points={{-60,-110},{-60,-50},{-73,
            -50}}, color={0,0,127}));
    connect(senTem.port, port_a)
      annotation (Line(points={{-80,-40},{-80,0},{-100,0}}, color={0,127,255}));
    annotation (
        experiment(StopTime=259200, __Dymola_Algorithm="Dassl"), Icon(graphics={
          Rectangle(
            lineColor={200,200,200},
            fillColor={248,248,248},
            fillPattern=FillPattern.HorizontalCylinder,
            extent={{-100,-100},{100,100}},
            radius=25.0),
          Rectangle(
            lineColor={128,128,128},
            extent={{-100,-100},{100,100}},
            radius=25.0),
          Line(
            points={{-40,100},{-182,102},{-170,106},{-168,48},{-132,70}},
            color={0,0,255},
            pattern=LinePattern.None),
          Line(
            points={{-130,102},{-58,52},{-56,56},{-12,78}},
            color={0,0,255},
            pattern=LinePattern.None),
          Text(
            extent={{-100,140},{-80,120}},
            lineColor={0,0,127},
            pattern=LinePattern.None,
            fillColor={0,0,127},
            fillPattern=FillPattern.Solid,
            textString="m"),
          Text(
            extent={{80,140},{100,120}},
            lineColor={0,0,127},
            pattern=LinePattern.None,
            fillColor={0,0,127},
            fillPattern=FillPattern.Solid,
            textString="T"),
          Rectangle(
            extent={{-44,100},{-36,40}},
            fillColor={0,0,127},
            fillPattern=FillPattern.Solid,
            lineColor={0,0,127}),
          Rectangle(
            extent={{36,100},{44,40}},
            fillColor={0,0,127},
            fillPattern=FillPattern.Solid,
            lineColor={0,0,127}),
          Rectangle(
            extent={{-64,-38},{-56,-102}},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid,
            lineColor={0,0,127}),
          Rectangle(
            extent={{-24,-38},{-16,-102}},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid,
            lineColor={0,0,127}),
          Rectangle(
            extent={{16,-38},{24,-102}},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid,
            lineColor={0,0,127}),
          Rectangle(
            extent={{56,-38},{64,-102}},
            pattern=LinePattern.None,
            fillColor={191,0,0},
            fillPattern=FillPattern.Solid),
          Polygon(
            points={{-80,40},{-80,-40},{-14,-40},{-24,-20},{4,20},{-6,40},{-80,
                40}},
            fillColor={95,95,95},
            fillPattern=FillPattern.Solid,
            pattern=LinePattern.None),
          Polygon(
            points={{80,-40},{80,40},{14,40},{24,20},{-4,-20},{6,-40},{80,-40}},
            fillColor={95,95,95},
            fillPattern=FillPattern.Solid,
            pattern=LinePattern.None),
          Polygon(
            points={{-100,6},{-6,6},{-14,-6},{-100,-6},{-100,6}},
            fillColor={238,46,47},
            fillPattern=FillPattern.Solid,
            pattern=LinePattern.None),
          Polygon(
            points={{100,-6},{6,-6},{14,6},{100,6},{100,-6}},
            fillColor={28,108,200},
            fillPattern=FillPattern.Solid,
            pattern=LinePattern.None),
          Line(
            points={{-10,48},{4,20},{-24,-20},{-10,-48}},
            color={0,0,0},
            thickness=0.5),
          Line(
            points={{10,48},{24,20},{-4,-20},{10,-48}},
            color={0,0,0},
            thickness=0.5)}),
            Documentation(revisions="<html>
<ul>
<li>Feburary 2, 2022, by Edmund Widl:<br>Implementation and added User&apos;s guide. </li>
</ul>
</html>", info="<html>
        <p>Demand model with prescribed mass flow and outlet temperature. The effects are delayed.</p>
</html>"));
  end DemandWithDelay_mT;

  model Supply_pT "Source model with prescribed pressure difference and outlet temperature."
    extends IBPSA.Fluid.Interfaces.PartialTwoPort(
      redeclare package Medium = IBPSA.Media.Water);

    Modelica.Blocks.Interfaces.RealInput delta_p_set annotation (Placement(
          transformation(
          extent={{-20,-20},{20,20}},
          rotation=-90,
          origin={-60,120})));
    Modelica.Blocks.Interfaces.RealInput T_supply_set annotation (Placement(
          transformation(
          extent={{-20,-20},{20,20}},
          rotation=-90,
          origin={60,120})));
    Modelica.Blocks.Interfaces.RealOutput T_return annotation (Placement(
          transformation(
          extent={{-10,-10},{10,10}},
          rotation=-90,
          origin={-40,-110})));
    Modelica.Blocks.Interfaces.RealOutput m_flow annotation (Placement(
          transformation(
          extent={{-10,-10},{10,10}},
          rotation=-90,
          origin={40,-110})));
    IBPSA.Fluid.Sensors.Temperature senTem(redeclare package Medium =
          IBPSA.Media.Water)
      annotation (Placement(transformation(extent={{-80,-30},{-60,-50}})));
    IBPSA.Fluid.Sources.Boundary_pT sink(redeclare package Medium =
          IBPSA.Media.Water,
      use_p_in=true,         nPorts=1)
      annotation (Placement(transformation(extent={{-40,-10},{-60,10}})));
    IBPSA.Fluid.Sources.Boundary_pT source(
      redeclare package Medium = IBPSA.Media.Water,
      use_p_in=true,
      use_T_in=true,
      nPorts=1) annotation (Placement(transformation(extent={{40,10},{60,-10}})));
    Modelica.Blocks.Math.Add add
      annotation (Placement(transformation(extent={{-10,-10},{10,10}},
          rotation=-90,
          origin={0,30})));

    parameter Modelica.SIunits.MassFlowRate eps_m_flow(min=0) = 1E-4 "Small mass flow rate for checking of mass flow balance" annotation (Dialog(tab="Advanced"));

    Modelica.Blocks.Interfaces.RealInput p_ref_set annotation (Placement(
          transformation(
          extent={{-20,-20},{20,20}},
          rotation=-90,
          origin={0,120})));
  equation

    m_flow = -port_b.m_flow;

    assert(abs(port_a.m_flow + port_b.m_flow) < eps_m_flow, "Mass flow is not balanced.", AssertionLevel.warning);
    connect(senTem.port, port_a)
      annotation (Line(points={{-70,-30},{-70,0},{-100,0}}, color={0,127,255}));
    connect(senTem.T, T_return) annotation (Line(points={{-63,-40},{-40,-40},{-40,
            -110}}, color={0,0,127}));
    connect(port_a, sink.ports[1])
      annotation (Line(points={{-100,0},{-60,0}}, color={0,127,255}));
    connect(T_supply_set, source.T_in) annotation (Line(points={{60,120},{60,60},
            {22,60},{22,-4},{38,-4}}, color={0,0,127}));
    connect(delta_p_set, add.u2) annotation (Line(points={{-60,120},{-60,50},{
            -6,50},{-6,42}},   color={0,0,127}));
    connect(source.ports[1], port_b)
      annotation (Line(points={{60,0},{100,0}}, color={0,127,255}));
    connect(p_ref_set, add.u1) annotation (Line(points={{0,120},{0,60},{6,60},{
            6,42}},    color={0,0,127}));
    connect(add.y, source.p_in) annotation (Line(points={{-1.9984e-15,19},{
            -1.9984e-15,-8},{38,-8}}, color={0,0,127}));
    connect(sink.p_in, p_ref_set) annotation (Line(points={{-38,8},{-20,8},{-20,
            60},{0,60},{0,120}}, color={0,0,127}));
    annotation (Icon(graphics={
          Rectangle(
            lineColor={200,200,200},
            fillColor={248,248,248},
            fillPattern=FillPattern.HorizontalCylinder,
            extent={{-100,-100},{100,100}},
            radius=25.0),
          Rectangle(
            lineColor={128,128,128},
            extent={{-100,-100},{100,100}},
            radius=25.0),
          Polygon(
            points={{-64,100},{-64,40},{-52,30},{-46,36},{-56,44},{-56,100},{
                -64,100}},
            fillColor={0,0,127},
            fillPattern=FillPattern.Solid,
            pattern=LinePattern.None,
            lineColor={0,0,0}),
          Polygon(
            points={{-4,100},{-4,42},{4,42},{4,100},{-4,100}},
            fillColor={0,0,127},
            fillPattern=FillPattern.Solid,
            pattern=LinePattern.None,
            lineColor={0,0,0}),
          Polygon(
            points={{64,100},{64,40},{52,30},{46,36},{56,44},{56,100},{64,100}},
            fillColor={0,0,127},
            fillPattern=FillPattern.Solid,
            pattern=LinePattern.None,
            lineColor={0,0,0}),
          Polygon(
            points={{-44,-100},{-44,-56},{-32,-46},{-26,-52},{-36,-60},{-36,
                -100},{-44,-100}},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid,
            lineColor={0,0,127}),
          Polygon(
            points={{44,-100},{44,-56},{32,-46},{26,-52},{36,-60},{36,-100},{44,
                -100}},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid,
            lineColor={0,0,127}),
          Ellipse(
            extent={{-60,60},{60,-60}},
            pattern=LinePattern.None,
            fillColor={95,95,95},
            fillPattern=FillPattern.Solid),Rectangle(
            extent={{0,6},{100,-6}},
            lineColor={0,0,255},
            pattern=LinePattern.None,
            fillColor={238,46,47},
            fillPattern=FillPattern.Solid),Rectangle(
            extent={{-100,6},{0,-6}},
            lineColor={0,0,255},
            pattern=LinePattern.None,
            fillColor={28,108,200},
            fillPattern=FillPattern.Solid)}),
            Documentation(revisions="<html>
<ul>
<li>Feburary 2, 2022, by Edmund Widl:<br>Implementation and added User&apos;s guide. </li>
</ul>
</html>", info="<html>
        <p>Source model with prescribed pressure difference and outlet temperature.</p>
</html>"));
  end Supply_pT;

  package Examples
    model DemandWitdhDelay_mQ_Test
      IBPSA.Fluid.Sources.Boundary_pT source(
        redeclare package Medium = IBPSA.Media.Water,
        p=IBPSA.Media.Water.p_default + 1500000,
        T=353.15,
        nPorts=1)
        annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
      IBPSA.Fluid.Sources.Boundary_pT sink(redeclare package Medium =
            IBPSA.Media.Water, nPorts=1)
        annotation (Placement(transformation(extent={{82,-10},{62,10}})));
    public
      Modelica.Blocks.Sources.CombiTimeTable profiles(
        tableOnFile=true,
        tableName="NetworkData",
        columns={2,3,4},
        extrapolation=Modelica.Blocks.Types.Extrapolation.HoldLastPoint,
        fileName=Modelica.Utilities.Files.loadResource("modelica://DisHeatLib/Resources/Data/DHNetworkDataDummy.txt"))
        annotation (Placement(transformation(
            extent={{10,-10},{-10,10}},
            rotation=90,
            origin={0,60})));
      DemandWithDelay_mQ demand_mQ(
        m_flow_nominal=10,
        dp_nominal=1500000,
        T_min=328.15,
        redeclare DisHeatLib.Pipes.Library.Isoplus.Isoplus_Std_DN50 pipeType,
        length=1000,
        cf=7) annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
      Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T=288.15)
                   annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=90,
            origin={0,-60})));
      IBPSA.Fluid.Sensors.TemperatureTwoPort senTem(redeclare package Medium =
            IBPSA.Media.Water, m_flow_nominal=10)
        annotation (Placement(transformation(extent={{20,-10},{40,10}})));
    equation
      connect(source.ports[1], demand_mQ.port_a)
        annotation (Line(points={{-60,0},{-10,0}}, color={0,127,255}));
      connect(demand_mQ.m_flow_set, profiles.y[2])
        annotation (Line(points={{-4,12},{-4,30},{0,30},{0,60},{-6.66134e-16,60},
              {-6.66134e-16,49}}, color={0,0,127}));
      connect(demand_mQ.Q_demand_set, profiles.y[1])
        annotation (Line(points={{4,12},{4,30},{0,30},{0,60},{-6.66134e-16,60},
              {-6.66134e-16,49}}, color={0,0,127}));
      connect(fixedTemperature.port,demand_mQ.port_ht)
        annotation (Line(points={{4.44089e-16,-50},{4.44089e-16,-30},{6,-30},{6,
              -10}},                               color={191,0,0}));
      connect(demand_mQ.port_b, senTem.port_a)
        annotation (Line(points={{10,0},{20,0}}, color={0,127,255}));
      connect(senTem.port_b, sink.ports[1])
        annotation (Line(points={{40,0},{62,0}}, color={0,127,255}));
      annotation (
          experiment(StopTime=259200, __Dymola_Algorithm="Dassl"), Icon(
            graphics={
            Ellipse(lineColor = {75,138,73},
                    fillColor={255,255,255},
                    fillPattern = FillPattern.Solid,
                    extent={{-100,-100},{100,100}}),
            Polygon(lineColor = {0,0,255},
                    fillColor = {75,138,73},
                    pattern = LinePattern.None,
                    fillPattern = FillPattern.Solid,
                    points={{-36,60},{64,0},{-36,-60},{-36,60}})}));
    end DemandWitdhDelay_mQ_Test;

    model Supply_pT_Test
      Supply_pT                           supply_pT
        annotation (Placement(transformation(extent={{-10,10},{10,30}})));
      Modelica.Blocks.Sources.Constant T_supply_degC(k=80)
        annotation (Placement(transformation(extent={{90,40},{70,60}})));
      Modelica.Blocks.Sources.Ramp p_ref_bar(
        height=1,
        duration=100,
        offset=1,
        startTime=50)
        annotation (Placement(transformation(extent={{-90,70},{-70,90}})));
      Modelica.Blocks.Math.UnitConversions.From_degC T_supply_K
        annotation (Placement(transformation(extent={{60,40},{40,60}})));
      Modelica.Blocks.Math.UnitConversions.From_bar p_ref_Pa
        annotation (Placement(transformation(extent={{-60,70},{-40,90}})));
      IBPSA.Fluid.HeatExchangers.SensibleCooler_T coo(
        redeclare package Medium = IBPSA.Media.Water,
        m_flow_nominal=4,
        dp_nominal=200000)
        annotation (Placement(transformation(extent={{10,-30},{-10,-10}})));
      Modelica.Blocks.Sources.Constant T_return_degC(k=40)
        annotation (Placement(transformation(extent={{90,-60},{70,-40}})));
      Modelica.Blocks.Math.UnitConversions.From_degC T_return_K
        annotation (Placement(transformation(extent={{60,-60},{40,-40}})));
      Modelica.Blocks.Sources.Ramp delta_p_bar(
        height=1,
        duration=100,
        offset=1,
        startTime=50)
        annotation (Placement(transformation(extent={{-90,40},{-70,60}})));
      Modelica.Blocks.Math.UnitConversions.From_bar delta_p_Pa
        annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
    equation
      connect(T_supply_degC.y, T_supply_K.u)
        annotation (Line(points={{69,50},{62,50}}, color={0,0,127}));
      connect(T_supply_K.y, supply_pT.T_supply_set)
        annotation (Line(points={{39,50},{6,50},{6,32}}, color={0,0,127}));
      connect(p_ref_bar.y,p_ref_Pa. u)
        annotation (Line(points={{-69,80},{-62,80}}, color={0,0,127}));
      connect(supply_pT.port_b, coo.port_a) annotation (Line(points={{10,20},{
              20,20},{20,-20},{10,-20}}, color={0,127,255}));
      connect(T_return_degC.y, T_return_K.u)
        annotation (Line(points={{69,-50},{62,-50}}, color={0,0,127}));
      connect(T_return_K.y, coo.TSet) annotation (Line(points={{39,-50},{30,-50},
              {30,-12},{12,-12}}, color={0,0,127}));
      connect(coo.port_b, supply_pT.port_a) annotation (Line(points={{-10,-20},
              {-20,-20},{-20,20},{-10,20}}, color={0,127,255}));
      connect(delta_p_bar.y, delta_p_Pa.u)
        annotation (Line(points={{-69,50},{-62,50}}, color={0,0,127}));
      connect(p_ref_Pa.y, supply_pT.p_ref_set)
        annotation (Line(points={{-39,80},{0,80},{0,32}}, color={0,0,127}));
      connect(delta_p_Pa.y, supply_pT.delta_p_set)
        annotation (Line(points={{-39,50},{-6,50},{-6,32}}, color={0,0,127}));
      annotation (
          experiment(StopTime=259200, __Dymola_Algorithm="Dassl"), Icon(
            graphics={
            Ellipse(lineColor = {75,138,73},
                    fillColor={255,255,255},
                    fillPattern = FillPattern.Solid,
                    extent={{-100,-100},{100,100}}),
            Polygon(lineColor = {0,0,255},
                    fillColor = {75,138,73},
                    pattern = LinePattern.None,
                    fillPattern = FillPattern.Solid,
                    points={{-36,60},{64,0},{-36,-60},{-36,60}})}));
    end Supply_pT_Test;
    annotation (Icon(graphics={
          Rectangle(
            lineColor={200,200,200},
            fillColor={248,248,248},
            fillPattern=FillPattern.HorizontalCylinder,
            extent={{-100,-100},{100,100}},
            radius=25.0),
          Rectangle(
            lineColor={128,128,128},
            extent={{-100,-100},{100,100}},
            radius=25.0),
          Polygon(
            origin={8,14},
            lineColor={78,138,73},
            fillColor={78,138,73},
            pattern=LinePattern.None,
            fillPattern=FillPattern.Solid,
            points={{-58.0,46.0},{42.0,-14.0},{-58.0,-74.0},{-58.0,46.0}})}));
  end Examples;
  annotation ( preferredView="info",
  Documentation(info="<html>
This package provides
models that can be used as simple equivalents of
more complex thermo-hydraulic models.
</html>"),
Icon(   graphics={
        Rectangle(
          lineColor={200,200,200},
          fillColor={248,248,248},
          fillPattern=FillPattern.HorizontalCylinder,
          extent={{-100,-100},{100,100}},
          radius=25.0),
        Rectangle(
          lineColor={128,128,128},
          extent={{-100,-100},{100,100}},
          radius=25.0),
        Ellipse(
          origin={10,10},
          fillColor={76,76,76},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          extent={{-80.0,-80.0},{-20.0,-20.0}}),
        Ellipse(
          origin={10,10},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          extent={{0.0,-80.0},{60.0,-20.0}}),
        Ellipse(
          origin={10,10},
          fillColor={128,128,128},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          extent={{0.0,0.0},{60.0,60.0}}),
        Ellipse(
          origin={10,10},
          lineColor={128,128,128},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-80.0,0.0},{-20.0,60.0}})}));
end ThermoHydraulicEquivalent;
