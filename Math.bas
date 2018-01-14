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

class Vec2 {
	constructor(x = 1, y = 1) {
		this.x = x;
		this.y = y;
	}

	normalize() {
		return Vec2.normalize(this);
	}

	plus(vector) {
		return Vec2.add(this, vector);
	}

	minus(vector) {
		return Vec2.substract(this, vector);
	}

	get length() {
		return Math.sqrt(this.x ** 2 + this.y ** 2);
	}

	/**
	 * Сумма двух векторов/вектора и числа
	 * @param vector1 
	 * @param vector2 
	 */
	static add(vector1, vector2) {
		if (typeof vector2 === 'number') {
			// Умножение на скаляр
			return new Vec2(
				vector1.x + vector2,
				vector1.y + vector2
			);
		}

		if (vector2 instanceof Vec2) {
			return new Vec2(
				vector1.x + vector2.x,
				vector1.y + vector2.y
			)
		}
	}

	/**
	 * разность двух векторов/вектора и числа
	 * @param vector1 
	 * @param vector2 
	 */
	static substract(vector1, vector2) {
		if (typeof vector2 === 'number') {
			// Умножение на скаляр
			return new Vec2(
				vector1.x - vector2,
				vector1.y - vector2
			);
		}

		if (vector2 instanceof Vec2) {
			return new Vec2(
				vector1.x - vector2.x,
				vector1.y - vector2.y
			)
		}
	}

	/** Нормализация вектора
	 */
	static normalize(vector) {
		return new Vec2(
			vector.x / vector.length,
			vector.y / vector.length
		);
	}

	static getLength(vector) {
		return Math.sqrt(vector.x ** 2 + vector.y ** 2);
	}

	/** Скалярное произведение
	 */
	static dot(vector1, vector2) {
		return (vector1.x * vector2.x) + (vector1.y * vector2.y);
	}

	/** Векторное произведение
	 * 
	 */
	static cross(vector1, vector2) {
		return new Vec2(
			vector1.y * vector2.z - vector1.z * vector2.y,
			vector1.z * vector2.x - vector1.x * vector2.z
		);
	}

	/** Умножение на число/вектор
	 * 
	 */
	static multiply(vector1, vector2) {
		if (typeof vector2 === 'number') {
			// Умножение на скаляр
			return new Vec2(
				vector1.x * vector2,
				vector1.y * vector2
			);
		}

		if (vector2 instanceof Vec2) {
			return new Vec2(
				vector1.x * vector2.x,
				vector1.y * vector2.y
			)
		}
	}
}


class Vec3 {
	constructor(x = 1, y = 1, z = 1) {
		this.x = x;
		this.y = y;
		this.z = z;
	}

	plus(value) {
		Vec3.add(this, value);
	}

	minus(value) {
		Vec3.substract(this, value);
	}

	normalize() {
		return Vec3.normalize(this);
	}

	get length() {
		return Math.sqrt(this.x ** 2 + this.y ** 2 + this.z ** 2);
	}

	/**
	 * Сумма двух векторов/вектора и числа
	 * @param vector1 
	 * @param vector2 
	 */
	static add(vector1, vector2) {
		if (typeof vector2 === 'number') {
			// Умножение на скаляр
			return new Vec3(
				vector1.x + vector2,
				vector1.y + vector2,
				vector1.z + vector2
			);
		}

		if (vector2 instanceof Vec3) {
			return new Vec3(
				vector1.x + vector2.x,
				vector1.y + vector2.y,
				vector1.z + vector2.z,
			)
		}
	}

	/**
	 * Разность двух векторов/вектора и числа
	 * @param vector1 
	 * @param vector2 
	 */
	static substract(vector1, vector2) {
		if (typeof vector2 === 'number') {
			// Умножение на скаляр
			return new Vec3(
				vector1.x + vector2,
				vector1.y + vector2,
				vector1.z + vector2
			);
		}

		if (vector2 instanceof Vec3) {
			return new Vec3(
				vector1.x + vector2.x,
				vector1.y + vector2.y,
				vector1.z + vector2.z,
			)
		}
	}

	/** Нормализация вектора
	 */
	static normalize(vector) {
		return new Vec3(
			vector.x / vector.length,
			vector.y / vector.length,
			vector.z / vector.length
		);
	}

	/** Скалярное произведение
	 */
	static dot(vector1, vector2) {
		return (vector1.x * vector2.x) + (vector1.y * vector2.y) + (vector1.z * vector2.z);
	}

	/** Векторное произведение
	 * 
	 */
	static cross(vector1, vector2) {
		return new Vec3(
			vector1.y * vector2.z - vector1.z * vector2.y,
			vector1.z * vector2.x - vector1.x * vector2.z,
			vector1.x * vector2.y - vector1.y * vector2.x
		);
	}

	/** Умножение на число/вектор
	 * 
	 */
	static multiply(vector1, vector2) {
		if (typeof vector2 === 'number') {
			// Умножение на скаляр
			return new Vec3(
				vector1.x * vector2, //TODO: a.x || a
				vector1.y * vector2,
				vector1.z * vector2
			);
		}

		if (vector2 instanceof Vec3) {
			return new Vec3(
				vector1.x * vector2.x,
				vector1.y * vector2.y,
				vector1.z * vector2.z,
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
			vertex.x * this.values[0] + vertex.y * this.values[4] + vertex.z * this.values[8], // X
			vertex.x * this.values[1] + vertex.y * this.values[5] + vertex.z * this.values[9], // Y
			vertex.x * this.values[2] + vertex.y * this.values[6] + vertex.z * this.values[10], // Z
			vertex.x * this.values[3] + vertex.y * this.values[7] + vertex.z * this.values[11], // Z
		);
	}
}