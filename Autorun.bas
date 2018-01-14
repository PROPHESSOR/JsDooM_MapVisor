// ==================JsMobileBasic Script================= *

include('Math.bas');
include('3Delements.bas');

const FRAME = true;

let elements = [];

const zero = [screenWidth() / 2, screenHeight() / 2];

let [transX, transY, transZ, Scale] = [0, 0, 0, 1];
let [posX, posY, posZ] = [0, 0, 0];

function Main() {
  window.onKeyDown = function (code) {
    // 38 w
    // 39 d
    // 40 s
    // 37 a
    // 87 W
    // 83 S
    // 65 A
    // 68 D
    switch (code) {
      case 38:
        transY--;
        if (FRAME) render();
        break;
      case 39:
        transX++;
        if (FRAME) render();
        break;
      case 40:
        transY++;
        if (FRAME) render();
        break;
      case 37:
        transX--;
        if (FRAME) render();
        break;
      case 87:
        Scale += .1;
        if (FRAME) render();
        break;
      case 83:
        Scale -= .1;
        if (Scale <= 0) Scale = 0.1;
        render();
        break;
      case 65:
        transZ+=0.1;
        render();
        break;
      case 68:
        transZ-=0.1;
        render();
        break;
      default:
        break;
    }
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
  //   console.log(vertexes);
  //   console.log(lines);
  function a(n) {
    return [100 + (n & 0xA), 100 + (n & 0xC), 100 + (n & 0xF)]
  }


  for (const line of lines) {
    debugger;
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

function render() {
  fillScreen('black');

  for (const element of elements) {
    element.render(transX, transY, transZ, Scale);
  }
}

/* 

//   triangles.push(new Squere(
  //     new Vertex(-100, -100, 100),
  //     new Vertex(100, -100, 100),
  // 	new Vertex(100, 100, 100),
  // 	new Vertex(-100, 100, 100),
  //     rgb(random(0, 255), random(0, 255), random(0, 255))));

  //   triangles.push(new Triangle(
  //     new Vertex(100, 100, 100),
  //     new Vertex(-100, 100, 100),
  //     new Vertex(-100, -100, 100),
  //     rgb(random(0, 255), random(0, 255), random(0, 255))));

  //   triangles.push(new Triangle(
  //     new Vertex(100, -100, 100),
  //     new Vertex(100, -100, -100),
  //     new Vertex(100, 100, -100),
  //     rgb(random(0, 255), random(0, 255), random(0, 255))));

  //   triangles.push(new Triangle(
  //     new Vertex(100, 100, -100),
  //     new Vertex(100, 100, 100),
  //     new Vertex(100, -100, 100),
  //     rgb(random(0, 255), random(0, 255), random(0, 255))));

  //   triangles.push(new Triangle(
  //     new Vertex(-100, -100, -100),
  //     new Vertex(100, -100, -100),
  //     new Vertex(100, 100, -100),
  //     rgb(random(0, 255), random(0, 255), random(0, 255))));

  //   triangles.push(new Triangle(
  //     new Vertex(100, 100, -100),
  //     new Vertex(-100, 100, -100),
  //     new Vertex(-100, -100, -100),
  //     rgb(random(0, 255), random(0, 255), random(0, 255))));

  //   triangles.push(new Triangle(
  //     new Vertex(-100, -100, 100),
  //     new Vertex(-100, -100, -100),
  //     new Vertex(-100, 100, -100),
  //     rgb(random(0, 255), random(0, 255), random(0, 255))));

  //   triangles.push(new Triangle(
  //     new Vertex(-100, 100, -100),
  //     new Vertex(-100, 100, 100),
  //     new Vertex(-100, -100, 100),
  //     rgb(random(0, 255), random(0, 255), random(0, 255))));


*/
