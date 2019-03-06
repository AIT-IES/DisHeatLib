within DisHeatLib.Pipes.Library.Isoplus;
record Isoplus_2IMP_DN25
  extends DisHeatLib.Pipes.BaseClasses.BasePipe(
    dh=0.0273,
    v_nominal=1.1,
    redeclare DisHeatLib.Pipes.BaseClasses.PipeMaterials.Steel pipeMaterial,
    dWall=0.0023,
    kIns=0.0240,
    dIns=0.04565);
  annotation (Documentation(revisions="<html>
<ul>
<li>Feburary 27, 2019, by Benedikt Leitner:<br>Implementation and added User&apos;s guide. </li>
</ul>
</html>"));
end Isoplus_2IMP_DN25;
