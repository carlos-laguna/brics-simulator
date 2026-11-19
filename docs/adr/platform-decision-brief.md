# Choosing a platform stack for our simulator

**19/11/2026** · Supporting evidence for [ADR 005](005-isaac-lab-and-newton.md).
Versions, capabilities and terms below are those reviewed for this decision.

Recommendation: start with a minimum implementation on Isaac Lab 3.0 with Newton
physics; add full Isaac Sim when a task needs features such as RTX LiDAR or ROS 2. It
combines
[robot controls, sensors and training](<https://isaac-sim.github.io/IsaacLab/v3.0.0/source/isaaclab/ecosystem.html>)
in one platform, with
[no software licence fee for internal research](<https://docs.isaacsim.omniverse.nvidia.com/6.2.0/common/license-faq.html>). We can publish our code and assets we have permission to share. Users must install
Isaac themselves, including Isaac Sim for sensor tasks. Shipping full Isaac Sim with
Omniverse Kit (NVIDIA’s runtime), or hosting it for outside users, requires a paid
enterprise licence. Isaac Lab 3.0 ([released October
2026](<https://github.com/isaac-sim/IsaacLab/releases/tag/v3.0.0>)) runs most workflows
without Isaac Sim (“kit-less”). For physics, Isaac Lab offers
[PhysX or Newton](<https://docs.nvidia.com/isaaclab/3.0/isaac-lab/ecosystem>). Newton
includes MJWarp, a GPU version of MuJoCo, and solvers for deformable materials. Warp is
a programming library, not a third physics engine.

## Recommended stack

| Build now: minimum version | Strengths for our simulator | Limitations to plan for |
| --- | --- | --- |
| Core: every task, scenario and metric is built here first<br>Isaac Lab 3.0 with Newton physics (kit-less install) | One task API across [physics and renderer backends](<https://docs.nvidia.com/isaaclab/3.0/isaac-lab/ecosystem>); many parallel GPU environments. Fast [Newton Warp](<https://docs.nvidia.com/isaaclab/concepts/renderers>) cameras, or RTX images through OVRTX without Isaac Sim. [Ray-cast LiDAR](<https://isaac-sim.github.io/IsaacLab/v3.0.0/source/concepts/sensors/ray_caster.html>), contact and IMU sensors also run kit-less. [Open-source core](<https://github.com/isaac-sim/IsaacLab>). | NVIDIA GPU (Turing or newer) on [Linux or Windows 11](<https://docs.nvidia.com/isaaclab/3.0/isaac-lab/installation>). Ray-cast LiDAR ignores materials. [MPM soil](<https://isaac-sim.github.io/IsaacLab/v3.0.0/source/concepts/using_mpm.html>) is experimental, with no digging example; the [VBD cable solver](<https://newton-physics.github.io/newton/1.6.1/api/_generated/newton.solvers.SolverVBD.html>) may change. OVRTX is [pre-release and proprietary](<https://pypi.org/project/ovrtx/>). Pin versions per release. |
| Core sensor layer, added for RTX LiDAR or ROS 2; users install it<br>Full Isaac Sim 6.2 (Omniverse Kit) | [RTX LiDAR](<https://docs.isaacsim.omniverse.nvidia.com/6.2.0/sensors/isaacsim_sensors_rtx_lidar.html>) with vendor models (Ouster, Hesai, SICK) and material-dependent returns, RTX radar and the ROS 2 bridge. Users install it from NVIDIA (pip, container or download); running our code and assets on it [needs no enterprise licence](<https://docs.isaacsim.omniverse.nvidia.com/6.2.0/common/license-faq.html>). | [RTX 4080, 16 GB VRAM and 32 GB RAM minimum](<https://docs.isaacsim.omniverse.nvidia.com/6.2.0/installation/requirements.html>); A100 and H100 GPUs are unsupported, so RTX LiDAR tasks cannot run on them. Shipping or hosting it ourselves needs NVIDIA AI Enterprise. Label tasks that need it; keep the rest kit-less. |

| Later: not part of the first build | What it would add | Main limitation | Revisit when |
| --- | --- | --- | --- |
| Second backend<br>Native MuJoCo 4 (CPU) | Runs on Linux, macOS and Windows without a GPU. Apache-2.0, with [MuJoCo Playground](<https://playground.mujoco.org/>) and a [ros2_control package](<https://control.ros.org/rolling/doc/mujoco_ros2_control/doc/index.html>). | No soil workflow. Isaac uses MuJoCo 3.12 and [Newton skips MJCF flex elements](<https://newton-physics.github.io/newton/1.6.1/solvers/mujoco.html>), so MuJoCo 4’s plasticity and rods do not carry over. | Contributors without NVIDIA GPUs need to run our tasks, or we want a CPU cross-check. |
| Offline engineering reference<br>Project Chrono 10 | Specialist soil, cable, steel and water models: SCM and [CRM terrain](<https://arxiv.org/abs/2507.05643>), FEA cables, plasticity, fluid–structure coupling. BSD-3. | Thin RL tooling. CRM soil and ray-traced sensors need an NVIDIA GPU. [No excavator or bulldozer templates](<https://groups.google.com/g/projectchrono/c/rekdSgLdOas>). | We need to calibrate or validate Isaac’s soil, cable or contact settings. |
| BIM and asset pipeline<br>Blender with Bonsai (IFC) | Clean IFC models, prepare site geometry, render reference images and labelled datasets. Newton’s [converter](<https://pypi.org/project/mujoco-usd-converter/>) turns MJCF into USD. | MuJoCo’s [USD import is experimental](<https://mujoco.readthedocs.io/en/4.0.0/OpenUSD/index.html>) and the converter is alpha. Each IFC route drops some BIM data. | We import real site or BIM models; until then we use existing USD assets. |
| Visuals and scenery<br>Unreal Engine 5 with URLab | Best editable scenery and scan viewing, with Lumen and path tracing. [Free](<https://www.unrealengine.com/license>) for schools and firms under US$1 million revenue. | Extra C++ and editor skills. [URLab](<https://github.com/URLab-Sim/UnrealRoboticsLab>) has no tagged releases and supports only Unreal 5.7. Fab assets cannot be republished alone. | Stakeholders need high-end visuals, or a task needs Unreal scenery. |
| Captured sites<br>Gaussian splats (OpenUSD) | Photoreal real sites for camera training, from phone or drone footage; Newton’s [renderer](<https://newton-physics.github.io/newton/latest/api/_generated/newton.Gaussian.html>) and OVRTX already draw them. | Appearance only: [splat scenes have no physics](<https://isaac-for-healthcare.github.io/data-generation/hospital_digital_twin/bring_your_own_or/reconstruct_or_from_video/>), so add a collision mesh. Lighting is baked in; NuRec replay gives RGB only. | A camera task needs a real site; pilot one captured site first. |

Ruled out: AGX Dynamics, Vortex Studio and Gazebo (reasons under Main takeaways).

## Main takeaways

Keep our simulator portable and backend-agnostic as far as practical. Our simulator
should provide standardisation, definitions, and assets that are relevant for
construction like site and equipment models, repeatable tasks such as lifting a panel or
digging a trench, and common measures such as clearance, excavation depth and task
completion. This is akin to [CARLA](<https://carla.org/2024/12/19/release-0.10.0/>)
which adds towns, traffic and driving scenarios to Unreal and its Chaos vehicle physics;
its benchmark
[multiplies route completion by a penalty for collisions and other infractions](<https://leaderboard.carla.org/evaluation_v2_0/>).

Why I considered AGX: its
[wire tools](<https://www.algoryx.se/documentation/complete/agx/html/doc/UserManual/source/agxwire__simulating_wires.html>)
handle winches, pulleys and ropes rubbing on guides. It also offers
[wind loading on wires](<https://www.algoryx.se/documentation/complete/agx/html/doc/UserManual/source/hydro__and_aerodynamics.html>)
and
[excavation tools](<https://www.algoryx.se/documentation/complete/agx/html/doc/UserManual/source/agxTerrain.html>).

Why I ruled out AGX: it requires a [paid licence](<https://www.algoryx.se/buy/>). It
supports
[training a controller](<https://www.algoryx.se/documentation/complete/agx/html/doc/UserManual/source/reinforcement_learning.html>), but its [published terms (§3.2)](<https://us.download.algoryx.se/AGXUnreal/>) prohibit
using the software or its outputs to train, calibrate or validate a model that imitates
its physics solver. That would also stop us using AGX results to calibrate or check our
own models.

Also ruled out:
[Vortex Studio](<https://vortexstudio.atlassian.net/wiki/spaces/VSD225/pages/3250290880>)
has rich ready-made cranes, excavators and soil, but it is proprietary and
[stopped offering academic licences in 2023](<https://vortexstudio.atlassian.net/wiki/spaces/VSD231/pages/3287835376>). [Gazebo Jetty](<https://gazebosim.org/docs/all/release_notes/>) is open source and
ROS-native, but its physics engines run on the CPU, so it does not offer GPU-parallel
training.

Where the alternatives are stronger: native MuJoCo is the lightest choice for rigid-body
experiments. Chrono has the most specialised tools in this shortlist for soil, water and
structural response. Unreal offers
[detailed site scenery](<https://dev.epicgames.com/documentation/unreal-engine/free-epic-games-content-for-unreal-engine?lang=en-US>)
and its own
[collision physics](<https://dev.epicgames.com/documentation/en-us/unreal-engine/physics-in-unreal-engine>).

I see Blender as a later companion: prepare site models, offline renders, inspect IFC
building files with [Bonsai](<https://docs.bonsaibim.org/>), and make
[reference images](<https://docs.blender.org/manual/en/5.0/render/introduction.html>) or
[labelled datasets](<https://github.com/DLR-RM/BlenderProc>) without adding Blender to
the training loop.

| Criterion and recommendation | Isaac Lab and optional RTX | MuJoCo alone or with Unreal | Project Chrono |
| --- | --- | --- | --- |
| Putting physics and graphics together<br>Best: Isaac. Its physics and robot cameras already work together. | No custom connection is needed. Isaac Lab can pair Newton (including MJWarp) or standalone PhysX with [RTX rendering](<https://docs.nvidia.com/isaaclab/3.0/isaac-lab/ecosystem>). Newton Warp cameras are fastest; [OVRTX](<https://docs.nvidia.com/isaaclab/concepts/renderers>) gives RTX images without Isaac Sim and is now NVIDIA’s recommended RTX renderer. Install the renderer and choose the task’s supported configuration. Selecting MJWarp alone does not enable RTX. | Least setup for physics alone. Adding Unreal means installing a [separate plugin](<https://github.com/URLab-Sim/UnrealRoboticsLab>) and checking that each image matches the right moment in the simulation. | Chrono provides basic visualisation and an optional module for realistic, ray-traced camera images. It can export simulations to Blender for rendering after a run. There is no maintained Unreal plugin (the official game-engine bridge is [ChronoUnity](<https://github.com/projectchrono/chrono-unity>), for Unity), so Unreal would mean custom work and more setup than Isaac’s combined workflow. |
| Estimated learning difficulty<br>Easiest for a first physics task: native MuJoCo. For cameras plus training: Isaac. | Moderate. A Python developer must learn the task setup and GPU tools; the camera and training examples carry over to later tasks. | Low for a simple rigid-body task in Python. High with Unreal if the team must also learn its editor and the plugin. | High for specialist models: choosing a material, contact method and numerical settings takes mechanics expertise. |

## Physics for construction robotics

| Criterion and recommendation | Isaac Lab and optional RTX | MuJoCo alone or with Unreal | Project Chrono |
| --- | --- | --- | --- |
| Suspended loads and rigging<br>Best for simple slings: native MuJoCo. For engineering studies of cable stretch and bending: Chrono. | Same simple-sling model as MuJoCo: MJWarp uses [length-limited tendons](<https://newton-physics.github.io/newton/1.6.1/solvers/mujoco.html#tendons>) that go slack and pull when taut, including supported pulley paths. They do not model loose-rope bending or contact along its length. For that, Newton offers an experimental VBD cable solver. [Newton skips MJCF flex elements](<https://newton-physics.github.io/newton/1.6.1/solvers/mujoco.html>), so native MuJoCo’s rods do not reach Isaac. | A length-limited tendon pulls when taut and goes slack when unloaded. It captures payload swing cheaply; it does not simulate how a loose rope drapes. MuJoCo 4 also has [flexible rods](<https://mujoco.readthedocs.io/en/4.0.0/modeling.html>) that bend, twist and rub against surfaces. | [Flexible cable and beam elements](<https://api.projectchrono.org/10.0.0/manual_fea_elements.html>) model deformation along the cable. Choose stiffness, mass and contact geometry. The simplest cable element does not model twist. |
| Contact between parts<br>Best for repeated assembly trials: Isaac. For a calibrated force–deformation study: Chrono. | Same soft-contact and friction formulation as MuJoCo, on GPU. Newton uses [MuJoCo collision detection by default](<https://newton-physics.github.io/newton/1.6.1/solvers/mujoco.html#collision-pipeline>); its alternative detector can change contact geometry. Imported settings and [numerical differences](<https://mujoco.readthedocs.io/en/3.12.0/mjwarp/index.html#differences-from-mujoco>) can change impact forces, so outputs need not match exactly. PhysX provides a separate contact model, demonstrated in [assembly tasks](<https://research.nvidia.com/publication/2022-05_factory-fast-contact-robotic-assembly>). | Lightweight baseline for gripping, sliding and placement. The contact model has adjustable softness and friction. That makes the response tunable; it does not make a computed impact peak a measured force. | Choose [hard contact or a model with stiffness and damping](<https://api.projectchrono.org/10.0.0/collisions.html>). The latter is useful for studying how force rises during contact, provided its parameters and time step are checked against measurements. |
| Outdoor wind and shelter<br>Best long-term: No ready-made winner here. | Same basic wind drag as MuJoCo: Newton exposes [uniform wind, air density and viscosity](<https://newton-physics.github.io/newton/1.6.1/api/_generated/newton.solvers.SolverMuJoCo.html>). MJWarp also supports finer shape-based lift and drag, but Newton’s [importer does not transfer those settings](<https://github.com/newton-physics/newton/blob/v1.6.1/newton/_src/solvers/mujoco/solver_mujoco.py#L6370-L6542>); they need extra integration. Neither predicts building shelter or gusts; supply a site wind model. | [Built-in aerodynamics](<https://mujoco.readthedocs.io/en/4.0.0/computation/fluid.html>) estimates forces from air moving past each body. The standard wind is uniform across the scene. The engine does not calculate the wake behind a building. | Can apply externally calculated wind loads. Its [fluid–structure interface](<https://api.projectchrono.org/10.0.0/manual_fsi.html>) is a specialist option if a moving structure must also change the airflow; an appropriate airflow solver and site model still need to be supplied. |
| Soil and excavation<br>Best: Chrono for forces between ground and vehicles. Isaac MPM is the training candidate once checked against Chrono. | Newton’s implicit Material Point Method (MPM) solver, [SolverImplicitMPM](<https://isaac-sim.github.io/IsaacLab/v3.0.0/source/concepts/using_mpm.html>), models granular and deformable material. Clay needs suitable cohesion and flow parameters. It is separate from MJWarp. MPM and the coupling that makes soil push back on a bucket are experimental. | Weakest ready-made option here for excavation. Native MuJoCo can represent simplified terrain and rigid particles, but lacks the dedicated soil workflows of Chrono or Newton MPM. A realistic soil-and-bucket model would need substantial additional development and validation. | [Deformable terrain models](<https://api.projectchrono.org/10.0.0/vehicle_terrain.html>) suit wheels or tracks. Choose the model for the question: wheel sinkage and a bucket moving soil need different tests. For blades and buckets, its developers suggest [CRM terrain](<https://arxiv.org/abs/2507.05643>), which needs an NVIDIA GPU. |

Version scope: Isaac Lab 3.0 uses Newton 1.6.1, which
[pins MuJoCo and MJWarp to 3.12.x](<https://github.com/newton-physics/newton/blob/v1.6.1/pyproject.toml>). Features of native MuJoCo 4 below are therefore not automatically included. Model
conversion and solver settings also affect equivalence. MuJoCo 4.0 (November 2026) also
[removed the composite element and cable plugin](<https://mujoco.readthedocs.io/en/4.0.0/changelog.html>), so shared models should avoid them.

## Building materials and site assets

An IFC file (Industry Foundation Classes) can tell us what a building part is and where
it belongs. Whether a robot can touch it, deform it or break it depends on the collision
shape and material model that the physics engine actually uses.

| Criterion and recommendation | Isaac Lab and optional RTX | MuJoCo alone or with Unreal | Project Chrono |
| --- | --- | --- | --- |
| Liquids and pouring<br>Best: Chrono for water forces on structures; Isaac for a robot pouring task. | Same basic fluid resistance as MuJoCo, such as drag on a submerged part. Neither tracks a volume of water. The finer shape-based fluid settings need extra integration through Newton, as in the wind row. Isaac’s [pouring examples use Newton’s separate implicit MPM solver](<https://isaac-sim.github.io/IsaacLab/v3.0.0/source/concepts/using_mpm.html>). | [Fluid forces](<https://mujoco.readthedocs.io/en/4.0.0/computation/fluid.html>) estimate how a surrounding fluid acts on a moving body. They do not simulate a stream of water pouring from a bucket. | [Wave tanks and fluid–structure examples](<https://api.projectchrono.org/10.0.0/tutorial_table_of_content_chrono_fsi.html>) model a moving water surface and how water and solid parts push one another. |
| Steel and permanent deformation<br>Best: Chrono for finding where a loaded steel part yields and stays bent. | No automatic equivalence to native MuJoCo 4’s deformables. In Isaac’s MJWarp path, a steel part modelled as rigid cannot bend or stay permanently deformed. Newton’s separate [MPM solver supports elastoplastic materials](<https://newton-physics.github.io/newton/1.6.1/api/_generated/newton.solvers.SolverImplicitMPM.html>); realistic steel still requires a suitable material law and measured parameters. | [MuJoCo 4](<https://mujoco.readthedocs.io/en/4.0.0/changelog.html>) supports permanent deformation in thin shells and 3D solids as well as springs. Check GPU support before porting a model. | [Finite-element material models](<https://api.projectchrono.org/10.0.0/classchrono_1_1fea_1_1_ch_continuum_plastic_von_mises.html>) can represent steel yielding. Supply yield stress and hardening data and check the residual bend after unloading. |
| Concrete and masonry walls<br>No ready-made winner for predicting cracks or crushing. | MJWarp shares the rigid-wall limitation: it detects contact but does not predict cracks or crushing. A damage or fracture model is needed to describe how strength falls as material breaks. This requires a specialist integration; see the concrete note below. | Use rigid wall geometry for robot contact. Permanent deformation of a solid does not itself model a crack, crushed concrete or a failed mortar joint. | Closest research option: a [fracture solver](<https://api.projectchrono.org/10.0.0/group__chrono__peridynamics.html>) exists. Reinforcement, joints, supports and measured material behaviour still have to be modelled. |
| Building information modelling (BIM)<br>Best direct IFC import: Unreal. Isaac can retain part data as well. | With metadata enabled, the [Omniverse IFC converter](<https://docs.omniverse.nvidia.com/kit/docs/omni.kit.converter.hoops_core/latest/CHANGELOG.html>) writes part data and building relationships into USD scene files. A [Revit exporter](<https://docs.omniverse.nvidia.com/connect/latest/revit.html>) also carries BIM fields. | In [MuJoCo alone](<https://mujoco.readthedocs.io/en/4.0.0/modeling.html>), convert geometry and keep a part-ID map. With Unreal, [Datasmith](<https://dev.epicgames.com/documentation/en-us/unreal-engine/importing-ifc-files-into-unreal-engine-using-datasmith>) keeps parts, storeys and properties. Values become [text](<https://dev.epicgames.com/documentation/en-us/unreal-engine/using-datasmith-metadata-in-unreal-engine>); property-set names are lost. | The [STEP route](<https://api.projectchrono.org/tutorial_pychrono_demo_cascade_step.html>) imports engineering geometry. Keep IFC identifiers and property sets separately and link them to the simulation parts. |
| Survey scans and collision geometry<br>Best for viewing scans: Unreal. None guarantees contact-ready parts. | Use the scan for appearance, including the lighting it captured. Choose and inspect [collision shapes](<https://docs.isaacsim.omniverse.nvidia.com/6.2.0/physics/simulation_fundamentals.html>): a simple outer hull can close a guide slot that looks open in the image. On the MJWarp path, [MuJoCo’s compiler turns non-convex meshes into convex hulls](<https://newton-physics.github.io/newton/1.6.1/solvers/mujoco.html>). | Unreal imports [LAS, LAZ or E57 scans](<https://dev.epicgames.com/documentation/en-us/unreal-engine/lidar-point-cloud-plugin-overview-in-unreal-engine>); creating [collision geometry](<https://dev.epicgames.com/documentation/en-us/unreal-engine/lidar-point-cloud-plugin-quick-start-guide-in-unreal-engine>) is a separate step. Native MuJoCo needs its own checked shapes. | Chrono can build [rigid terrain from surveyed ground heights](<https://api.projectchrono.org/classchrono_1_1vehicle_1_1_rigid_terrain.html>). Walls, overhangs and moving parts need separate geometry. Check dimensions against the survey before using it for contact. |

Concrete damage: for example, OpenSees
[ASDConcrete3D](<https://opensees.github.io/OpenSeesDocumentation/user/manual/material/ndMaterials/ASDConcrete3D.html>)
models cracking-related damage and permanent deformation. Fit stiffness, tensile and
compressive response, and fracture energy to measurements. For masonry, also model
[mortar-joint opening and slip](<https://www.oofem.org/resources/doc/matlibmanual/html/pages/plasticity-based-material-models.html>). This is a possible specialist integration, not an existing Isaac feature.

## Site images and robot training

Reality capture uses photos, video or laser scans to model real equipment and sites.
Point clouds record measured points; meshes connect them into surfaces.
[Gaussian splats](<https://repo-sam.inria.fr/fungraph/3d-gaussian-splatting/>) show an
object or site from new viewpoints, even when made from synthetic images. Appearance
alone cannot establish collision shapes or friction. Splats are useful for camera-based
navigation and training, but
[captured lighting limits relighting](<https://docs.omniverse.nvidia.com/materials-and-rendering/latest/particle-fields.html>). Depth and labels depend on the workflow: Isaac’s
[NuRec replay in MobilityGen](<https://docs.isaacsim.omniverse.nvidia.com/6.2.0/synthetic_data_generation/tutorial_replicator_mobility_gen.html#use-nurec-assets-in-mobilitygen>)
currently outputs RGB only.

| Criterion and recommendation | Isaac Lab and optional RTX | MuJoCo alone or with Unreal | Project Chrono |
| --- | --- | --- | --- |
| Photorealism for a designed site<br>Best: Unreal for editable sites; Isaac RTX for photorealistic robot training. | RTX renders photorealistic views from robot cameras. Labelled 3D models also give [depth and object identities](<https://docs.isaacsim.omniverse.nvidia.com/6.2.0/sensors/isaacsim_sensors_camera.html>) without hand-labelling. A designed site cannot be filmed, so [splats](<https://docs.omniverse.nvidia.com/materials-and-rendering/latest/particle-fields.html>) can only add its real surroundings. | The classic MuJoCo viewer is simplified. [Filament](<https://mujoco.readthedocs.io/en/4.0.0/programming/rendering.html>) gives more realistic materials. Add Unreal for [lighting across a large site](<https://dev.epicgames.com/documentation/en-us/unreal-engine/lumen-global-illumination-and-reflections-in-unreal-engine>) and [high-quality images](<https://dev.epicgames.com/documentation/en-us/unreal-engine/path-tracer-in-unreal-engine>). | Live viewers give engineering previews. [Chrono Sensor](<https://api.projectchrono.org/camera_sensor.html>) ray-traces camera images. Use [Blender Cycles](<https://api.projectchrono.org/introduction_chrono_blender.html>) for photorealistic films after a run. |
| Reality capture of equipment and sites<br>Best for survey models: Unreal with RealityScan. For robot cameras in a captured site: Isaac. | [Object reconstruction](<https://docs.isaacsim.omniverse.nvidia.com/6.2.0/assets/usd_assets_real_to_sim_index.html>) turns stereo video of a component into a textured mesh. [NuRec and RTX](<https://docs.isaacsim.omniverse.nvidia.com/6.2.0/assets/usd_assets_nurec.html>) can show a captured site alongside a simulated robot. Add and check collision surfaces for interaction. | [RealityScan](<https://www.realityscan.com/>) builds models from images and laser scans for Unreal. Epic’s 5.9 roadmap lists [experimental splat import](<https://forums.unrealengine.com/t/gaussian-splats-experimental/2852858>). The MJWarp renderer also draws splats with robots; its splat colours do not vary with viewpoint. | Use a measured mesh for a structure or a [survey of heights](<https://api.projectchrono.org/classchrono_1_1vehicle_1_1_rigid_terrain.html>) for the ground. The documented [sensor renderer](<https://api.projectchrono.org/sensor_overview.html>) uses surfaces; plan on a separate renderer for Gaussian splats. |
| Free scenes and equipment<br>Best: Isaac for robots; Unreal for ready-made visual scenery. | The [robot catalogue](<https://docs.isaacsim.omniverse.nvidia.com/6.2.0/assets/usd_assets_robots.html>) and [example sites](<https://docs.isaacsim.omniverse.nvidia.com/6.2.0/assets/usd_assets_environments.html>) give sensors and robots something to interact with quickly. Check individual asset licences. | MuJoCo Menagerie supplies robots. Unreal adds [free scenery](<https://dev.epicgames.com/documentation/unreal-engine/free-epic-games-content-for-unreal-engine?lang=en-US>). A free download may not be republished on its own under the [Fab Standard licence](<https://www.fab.com/eula>). | [Vehicle examples](<https://api.projectchrono.org/10.0.0/tutorial_table_of_content_chrono_vehicle.html>) suit site vehicles but include no excavator. More work is needed to dress a whole scene. |
| Cameras and robot perception<br>Best: Isaac for images, depth, object labels and laser scans. | [RTX cameras](<https://isaac-sim.github.io/IsaacLab/v3.0.0/source/concepts/renderers.html>) read the scene directly. [Ray-cast LiDAR](<https://isaac-sim.github.io/IsaacLab/v3.0.0/source/concepts/sensors/ray_caster.html>) runs kit-less; full Isaac Sim adds [RTX LiDAR](<https://docs.isaacsim.omniverse.nvidia.com/6.2.0/sensors/isaacsim_sensors_rtx_lidar.html>) and a wider [sensor library](<https://docs.isaacsim.omniverse.nvidia.com/6.2.0/assets/usd_assets_sensors.html>). | Native cameras support images, depth and labels. Unreal cameras need the additional [integration](<https://github.com/URLab-Sim/UnrealRoboticsLab>). | [Cameras and LiDAR](<https://api.projectchrono.org/10.0.0/sensor_overview.html>) are available. Their detailed simulation requires compatible NVIDIA hardware. |
| Dust and visibility<br>Best: Unreal for visible dust. No verified winner for laser returns in dust. | [Volume effects](<https://docs.omniverse.nvidia.com/kit/docs/flow/latest/overview.html>) can obscure a view. A darkened image does not tell us the dust concentration or what a laser receives. | Unreal’s [Niagara effects](<https://dev.epicgames.com/documentation/unreal-engine/quick-start-for-niagara-effects-in-unreal-engine?lang=en-US>) can draw plumes. Check simulated sensor readings against [laser measurements in dust](<https://www.vinnova.se/en/p/model-of-lidar-perception-disturbance-by-a-cloud-of-dust/>). | Ground models do not automatically predict an airborne dust cloud. A dust transport and sensor model is a separate task. |
| Reinforcement learning<br>Best: Isaac for training many robots in parallel, with or without cameras. | [Robot tasks and training libraries](<https://isaac-sim.github.io/IsaacLab/v3.0.0/source/concepts/reinforcement_learning.html>) work together. Turn cameras off for motion-only experiments. Measure speed and GPU memory again when adding images. | [MuJoCo Playground](<https://playground.mujoco.org/>) supports learning from state or images in many environments. A good choice for a MuJoCo-only workflow. | [Training examples](<https://github.com/projectchrono/gym-chrono>) exist; the group would assemble more of the experiment and data-recording tools. |
| Connecting to real robot software<br>Best: Isaac Sim for its maintained ROS 2 sensor and robot connection. | Full Isaac Sim supplies the [ROS 2 bridge](<https://docs.isaacsim.omniverse.nvidia.com/6.2.0/installation/install_ros.html>). Enable it when we need to exchange robot commands, camera images or sensor readings. | An external [MuJoCo ROS 2 control package](<https://control.ros.org/rolling/doc/mujoco_ros2_control/doc/index.html>) exists. It supports ROS 2 Humble, Jazzy and Kilted. | [Chrono ROS](<https://api.projectchrono.org/10.0.0/module_ros_installation.html>) supports ROS 2. We select the required messages and build the additional module. |

## Sharing and maintaining our simulator

Our public release can contain our own code, site and robot models, and instructions.
Whether anyone pays for an engine depends on which software they use, what they do with
it, and what we give them.

| Criterion and recommendation | Isaac Lab and optional RTX | MuJoCo alone or with Unreal | Project Chrono |
| --- | --- | --- | --- |
| Price and sharing<br>Lowest barriers: native MuJoCo and Chrono. Neither charges an engine fee. | Our lab can run full Isaac Sim internally for free. For public releases, share our own code and models; let users install NVIDIA software themselves. See [NVIDIA’s examples](<https://docs.isaacsim.omniverse.nvidia.com/6.2.0/common/license-faq.html>) below. Standalone RTX has separate terms. | MuJoCo alone: free for universities, individuals and companies, including commercial use. If we pass it on, keep the [licence and required notices](<https://www.apache.org/licenses/LICENSE-2.0>). Adding Unreal brings its own rules; see below. | The [Chrono core](<https://projectchrono.org/about/>) is free for academic and commercial use. Keep its licence and notices when redistributing it. Third-party components and assets may have separate terms. |
| Hardware and operating systems<br>Best: native MuJoCo for contributors with a CPU laptop. | [Newton GPU training](<https://docs.nvidia.com/isaaclab/3.0/isaac-lab/installation>) needs an NVIDIA GPU from Turing onwards, with or without RT cores. [Full Isaac Sim 6.2](<https://docs.isaacsim.omniverse.nvidia.com/6.2.0/installation/requirements.html>) lists RTX 4080, 16 GB VRAM, 32 GB RAM; Ubuntu 22.04 (deprecated)/24.04 or Windows 11. | [Core physics](<https://github.com/google-deepmind/mujoco>) runs on Linux, macOS and Windows without a dedicated GPU. [MJWarp](<https://github.com/google-deepmind/mujoco_warp>) uses NVIDIA GPUs; adding Unreal increases requirements. | [Core simulation](<https://api.projectchrono.org/10.0.0/tutorial_install_chrono.html>) runs on CPUs. [Ray-traced sensors](<https://api.projectchrono.org/10.0.0/module_sensor_installation.html>) need a compatible NVIDIA GPU and driver. CRM soil ([FSI-SPH](<https://api.projectchrono.org/10.0.0/module_fsi_installation.html>)) also needs one. |
| Maintenance and investment<br>Best documented breadth: Isaac and Newton, with several major contributors. | Newton has [Linux Foundation stewardship](<https://www.linuxfoundation.org/press/linux-foundation-announces-contribution-of-newton-by-disney-research-google-deepmind-and-nvidia-to-accelerate-open-robot-learning>) and contributions from NVIDIA, Google DeepMind and Disney Research. Use versions supported by [Isaac Lab](<https://github.com/isaac-sim/IsaacLab/releases/tag/v3.0.0>). | Google DeepMind maintains [native MuJoCo](<https://github.com/google-deepmind/mujoco/releases/tag/4.0.1>). The separately maintained Unreal plugin can lag behind either engine. URLab supports only Unreal 5.7. | An active [research project](<https://projectchrono.org/news/>) with [published funding](<https://projectchrono.org/about/>). Its specialist modules vary in maturity. |

## Who pays in practice

Running Isaac ourselves: no enterprise licence is needed for research and development.
[Omniverse Kit](<https://docs.omniverse.nvidia.com/kit/docs/kit-manual/latest/guide/kit_overview.html>)
is the NVIDIA software that runs the full Isaac Sim application; the
[kit-less setup](<https://isaac-sim.github.io/IsaacLab/v3.0.0/source/concepts/renderers.html>)
does not use it.

Sharing with other labs, including sensor tasks: publish our code, models and install
instructions; each lab installs Isaac Sim from NVIDIA and runs it itself, which needs no
enterprise licence (see
[NVIDIA’s examples](<https://docs.isaacsim.omniverse.nvidia.com/6.2.0/common/license-faq.html>)
). A Dockerfile that each lab builds from NVIDIA’s Isaac Sim image follows the same
pattern as
[Isaac Lab’s own container](<https://docs.nvidia.com/isaaclab/3.0/isaac-lab/installation>). Giving outsiders a ready-built image that contains Isaac Sim with Kit, or hosting it
for them, needs NVIDIA AI Enterprise; the FAQ makes no exception for free access. A
kit-less image contains no Kit, but check OVRTX’s licence before including it.

If we add Unreal later: no developer seat fee for education,
[solely non-commercial use](<https://www.unrealengine.com/eula/unreal>), or
organisations whose group had under US$1 million revenue in the past 12 months ([Epic
counts advances and funds raised](<https://www.unrealengine.com/eula/unreal>));
otherwise [US$1,850 per developer per year](<https://www.unrealengine.com/license>).
People who only run a packaged app need no seat, but university work for a commercial
client is not automatically exempt. Products sold generally pay royalties instead:
[5% of revenue above US$1 million over the product’s lifetime](<https://www.unrealengine.com/license>), so a free simulator owes none. Epic’s
[EULA update of 29 October 2026](<https://www.unrealengine.com/ue-devs-can-now-choose-to-train-ai-models-on-their-projects>)
allows AI training on our projects once we accept it; Fab items tagged NoAI stay
restricted.
