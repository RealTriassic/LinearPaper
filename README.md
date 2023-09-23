# LinearPurpur
A fork of [Purpur](https://github.com/PurpurMC/Purpur) that adds support for the [Linear region file format](https://github.com/xymb-endcrystalme/LinearRegionFileFormatTools).

> ⚠️ **99% of plugins should be functional, except plugins that need to directly access the `.mca` files.**

# Configuration
All configuration regarding LinearPurpur is stored in Purpur's `purpur.yml` file, you may need to manually add in these configuration options
if you are replacing Purpur with LinearPurpur or delete the `purpur.yml` file to allow it to re-generate.

### Global Configuration
```yml
region-format:
  linear:
    flush-frequency: 10
    flush-max-threads: 1
```

### Per-world Configuration
```yml
region-format:
  format: ANVIL # Change this to "LINEAR" to use Linear region file format.
  linear:
    compression-level: 1
    crash-on-broken-symlink: true
```

# Compiling
1. #### Clone LinearPurpur
```sh
git clone https://github.com/StupidCraft/LinearPurpur.git
```
2. #### Apply Patches
```sh
./gradlew applyPatches
```
3. #### Create Paperclip Jar
```sh
./gradlew createReobfPaperclipJar
```

You will find a compiled Paperclip Jar file in `build/libs/`.

# Credits
- [**Xymb**](https://github.com/xymb-endcrystalme) - Created the Linear region file format!
- [**Kaiiju**](https://github.com/KaiijuMC/Kaiiju) - Linear-related patches have been borrowed from this repository.
