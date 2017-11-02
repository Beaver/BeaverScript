#!/usr/bin/swift -FRome

import Commander
import BeaverCodeGen

func absolutePath(with path: String) -> String {
    guard let basePath = ProcessInfo.processInfo.environment["BASE_DIR"] else {
        fatalError("Could not find env variable 'BASE_DIR'")
    }
    return basePath + "/" + path.replacingOccurrences(of: basePath, with: "")
}

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
        
        let fileHandler = FileHandler(basePath: absolutePath(with: path))
        let generator = ProjectGenetator(name: name,
                                         moduleNames: moduleNames)

        generator.generate(in: fileHandler)
    }
    $0.command("module",
        Argument<String>("path", description: "Path to generated project"),
        Argument<String>("project_name", description: "Your project name"),
        Argument<String>("module_name", description: "Your module name")
    ) { path, projectName, moduleName in
        let fileHandler = FileHandler(basePath: absolutePath(with: path))
        let generator = ProjectGenetator(name: projectName,
                                         moduleNames: [])
        _ = generator.byInserting(module: moduleName, in: fileHandler)
    }
    $0.command("action",
       Argument<String>("path", description: "Path to generated project"),
       Argument<String>("project_name", description: "Your project name"),
       Argument<String>("module_name", description: "Your module name"),
       Argument<String>("action_name", description: "Your action name"),
       Argument<String>("action_type", description: "Your action type: [ui|routing]")
    ) { path, projectName, moduleName, actionName, actionType in
        let fileHandler = FileHandler(basePath: absolutePath(with: path))
        let generator = ProjectGenetator(name: projectName,
                                         moduleNames: [])
        _ = generator.byInserting(action: actionType == "ui" ? .ui(EnumCase(name: actionName)) : .routing(EnumCase(name: actionName)),
                                  toModule: moduleName,
                                  in: fileHandler)
    }
}.run()

