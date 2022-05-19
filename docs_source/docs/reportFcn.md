# Report Generator

The integrated report generator can generate a LaTeX document from a template, which includes data from various sources in kVIS.

If available in the dataset, the following can be integrated into the report:
	
- A table generated from aircraft info
- A table generated from test info
- A map plot
- Figures derived from custom plot definitions
- Figures derived from a BSP function

The template itself is a LaTeX file with some extra kVIS specific commands. All other LaTeX functions can be used to design a report. The additional commands are defined as LaTeX comments to not interfere with the normal document compilation. These special comments have the form ```%_kVIS_xxxxx``` where ```xxxx``` is the actual command. **Therefore, comments that resemble this form are reserved for those additional kVIS commands.**

## Available Report Commands

- ```%_kVIS_make_title```: Generate Document title with data set name
- ```%_kVIS_test_info```: Generates a table from the test info fields
- ```%_kVIS_aircraft_properties```: Generates a table from aircraft properties
- ```%_kVIS_map_plot{xxx}```: Generates a map plot (if available in the BSP). ```xxx``` is the standard Group/Channel tupel to define the track colour, for example airspeed.
- ```%_kVIS_plot[xxx]{yyy.xlsx}```: Generates figures from custom plot definition ```yyy.xslx```. If the plot definition contains more than one subplot, ```xxx``` is a comma separated list of subplot indices to include. Leave empty to include all subplots. Each subplot becomes a separate figure at this stage. Only the Excel plot definitions are supported. The figure caption is generated from the dedicated column in the plot definition file (column I).
- ```%_kVIS_bsp_fcn_eval{xxx}```: Evaluate BSP - function ```xxx``` and generate figures from the returned figure handles of the function. The function can return an array of figure handles. One plot per array entry will be generated.

## How to use the Report Generator

1) Create a normal LaTex document with all required content (Header, Body, Styling). The tex file must compile without error into a document.

2) Add the kVIS commands where desired

3) Save the .tex file to the BSP ```ReportGeneration``` folder

4) Refresh the Reports tab, the new template will appear in the list

5) Click on the template name to run it, or edit it with the pencil button

6) After running a template, it will ask for a folder to save the files in

7) The generator runs and produces all plots and other data items

8) At the end the folder contains a new LaTeX file, where all special commands have been translated into LaTeX code, and all images have been generated into a ```img``` folder. If a compatible LaTeX installation is found, also a PDF file of the report is generated automatically. Otherwise, the generated .tex file can be compiled manually.

