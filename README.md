# kVIS3 -- Kai's Data visualisation and manipulation tool (3rd edition)

## Management and visualisation of time sampled experimental data with emphasis on flight test data in Matlab

![kVIS UI](./docs/img/1.jpeg "kVIS UserInterface")

*kVIS3 is released under the GPL V3 license.*

Inspired by the SIDPAC GUI by E.A. Morelli.

## Features:
- present large amount of data in an accessible tree structure ( 4000+ data channels are routinely used by the author )
- supports non-uniform sample rates between data groups
- supports multiple data sets concurrently (WiP)
- flexible plot axes framework to freely define desired layout and mixing of different plot types
- data set trimming
- marking of significant time points in the data with events
- definition of quickly accessible custom plot layouts 
- export data as CSV or into the Matlab workspace
- google map plot (requires API key) or open street map plot
- data manipulation with filters and freely defined Matlab functions via context menus
- Report generator
- plug in architecture for custom extensions

## Installation:
### kVIS3
kVIS3 can be cloned using git into your preferred directory, or download the zip file from the github page.
```
git clone https://github.com/flyingk/kVIS3.git --recursive
```
The `--recursive` flag ensure that the requried submodules are also downloaded with the main repo.

### git submodules
kVIS3 requires the `FDS File Format` git submodule to be initialised and updated to be able to generate the correct file structures for kVIS3.  If you forgot to clone kVIS3 recursively, these can easily be pulled at any time.

From the kVIS3 directory, run in a terminal
```
git submodule init
git submodule update
```

### MATLAB toolboxes
kVIS3 depends upon the `GUI Layout Toolbox` and `Widgets Toolbox` to generate the GUI.  These are easily installed by double clicking the respective `.mltbx` files found in `kVIS3 > contribute`. 

### Board support package (BSP)
kVIS3 requires a *Board Support Package (BSP)*, specified in the preferences, to import and process data from the user's data acquisition system. This split allows for kVIS3 to be open source, while working with potentially propriatry data. All data specific functionality is provided by the BSP, and therefore **kVIS3 without a BSP will not launch (or be able to do anything).**

Freely available BSP's are (work in progress):

- [Generic BSP template for CSV files](https://github.com/flyingk/kVIS3_bsp_generic_demo)
- [ArduPilot](https://github.com/flyingk/kVIS3_bsp_ardupilot)
- [PX4](https://github.com/flyingk/kVIS3_bsp_px4)
- [Betaflight](https://github.com/flyingk/kVIS3_bsp_betaflight)

As many of these BSPs rely on submodules for the log > MATLAB conversion, make sure to `init` and `update` the submodules.

## How to run:
Run 'kVIS3.m' from the main directory. On first launch you will be asked to specify the path to the BSP folder containing the `BSP_ID.m` file.  Make sure to select the root folder for the BSP and not one of the BSPs sub-folders.

## Additional information:

Refer to the [help](https://flyingk.github.io/kVIS3/) for a user manual and coding information. (WiP)

Development of kVIS3 supported by The University of Sydney, School of AMME, and Lilium GmbH. 

### External Contributions:
kVIS3 uses the following external contributions:

- [Matlab GUI Layout Toolbox](https://www.mathworks.com/matlabcentral/fileexchange/47982-gui-layout-toolbox)
- [Matlab Widgets Toolbox](https://www.mathworks.com/matlabcentral/fileexchange/66235-widgets-toolbox)
- [Plot Google Maps](https://github.com/zoharby/plot_google_map)
- [Plot Open Street Map](https://github.com/alexvoronov/plot_openstreetmap)
- [Icons](https://icons8.com)
- [Standard-Atmosphere](https://github.com/sky-s/standard-atmosphere)

Thanks for sharing!

## Created and copyright by Kai Lehmkühler Ph.D. and Matt Anderson Ph.D.
