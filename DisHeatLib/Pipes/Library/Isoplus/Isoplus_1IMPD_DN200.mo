within DisHeatLib.Pipes.Library.Isoplus;
record Isoplus_1IMPD_DN200
  extends DisHeatLib.Pipes.BaseClasses.BasePipe(
    dh=0.2101,
    v_nominal=2.4,
    redeclare DisHeatLib.Pipes.BaseClasses.PipeMaterials.Steel pipeMaterial,
    dWall=0.0045,
    kIns=0.0240,
    dIns=0.06795);
  annotation (Documentation(revisions="<html>
<ul>
<li>Feburary 27, 2019, by Benedikt Leitner:<br>Implementation and added User&apos;s guide. </li>
</ul>
</html>"));
end Isoplus_1IMPD_DN200;
