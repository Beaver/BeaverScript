import Foundation
import Commander
import BeaverCodeGen

struct ArgumentInputs {
    private var projectPath: String?
    private var projectName: String?
    private var moduleNamesString: String?
    private var moduleName: String?
    
    init(projectPath: String = "",
         projectName: String = "",
         moduleNamesString: String = "",
         moduleName: String = "") {
        self.projectPath = projectPath.isEmpty ? nil : projectPath
        self.projectName = projectName.isEmpty ? nil : projectName
        self.moduleNamesString = moduleNamesString.isEmpty ? nil : moduleNamesString
        self.moduleName = moduleName.isEmpty ? nil : moduleName
    }
    
    mutating func getProjectPath() -> String {
        guard let projectPath = projectPath else {
            let defaultValue = "."
            print("Project path? [default: '\(defaultValue)']")
            guard let response = input()?
                .trimmingCharacters(in: .illegalCharacters)
                .trimmingCharacters(in: .whitespaces) else {
                self.projectPath = defaultValue
                return defaultValue
            }
            self.projectPath = response
            return response
        }
        return projectPath
    }
    
    mutating func getProjectName() -> String {
        guard let projectName = projectName else {
            let defaultValue = "NewProject"
            print("Project name? [default: \(defaultValue)]")
            guard let response = input()?
                .trimmingCharacters(in: .illegalCharacters)
                .trimmingCharacters(in: .whitespaces) else {
                self.projectName = defaultValue
                return defaultValue
            }
            self.projectName = response
            return response
        }
        return projectName
    }
    
    mutating func getModuleNames() -> [String] {
        guard let moduleNames = moduleNamesString.flatMap({ self.moduleNames(from: $0) }) else {
            let defaultValue = "Home"
            print("Project modules' names? (Answer example: Module1,Module2,...) [default: \(defaultValue)]")
            guard let response = input().flatMap({ self.moduleNames(from: $0) }) else {
                moduleNamesString = defaultValue
                return [defaultValue]
            }
            moduleNamesString = response.joined(separator: ", ")
            return response
        }
        return moduleNames
    }
    
    mutating func getModuleName() -> String {
        guard let moduleName = moduleName else {
            print("Module name?")
            guard let response = input() else {
                return getModuleName()
            }
            self.moduleName = response
            return response
        }
        return moduleName
    }
    
    private func moduleNames(from string: String) -> [String] {
        return string
            .split(separator: ",")
            .map({ $0.trimmingCharacters(in: .whitespaces) })
            .filter({ !$0.isEmpty })
    }
    
    private func input() -> String? {
        let keyboard = FileHandle.standardInput
        let inputData = keyboard.availableData
        
        guard let input = String(data: inputData, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines),
            !input.isEmpty else {
            return nil
        }
        return input
    }
}


Group {
    $0.command("init",
               Option<String>("project_path", default: "", description: "Path to generated project"),
               Option<String>("project_name", default: "", description: "Your project name"),
               Option<String>("module_names", default: "", description: "List of module names separate")
    ) { path, projectName, moduleNamesString in
        var argumentInputs = ArgumentInputs(projectPath: path,
                                            projectName: projectName,
                                            moduleNamesString: moduleNamesString)
        
        let fileHandler = FileHandler(basePath: argumentInputs.getProjectPath())
        let generator = ProjectGenetator(name: argumentInputs.getProjectName(),
                                         moduleNames: argumentInputs.getModuleNames())

        generator.generate(in: fileHandler)
        
        print("""
        Your project has been generated.
            
        To start working on it, copy this command in your terminal:
        $ cd \(argumentInputs.getProjectPath()) && xcake make && open App.xcworkspace
            
        You will need `cocoapods` and `xcake` installed.
        """)
    }
    
    $0.group("add", "Add items to your project") {
        $0.command("module",
                   Option<String>("project_path", default: "", description: "Path to generated project"),
                   Option<String>("project_name", default: "", description: "Your project name"),
                   Option<String>("module_name", default: "", description: "Your module name")
        ) { path, projectName, moduleName in
            var argumentInputs = ArgumentInputs(projectPath: path,
                                                projectName: projectName,
                                                moduleName: moduleName)
            
            let fileHandler = FileHandler(basePath: argumentInputs.getProjectPath())
            let generator = ProjectGenetator(name: argumentInputs.getProjectName(),
                                             moduleNames: [])
            _ = generator.byInserting(module: argumentInputs.getModuleName(), in: fileHandler)

            print("A new module has been added to your project.")
        }
        
        $0.command("action",
                   Option<String>("project_path", default: "", description: "Path to generated project"),
                   Option<String>("project_name", default: "", description: "Your project name"),
                   Option<String>("module_name", default: "", description: "Your module name"),
                   Argument<String>("action_name", description: "Your action name"),
                   Argument<String>("action_type", description: "Your action type: [ui|routing]")
        ) { path, projectName, moduleName, actionName, actionType in
            var argumentInputs = ArgumentInputs(projectPath: path,
                                                projectName: projectName,
                                                moduleName: moduleName)

            let fileHandler = FileHandler(basePath: argumentInputs.getProjectPath())
            let generator = ProjectGenetator(name: argumentInputs.getProjectName(),
                                             moduleNames: [])
            _ = generator.byInserting(action: actionType == "ui" ? .ui(EnumCase(name: actionName)) : .routing(EnumCase(name: actionName)),
                                      toModule: argumentInputs.getModuleName(),
                                      in: fileHandler)
            
            print("A new action has been added to your module.")
        }
    }
}.run()

