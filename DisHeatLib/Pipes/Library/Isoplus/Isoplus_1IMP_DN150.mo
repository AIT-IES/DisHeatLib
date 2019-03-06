within DisHeatLib.Pipes.Library.Isoplus;
record Isoplus_1IMP_DN150
  extends DisHeatLib.Pipes.BaseClasses.BasePipe(
    dh=0.1603,
    v_nominal=2.1,
    redeclare DisHeatLib.Pipes.BaseClasses.PipeMaterials.Steel pipeMaterial,
    dWall=0.0040,
    kIns=0.0240,
    dIns=0.05585);
  annotation (Documentation(revisions="<html>
<ul>
<li>Feburary 27, 2019, by Benedikt Leitner:<br>Implementation and added User&apos;s guide. </li>
</ul>
</html>"));
end Isoplus_1IMP_DN150;
