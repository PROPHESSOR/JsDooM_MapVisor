//    Copyright 2018 PROPHESSOR
// 
//    Licensed under the Apache License, Version 2.0 (the "License");
//    you may not use this file except in compliance with the License.
//    You may obtain a copy of the License at
// 
//        http://www.apache.org/licenses/LICENSE-2.0
// 
//    Unless required by applicable law or agreed to in writing, software
//    distributed under the License is distributed on an "AS IS" BASIS,
//    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//    See the License for the specific language governing permissions and
//    limitations under the License.

class Vec2 extends Array {
	constructor(val1, val2) {
		super(val1, val2);
	}

	normalize() {
		return Vec2.normalize(this);
	}
	/** Нормализация вектора
	 */
	static normalize(vector) {
		return new Vec2(
			vector[0] / vector.length,
			vector[1] / vector.length
		);
	}

	/** Скалярное произведение
	 */
	static dot(vector1, vector2) {
		return (vector1[0] * vector2[0] ) + (vector1[1] * vector2[1]);
	}

	/** Векторное произведение
	 * 
	 */
	static cross(vector1, vector2) {
		return new Vec2(
			vector1[1] * vector2[2] - vector1[2] * vector2[1],
			vector1[2] * vector2[0] - vector1[0] * vector2[2]
		);
	}

	/** Умножение на число/вектор
	 * 
	 */
	static multiply(vector1, vector2) {
		if (typeof vector2 === 'number') {
			// Умножение на скаляр
			return new Vec2(
				vector1[0] * vector2,
				vector1[1] * vector2
			);
		}

		if(vector2 instanceof Vec2) {
			return new Vec2(
				vector1[0] * vector2[0],
				vector1[1] * vector2[1]
			)
		}
	}
}


class Vec3 extends Array {
	constructor(val1, val2, val3) {
		super(val1, val2, val3);
	}

	normalize() {
		return Vec3.normalize(this);
	}

	/** Нормализация вектора
	 */
	static normalize(vector) {
		return new Vec3(
			vector[0] / vector.length,
			vector[1] / vector.length,
			vector[2] / vector.length
		);
	}

	/** Скалярное произведение
	 */
	static dot(vector1, vector2) {
		return (vector1[0] * vector2[0] ) + (vector1[1] * vector2[1]) + (vector1[2] * vector2[2]);
	}

	/** Векторное произведение
	 * 
	 */
	static cross(vector1, vector2) {
		return new Vec3(
			vector1[1] * vector2[2] - vector1[2] * vector2[1],
			vector1[2] * vector2[0] - vector1[0] * vector2[2],
			vector1[0] * vector2[1] - vector1[1] * vector2[0]
		);
	}

	/** Умножение на число/вектор
	 * 
	 */
	static multiply(vector1, vector2) {
		if (typeof vector2 === 'number') {
			// Умножение на скаляр
			return new Vec3(
				vector1[0] * vector2,
				vector1[1] * vector2,
				vector1[2] * vector2
			);
		}

		if(vector2 instanceof Vec3) {
			return new Vec3(
				vector1[0] * vector2[0],
				vector1[1] * vector2[1],
				vector1[2] * vector2[2],
			)
		}
	}
}

class Matrix3 {
	constructor(values) {
		this.values = values;
	}

	multiply(other) {
		const result = new Array(9);
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

class Matrix4 {
	constructor(values) {
		this.values = values;
	}

	multiply(other) {
		const result = new Array(16);
		result.fill(0);
		for (let row = 0; row < 4; row++) {
			for (let col = 0; col < 4; col++) {
				for (let i = 0; i < 4; i++) {
					result[row * 4 + col] += this.values[row * 4 + i] * other.values[i * 4 + col];
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