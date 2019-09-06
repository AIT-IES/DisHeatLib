within ;
package DisHeatLib
















annotation (
Diagram(coordinateSystem(preserveAspectRatio=true, initialScale=0.1)),
Icon(coordinateSystem(preserveAspectRatio=true, initialScale=0.1), graphics={
        Rectangle(
          lineColor={200,200,200},
          fillColor={248,248,248},
          fillPattern=FillPattern.HorizontalCylinder,
          extent={{-100.0,-100.0},{100.0,100.0}},
          radius=25.0),
        Rectangle(
          lineColor={128,128,128},
          extent={{-100.0,-100.0},{100.0,100.0}},
          radius=25.0),
                  Bitmap(extent={{-90,-90},{90,90}}, fileName="modelica://DisHeatLib/Resources/Images/DisHeatLib_logo.png")}),
preferredView="info",
version="1.2",
versionDate="2019-09-06",
dateModified="2019-09-06",
uses(
    Modelica(version="3.2.3"),
    IBPSA(version="3.0.0")),
Documentation(info="<html>
<p><img src=\"modelica://DisHeatLib/Resources/Images/DisHeatLib_logo.png\" width=\"250\" align=\"right\" border=1\" /> </p>
<p>The <span style=\"font-family: Courier New;\">DisHeatLib</span> library is a library for dynamic modeling of district heating networks including corresponding control systems. Many models are based on the excellent Modelica library <span style=\"font-family: Courier New;\"><a href=\"https://github.com/ibpsa/modelica-ibpsa\">IBPSA</a></span>. </p>
<p><span style=\"font-family: Courier New;\">DisHeatLib</span> is providing the means to study district heating systems in detail. The key additions and highlights compared to standard steady-state approaches when modeling district heating networks include:</p>
<ul>
<li>Transport phenomena (temperature wave propagation, heat losses, zero and reversed flows, ...)</li>
<li>Multiple heat sources (different and possibly fluctuating supply temperature levels, bi-directional flows, ...)</li>
<li>Thermal-hydraulic details</li>
<li>Explicit control functions (no steady-state assumptions)</li>
<li>Thermal storage tanks, thermal mass of pipes, etc.</li>
<li>Interface to (low-energy) building models (directly in Modelica or coupled via the <a href=\"https://fmi-standard.org/\">FMI standard</a>)</li>
<li>Interface to power distribution network models (via the <a href=\"https://fmi-standard.org/\">FMI-standard</a>)</li>
<li>Interface to external control implementations (via the <a href=\"https://fmi-standard.org/\">FMI-standard</a>)</li>
</ul>
<p>These effects and interfaces are especially important as district heating is becoming an essential part of smart energy systems which leads to high interconnections with the power system and the need for intelligent control. </p>
<p><br>The development page for this library is <a href=\"https://github.com/AIT-IES/DisHeatLib\">https://github.com/AIT-IES/DisHeatLib</a>. Contributions to further advance the library are welcomed. Contributions may not only be in the form of model development, but also through model use, model testing, requirements definition or providing feedback regarding the model applicability to solve specific problems. Issues with the library can be easily reported <a href=\"https://github.com/benleit/DisHeatLib/issues\">here</a>.</p>
</html>", revisions="<html>
<ul>
<li>Feburary 27, 2019, by Benedikt Leitner:<br>Implementation and added User&apos;s guide. </li>
</ul>
</html>"),
  conversion(noneFromVersion="1.1"));
end DisHeatLib;
