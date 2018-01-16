function fillRect4(x1, y1, x2, y2, x3, y3, x4, y4) {
  const ctx = $JsMobileBasic.canvas.getContext('2d');
  ctx.beginPath();
  ctx.moveTo(x1, y1);
  ctx.lineTo(x2, y2);
  ctx.lineTo(x3, y3);
  ctx.lineTo(x4, y4);
  ctx.lineTo(x1, y1);
  ctx.closePath();
  ctx.stroke();
  ctx.fill();
}

class Vertex extends Vec3 {
  constructor(x = 0, y = 0, z = 0) {
    super(x, y, z);
  }
}

class Triangle {
  constructor(v1, v2, v3, color) {
    this.v1 = v1;
    this.v2 = v2;
    this.v3 = v3;
    this.color = color;
  }


  render(transX = transX, transY = transY) {
    const heading = transX * DEG2RAD;
    const pitch = transY * DEG2RAD;

    const headingTransform = new Matrix3([
      Math.cos(heading), 0, Math.sin(heading),
      0, 1, 0, //
      Math.sin(heading), 0, Math.cos(heading)
    ]);


    const pitchTransform = new Matrix3([
      1, 0, 0,
      0, Math.cos(pitch), Math.sin(pitch),
      0, -Math.sin(pitch), Math.cos(pitch)
    ]);
    const transform = headingTransform.multiply(pitchTransform);


    const [v1, v2, v3] = [transform.transform(this.v1), transform.transform(this.v2), transform.transform(this.v3)]
    setColor(this.color);
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
}

class Squere {
  constructor(v1, v2, v3, v4, color) {
    this.v1 = v1;
    this.v2 = v2;
    this.v3 = v3;
    this.v4 = v4;
    this.color = color;
    this.depth = (v1.z + v2.z + v3.z + v4.z) / 4;
  }

