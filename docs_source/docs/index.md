# kVIS3 Documentation

![App](img/1.jpeg)

## Overview

kVIS3 provides a framework to visualise and process time sampled data. The application design is fully modular to allow for easy implementation of custom functionality.

The functionality to interpret and handle the data files from the recording system has been moved into a separate component, called the Board Support Package (BSP). The kVIS3 application does not contain any functionality specific to the data format and content of the user data. This allows for a single application to be used for multiple, potentially proprietary, data formats, while still be open and easily expandable. The user can also add functionality to the BSP without need to change the main application.

kVIS3 contains all the generic functionality described in this document. All BSP specific functionality must be documented in a BSP help.
kVIS3 is based on a generic file format for the test data, which arranges the data in a convenient and easy to manage tree format. The file format also saves auxiliary data like event markers and test information together with the data in one place. The BSP is responsible to generate the FDS file format form the user supplied data format. This includes the generation of the tree structure, which can be entirely defined by the user.


## Contents

### UI Elements

- Application Framework

- Data Viewer Tab
	- Timeplot
	- Frequency plot
	- Correlation plot
	- Map plot


- Function Tabs
	- Data
	- Events
	-  Custom Plots
	-  Exports


### Developer Information

- [FDS data structure](fdsFormat.md)

- FDS API functions

- BSP requirements

- Custom functionality
