within DisHeatLib.Substations.BaseStations;
model StorageTankHexEBH
  extends BaseStations.StorageTankHex(
                         total_power(y=EBH.P),
          nSegMeasure = nSegEBH+1);

  parameter Modelica.SIunits.Power Q_flow_nominal_EBH = Q2_flow_nominal "Heat capacity of EBH"
    annotation(Dialog(group="Electric booster heater"));
  parameter Modelica.SIunits.Temperature T_min_EBH = TemSup2_nominal "Reference temperature of EBH"
    annotation(Dialog(group="Electric booster heater"));
  parameter Modelica.SIunits.TemperatureDifference T_bandwidth_EBH = 4.0 "Temperature bandwidth of EBH"
    annotation(Dialog(group="Electric booster heater"));
  parameter Integer nSegEBH=1 "Number of top tank segments heated by EBH"
    annotation(Dialog(group="Electric booster heater"));
  parameter Modelica.SIunits.Efficiency eff_EBH = 0.97 "Power-to-heat efficiency of EBH"
    annotation(Dialog(group="Electric booster heater"));

  Supply.BaseClasses.ElectricHeatingRod EBH(
    Q_flow_nominal=Q_flow_nominal_EBH,
    eff=eff_EBH,
    nPorts=nSegEBH,
    u_min=T_min_EBH,
    u_bandwidth=T_bandwidth_EBH) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,34})));
equation
  connect(storageTankHex.TemTank[1], EBH.u) annotation (Line(points={{0,-11},{0,
          -22},{20,-22},{20,52},{0,52},{0,46}}, color={0,0,127}));
  connect(EBH.port, storageTankHex.heaPorVol[1:nSegEBH])
    annotation (Line(points={{0,24},{0,10}}, color={191,0,0}));
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