  render({
    transX = transX,
    transY = transY,
    transZ = 0,
    Scale = 1,
    posX = 0,
    posY = 0,
    posZ = 0
  }) {
    const heading = transX * DEG2RAD;
    const pitch = transY * DEG2RAD;
    const angle = transZ * DEG2RAD;

    const headingTransform = new Matrix3([
      Math.cos(heading), 0, -Math.sin(heading), // 0,
      0, 1, 0, //0,
      Math.sin(heading), 0, Math.cos(heading), //0,
      //0, 0, 0, 1
    ]);

    const angleTransform = new Matrix3([
      cos(transZ), -sin(transZ), 0, // 0,
      sin(transZ), cos(transZ), 0, //0,
      0, 0, 1, //0,
      //0, 0, 0, 1
    ])

    const scaleTransform = new Matrix3([
      Scale, 0, 0, //0,
      0, Scale, 0, //0,
      0, 0, Scale, //0,
      //0, 0, 0, 1
    ])


    const pitchTransform = new Matrix3([
      1, 0, 0, //0,
      0, Math.cos(pitch), Math.sin(pitch), //0,
      0, -Math.sin(pitch), Math.cos(pitch), // 0,
      //0, 0, 0, 1
    ]);

    const positionTransform = new Matrix4([
      1, 0, 0, posX,
      0, 1, 0, posY,
      0, 0, 1, posZ,
      0, 0, 0, 1
    ]);

    const transform = (((headingTransform.multiply(pitchTransform))
        .multiply(angleTransform))
      .multiply(scaleTransform))
    // .multiply(positionTransform);

    // const transform = Matrix4.template
    //   .setPosition(new Vec3(posX, posY, posZ))
    //   .setRotation(new Vec3(heading, pitch, transZ));


    const [v1, v2, v3, v4] = [transform.transform(this.v1), transform.transform(this.v2), transform.transform(this.v3), transform.transform(this.v4)]
    if (this.color) {
      ctx.fillStyle = this.color;
      ctx.strokeColor = 'black'; // this.color.replace('0.3', 1)
    }

    function project(x, y, z) {
      const Z = 3;
      // Xp = (XZw - ZXw) / (Zw - Z)
      // Xp = (YZw - ZYw) / (Zw - Z)
      return [
        // (x*z - z*x) / (z - z),
        x + posX,
        y + posZ
      ]
    }

    // ctx.fillStyle = rgb(5*~~Math.abs(v1.z/100), 5*~~Math.abs(v2.z/100), 5*~~Math.abs(v3.z/100));
    /* 
        const среднее = Math.abs(v1.normalize().z+v2.normalize().z)/2;//+v3.normalize().z+v4.normalize().z) / 4;
        ctx.fillStyle = this.color.replace('0.3', среднее);//v1.normalize().z)
    console.log(`%c${среднее}`, `color:${ctx.fillStyle}`);

    */
    const avg = Math.max(abs(v1.normalize().z), abs(v2.normalize().z), abs(v3.normalize().z), abs(v4.normalize().z)) // 4;
    // const среднее = (v1.z+v2.z+v3.z+v4.z) / 4;
    // console.log(`%c${v1.normalize().z}; ${v2.normalize().z}`, `color:${ctx.fillStyle.replace('0.3',1)}`);

    if (fill) {
      ctx.fillStyle = this.color.replace('0.3', avg)
      ctx.strokeStyle = 'black';
    } else {
      ctx.fillStyle = 'black';
      ctx.strokeStyle = this.color.replace('0.3', 1);
    }

    fillRect4(
      ...project(zero[0] + v1.x, zero[1] + v1.y, v1.z),
      ...project(zero[0] + v2.x, zero[1] + v2.y, v2.z),
      ...project(zero[0] + v3.x, zero[1] + v3.y, v3.z),
      ...project(zero[0] + v4.x, zero[1] + v4.y, v4.z)
    )
    /* drawLine(
      zero[0] + v1.x, zero[1] + v1.y,
      zero[0] + v2.x, zero[1] + v2.y
    );

    drawLine(
      zero[0] + v2.x, zero[1] + v2.y,
      zero[0] + v3.x, zero[1] + v3.y
    );

    drawLine(
      zero[0] + v3.x, zero[1] + v3.y,
      zero[0] + v4.x, zero[1] + v4.y
    );

    drawLine(
      zero[0] + v1.x, zero[1] + v1.y,
      zero[0] + v4.x, zero[1] + v4.y
    ); */
  }
}

class Wall extends Squere {
  constructor(_v1, _v2, color, floor = 0, height = 200) {
    const [v1, v2, v3, v4] = [
      new Vertex(_v1.x, _v2.y + floor, _v1.z),
      new Vertex(_v2.x, _v1.y + floor, _v2.z),
      new Vertex(_v2.x, _v2.y + height, _v2.z),
      new Vertex(_v1.x, _v1.y + height, _v1.z)
    ];

    super(v1, v2, v3, v4, color);

    this.height = height;
  }
  /* 
    render(transX = transX, transY = transY) {
      const heading = transX * DEG2RAD;
      const pitch = transY * DEG2RAD;

      const headingTransform = new Matrix3([
        Math.cos(heading), 0, Math.sin(heading),
        0, 1, 0, //
        Math.sin(heading), 0, Math.cos(heading)
      ]);


      const pitchTransform = new Matrix3([
        1, 0, 0,
        0, Math.cos(pitch), Math.sin(pitch),
        0, -Math.sin(pitch), Math.cos(pitch)
      ]);
      const transform = headingTransform.multiply(pitchTransform);


      const [v1, v2, v3, v4] = [transform.transform(this.v1), transform.transform(this.v2), transform.transform(this.v3), transform.transform(this.v4)]
      setColor(this.color);
      drawLine(
        zero[0] + v1.x, zero[1] + v1.y,
        zero[0] + v2.x, zero[1] + v2.y
      );

      drawLine(
        zero[0] + v2.x, zero[1] + v2.y,
        zero[0] + v3.x, zero[1] + v3.y
      );

      drawLine(
        zero[0] + v3.x, zero[1] + v3.y,
        zero[0] + v4.x, zero[1] + v4.y
      );

      drawLine(
        zero[0] + v1.x, zero[1] + v1.y,
        zero[0] + v4.x, zero[1] + v4.y
      );
    } */
}