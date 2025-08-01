// Конфигурация
const DEFAULT_GRID_SIZE = 16;
const MAX_GRID_SIZE = 100;
const CONTAINER_SIZE = 960; // px

// Состояние приложения
let currentGridSize = DEFAULT_GRID_SIZE;
let isRandomColorMode = false;
let isDarkenMode = false;
let currentColor = '#000000';

// DOM элементы
const gridContainer = document.getElementById('grid-container');
const changeGridBtn = document.getElementById('change-grid');
const clearGridBtn = document.getElementById('clear-grid');
const randomColorBtn = document.getElementById('random-color');
const darkenModeBtn = document.getElementById('darken-mode');

// Инициализация сетки
function initGrid(size) {
    // Очищаем контейнер
    gridContainer.innerHTML = '';
    
    // Рассчитываем размер каждого квадрата
    const itemSize = CONTAINER_SIZE / size;
    
    // Создаем сетку
    for (let i = 0; i < size * size; i++) {
        const gridItem = document.createElement('div');
        gridItem.classList.add('grid-item');
        gridItem.style.width = `${itemSize}px`;
        gridItem.style.height = `${itemSize}px`;
        
        // Добавляем обработчики событий
        gridItem.addEventListener('mouseover', handleMouseOver);
        gridItem.addEventListener('mousedown', handleMouseDown);
        
        gridContainer.appendChild(gridItem);
    }
}

// Обработчики событий
function handleMouseOver(e) {
    if (isDrawing) {
        paintCell(e.target);
    }
}

function handleMouseDown(e) {
    isDrawing = true;
    paintCell(e.target);
    e.preventDefault(); // Предотвращаем выделение текста
}

function handleMouseUp() {
    isDrawing = false;
}

// Раскрашивание ячейки
function paintCell(cell) {
    if (isRandomColorMode) {
        const r = Math.floor(Math.random() * 256);
        const g = Math.floor(Math.random() * 256);
        const b = Math.floor(Math.random() * 256);
        cell.style.backgroundColor = `rgb(${r}, ${g}, ${b})`;
        cell.style.opacity = 1;
    } else if (isDarkenMode) {
        const currentOpacity = parseFloat(cell.style.opacity) || 0;
        cell.style.backgroundColor = currentColor;
        cell.style.opacity = Math.min(currentOpacity + 0.1, 1);
    } else {
        cell.style.backgroundColor = currentColor;
        cell.style.opacity = 1;
    }
}

// Очистка сетки
function clearGrid() {
    const cells = document.querySelectorAll('.grid-item');
    cells.forEach(cell => {
        cell.style.backgroundColor = 'white';
        cell.style.opacity = 1;
    });
}

// Изменение размера сетки
function changeGridSize() {
    let newSize = prompt(`Введите размер сетки (1-${MAX_GRID_SIZE}):`, currentGridSize);
    
    newSize = parseInt(newSize);
    if (isNaN(newSize) || newSize < 1 || newSize > MAX_GRID_SIZE) {
        alert(`Пожалуйста, введите число от 1 до ${MAX_GRID_SIZE}`);
        return;
    }
    
    currentGridSize = newSize;
    initGrid(currentGridSize);
}

// Переключение режимов
function toggleRandomColorMode() {
    isRandomColorMode = !isRandomColorMode;
    isDarkenMode = false;
    randomColorBtn.style.backgroundColor = isRandomColorMode ? '#45a049' : '#4CAF50';
    darkenModeBtn.style.backgroundColor = '#4CAF50';
}

function toggleDarkenMode() {
    isDarkenMode = !isDarkenMode;
    isRandomColorMode = false;
    darkenModeBtn.style.backgroundColor = isDarkenMode ? '#45a049' : '#4CAF50';
    randomColorBtn.style.backgroundColor = '#4CAF50';
}

// Обработчики кнопок
changeGridBtn.addEventListener('click', changeGridSize);
clearGridBtn.addEventListener('click', clearGrid);
randomColorBtn.addEventListener('click', toggleRandomColorMode);
darkenModeBtn.addEventListener('click', toggleDarkenMode);

// Глобальные обработчики
let isDrawing = false;
document.addEventListener('mouseup', handleMouseUp);

// Инициализация при загрузке
window.addEventListener('load', () => {
    initGrid(DEFAULT_GRID_SIZE);
});