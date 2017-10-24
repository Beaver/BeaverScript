#!/usr/bin/swift -FRome

import Commander
import BeaverCodeGen

Group {
    $0.command("project",
        Argument<String>("path", description: "Path to generated project"),
        Argument<String>("name", description: "Your module name"),
        Argument<String>("module_names", description: "List of module names")
    ) { path, name, moduleNamesString in
        let moduleNames = moduleNamesString
            .split(separator: ",")
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }
        
        let fileHandler = FileHandler(basePath: path)
        let generator = ProjectGenetator(name: name,
                                         moduleNames: moduleNames)

        generator.generate(in: fileHandler)
    }
    $0.command("module",
        Argument<String>("path", description: "Path to generated project"),
        Argument<String>("project_name", description: "Your project name"),
        Argument<String>("module_name", description: "Your module name")
    ) { path, projectName, moduleName in
        let fileHandler = FileHandler(basePath: path)
        let generator = ProjectGenetator(name: projectName,
                                         moduleNames: [])
        _ = generator.byInserting(module: moduleName, in: fileHandler)
    }
}.run()

