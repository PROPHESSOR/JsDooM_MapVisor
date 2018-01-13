// ==================JsMobileBasic Script================= *

const FRAME = true;

class Vertex {
  constructor(x, y, z) {
    this.x = x;
    this.y = y;
    this.z = z;
  }
}

class Triangle {
  constructor(v1, v2, v3, color) {
    this.v1 = v1;
    this.v2 = v2;
    this.v3 = v3;
    this.color = color;
  }
}

class Matrix3 {
  constructor(values) {
    this.values = values;
  }

  multiply(other) {
    const result = new Array(9); // 9
    result.fill(0);
    for (let row = 0; row < 3; row++) {
      for (let col = 0; col < 3; col++) {
        for (let i = 0; i < 3; i++) {
          result[row * 3 + col] += this.values[row * 3 + i] * other.values[i * 3 + col];
        }
      }
    }
    return new Matrix3(result);
  }

  transform(vertex) {
    return new Vertex(
      vertex.x * this.values[0] + vertex.y * this.values[3] + vertex.z * this.values[6], // X
      vertex.x * this.values[1] + vertex.y * this.values[4] + vertex.z * this.values[7], // Y
      vertex.x * this.values[2] + vertex.y * this.values[5] + vertex.z * this.values[8] /// Z
    );
  }
}

let triangles = [];

const zero = [screenWidth() / 2, screenHeight() / 2];

let [transX, transY] = [0, 0];

zBuffer = new Array(screenWidth() * screenHeight());
zBuffer.fill(0);

function Main() {
  window.onKeyDown = function (code) {
    // 38 w
    // 39 d
    // 40 s
    // 37 a
    switch (code) {
      case 38:
        transY++;
        if (FRAME) render();
        break;
      case 39:
        transX++;
        if (FRAME) render();
        break;
      case 40:
        transY--;
        if (FRAME) render();
        break;
      case 37:
        transX--;
        if (FRAME) render();
        break;
      default:
        break;
    }
  }

  window.onKeyUp = render;

  triangles = [];
  triangles.push(new Triangle(
    new Vertex(-100, -100, 100),
    new Vertex(100, -100, 100),
    new Vertex(100, 100, 100),
    rgb(random(0, 255), random(0, 255), random(0, 255))));

  triangles.push(new Triangle(
    new Vertex(100, 100, 100),
    new Vertex(-100, 100, 100),
    new Vertex(-100, -100, 100),
    rgb(random(0, 255), random(0, 255), random(0, 255))));

  triangles.push(new Triangle(
    new Vertex(100, -100, 100),
    new Vertex(100, -100, -100),
    new Vertex(100, 100, -100),
    rgb(random(0, 255), random(0, 255), random(0, 255))));

  triangles.push(new Triangle(
    new Vertex(100, 100, -100),
    new Vertex(100, 100, 100),
    new Vertex(100, -100, 100),
    rgb(random(0, 255), random(0, 255), random(0, 255))));

  triangles.push(new Triangle(
    new Vertex(-100, -100, -100),
    new Vertex(100, -100, -100),
    new Vertex(100, 100, -100),
    rgb(random(0, 255), random(0, 255), random(0, 255))));

  triangles.push(new Triangle(
    new Vertex(100, 100, -100),
    new Vertex(-100, 100, -100),
    new Vertex(-100, -100, -100),
    rgb(random(0, 255), random(0, 255), random(0, 255))));

  triangles.push(new Triangle(
    new Vertex(-100, -100, 100),
    new Vertex(-100, -100, -100),
    new Vertex(-100, 100, -100),
    rgb(random(0, 255), random(0, 255), random(0, 255))));

  triangles.push(new Triangle(
    new Vertex(-100, 100, -100),
    new Vertex(-100, 100, 100),
    new Vertex(-100, -100, 100),
    rgb(random(0, 255), random(0, 255), random(0, 255))));
  //   triangles.push(new Triangle(
  //     new Vertex(100, 100, 100),
  //     new Vertex(-100, -100, 100),
  //     new Vertex(-100, 100, -100),
  //     'black'));

  //   triangles.push(new Triangle(
  //     new Vertex(100, 100, 100),
  //     new Vertex(-100, -100, 100),
  //     new Vertex(100, -100, -100),
  //     'red'));

  //   triangles.push(new Triangle(
  //     new Vertex(-100, 100, -100),
  //     new Vertex(100, -100, -100),
  //     new Vertex(100, 100, 100),
  //     'green'));

  //   triangles.push(new Triangle(
  //     new Vertex(-100, 100, -100),
  //     new Vertex(100, -100, -100),
  //     new Vertex(-100, -100, 100),
  //     'blue'));

  render();
}

