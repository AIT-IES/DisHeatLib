within DisHeatLib.Pipes.Library.Isoplus;
record Isoplus_2IMP_DN80
  extends DisHeatLib.Pipes.BaseClasses.BasePipe(
    dh=0.0825,
    v_nominal=1.6,
    redeclare DisHeatLib.Pipes.BaseClasses.PipeMaterials.Steel pipeMaterial,
    dWall=0.0032,
    kIns=0.0240,
    dIns=0.05555);
  annotation (Documentation(revisions="<html>
<ul>
<li>Feburary 27, 2019, by Benedikt Leitner:<br>Implementation and added User&apos;s guide. </li>
</ul>
</html>"));
end Isoplus_2IMP_DN80;
