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
version="1.1",
versionDate="2019-03-06",
dateModified="2019-03-06",
uses(Modelica(version="3.2.2"), IBPSA(version="3.0.0")),
Documentation(info="<html>
<p>The <span style=\"font-family: Courier New;\">DisHeatLib</span> library is a library for modeling district heating networks and corresponding control systems. Many models are based on models from the package <span style=\"font-family: Courier New;\"><a href=\"https://github.com/ibpsa/modelica-ibpsa\">IBPSA</a></span>. </p>
<p>The development page for this library is <a href=\"https://github.com/AIT-IES/DisHeatLib\">https://github.com/AIT-IES/DisHeatLib</a>. Contributions to further advance the library are welcomed. Contributions may not only be in the form of model development, but also through model use, model testing, requirements definition or providing feedback regarding the model applicability to solve specific problems. </p>
</html>", revisions="<html>
<ul>
<li>Feburary 27, 2019, by Benedikt Leitner:<br>Implementation and added User&apos;s guide. </li>
</ul>
</html>"));
end DisHeatLib;
