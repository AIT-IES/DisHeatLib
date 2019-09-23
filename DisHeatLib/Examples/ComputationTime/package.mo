within DisHeatLib.Examples;
package ComputationTime
  extends Modelica.Icons.ExamplesPackage;

annotation (Documentation(info="<html>
<p>This subpackage of examples demonstrates the main mechanisms to reduce computation time. By slightly altering the example &quot;base&quot; which can be found in the subpackage &quot;Network&quot;. All &quot;StorageTankHex&quot; inside of the substations of the buildings have been replaced by &quot;IndirectStation&quot;.</p>
<p>Following changes will be shown here:</p>
<ul>
<li>Using a different solver such as Cvode instead of dassl</li>
<li>Replacing valves by pumps</li>
<li>Forbidding flow reversals to set the flow direction</li>
<li>Setting the flow resistance to a linear function</li>
<li>Using the sparse matrix format</li>
</ul>
<p><br>A test run of a few examples yielded the following computation times in min:</p>
<ul>
<li>None of the four optimizations: 		44 min</li>
<li>Using Cvode instead of Dassl: </li>
<li>Using Cvode and linearized flow resistance:</li>
<li>Using Cvode and pumps instead of valves: </li>
<li>Using Cvode and the sparse command:</li>
<li>Using Cvode and forbidding flow reversal:</li>
<li>All five optimizations: </li>
</ul>
<p><br>Unless specified otherwise all commands use the solver Cvode instead of the default solver dassl.</p>
</html>"));
end ComputationTime;
