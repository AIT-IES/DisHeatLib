within DisHeatLib.Pipes.Library.Isoplus;
record Isoplus_1IMP_DN80
  extends DisHeatLib.Pipes.BaseClasses.BasePipe(
    dh=0.0825,
    v_nominal=1.60,
    redeclare DisHeatLib.Pipes.BaseClasses.PipeMaterials.Steel pipeMaterial,
    dWall=0.0032,
    kIns=0.0240,
    dIns=0.04555);
  annotation (Documentation(revisions="<html>
<ul>
<li>Feburary 27, 2019, by Benedikt Leitner:<br>Implementation and added User&apos;s guide. </li>
</ul>
</html>"));
end Isoplus_1IMP_DN80;
