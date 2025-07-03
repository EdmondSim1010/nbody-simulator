# MATLAB N-Body Simulator

<p align="center">
  <img src="https://img.shields.io/badge/MATLAB-R2022b%2B-blue.svg" alt="MATLAB Version">
  <img src="https://img.shields.io/badge/license-MIT-green.svg" alt="License">
  <img src="https://img.shields.io/badge/status-active-brightgreen.svg" alt="Project Status">
</p>

A vectorized N-body gravitational simulator implemented in MATLAB. This project models the evolution of a system of celestial bodies under mutual gravitational attraction using various numerical integration schemes. It is designed with scientific accuracy and performance in mind.

---

## Table of Contents

- [Overview](#overview)  
- [Key Features](#key-features)  
- [Demonstration](#demonstration)  
- [Technical Deep Dive](#technical-deep-dive)  
- [Setup](#setup)   
- [License](#license)  
- [Contact](#contact)  

---

## Overview

The N-body problem is a classical challenge in physics and computational science: predicting the individual motions of a group of celestial objects that interact gravitationally. This simulator provides a framework to solve this problem for any set of initial conditions (masses, positions, velocities).

The primary goal of this project is to leverage MATLAB's powerful matrix manipulation capabilities to create an efficient, vectorized solution that avoids nested loops—achieving significant performance gains.

---

## Key Features

- **Multiple Numerical Integrators**  
  - **Euler Method**: A simple, first-order integrator for baseline comparison.  
  - **Velocity Verlet (Leapfrog)**: A second-order, symplectic integrator ideal for conserving energy over long simulations.  
  - **Runge-Kutta 4th Order (RK4)**: A high-accuracy method suited for precision-critical applications.

- **Vectorized Computation**  
  Fully vectorized gravitational force calculation eliminates nested loops and uses optimized MATLAB matrix operations, achieving \( \mathcal{O}(N^2) \) complexity per timestep.

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
  <!-- Insert your simulation GIF or image here -->
  <!-- Example: <img src="assets/solar_system.gif" width="600" alt="Solar System Simulation"> -->
</p>

The image above shows a stable solar-system-like configuration simulated with the Velocity Verlet integrator.

---

## Technical Deep Dive

### Main Equations

This simulation uses Newton’s Law of Universal Gravitation:

\[
\vec{F}_{ij} = G \frac{m_i m_j}{|\vec{r}_{ij}|^3} \vec{r}_{ij}, \quad \vec{r}_{ij} = \vec{r}_j - \vec{r}_i
\]

The total force on body \( i \) is:

\[
\vec{F}_i = \sum_{j \neq i} \vec{F}_{ij}
\]

And acceleration is computed via:

\[
\vec{a}_i = \frac{\vec{F}_i}{m_i}
\]

---

### Numerical Integration

#### Velocity Verlet (Leapfrog)

This symplectic method conserves energy well over time. The update steps are:

1. \( \mathbf{v}(t + \frac{\Delta t}{2}) = \mathbf{v}(t) + \mathbf{a}(t) \cdot \frac{\Delta t}{2} \)  
2. \( \mathbf{r}(t + \Delta t) = \mathbf{r}(t) + \mathbf{v}(t + \frac{\Delta t}{2}) \cdot \Delta t \)  
3. \( \mathbf{a}(t + \Delta t) = \frac{\mathbf{F}(\mathbf{r}(t + \Delta t))}{m} \)  
4. \( \mathbf{v}(t + \Delta t) = \mathbf{v}(t + \frac{\Delta t}{2}) + \mathbf{a}(t + \Delta t) \cdot \frac{\Delta t}{2} \)

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
end

## License

This project is licensed under the MIT License.

## Contact

[Your Name] - [your-email@example.com]

Project Link: `https://github.com/[your-username]/[your-repo-name]`