# Calculator

ViewController
display -> displayValue?
- 小数点后最多六位，且只能有一个小数点
- Double？ 也可以是Int

touchDigit: 
- sender.currentTitle
- userIsInTheMiddleOfTyping
- userIsInTheMiddleOfFloatingPointNumber

performOperation:
- setOperand(displayValue!)
- brain.performration(mathematicalSymbol)
- displayValue = brain.result


clear every things

backspace

Autolayout

![alt text](https://github.com/ambuilding/Calculator/blob/master/suping.png "竖屏")

![alt text](https://github.com/ambuilding/Calculator/blob/master/hengping.png "横屏")


Model

accumulator

func:
- setOperand
- addUnaryOperation
- operations: Dictionary<String, Operation>
- enum Operation
- performOperation(symbol: String): BinaryOperation?
- executePendingBinaryOperation
- struct pendingBinaryOperatinInfo

