# Modelica DisHeatLib library

_DisHeatLib_ is a Modelica library for dynamic modelling of district heating networks. It uses the excellent [Modelica IBPSA library](https://github.com/ibpsa/modelica-ibpsa) as core.

This is the development site for the _Modelica DisHeatLib library_ and its user guide.

Instructions for developers are available on the [IBPSA wiki](https://github.com/ibpsa/modelica-ibpsa/wiki).

## Library description

The Modelica _DisHeatLib_ library is a free open-source library with basic models that simplify the implementation of district heating networks, relevant control systems and provide an interface to an optional electric power network.

## License

The Modelica _DisHeatLib_ library is available under a 3-clause BSD-license.
See [Modelica DisHeatLib Library license](https://htmlpreview.github.io/?https://github.com/AIT-IES/DisHeatLib/blob/master/LICENSE).

## Development and contribution
You may report any issues by using the [Issues](https://github.com/AIT-IES/DisHeatLib/issues) button.

Contributions in the form of [Pull Requests](https://github.com/AIT-IES/DisHeatLib/pulls) are always welcome.
Prior to issuing a pull request, make sure your code follows
the [IBPSA style guide and coding conventions](https://github.com/ibpsa/modelica-ibpsa/wiki/Style-Guide).

## Prerequisites

[Dymola](https://www.3ds.com/products-services/catia/products/dymola/) is needed including a supported C++ compiler such as [Visual Studio](https://visualstudio.microsoft.com/de/?rr=https%3A%2F%2Fwww.google.com%2F). Newer versions of Visual Studio might not be supported. For Dymola 2020 Visual Studio 2017 is supported and can be found, e.g., [here](https://www.kunal-chowdhury.com/p/download-visual-studio-2017.html). The IBPSA library must be loaded before the DisHeatLib.

## Tutorials

[Modelica by Example](https://mbe.modelica.university/) is an interactive introduction to Modelica by M. Tiller.

The [Buildings library user guide](https://simulationresearch.lbl.gov/modelica/userGuide/index.html) contains best practices and useful information for modeling thermal-hydraulic models in Modelica which applies to the IBPSA and DisHeatLib libraries.

## Examples
Concrete examples on how to use models from the DisHeatLib library can be found in the respective example sub-packages. They include simple one component examples and more elaborate examples combining multiple models to larger district heating systems of varying complexity. Each example is explained in detail in the respective model documentation including example commands and plots.

## Autoload package

To automatically load packages open “dymola.mos” with editor/notepad++ in the folder “insert” in “Dymola” (probably in “program files”). Then add the following lines:
openModel("[library path]/modelica-ibpsa-master/IBPSA/package.mo");
openModel("[library path]/DisHeatLib-master/DisHeatLib/package.mo");
