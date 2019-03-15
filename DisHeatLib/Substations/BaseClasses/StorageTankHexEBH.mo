within DisHeatLib.Substations.BaseClasses;
model StorageTankHexEBH
  extends StorageTankHex(total_power(y=sum(prescribedHeatFlow[i].Q_flow for
          i in 1:nSegEBH)/eff_EBH),
          nSegMeasure = nSegEBH+1);

  parameter Modelica.SIunits.Power Q_flow_nominal_EBH "Heat capacity of EBH"
    annotation(Dialog(group="Electric booster heater"));
  parameter Modelica.SIunits.Temperature T_min_EBH "Reference temperature of EBH"
    annotation(Dialog(group="Electric booster heater"));
  parameter Modelica.SIunits.TemperatureDifference T_bandwidth_EBH "Temperature bandwidth of EBH"
    annotation(Dialog(group="Electric booster heater"));
  parameter Integer nSegEBH=1 "Number of top tank segments heated by EBH"
    annotation(Dialog(group="Electric booster heater"));
  parameter Modelica.SIunits.Efficiency eff_EBH "Power-to-heat efficiency of EBH"
    annotation(Dialog(group="Electric booster heater"));

  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow prescribedHeatFlow[nSegEBH]
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,28})));
  Controls.twopoint_control EBH_control(
    y_max=Q_flow_nominal_EBH/nSegEBH,
    y_min=0,
    u_min=T_min_EBH,
    u_bandwidth=T_bandwidth_EBH) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={0,68})));
  Modelica.Blocks.Routing.Replicator replicator(nout=nSegEBH)
                                                annotation (Placement(
        transformation(
        extent={{-5,-4},{5,4}},
        rotation=-90,
        origin={0,47})));
equation
  connect(replicator.y, prescribedHeatFlow.Q_flow)
    annotation (Line(points={{0,41.5},{0,38}}, color={0,0,127}));
  connect(EBH_control.y, replicator.u)
    annotation (Line(points={{0,57},{0,53}}, color={0,0,127}));
  connect(storageTankHex.TemTank[1], EBH_control.u) annotation (Line(points={
          {4,-11},{4,-22},{20,-22},{20,80},{0,80}}, color={0,0,127}));
  connect(prescribedHeatFlow.port, storageTankHex.heaPorVol[1:nSegEBH])
    annotation (Line(points={{0,18},{0,10}}, color={191,0,0}));
  annotation (Icon(graphics={
        Line(
          points={{-14,58},{-20,58},{-20,58},{-20,26},{-10,40},{0,26},{10,40},
              {20,26},{20,58},{14,58}},
          color={0,0,0},
          thickness=1),
        Ellipse(
          extent={{-16,78},{16,46}},
          lineColor={0,0,0},
          fillColor={247,247,247},
          fillPattern=FillPattern.Solid,
          lineThickness=0.5),
        Polygon(
          points={{2,76},{0,64},{6,64},{-2,48},{0,60},{-6,60},{2,76}},
          lineColor={0,0,0},
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid,
          lineThickness=0.5)}), Documentation(info="<html>
<p>This is a model for a district heating substation storage tank with an internal heat exchanger and an electric booster heater. Its main components are the storage tank with internal heat exchanger and an electric booster heater, a flow regulating valve/pump, an expansion vessel, a controller that maintains the temperature in the selected tank layer by setting the position of the flow regulating valve/pump to open or closed and a controller that activates the electric booster heater in case the temperature of the standby volume in the tank is too low.</p>
<p>A mismatch between the setpoint and the actual value of the secondary supply temperature can have different reasons:</p>
<ul>
<li>The differential pressure at the station is too low, resulting in a too low mass flow at the primary side even if the valve is completely open.</li>
<li>The nominal mass flow rate at the primary side is too low, leading to a too low secondary supply temperature even with a fully opend valve.</li>
<li>The supply temperature at the primary side is too low, i.e., lower than the tank temperature setpoint, leading to a fully opened valve</li>
</ul>
</html>"));
end StorageTankHexEBH;
