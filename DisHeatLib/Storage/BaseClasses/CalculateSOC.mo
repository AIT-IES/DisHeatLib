within DisHeatLib.Storage.BaseClasses;
model CalculateSOC
  extends Modelica.Blocks.Interfaces.MISO;

  parameter Modelica.SIunits.Temperature TemHot
    "Minimum temperature to be considered hot";

  Real n_hot "Number of hot layers";

algorithm
  n_hot :=0;
  for i in 1:nin loop
    if u[i] > TemHot then
      n_hot := n_hot + 1;
    end if;
  end for;
  y := n_hot/nin;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end CalculateSOC;
