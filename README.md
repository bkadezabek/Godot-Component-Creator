# Godot Component Creator plugin
A simple plugin for Godot 4.x.x that allows you to create components from one project and then reuse them in other projects without the hassle of copy and pasting... 

For instance, this plugin will be great for reusing components like HealthComponents or Hit and Hurt boxes that are basically more or less the same across all projects, or for instance re-using Autoload Singletons and assets and stuff...

Icon attribution: <a href="https://www.flaticon.com/free-icon/rotation_2161786" title="round arrow icons">Round arrow icons created by Freepik - Flaticon</a>

NOTE: Issues and Pull Requests are always welcome :)

## How to use the plugin
To use the plugin, either download it from the Godot Asset Library: (HREF). Or clone it from GitHub manually. Make sure to enable it under plugins in project (Project Settings > Plugins)!

The plugin also has additional settings in the Editor Settings under (Project Settings > Plugins > Component Creator) that make it persistent across all projects. Meaning, you only have to configure it once and it will stay consistent across all projects. You will however have to redownload the plugin every new project, but that is a minor inconvenience.

To use the plugin, you can find it at the top bar under the name Component Creator. You can set the path to the library component folder ("Set components directory" button on the bottom left) that will contain copies of all of your components that you will use for the forseable future. It is RECOMMENDED that the folder is outside any Godot project, to not mess anything up. You can always manually set the path from the Editor Settings.

Once you create and add the folder as a path. You will be able to generate components. To generate a component, the components should always be inside a folder of a telling name, cause the name that the component will get is the name of the folder that it is contained within. Meaning, you cannot mix and match what files get to what component from paths that differ beyond the root of the component. So make sure that the component is contained within that folder and that it works by itself or in tandem with other components, for instance hit and hurt boxes. To generate it pick a folder that is one INDIVIDUAL component and hit Create.

Now you can import that component across all your project by hitting the import button after electing the component from the GridContainer within the Component Creator viewport window.

If for what ever reason some part of the plugin does not autorefresh go to (Project Settings > Plugins) and disable and then re-enable the Godot Component Creator plugin.

Have fun coding games :)
