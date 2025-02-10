---
title: Poetry
date: 2024-11-22T09:10:55+08:00
authors:
  - name: wylu
    link: https://github.com/wylu1037
    image: https://github.com/wylu1037.png?size=40
weight: 1
---

{{< button/docs text="Python packaging and dependency management made easy" link="https://python-poetry.org/" >}}

## Basic usage

### Dependency management
+ `poetry new my_project`: Create a new project.
+ `poetry add package_name`: Add a package to the project.
+ `poetry remove package_name`: Remove a package from the project.
+ `poetry update package_name`: Update a package in the project.
+ `poetry show`: Show the list of installed packages.

### Virtual Environment
> By default, Poetry creates a virtual environment in {cache-dir}/virtualenvs. You can change the cache-dir value by editing the Poetry configuration. Additionally, you can use the virtualenvs.in-project configuration variable to create virtual environments within your project directory.
+ `poetry run`: Run a command in the virtual environment.
+ `poetry shell`: Start a shell in the virtual environment.
+ `poetry env list`: List the virtual environments.