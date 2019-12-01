# kVIS3 -- Kai's Data visualisation and manipulation tool (3rd edition)

## Management and visualisation of time sampled experimental data with emphasis on flight test data in Matlab

![kVIS UI](./docs/img/1.jpeg "kVIS UserInterface")

*kVIS3 is released under the GPL V3 license.*

Inspired by the SIDPAC GUI by E.A. Morelli.

## Features:
- present large amount of data in an accessible tree structure ( 4000+ data channels are routinely used by the author )
- supports non-uniform sample rates between data groups
- supports multiple data sets concurrently
- flexible plot axes framework to freely define desired layout and mixing of different plot types
- data set trimming
- marking of significant time points in the data with events
- definition of quickly accessible custom plot layouts 
- export data in freely defined formats 
- google map plot (requires API key)
- data manipulation with filters and freely defined Matlab functions via context menus
- plug in architecture for custom extensions

## How to run:

kVIS3 requires a *Board Support Package (BSP)*, specified in the preferences, to import and process data from the user's data acquisition system. This split allows for kVIS3 to be open source, while potentially dealing with propriatry data. All data specific functionality is provided by the BSP, and therefore kVIS3 without a BSP will not launch (or be able to do anything).

Freely available BSP's are (work in progress):

- Generic BSP template for CSV files
- [ArduPilot](https://github.com/flyingk/kVIS3_bsp_ardupilot)
- [PX4](https://github.com/flyingk/kVIS3_bsp_px4)
- tbd.

Run 'kVIS3.m' after installing the two toolboxes in the `Contributed` folder. On first launch you will be asked to specify the path to the BSP folder containing the `BSP_ID.m` file.


## Additional information:

Refer to the [help](https://flyingk.github.io/kVIS3/) for a user manual and coding information. (WiP)

Development of kVIS3 supported by The University of Sydney, School of AMME, and Lilium GmbH. 

### External Contributions:
kVIS3 relies on the following external contributions:

- [Matlab GUI Layout Toolbox](https://www.mathworks.com/matlabcentral/fileexchange/47982-gui-layout-toolbox)
- [Matlab Widgets Toolbox](https://www.mathworks.com/matlabcentral/fileexchange/66235-widgets-toolbox)
- [Plot Google Maps](https://github.com/zoharby/plot_google_map)
- [Icons](https://icons8.com)

Thanks for sharing!

## Created and copyright by Kai Lehmkühler Ph.D. and Matt Anderson Ph.D.
