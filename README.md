# LinearPaper

A fork of [Paper](https://github.com/PaperMC/Purpur) which adds support for the **experimental** [Linear region file format](https://github.com/xymb-endcrystalme/LinearRegionFileFormatTools) to the dedicated server.

> [!CAUTION]
Starting with Minecraft 1.20.6, we are based on Paper, instead of Purpur. All Linear configuration options
have been migrated to `config/linear.yml`, the format is pretty much almost the same as before. **You need to manually update your configuration**.

## Configuration
All configuration regarding anything Linear-related is stored in `config/linear.yml`. You must restart your server for any edits to be applied, **reloading is not supported and may even break your server**.

### Global Configuration
```yml
linear:
  flush-frequency: 10
  flush-max-threads: 1
```

### Per-world Configuration
```yml
format: ANVIL # Change this to "LINEAR" to use the Linear region format.
  linear:
    compression-level: 1
```

## Plugin compatibility
> [!IMPORTANT]
Generally, all plugins that run on Paper should run on LinearPaper exactly the same, but if the plugin needs to access the region files
directly by reading the `.mca` region files, it isn't going to be able to do so and may cause errors and unexpected behaviour.
Plugin developers need to manually update their plugins to support Linear.

## Compiling
1. #### Clone LinearPaper
```sh
git clone https://github.com/StupidCraft/LinearPaper.git
```
2. #### Change directory to LinearPaper
```sh
cd LinearPaper
```
4. #### Apply Patches
```sh
./gradlew applyPatches
```
4. #### Create Paperclip Jar
```sh
./gradlew createReobfPaperclipJar
```

You will find a compiled Paperclip Jar file in `build/libs/`.

## Credits
- [**Xymb**](https://github.com/xymb-endcrystalme) - Created the Linear region file format.
- [**Kaiiju**](https://github.com/KaiijuMC/Kaiiju) - Linear-related patches have been borrowed from this repository.
