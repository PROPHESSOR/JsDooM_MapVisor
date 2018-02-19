// ==================JsMobileBasic Script================= *

include('Math.bas');
include('3Delements.bas');

const FRAME = true;

let elements = [];

const zero = [screenWidth() / 2, screenHeight() / 2];

let [transX, transY, transZ, Scale] = [0, 0, 0, 1];
let [posX, posY, posZ] = [0, 0, 0];
let fill = true;
let gradient = true;
let mode = 1;

/** Точка входа
 */
function Main() {
  /** Обработчик клавиатуры
   * @param  {number} code - Код нажатой клавиши
   */
  window.onKeyDown = function (code) {
    // 38 w
    // 39 d
    // 40 s
    // 37 a
    // 87 W
    // 83 S
    // 65 A
    // 68 D
    // 85 U
    // 75 K
    // 74 J
    // 72 H
    console.log(code);
    switch (code) {
      case 38: // Вверх
        transY--;
        render();
        break;
      case 39: // Вправо
        transX++;
        render();
        break;
      case 40: // Вних
        transY++;
        render();
        break;
      case 37: // Влево
        transX--;
        render();
        break;
      case 87: // W
        Scale += .1;
        render();
        break;
      case 83: // S
        Scale -= .1;
        render();
        break;
      case 65: // A
        transZ += 0.1;
        render();
        break;
      case 68: // D
        transZ -= 0.1;
        render();
        break;
      case 85: // U
        posZ += 10; //Forward
        render();
        break;
      case 75: // K
        posX += 10; //Right
        render();
        break;
      case 74: // J
        posZ -= 10; //Backward
        render();
        break;
      case 72: // H
        posX -= 10; //Left
        render();
        break;
      case 71:
        gradient = !gradient;
        render();
        break;
      case 82: //R
        [transX, transY, transZ, Scale] = [0, 0, 0, 1];
        [posX, posY, posZ] = [0, 0, 0];
        mode = 1;
        render();
        break;

        //Modes
      case 48: // 0
        mode = 0;
        render();
        break;
      case 49: // 1
        mode = 1;
        render();
        break;
      case 50: // 2
        mode = 2;
        render();
        break;
      case 51: // 3
        mode = 3;
        render();
        break;
      case 52: // 4
        mode = 4;
        render();
        break;
      case 53: // 5
        mode = 5;
        render();
        break;
	  case 54: // 6
        mode = 6;
		posZ = 600;
        render();
        break;
      case 89: // Y
        posY-=10;
        render();
        break;
      case 73: // I
        posY+=10;
        render();
        break;
      case 27: //Esc
        fill = !fill;
        render();
        break;
      case 112: // F1
        alert(
          `Стрелки - вращение карты по XY
WS - масштабирование
AD - вращение карты по Z (наклон)
UJ - перемещение камеры по оси Z
HK - перемещение камеры по оси X
YI - перемещение камеры по оси Y
0  - режим тестирования 2d -> 1d проекции
1  - режим отображения без проекции
2  - режим отображения с 3d -> 2d проекцией
3  - режим отображения с Хабровской проекцией
5  - проекция на основе 3d -> 2d * sin(alpha)
Esc - переключение fill/wireframe (заливка/каркасс)
G  - переключение фонового градиента
R  - сброс режима и перемещения
F12 - открыть консоль отладки
`);
        break;
      default:
        break;
    }
    console.log([transX, transY, transZ, posX, posY, posZ].join('\t'));
  }

  window.onKeyUp = render;

  elements = [];
  //   elements.push(new Wall(
  //     new Vertex(-100, 0, 100),
  //     new Vertex(100, 0, 100),
  //     rgb(random(0, 255), random(0, 255), random(0, 255))));

  const WadParser = new(require('./WadParser'));
  const vertexes = WadParser.getVertexes('data/VERTEXES.lmp');
  const lines = WadParser.getLinedefs('data/LINEDEFS.lmp');
  const sectors = WadParser.getSectors('data/SECTORS.lmp');
  const sides = WadParser.getSides('data/SIDEDEFS.lmp')

  function a(n) {
    return [100 + (n & 0xA), 100 + (n & 0xC), 100 + (n & 0xF)]
  }


  for (const line of lines) {
    //debugger;
    const color = rgba(random(0, 255), random(0, 255), random(0, 255), .3);
    elements.push(new Wall(
      new Vertex(vertexes[line.v1].x, 0, vertexes[line.v1].y),
      new Vertex(vertexes[line.v2].x, 0, vertexes[line.v2].y),
      rgba(random(0, 255), random(0, 255), random(0, 255), .3),
      //   rgb(...a(sides[Math.max(line.front, 0)].middletex)),
      sectors[sides[Math.max(line.front, 0)].sector].floor,
      sectors[sides[Math.max(line.front, 0)].sector].height
    ))
  }
  render();
}
/** Функция рендера
 */
