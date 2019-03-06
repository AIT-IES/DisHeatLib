within DisHeatLib.Pipes.Library.Isoplus;
record Isoplus_1IMP_DN125
  extends DisHeatLib.Pipes.BaseClasses.BasePipe(
    dh=0.1325,
    v_nominal=1.80,
    redeclare DisHeatLib.Pipes.BaseClasses.PipeMaterials.Steel pipeMaterial,
    dWall=0.0036,
    kIns=0.0240,
    dIns=0.05515);
  annotation (Documentation(revisions="<html>
<ul>
<li>Feburary 27, 2019, by Benedikt Leitner:<br>Implementation and added User&apos;s guide. </li>
</ul>
</html>"));
end Isoplus_1IMP_DN125;
