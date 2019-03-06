within DisHeatLib.Pipes.Library.Isoplus;
record Isoplus_Std_DN65
  extends DisHeatLib.Pipes.BaseClasses.BasePipe(
    dh=0.0697,
    v_nominal=1.4,
    redeclare DisHeatLib.Pipes.BaseClasses.PipeMaterials.Steel pipeMaterial,
    dWall=0.0029,
    kIns=0.0240,
    dIns=0.03195);
  annotation (Documentation(revisions="<html>
<ul>
<li>Feburary 27, 2019, by Benedikt Leitner:<br>Implementation and added User&apos;s guide. </li>
</ul>
</html>"));
end Isoplus_Std_DN65;
