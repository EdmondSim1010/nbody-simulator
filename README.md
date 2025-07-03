# MATLAB N-Body Simulator

<p align="center">
  <img src="https://img.shields.io/badge/MATLAB-R2022b%2B-blue.svg" alt="MATLAB Version">
  <img src="https://img.shields.io/badge/license-MIT-green.svg" alt="License">
  <img src="https://img.shields.io/badge/status-active-brightgreen.svg" alt="Project Status">
</p>

A vectorised N-body gravitational simulator made in MATLAB. This project models the evolution of a system of celestial bodies under mutual gravitational attraction using numerical integration schemes.

---

## Table of Contents

- [Overview](#overview)  
- [Key Features](#key-features)  
- [Demonstration](#demonstration)  
- [Underlying Physics](#underlying-physics)  
- [Setup](#setup)   
- [License](#license)  
- [Contact](#contact)  

---

## Overview

The N-body problem is a classical challenge in physics and computational science: predicting the individual motions of a group of celestial objects that interact gravitationally. This simulator provides a framework to solve this problem for any set of initial conditions (masses, positions, velocities).

The primary goal of this project is to leverage MATLAB's powerful matrix manipulation capabilities to create an efficient, vectorised solution that avoids nested loops, thus achieving significant performance gains.

---

## Key Features

- **Multiple Numerical Integrators**  
  - **Euler Method**: A simple, first-order integrator for baseline comparison.  
  - **Velocity Verlet (Leapfrog)**: A second-order, symplectic integrator ideal for conserving energy over long simulations.  
  - **Runge-Kutta 4th Order (RK4)**: A high-accuracy method suited for precision-critical applications.

- **Vectorized Computation**  
  Fully vectorized gravitational force calculation eliminates nested loops and uses optimized MATLAB matrix operations, achieving O(N^2) complexity per timestep.

- **Object-Oriented Design**  
  Implemented using MATLAB classes (`NBodySystem`, `Body`) for modularity, extensibility, and readability.

- **Configurable Scenarios**  
  Create and simulate custom scenarios such as binary star systems, planetary systems, or randomized galaxies.

- **Visualization & Logging**  
  - Real-time 2D trajectory plotting.  
  - Optional logging of energy, momentum, and positions for post-analysis.

---

## Demonstration

<p align="center">

<img width="436" alt="Screenshot 2025-07-04 at 9 33 20 am" src="https://github.com/user-attachments/assets/8cf45504-f947-41d0-8612-aab64ea6bc57" />
  
</p>

The image above shows a stable solar-system-like configuration simulated with the Velocity Verlet integrator.


<img width="538" alt="Screenshot 2025-07-04 at 9 32 43 am" src="https://github.com/user-attachments/assets/823bf6b2-d8f4-4751-b368-89a73c13f228" />

The image above shows a chaotic three-body configuration simulated with the 4th order Runge–Kutta (RK4) method

---

## Underlying Physics

### Main Equations

This simulation uses Newton’s Law of Universal Gravitation:

<img width="508" alt="Screenshot 2025-07-04 at 8 33 32 am" src="https://github.com/user-attachments/assets/68d2157a-ef68-4cac-8bab-14fd08d0d609" />


The total force on body \( i \) is:

<img width="235" alt="Screenshot 2025-07-04 at 8 33 45 am" src="https://github.com/user-attachments/assets/2a0f21fe-df0b-4a06-bf63-67062432fa16" />


And acceleration is computed via:

<img width="201" alt="Screenshot 2025-07-04 at 8 33 58 am" src="https://github.com/user-attachments/assets/5b5d1e57-0245-4e66-92ea-fb2af6fe2e5c" />

---

### Numerical Integration

#### Velocity Verlet (Leapfrog)

This symplectic method conserves energy well over time. The update steps are:

<img width="503" alt="Screenshot 2025-07-04 at 8 35 59 am" src="https://github.com/user-attachments/assets/899b7720-18f4-485b-a2cd-b32f918373cf" />


#### Runge-Kutta 4th Order (RK4)

A high-accuracy integrator that evaluates derivatives four times per timestep. Ideal for simulations requiring tight error bounds.

---

## Setup

### Prerequisites

- MATLAB R2021b or newer  
- No additional toolboxes required

### Installation & Usage

**In terminal:**  
git clone https://github.com/[your-username]/[your-repo-name].git  
cd [your-repo-name]

**In MATLAB:**  
% Run the main simulation script  
main

---

### Creating a Custom Scenario

Add a new function in the `+scenarios/` directory. Each scenario returns a struct containing the gravitational constant `G` and a cell array of `Body` objects.

**Example:** `+scenarios/binary_star.m`

```matlab
function config = binary_star()
    config.G = 6.674e-11;

    star1 = Body('Mass', 1.989e30, ...
                 'Position', [1e11, 0], ...
                 'Velocity', [0, 15e3]);

    star2 = Body('Mass', 1.989e30, ...
                 'Position', [-1e11, 0], ...
                 'Velocity', [0, -15e3]);

    config.bodies = {star1, star2};
```
---

## License

This project is licensed under the MIT License.

## Contact

Edmond Sim - edmond.sim1010@gmail.com

Project Link: `https://github.com/EdmondSim1010/nbody-simulator`
