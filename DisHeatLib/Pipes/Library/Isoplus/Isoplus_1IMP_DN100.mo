within DisHeatLib.Pipes.Library.Isoplus;
record Isoplus_1IMP_DN100
  extends DisHeatLib.Pipes.BaseClasses.BasePipe(
    dh=0.1071,
    v_nominal=1.60,
    redeclare DisHeatLib.Pipes.BaseClasses.PipeMaterials.Steel pipeMaterial,
    dWall=0.0036,
    kIns=0.0240,
    dIns=0.05535);
  annotation (Documentation(revisions="<html>
<ul>
<li>Feburary 27, 2019, by Benedikt Leitner:<br>Implementation and added User&apos;s guide. </li>
</ul>
</html>"));
end Isoplus_1IMP_DN100;