function render() {
  if (mode === 0) {
    // Тест 2d -> 1d проекции
    cls();
    project2(transX, transY, posX, posZ);
    return;
  }
  if (gradient) {
    const grad = makeLinearGradient(0, 0, 1, screenHeight());
    setGradientColor(grad, 0, 'gray');
    setGradientColor(grad, 1, 'black');
    fillScreen(grad);
  } else fillScreen('black');

  for (const element of elements) {
    element.render({
      transX,
      transY,
      transZ,
      Scale,
      posX,
      posY,
      posZ
    });
  }
}

/** Проецирует двумерное пространство на одномерную плоскость
 * @param  {number} x - X Координата проецируемой точки в двумерном пространстве
 * @param  {number} y - Y Координата проецируемой точки в двумерном пространстве
 * @param  {number} posX - Координата наблюдателя в двумерном пространстве
 * @param  {number} posY - Координата наблюдателя в двумерном пространстве
 * @returns {number} X координата на одномерной плоскости
 */
function _2dTO1d(x, y, posX, posY) {
  const tana = (posY - y) / (posX - x);

  // Для отсечения ошибочных результатов
  if (y > posY || y < 0) return -Infinity;

  return x - y / tana;
}

/** Проецирует трехмерное пространство на двуменрую плоскость
 * @param  {number} x - X Координата проецируемой точки в трехмерном пространстве
 * @param  {number} y - Y Координата проецируемой точки в трехмерном пространстве
 * @param  {number} z - Z Координата проецируемой точки в трехмерном пространстве
 * @param  {number} posX - X Координата наблюдателя в трехмерном пространстве
 * @param  {number} posY - Y Координата наблюдателя в трехмерном пространстве
 * @param  {number} posZ - Z Координата наблюдателя в трехмерном пространстве
 * @returns {array} Координаты X и Y на двумерной плоскости
 */
function _3dTO2d(x, y, z, posX, posY, posZ) {
  // Без проекции
  if (mode === 1) return [x - posX, y - posZ];
  
  if(mode === 6) {
	  function normalize(z) {
		while(Math.floor(z) > 0) {
			z /= 10;
		}
		return z.toFixed(2);
	}
	  const z_lenght = z;// - posZ;
		  
	const perspective = new Matrix3([
		normalize(z_lenght), 0, 0,
		0, normalize(z_lenght), 0,
		0, 0, normalize(z_lenght),
	]);
	
	const vec = perspective.transform(new Vec3(x, y, z));
	const x1 = _2dTO1d(x, z, posX, posZ); // Чем больше 1 - тем больше дальность отрисовки
    const y1 = _2dTO1d(y, z, posY, posZ);
    return [x1, y1];
  }

  if (mode === 2) {
    // 3d -> 2d проекция
    const x1 = _2dTO1d(x, z / 1, posX, posZ); // Чем больше 1 - тем больше дальность отрисовки
    const y1 = _2dTO1d(y, z / 1, posY, posZ);
    return [x1, y1];
  }

  if (mode === 5) {
    // 3d -> 2d проекция
    const x1 = _2dTO1d(x, z / 1, posX, posZ); // Чем больше 1 - тем больше дальность отрисовки
    const y1 = _2dTO1d(y, z / 1, posY, posZ);

    const vec = new Vec3(x - posX, y - posY, z - posZ);
    const length = sqrt(vec.x ** 2 + vec.y ** 2 + vec.z ** 2);

    const xlen = x - posX;
    const sina = xlen / length;
    return [x1 * sin(90 - sina) - zero[0], y1 * sin(sina) + zero[1]];
  }

  // Какая-то проекция с Хабра
  if (mode === 3 || mode === 4) {
    let [x1, y1, z1] = [x, y, z];

    x1 -= posX;
    y1 -= posY;
    z1 -= posZ;

    const x2 = x1 * sin(transX) + y1 * cos(transX);
    const z2 = x1 * cos(transX) - y1 * sin(transX);
    const y2 = z1;

    const x3 = zero[0] + (x2 / z) * (screenWidth() / 2);
    const y3 = zero[1] + (y2 / z) * (screenHeight() / 2);
    
    if(mode === 3) return [x2, y2];
    if(mode === 4) return [x3, y3];
  }

  // Другая проекция с Хабра
  /* const [c, s, a, b] = [S3.cosMy, S3.sinMy, S3.termA, S3.termB];
  const px = 0.9815 * c * x + 0.9815 * s * z + 0.9815 * a
  const py = 1.7321 * y - 1.7321 * S3.ey
  const pz = s * x - z * c - b - 0.2
  const pw = x * s - z * c - b
  const [ndcx, ndcy] = [px / abs(pw), py / abs(pw)]
  return 120 + ndcx * 120, 68 - ndcy * 68, pz */
}

function project2(x, y, posX, posY) {
  setColor('red');
  fillArc(zero[0] + x, zero[1] - y, 5); // Точка

  setColor('green');
  fillArc(zero[0] + posX, zero[1] - posY, 5); // Наблюдатель

  setColor('blue');
  fillArc(
    zero[0] + _2dTO1d(x, y, posX, posY),
    zero[1],
    5
  ); // Проекция точки на ось X
}