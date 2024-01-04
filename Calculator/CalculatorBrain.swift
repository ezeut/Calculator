//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by 이지은 on 1/2/24.
//

// MVC 중 M, Model

import Foundation

// 클래스의 메소드가 아닌 전역함수
//func multiply(op1: Double, op2: Double) -> Double {
//    return op1 * op2
//}



// private으로 만들어야 하는건 모두 private 으로 만들고, 객체 안에서 영구적으로 지원하려는 것만 public

// API - 메소드, 프로퍼티를 포함한 우리가 프로그래밍할 인터페이스
class CalculatorBrain {
    
    private var accumulator = 0.0
    private var internalProgram = [Any]()
    
    
    func setOperand(operand: Double) {
        accumulator = operand
        internalProgram.append(operand)
    }
    
    private var operations: Dictionary<String, Operation> = [
        "π": Operation.Constant(Double.pi),
        "e": Operation.Constant(M_E),
        "√": Operation.UnaryOperation(sqrt),
        "cos": Operation.UnaryOperation(cos),
        "+": Operation.BinaryOperation({ $0 + $1 }),
        "−": Operation.BinaryOperation({ $0 - $1 }),
        "×": Operation.BinaryOperation({ $0 * $1 }),
        "÷": Operation.BinaryOperation({ $0 / $1 }),
        "=": Operation.Equals
    ]
    
    // Closures: 환경상태를 캡쳐하는 인라인 함수
    
    
    // enum: 별개의 값을 모아놓은 세트, 서로 구별되는 값들을 가지고 있어야 함, 특별한 점 -> 클래스처럼 메소드를 가질 수 있다
    // 계산변수는 가질 수 있지만 저장변수는 가질 수 없다. case들이 enum의 실질적인 저장소
    // 상속하거나 상속받을 수 없다
    // struct와 같이 pass by value, 즉 값으로 전달됨
    private enum Operation {
        case Constant(Double)
        case UnaryOperation((Double) -> Double)   // Swift에선 함수가 다른 Type들과 동일하게 사용됨
        case BinaryOperation((Double, Double) -> Double)
        case Equals
    }
    
    // Optional은 연관값을 가지고있고 사실 Optional은 Enum 이다..!!!
    // Optional의 작동방식
    //    enum Optional<T> {
    //        case None       // nil이 되는 경우
    //        case Some(T)    // T에는 어떤 타입도 올 수 있다
    //    }
    
    func performOperation(symbol: String) {
        internalProgram.append(symbol)
        if let operation = operations[symbol] {
            // switch구문은 Swift에서 강력함, 연관값을 가져오기 위해 패턴 매칭을 할 수 있다
            switch operation {
            case .Constant(let value):
                accumulator = value
                // Operation.Constant이지만 Dictionary에서 가져온 operation이 Operation타입인 것을 알기 때문에 swift는 Operation일 것이라고 추론하기 때문에 생략
            case .UnaryOperation(let function):
                accumulator = function(accumulator)
            case .BinaryOperation(let function):
                executePendingBinaryOperation()
                pending = PendingBinaryOperationInfo(binaryFunction: function, firstOperand: accumulator)
            case .Equals: executePendingBinaryOperation()

            }   // 4개의 모든 케이스를 가지고 있기 때문에 default값은 지정하지 않아도 됨
        }
    }
    
    private func executePendingBinaryOperation() {
        if pending != nil {     // 현재 대기중인 연산이 있다면
            accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)
            pending = nil
        }
    }
    
    private var pending: PendingBinaryOperationInfo?    // Optional struct, 연산자가 아니면 nil이길 바람!
    
    
    // struct와 class는 거의 같음. 저장변수나 계산변수같은 var 변수를 가질 수 있지만, 상속은 할 수 없다
    // struct: pass by value    class: pass by reference(참조)
    
    // 값 전달 -> 전달할 때 그걸 복사해서 복사한 것을 전달, Array, Double, Int, String 모두 struct
    // Array를 다른 메소드로 전달한 후에 값을 변경해도 호출하는 쪽의 Array는 변하지 않음
    // 복사하여 전달하면 성능이 떨어진다고 생각할 수 있으나 값 형식으로 struct를 전달할 때, 그것을 건들기 전까지는 실질적으로 복사를 하지 않음. 값을 바꾸려고 할 때 필요하다면 그 때 복사. 전체를 복사하지는 않음. 건들지 않는다면? 같은 것을 공유
    
    // 참조형식 -> heap어딘가에 있다가 메소드나 어딘가로 전달하게 되면 실제로는 pointer(메모리 주소)를 전달
    // 즉, 누군가에게 뭔가를 전달하면 내가 가진 것과 동일한 것을 갖게됨, 둘 다 heap에서 같은 것을 가리키는 pointer를 갖기 때문
    // heap에 또 다른 하나를 초기화해서 다른 걸 가질 수는 있음, 하나를 만들면 그걸 가리키는 포인터를 전달하고 다니는 것
    private struct PendingBinaryOperationInfo {
        var binaryFunction: (Double, Double) -> Double
        var firstOperand: Double    // 구조체에서 자동 생성되는 초기화 함수는 구조체 안의 모든 변수를 입력인자로 갖게 됨
        
    }
    // typealias: 타입을 만들 수 있게 해주는 swift 기능
    typealias PropertyList = AnyObject
    
    func clear() {
        accumulator = 0.0
        pending = nil
        internalProgram.removeAll()
    }
    
    var program: PropertyList {
        get {
            return internalProgram as AnyObject
        }
        set {
            clear()
            if let  arrayOfOps = newValue as? [AnyObject] {
                for op in arrayOfOps {
                    if let operand = op as? Double {
                        setOperand(operand: operand)
                    } else if let operation = op as? String {
                        performOperation(symbol: operation)
                    }
                }
            }
        }

    }
    
    var result: Double {
        get{
            return accumulator
        }
    }
}
