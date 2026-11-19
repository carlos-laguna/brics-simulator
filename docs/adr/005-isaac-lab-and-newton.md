# 005: Build the first tasks with Isaac Lab and Newton

**Accepted on 19/11/2026.**

Build the first BRICS task in Isaac Lab 3.0 with Newton physics, using the kit-less
installation. Isaac Lab brings robot control, sensors and parallel training into the
same task environment. Newton supplies dynamics. Start with a headless free-fall check,
then model a suspended rigid load and test its motion against the reference cases.

Use kit-less cameras, ray-cast LiDAR, contact sensors or IMUs where they meet the task
requirements. Add full Isaac Sim 6.2 for tasks that need material-dependent RTX LiDAR,
radar or the ROS 2 bridge. Label those tasks and record their hardware and software
requirements. Contributors install NVIDIA software separately.

Keep BRICS scenarios, commands, observations and metrics independent of engine objects.
Record the solver, time step, asset versions and approximations for each run. Newton’s
MJWarp solver supports simple tension-only slings. Test slack and taut behaviour before
using it for placement. Cable contact and experimental soil models need separate
validation.

GPU access is a cost of this choice. Revisit native MuJoCo for CPU access or an
independent cross-check, and Chrono for specialist mechanics. Consider Blender and
Bonsai when importing IFC, Unreal when a task needs its scenery, and captured sites when
a camera task warrants them.

The [platform decision brief](platform-decision-brief.md) compares alternatives and
records the licensing and hardware constraints. This decision replaces the
[MuJoCo proposal](001-mujoco-and-bounded-backend-portability.md) and the
[Unreal integration proposal](003-optional-rendering-and-middleware.md).
