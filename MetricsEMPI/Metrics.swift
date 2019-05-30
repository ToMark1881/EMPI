//
//  Metrics.swift
//  MetricsEMPI
//
//  Created by Vladyslav Vdovychenko on 5/24/19.
//  Copyright © 2019 Vladyslav Vdovychenko. All rights reserved.
//


class MetricsCalculator {
    
    static let shared = MetricsCalculator()
    
    private init() {
    }
    
    
    // Прямые метрики
    
    func findNOC(_ files: [String]) -> Double {
        var noc = 0.0
        for file in files {
            let lines = file.components(separatedBy: "\n")
            for line in lines {
                if (line.contains("class") && line.contains("{") && !line.contains("(")) {
                    noc += 1
                }
            }
        }
        return noc
    }
    
    func findNOM(_ files: [String]) -> Double {
        var nom = 0.0
        
        for file in files {
            let lines = file.components(separatedBy: "\n")
            for line in lines {
                if (line.contains("{") && line.contains("(") && line.contains(")") && !line.contains("//")) {
                    nom += 1
                }
            }
        }
        return nom
    }
    
    func findCALL(_ files: [String]) -> Double {
        var call = 0.0
        for file in files {
            let lines = file.components(separatedBy: "\n")
            for line in lines {
                if (!line.contains("new") && line.contains("(") && line.contains(")") && !line.contains("//") && !line.contains("{")) {
                    call += 1
                }
            }
        }
        return call
    }
    
    func findCYCLO(_ files: [String]) -> Double {
        var cyclo = 0.0
        for file in files {
            let lines = file.components(separatedBy: "\n")
            for line in lines {
                if line.contains("if") || line.contains("else") || line.contains("for") || line.contains("while") || line.contains("&&") || line.contains("||") || line.contains("case") || line.contains("default") || line.contains("try") {
                    cyclo += 1
                }
            }
        }
        return cyclo
    }
    
    func findFOUT(_ files: [String]) -> Double {
        var fout = 0.0
        for file in files {
            let lines = file.components(separatedBy: "\n")
            var openCount = 0
            var closeCount = 0
            for line in lines {
                if /*line.contains("func") && */ line.contains("(") && line.contains(")") && line.contains("{") {
                    // we are inside function
                    openCount += 1
                }
                if line.contains("{") {
                    openCount += 1
                }
                if line.contains("}") {
                    closeCount += 1
                }
                
                if closeCount != openCount {
//                    if (line.contains("var") && line.contains(".") && line.contains("(") && line.contains(")")) || (line.contains("let") && line.contains(".") && line.contains("(") && line.contains(")")) {
//                        fout += 1
//                    } SWIFT
                    if (line.contains(".") && line.contains("(") && line.contains(")") && line.contains("new")) {
                        fout += 1
                    }
                }
                
                if (closeCount == openCount) {
                    openCount = 0
                    closeCount = 0
                    continue
                }
            }
        }
        return fout
    }
    
    
    
    
    //Непрямые метрики
    
    func findAMW(_ files: [String]) -> Double {
        let nom = findNOM(files)
        let cyclo = findCYCLO(files)
        let amw = Double(cyclo)/Double(nom)
        return amw
    }
    
    func findATFD(_ files: [String]) -> Double {
        var atfd = 0.0
        for file in files {
            let lines = file.components(separatedBy: "\n")
            for line in lines {
                if ( line.contains("(") && line.contains(")") && line.contains(".") && line.contains("new")) {
                    if line.contains("=") || line.contains(":") {
                        let numberOfAtributtes = line.countInstances(of: ",")
                        atfd += (Double(numberOfAtributtes) + 1.0)
                    }
                }
            }
        }
        return atfd
    }
    
    func findBOvR(_ files: [String]) -> Double {
        var bovr = 0.0
        for file in files {
            let lines = file.components(separatedBy: "\n")
            for line in lines {
                if line.contains("@Override") { // if line.contains("override")
                    bovr += 1
                }
            }
        }
        return bovr
    }
}
