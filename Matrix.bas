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
  