function render() {
  cls();
  const heading = transX * DEG2RAD;
  const pitch = transY * DEG2RAD;

  const headingTransform = new Matrix3([
    Math.cos(heading), 0, Math.sin(heading),
    00000000000000000, 1, 0, //
    Math.sin(heading), 0, Math.cos(heading)
  ]);


  const pitchTransform = new Matrix3([
    1, 000000000000000, 0,
    0, Math.cos(pitch), Math.sin(pitch),
    0, -Math.sin(pitch), Math.cos(pitch)
  ]);
  transform = headingTransform.multiply(pitchTransform);

  for (const triangle of triangles) {
    const [v1, v2, v3] = [transform.transform(triangle.v1), transform.transform(triangle.v2), transform.transform(triangle.v3)]
    setColor(triangle.color);
    drawLine(
      zero[0] + v1.x, zero[1] + v1.y,
      zero[0] + v2.x, zero[1] + v2.y
    );

    drawLine(
      zero[0] + v2.x, zero[1] + v2.y,
      zero[0] + v3.x, zero[1] + v3.y
    );

    drawLine(
      zero[0] + v1.x, zero[1] + v1.y,
      zero[0] + v3.x, zero[1] + v3.y
    );
  }

  if (!FRAME) fill();
}

function fill() {
  for (const triangle of triangles) {
    const [v1, v2, v3] = [transform.transform(triangle.v1), transform.transform(triangle.v2), transform.transform(triangle.v3)]
    setColor(triangle.color);
    // since we are not using Graphics2D anymore, we have to do translation manually
    v1.x += screenWidth() / 2;
    v1.y += screenHeight() / 2;
    v2.x += screenWidth() / 2;
    v2.y += screenHeight() / 2;
    v3.x += screenWidth() / 2;
    v3.y += screenHeight() / 2;

    // compute rectangular bounds for triangle
    let minX = Math.floor(Math.max(0, Math.ceil(Math.min(v1.x, Math.min(v2.x, v3.x)))));
    let maxX = Math.floor(Math.min(screenWidth() - 1, Math.floor(Math.max(v1.x, Math.max(v2.x, v3.x)))));
    let minY = Math.floor(Math.max(0, Math.ceil(Math.min(v1.y, Math.min(v2.y, v3.y)))));
    let maxY = Math.floor(Math.min(screenHeight() - 1, Math.floor(Math.max(v1.y, Math.max(v2.y, v3.y)))));

    let triangleArea = (v1.y - v3.y) * (v2.x - v3.x) + (v2.y - v3.y) * (v3.x - v1.x);
    for (let y = minY; y <= maxY; y++) {
      for (let x = minX; x <= maxX; x++) {
        let b1 = ((y - v3.y) * (v2.x - v3.x) + (v2.y - v3.y) * (v3.x - x)) / triangleArea;
        let b2 = ((y - v1.y) * (v3.x - v1.x) + (v3.y - v1.y) * (v1.x - x)) / triangleArea;
        let b3 = ((y - v2.y) * (v1.x - v2.x) + (v1.y - v2.y) * (v2.x - x)) / triangleArea;
        if (b1 >= 0 && b1 <= 1 && b2 >= 0 && b2 <= 1 && b3 >= 0 && b3 <= 1) {
          const depth = b1 * v1.z + b2 * v2.z + b3 * v3.z;
          const zIndex = y * screenWidth() + x;
          if (zBuffer[zIndex] < depth) {
            drawPlot(x, y);
            zBuffer[zIndex] = depth;
          }
        }
      }
    }
  }
}
