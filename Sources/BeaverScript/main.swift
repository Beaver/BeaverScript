#!/usr/bin/swift -FRome

import Foundation
import Commander
import BeaverCodeGen

Group {
    $0.command("project",
               Option<String>("path", default: "", description: "Path to generated project"),
               Argument<String>("project_name", description: "Your project name"),
               Argument<String>("module_names", description: "List of module names")
    ) { path, projectName, moduleNamesString in
        let moduleNames = moduleNamesString
            .split(separator: ",")
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }
        
        let fileHandler = FileHandler(basePath: path.isEmpty ? projectName : path)
        let generator = ProjectGenetator(name: projectName,
                                         moduleNames: moduleNames)

        generator.generate(in: fileHandler)
    }
    $0.command("module",
               Option<String>("path", default: "", description: "Path to generated project"),
               Argument<String>("project_name", description: "Your project name"),
               Argument<String>("module_name", description: "Your module name")
    ) { path, projectName, moduleName in
        let fileHandler = FileHandler(basePath: path.isEmpty ? projectName : path)
        let generator = ProjectGenetator(name: projectName,
                                         moduleNames: [])
        _ = generator.byInserting(module: moduleName, in: fileHandler)
    }
    $0.command("action",
               Option<String>("path", default: "", description: "Path to generated project"),
               Argument<String>("project_name", description: "Your project name"),
               Argument<String>("module_name", description: "Your module name"),
               Argument<String>("action_name", description: "Your action name"),
               Argument<String>("action_type", description: "Your action type: [ui|routing]")
    ) { path, projectName, moduleName, actionName, actionType in
        let fileHandler = FileHandler(basePath: path.isEmpty ? projectName : path)
        let generator = ProjectGenetator(name: projectName,
                                         moduleNames: [])
        _ = generator.byInserting(action: actionType == "ui" ? .ui(EnumCase(name: actionName)) : .routing(EnumCase(name: actionName)),
                                  toModule: moduleName,
                                  in: fileHandler)
    }
}.run()

