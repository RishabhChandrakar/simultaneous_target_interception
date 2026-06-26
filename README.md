# simultaneous-target-interception
**Simultaneous Target Interception** is the implementation of the research paper    , which proposes a distributed guidance law for the simultaneous interception of a stationary target. The proposed guidance
law establishes the necessary conditions on static graphs as well as on switching graph topologies which ensures simultaneous target interception, regardless of the initial conditions of the pursuers. The proposed guidance formulation is extremely lightweight and efficient, making it suitable for real-time use even on low-cost, resource-constrained onboard computers and in the practical scenarios, where factors such as limited sensory ranges, device failures and the presence of obstacles can
adversely hinder the communication between the pursuers, which leads to switching graphs.




## Implementation Results

### Case 1: In Static Graph

<p align="center">
  <!-- <img src="media_files/minco_trajectory_planner_hardware_1-ezgif.com-video-to-gif-converter.gif" width = "800" height = "225"/> -->
  <img src="implementation_results/Case_1/Screencast from 04-22-2026 11_56_30 AM(1).gif" width = "800" height = "600"/>
  <img src="implementation_results/Case_1/path.png" width = "800" height = "600"/>
  <img src="implementation_results/Case_1/t_tilda.png" width = "800" height = "600"/> 

  <!-- <img src="media_files/minco_trajectory_planner.jpeg" width = "400" height = "225"/> -->
  <!-- <img src="files/icra20_1.gif" width = "320" height = "180"/> -->
</p>


### Case 2: In Switching Graph(without sink)

<p align="center">
  <!-- <img src="media_files/minco_trajectory_planner_hardware_1-ezgif.com-video-to-gif-converter.gif" width = "800" height = "225"/> -->
  <img src="implementation_results/Case_2(without sink)/video.gif" width = "800" height = "600"/>
  <img src="implementation_results/Case_2(without sink)/path.png" width = "800" height = "600"/>
  <img src="implementation_results/Case_2(without sink)/t_tilda.png" width = "800" height = "600"/> 

</p>

### Case 3: In Switching Graph(with sink)

<p align="center">
  <!-- <img src="media_files/minco_trajectory_planner_hardware_1-ezgif.com-video-to-gif-converter.gif" width = "800" height = "225"/> -->
  <img src="implementation_results/Case_2(with sinks)/Screencast from 04-22-2026 11_50_04 AM.gif" width = "800" height = "600"/>
  <img src="implementation_results/Case_2(with sinks)/Screenshot from 2026-04-22 11-51-06.png" width = "800" height = "600"/>
  <img src="implementation_results/Case_2(with sinks)/Screenshot from 2026-04-22 11-51-26.png" width = "800" height = "600"/> 

  <!-- <img src="media_files/minco_trajectory_planner.jpeg" width = "400" height = "225"/> -->
  <!-- <img src="files/icra20_1.gif" width = "320" height = "180"/> -->
</p>


### Case 3: In Switching Graph(with addition of a new robot in between)

<p align="center">
  <!-- <img src="media_files/minco_trajectory_planner_hardware_1-ezgif.com-video-to-gif-converter.gif" width = "800" height = "225"/> -->
  <img src="implementation_results/Case_3(node addition)/Screencast from 04-22-2026 01_04_47 PM.gif" width = "800" height = "600"/>
  <img src="implementation_results/Case_3(node addition)/Screenshot from 2026-04-22 13-07-48.png" width = "800" height = "600"/>
  <img src="implementation_results/Case_3(node addition)/Screenshot from 2026-04-22 13-08-13.png" width = "800" height = "600"/> 

</p>



<!-- Complete videos: 
[video1](https://www.youtube.com/watch?v=NvR8Lq2pmPg&feature=emb_logo),
[video2](https://www.youtube.com/watch?v=YcEaFTjs-a0), 
[video3](https://www.youtube.com/watch?v=toGhoGYyoAY). 
Demonstrations about this work have been reported on the IEEE Spectrum: [page1](https://spectrum.ieee.org/automaton/robotics/robotics-hardware/video-friday-nasa-lemur-robot), [page2](https://spectrum.ieee.org/automaton/robotics/robotics-hardware/video-friday-india-space-humanoid-robot),
[page3](https://spectrum.ieee.org/automaton/robotics/robotics-hardware/video-friday-soft-exoskeleton-glove-extra-thumb) (search for _HKUST_ in the pages).

-->

To run this project in minutes, check [Quick Start](#1-Quick-Start). Check other sections for more detailed information.

Please kindly star :star: this project if it helps you. We take great efforts to develope and maintain it :grin::grin:.







