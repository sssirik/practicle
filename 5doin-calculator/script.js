// Переменные для хранения состояния калькулятора
let firstOperand = null;
let secondOperand = null;
let currentOperator = null;
let shouldResetDisplay = false;
let displayValue = '0';

// Элемент дисплея
const display = document.getElementById('display');

// Обновление дисплея
function updateDisplay() {
    display.textContent = displayValue;
}

// Добавление цифры
function appendNumber(number) {
    if (displayValue === '0' || shouldResetDisplay) {
        displayValue = number;
        shouldResetDisplay = false;
    } else {
        displayValue += number;
    }
    updateDisplay();
}

// Добавление десятичной точки
function appendDecimal() {
    if (shouldResetDisplay) {
        displayValue = '0.';
        shouldResetDisplay = false;
        updateDisplay();
        return;
    }
    
    if (!displayValue.includes('.')) {
        displayValue += '.';
        updateDisplay();
    }
}

// Добавление оператора
function appendOperator(operator) {
    if (currentOperator !== null && !shouldResetDisplay) {
        calculate();
    }
    
    firstOperand = parseFloat(displayValue);
    currentOperator = operator;
    shouldResetDisplay = true;
}

// Вычисление результата
function calculate() {
    if (currentOperator === null || shouldResetDisplay) return;
    
    if (currentOperator === '/' && displayValue === '0') {
        alert("Нельзя делить на ноль!");
        clearDisplay();
        return;
    }
    
    secondOperand = parseFloat(displayValue);
    displayValue = operate(currentOperator, firstOperand, secondOperand).toString();
    firstOperand = parseFloat(displayValue);
    shouldResetDisplay = true;
    updateDisplay();
}

// Очистка дисплея
function clearDisplay() {
    displayValue = '0';
    firstOperand = null;
    secondOperand = null;
    currentOperator = null;
    shouldResetDisplay = false;
    updateDisplay();
}

// Удаление последнего символа
function backspace() {
    if (displayValue.length === 1 || (displayValue.length === 2 && displayValue.startsWith('-'))) {
        displayValue = '0';
    } else {
        displayValue = displayValue.slice(0, -1);
    }
    updateDisplay();
}

// Основные математические операции
function add(a, b) {
    return a + b;
}

function subtract(a, b) {
    return a - b;
}

function multiply(a, b) {
    return a * b;
}

function divide(a, b) {
    return a / b;
}

// Выбор операции
function operate(operator, a, b) {
    a = parseFloat(a);
    b = parseFloat(b);
    
    switch (operator) {
        case '+':
            return roundResult(add(a, b));
        case '-':
            return roundResult(subtract(a, b));
        case '*':
            return roundResult(multiply(a, b));
        case '/':
            return roundResult(divide(a, b));
        default:
            return b;
    }
}

// Округление результата
function roundResult(number) {
    return Math.round(number * 100000) / 100000;
}

// Обработка нажатий клавиш
document.addEventListener('keydown', function(event) {
    if (event.key >= '0' && event.key <= '9') {
        appendNumber(event.key);
    } else if (event.key === '.') {
        appendDecimal();
    } else if (event.key === '+' || event.key === '-' || event.key === '*' || event.key === '/') {
        appendOperator(event.key);
    } else if (event.key === 'Enter' || event.key === '=') {
        calculate();
    } else if (event.key === 'Escape') {
        clearDisplay();
    } else if (event.key === 'Backspace') {
        backspace();
    }
});

// Инициализация дисплея
updateDisplay();