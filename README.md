## Overview 

Given the presence of barrel distortion in virtual reality headsets, had to look at different methods of distortion correction. Primarily if it is implement in the fragment or vertex shader. For further details please see 'Research_Report.pdf'.

## Viewing Scenes

For all displays ensure that the Square(1200x1200) preset is selected in the drop down next to the ‘Display’ drop down.

Display 1  -  Distortion pre-correction using fragment shader
Display 2  -  Chromatic aberration pre-correction using fragment shader 
Display 3  -  Distortion pre-correction using vertex shader 			 - 10 vertices / unity plane
Display 4  -  Simulated distortion after pre-correction using vertex shader	 - 10 vertices / unity plane
Display 5  -  Distortion pre-correction using vertex shader 			 - 64 vertices / blender
Display 6  -  Distortion pre-correction using vertex shader 			 - 100 vertices / blender
Display 7  -  Distortion pre-correction using vertex shader 			 - 512 vertices / blender

## Changing Parameters

### Coefficients

All coefficients can be changed by clicking on a quad/plane for a given section and scrolling to its material. Values can then be typed into the boxes labelled C1 value and C2 value. In the case of chromatic aberration correction, there are also boxes to specify the degree to which each colour channel is radially distorted. All planes used for pre-correction (starting ‘Inv-Plane- …’) using the vertex shader share the same texture, therefore, changing the coefficient values for one plane changes it for all of them.

### Distortion Pre-Correction Vs Simulated Distortion

This applies only to Problem-3. The ‘Standard’ subsection already outputs simulated distortion after pre-correction to camera 4 in the game mode. For each other subsection the camera labelled ‘Obs- … -Camera’ for that subsection outputs the distortion pre-correction to a camera in the game mode. To view the simulated distortion after pre-correction instead, requires adding 10 to the x value of the camera labelled ‘Obs- … -Camera’ for that subsection. 

## Static Renders

![Screenshot from 2022-09-05 09-12-59](https://user-images.githubusercontent.com/30124151/188401440-fdad69e1-f8db-46f2-9ed5-845b5393027a.png)

